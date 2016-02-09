#! /usr/bin/perl -w

#  Copyright (C) 2015-02-20 Stefan Lang

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

=head1 ngs_pipeline_change_pw.pl

Change the passowrd of a user.

To get further help use 'ngs_pipeline_change_pw.pl -help' at the comman line.

=cut

use Getopt::Long;
use strict;
use warnings;

use stefans_libs::database::scientistTable;

use FindBin;
my $plugin_path = "$FindBin::Bin";

my $VERSION = 'v1.0';


my ( $help, $debug, $database, $dbh_config, $username, $pw);

Getopt::Long::GetOptions(
	 "-dbh_config=s"    => \$dbh_config,
	 "-username=s"    => \$username,
	 "-pw=s"    => \$pw,

	 "-help"             => \$help,
	 "-debug"            => \$debug
);

my $warn = '';
my $error = '';

unless ( -f $dbh_config) {
	$error .= "the cmd line switch -dbh_config is undefined!\n";
}
unless ( defined $username) {
	$error .= "the cmd line switch -username is undefined!\n";
}
unless ( defined $pw) {
	$error .= "the cmd line switch -pw is undefined!\n";
}


if ( $help ){
	print helpString( ) ;
	exit;
}

if ( $error =~ m/\w/ ){
	print helpString($error ) ;
	exit;
}

sub helpString {
	my $errorMessage = shift;
	$errorMessage = ' ' unless ( defined $errorMessage); 
 	return "
 $errorMessage
 command line switches for ngs_pipeline_change_pw.pl

   -dbh_config       :<please add some info!>
   -username       :<please add some info!>
   -pw       :<please add some info!>

   -help           :print this help
   -debug          :verbose output
   

"; 
}


my ( $task_description);

$task_description .= 'perl '.root->perl_include().' '.$plugin_path .'/ngs_pipeline_change_pw.pl';
$task_description .= " -dbh_config $dbh_config" if (defined $dbh_config);
$task_description .= " -username $username" if (defined $username);
$task_description .= " -pw $pw" if (defined $pw);

$ENV{'DBFILE'} = $dbh_config;

## Do whatever you want!

my $db = scientistTable->new(variable_table->getDBH());
my ($hashed,  $old, $salt ) = $db->_hash_pw($username, $pw ) ;
my $id = $db->UpdateDataset( { 'username' => $username, 'pw' => $hashed , 'id' => $db -> Get_id_for_name( $username) } );
print "Password for user $id changed!\n";

