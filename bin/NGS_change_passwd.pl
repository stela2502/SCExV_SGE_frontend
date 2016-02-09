#! /usr/bin/perl -w

#  Copyright (C) 2015-04-23 Stefan Lang

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

=head1 NGS_change_passwd.pl

This script can be used to chenge the web passowerds for a given DB connection.

To get further help use 'NGS_change_passwd.pl -help' at the comman line.

=cut

use Getopt::Long;
use strict;
use warnings;
use stefans_libs::database::scientistTable;

use FindBin;
my $plugin_path = "$FindBin::Bin";

my $VERSION = 'v1.0';


my ( $help, $debug, $database, $username, $new_passord, $db_driver, $host, $port, $db_name, $db_user, $db_pw);

Getopt::Long::GetOptions(
	 "-username=s"    => \$username,
	 "-new_passord=s"    => \$new_passord,
	 "-db_driver=s"    => \$db_driver,
	 "-host=s"    => \$host,
	 "-port=s"    => \$port,
	 "-db_name=s"    => \$db_name,
	 "-db_user=s"    => \$db_user,
	 "-db_pw=s"    => \$db_pw,

	 "-help"             => \$help,
	 "-debug"            => \$debug
);

my $warn = '';
my $error = '';

unless ( defined $username) {
	$error .= "the cmd line switch -username is undefined!\n";
}
unless ( defined $new_passord) {
	$error .= "the cmd line switch -new_passord is undefined!\n";
}
unless ( defined $db_driver) {
	$db_driver = 'mysql';
	$warn .= "driver set to '$db_driver'!\n";
}
unless ( defined $host) {
	$host = 'localhost';
	$warn .= "host set to '$host'!\n";
}
unless ( defined $port) { 
	$warn .= "the cmd line switch -port is undefined!\n";
}
unless ( defined $db_name) {
	$error .= "the cmd line switch -db_name is undefined!\n";
}
unless ( defined $db_user) {
	$error .= "the cmd line switch -db_user is undefined!\n";
}
unless ( defined $db_pw) {
	$error .= "the cmd line switch -db_pw is undefined!\n";
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
 command line switches for new_NGS_change_passwd.pl

   -username       :the web username to change
   -new_passord    :the new password
   -db_driver      :the db driver (MySQL)
   -host           :the host to connect to (localhost)
   -port           :the optional port
   -db_name        :the required name of the db
   -db_user       :<please add some info!>
   -db_pw       :<please add some info!>
   
   -help           :print this help
   -debug          :verbose output
   

"; 
}


my ( $task_description);

$task_description .= 'perl '.$plugin_path .'/NGS_change_passwd.pl';
$task_description .= " -username $username" if (defined $username);
$task_description .= " -new_passord $new_passord" if (defined $new_passord);
$task_description .= " -db_driver $db_driver" if (defined $db_driver);
$task_description .= " -host $host" if (defined $host);
$task_description .= " -port $port" if (defined $port);

my $connection_str = "DBI:$db_driver:$db_name:$host";
		$connection_str .= ":$port"
		  if ( defined $port );
my $dbh = DBI->connect_cached($connection_str, $db_user,$db_pw)
		  or Carp::confess(
			 "getDBH -> we die from errors using connection string $connection_str\n",
			DBI->errstr
		  );

my $scientistTable = scientistTable->new($dbh);
my $id = $scientistTable -> Get_id_for_name ( $username );
my ( $pw, $old_pw, $salt ) = $scientistTable->_hash_pw($username, $new_passord);
$scientistTable -> UpdateDataset ( {'id' => $id, 'pw' => $pw, 'salt' => $salt  });

print "Password updated for user $username\n";
