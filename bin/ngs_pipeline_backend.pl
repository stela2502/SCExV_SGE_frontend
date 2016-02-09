#! /usr/bin/perl -w

#  Copyright (C) 2015-02-12 Stefan Lang

#  This program is free software; you can redistribute it
#  and/or modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation;
#  either version 3 of the License, or (at your option) any later version.

#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#  See the GNU General Public License for more details.

#  You should have received a copy of the GNU General Public License
#  along with this program; if not, see <http://www.gnu.org/licenses/>.

=head1 ngs_pipeline_backend.pl

This tool is the backend demon checking the main path and starting the SGE scripts.

To get further help use 'ngs_pipeline_backend.pl -help' at the comman line.

=cut

use Getopt::Long;
use strict;
use warnings;
use Proc::Daemon;

use stefans_libs::NGS_pipeline::SGE_helper;

my $Kid_1_PID;
$Kid_1_PID = Proc::Daemon::Init;
if ($Kid_1_PID) {
	exit 0;
}
use FindBin;
my $plugin_path = "$FindBin::Bin";

use stefans_libs::database::workload;
use stefans_libs::database::outfiles;
use stefans_libs::database::process_finished;

my $VERSION = 'v1.0';

my ( $help, $debug, $database, $root_path, $dbh_definition, $frequency,
	$pid_file, $log_file );

Getopt::Long::GetOptions(
	"-root_path=s"      => \$root_path,
	"-dbh_definition=s" => \$dbh_definition,
	"-frequency=s"      => \$frequency,
	"-pid_file=s"       => \$pid_file,
	"-log_file=s"       => \$log_file,

	"-help"  => \$help,
	"-debug" => \$debug
);

my $warn  = '';
my $error = '';

unless ( defined $root_path ) {
	$warn .= "the cmd line switch -root_path is undefined!\n";
}
unless ( defined $log_file ) {
	$warn .= "the cmd line switch -log_file is undefined!\n";
	$log_file = "/var/log/ngs_sge_backend.log";
}
unless ( defined $dbh_definition ) {
	$error .= "the cmd line switch -dbh_definition is undefined!\n";
}
unless ( defined $frequency ) {
	$warn .= "the cmd line switch -frequency is undefined!\n";
	$frequency = 10;
}
unless ( defined $pid_file ) {
	$error .= "the cmd line switch -pid_file is undefined!\n";
}

if ($help) {
	print helpString();
	exit;
}

if ( $error =~ m/\w/ ) {
	print helpString($error);
	exit;
}

sub helpString {
	my $errorMessage = shift;
	$errorMessage = ' ' unless ( defined $errorMessage );
	return "
 $errorMessage
 command line switches for ngs_pipeline_backend.pl

   -root_path       :the path that will be used to re-shuffle the results to
   -dbh_definition  :the dbh definition file to connect to the dbh
   -frequency       :the re-check frequency in seconds between checks (default = 10s)
   -pid_file        :the pid file
   -log_file        :the file to log both stdout and stderr messages 
                     default ='/var/log/ngs_sge_backend.log'
   
   -help           :print this help
   -debug          :verbose output
   

";
}

my ($task_description);

$task_description .= 'perl '
  . root->perl_include() . ' '
  . $plugin_path
  . '/ngs_pipeline_backend.pl';
$task_description .= " -root_path $root_path" if ( defined $root_path );
$task_description .= " -dbh_definition $dbh_definition"
  if ( defined $dbh_definition );
$task_description .= " -frequency $frequency" if ( defined $frequency );
$task_description .= " -log_file $log_file"   if ( defined $log_file );

# code executed only by the child ...
exit 0 if ( -f $pid_file );
open( OUT, ">$pid_file" )
  or die "I could not create the pid file '$pid_file'\n$!\n";
print OUT $$;
close(OUT);

$ENV{'DBFILE'} = $dbh_definition;
my $db     = stefans_libs::database::workload->new( variable_table->getDBH() );
my $ofiles = stefans_libs::database::outfiles->new( $db->{'dbh'} );
my $postprocess = stefans_libs::database::process_finished->new( $db->{'dbh'} );
my $SGE_helper  = stefans_libs::NGS_pipeline::SGE_helper->new();

### start logging
open my $log_fh, '>>', $log_file;
*STDOUT = $log_fh;
*STDERR = $log_fh;

print $db->NOW()
  . ": ngs_pipeline_backend started (PID=$$)\n$task_description\n";

my ( $workload, $running, @cmd, $hash );
while (1) {
	$workload = $db->check_new();
	if ( $workload->Lines() ) {
		&fix_rights( @{ @{ $workload->{'data'} }[0] }[1] );
	}
	for ( my $line = 0 ; $line < $workload->Lines() ; $line++ ) {
		$hash = $workload->get_line_asHash($line);
		$db->process( $hash->{'id'} );
		my ( $pid, $msg, $failed ) = &crete_qsub_calls($hash);
	}
	sleep($frequency);

	#id, script, state (==PID)
	$running = $db->get_running();    #id script state module
	for ( my $line = 0 ; $line < $running->Lines() ; $line++ ) {
		$hash = $running->get_line_asHash($line);

		unless ( &is_running($hash) ) {
			if ( my $err = &get_error( $hash->{'script'}, $hash->{'state'} ) ) {
				warn $db->NOW()
				  . ":Process $hash->{'script'} with id  $hash->{'id'} failed! $err\n";
				$db->failed( $hash->{'id'}, $err );
			}
			else {
				$db->finish( $hash->{'id'} );
				&do_after_process_finished( $hash, 1 );
			}
		}
	}
}

sub _call_and_process_qsub {
	my ($script) = @_;
	print $db->NOW() . ":su - worker -c 'qsub $script' 2>&1 |\n" if ($debug);
	open CMD, "su - worker -c 'qsub $script' 2>&1 |" or print $@;
	@cmd = <CMD>;
	close(CMD);
	if ( $cmd[0] =~ m/Your job (\d+) \(/ ) {
		print $db->NOW() . ":qsub process registered: $1\n";
		return ( $1, 'all fine', 0 );
	}
	else {
		$error = join( " ", @cmd );
		warn $db->NOW() . ":qsub process failed: $error\n";
		$error = substr( $error, 0, 90 ) . "..." if ( length($error) > 90 );
		return ( '', join( " ", @cmd ), 1 );
	}
	Carp::confess("You should not have been able to reach this!\n");
}

sub crete_qsub_calls {
	my ($hash) = @_;
	my ( $pid, $msg, $failed, @pids, $fn, @path );
	if ( $hash->{'type'} eq "normal" ) {
		( $pid, $msg, $failed ) = &_call_and_process_qsub( $hash->{'script'} );
		if ($failed) {
			warn $db->NOW() . ":qsub process failed: $msg\n";
			$msg = substr( $msg, 0, 90 ) . "..." if ( length($msg) > 90 );
			$db->failed( $hash->{'id'}, "qsub:" . $msg );
		}
		else {
			$db->process_SGE( $hash->{'id'}, $pid );
		}
		return $pid, $msg, $failed;
	}
	elsif ( $hash->{'type'} eq "multiple" ) {
		@path = split( "/", $hash->{'script'} );
		pop(@path);
		my $path = join( "/", @path );
		$fn = join( "/", $path, 'qsub_multiple_script' ) or warn $!;
		open( IN, "<", $hash->{'script'} )
		  or warn "could not open script '$hash->{'script'}'\n$!\n";
		my $i = 0;
		my $err;
		while (<IN>) {

			#	print "I process the good line $i : $_";
			next if ( $_ =~ m/^#/ );
			open( OUT, ">", $fn . "_$i.sh" );
			$_ =~ s/\&\s*$//;
			print OUT $SGE_helper->qsub_head(
				{ 'proc' => 1, 'memfree' => "1G" } )
			  . "cd $path\n$_";
			close(OUT);

			( $pid, $msg, $failed ) = &_call_and_process_qsub( $fn . "_$i.sh" );
			$err .= $msg;
			$i++;
			push( @pids, $pid ) unless ($failed);
		}
		close(IN);
		&pids( join( "/", @path ), @pids );
		if ( @pids == 0 ) {    ##failed
			warn $db->NOW() . ":qsub process failed: $err\n";
			$err = substr( $err, 0, 90 ) . "..." if ( length($err) > 90 );
			$db->failed( $hash->{'id'}, "qsub:" . $err );
		}
		else {
			$db->process_SGE( $hash->{'id'}, $pids[0] );
		}
		return ( $pids[0], $msg, $failed );
	}
	Carp::confess(
		root::get_hashEntries_as_string(
			$hash, 4, "You should not have been able to reach this!\n"
		)
	);
}

=head2 pids($path,@pids)

returns true if any of the pids are still active.
If the function does not get a list of pids, it will open the file $path/pids.txt and use the pids stored in the file.
After the check of pids the file  $path/pids.txt is created and all still active pids are stored in the file.
=cut

sub pids {
	my ( $path, @pids ) = @_;
	unless ( defined $pids[0] ) {
		open( IN, "<$path/pids.txt" ) or return 0;
		@pids = split( /\s/, join( "", <IN> ) );
		close(IN);
	}
	my @keep;
	foreach (@pids) {
		push( @keep, $_ ) if ( &check_pid($_) );
	}
	if ( @keep > 0 ) {
		open( OUT, ">$path/pids.txt" )
		  or warn "could not create the pid file '$path/pids.txt'\n$!";
		print OUT join( " ", @keep );
		close(OUT);
	}
	return @keep;
}

sub fix_rights {
	my $script = shift;
	my @path = split( "/", $script );
	my $path =
	  join( "/", @path[ 0 .. ( @path - 2 ) ] );    ## we get the script name!!
	print $db->NOW()
	  . ":chown -R apache:users $path \nchmod -R g+rw $path\nfind $path -type d -exec chmod 770 {} \+'\n"
	  if ($debug);
	system(
"chown -R apache:users $path \nchmod -R g+rw $path\nfind $path -type d -exec chmod 770 {} \+'"
	);
}

sub do_after_process_finished {
	my ( $hash, $sucess ) = @_;
	my $tab = $postprocess->for_module( $hash->{'module'} );
	if ( $tab->Lines() ) {
		my $prog_info = $tab->get_line_as_hash(0);
		unless ( $prog_info->{'program'} eq "no action" ) {
			print $db->NOW()
			  . ":$prog_info->{'program'} -workload_id $hash->{'id'}\n"
			  ;    #  if ( $debug);
			system("$prog_info->{'program'} -workload_id $hash->{'id'} &");
		}
	}
	else {
		warn
"I do not see a entry in the postprocess register for module '$hash->{'module'}'\n";
	}
	return 1;
}

sub get_error {
	unless ( open( IN, "<" . &get_filename(@_) ) ) {
		warn $!;
	}
	else {
		my $str = join( "", <IN> );
		close(IN);
		$str = undef unless ( $str =~ m/\w/ );
		return $str;
	}
	return undef;
}

sub get_filename {
	my ( $script_file, $pid ) = @_;
	my @tmp = split( "/", $script_file );
	return "/home/worker/" . pop(@tmp) . ".e$pid";
}

sub is_running() {
	my $hash = shift;
	return &check_pid( $hash->{'state'} ) if ( $hash->{'type'} eq "normal" );
	if ( $hash->{'type'} eq "multiple" ) {
		my @path = split( "/", $hash->{'script'} );
		pop(@path);
		return &pids( join( "/", @path ) );
	}
	Carp::confess("Unrecognized type '$hash->{'type'}'");
}

sub check_pid {
	my $pid = shift;
	return undef unless ( defined $pid);
	my @proc_data =
	  split( /\s+:\s+/,
		`su - worker -c 'qstat -f' | grep $pid | awk {'print \$1'}` );
	return ( @proc_data && $proc_data[1] == $pid ) ? $proc_data[0] : undef;
}

sub in_SGE {
	my @proc_data =
	  split( /\s+:\s+/,
		`su - worker -c "qstat | awk '{print \\\$1 }' | grep [0-9]"` );
	return { map { $_ => 1 } @proc_data };
}

