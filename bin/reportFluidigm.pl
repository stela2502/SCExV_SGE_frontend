#! /usr/bin/perl -w

#  Copyright (C) 2015-03-02 Stefan Lang

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

=head1 reportFluidigm.pl

This script sends back finished Fluidigm result to the SCExV server.

To get further help use 'reportFluidigm.pl -help' at the comman line.

=cut

use Getopt::Long;
use strict;
use warnings;

use stefans_libs::database::workload;
use WWW::Mechanize;
use Digest::MD5 qw(md5_hex);

use FindBin;
my $plugin_path = "$FindBin::Bin";

my $VERSION = 'v1.0';

my ( $help, $debug, $database, $workload_id, $log_file );

Getopt::Long::GetOptions(
	"-workload_id=s" => \$workload_id,
	"-log_file=s" => \$log_file,

	"-help"  => \$help,
	"-debug" => \$debug
);

my $warn  = '';
my $error = '';

unless ( defined $workload_id ) {
	$error .= "the cmd line switch -workload_id is undefined!\n";
}
unless ( defined $log_file ) {
	$warn .= "the cmd line switch -log_file is undefined!\n";
	$log_file = "/etc/ngs_sge/reportFluidigm.log"; 
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
 command line switches for reportFluidigm.pl

   -workload_id       :the workload id that has to be postprocessed
   -log_file          :default = /etc/ngs_sge/reportFluidigm.log

   -help           :print this help
   -debug          :verbose output
   

";
}

my ($task_description);

$task_description .=
  'perl ' . root->perl_include() . ' ' . $plugin_path . '/reportFluidigm.pl';
$task_description .= " -workload_id $workload_id" if ( defined $workload_id );

my $workload =
  stefans_libs::database::workload->new( variable_table->getDBH() );

print "The dbh configuration file is: " . $ENV{'DBFILE'} . "\n";

open my $log_fh, '>>', $log_file;
*STDOUT = $log_fh;
*STDERR = $log_fh;

print $workload->NOW().":start $task_description\n";

$workload->{'use_this_sql'} =
    "select script, info1, info2 from "
  . $workload->TableName()
  . " where id = $workload_id;";

my $data = $workload->get_data_table_4_search(
	{
		'search_columns' => [ 'script', 'info1', 'info2' ],
		'where'          => [],
	},
);
Carp::confess("This id $workload_id does not exist!\n")
  unless ( $data->Lines() );
my $dataset = $data->get_line_as_hash(0);
## now I check the path and pack all .Rdata objects into a tar.gz file
my @path = split( "/", $dataset->{'script'} );
pop(@path);    # the script file is not of interest!
$path[0] = join( "/", @path );
chdir( $path[0] );
print "Working in path $path[0]\n";
unlink("RandomForest_transfereBack.tar.gz")
  if ( -f "RandomForest_transfereBack.tar.gz" );
unless ( -f 'RandomForestdistRFobject.RData') {
	sleep(10);
}
unless ( -f 'RandomForestdistRFobject_genes.RData') {
	sleep(10);
}
sleep(60);
system(
'tar -cf RandomForest_transfereBack.tar RandomForestdistRFobject.RData RandomForestdistRFobject_genes.RData'
);
system('gzip -f9 RandomForest_transfereBack.tar');
my $mech = WWW::Mechanize->new();
my $ctx  = Digest::MD5->new;
open( DATA, "<" . $path[0] . '/RandomForest_transfereBack.tar.gz' )
  or die "$!\n";
$ctx->addfile(*DATA);
close(DATA);
my $md5_sum = $ctx->b64digest;
$mech->get( "http://" . $dataset->{'info1'} );
$mech->form_number(1);
$mech->field('fn'      =>  $path[0] . "/RandomForest_transfereBack.tar.gz");
$mech->field('md5'     => $md5_sum );
$mech->field('session' => $dataset->{'info2'} );
$mech->submit();

print 'rm -Rf '.$path[0];
system ( 'rm -Rf '.$path[0] );

#print $mech->content();

