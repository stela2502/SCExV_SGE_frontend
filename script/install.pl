#! /usr/bin/perl -w

#  Copyright (C) 2008 Stefan Lang

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

=head1 install.pl

Use this script to install the NGS_SGE server to your computer.

To get further help use 'setup.pl -help' at the comman line.

=cut

use Getopt::Long;
use FindBin;
use Digest::MD5 qw(md5_hex);
use stefans_libs::install_helper;
use stefans_libs::database::scientistTable;
use stefans_libs::database::process_finished;

use strict;
use warnings;
my $plugin_path = "$FindBin::Bin";

my $VERSION = 'v1.0';

my (
	$install_path, $help,     $server_user, $debug,    $shared_path,
	@options,      $web_root, $dbhfile,     $username, $pw,
	$groupName,    $position, $name,        $email,
);

#my $root_path = "/var/www/html/HTPCR/";

Getopt::Long::GetOptions(
	"-install_path=s" => \$install_path,
	"-server_user=s"  => \$server_user,
	"-web_root=s"     => \$web_root,
	"-options=s{,}"   => \@options,
	"-shared_path=s"  => \$shared_path,
	"-dbhfile=s"      => \$dbhfile,
	"-name=s"         => \$name,
	"-username=s"     => \$username,
	"-email=s"        => \$email,
	"-pw=s"           => \$pw,
	"-groupName"      => \$groupName,
	"-position=s"     => \$position,

	"-help"  => \$help,
	"-debug" => \$debug
);

my $warn  = '';
my $error = '';

unless ( defined $username ) {
	$error .= "the cmd line switch -username is undefined!\n";
}
unless ( defined $pw ) {
	$error .= "the cmd line switch -pw is undefined!\n";
}
unless ( defined $groupName ) {
	$error .= "the cmd line switch -groupName is undefined!\n";
}
unless ( defined $position ) {
	$error .= "the cmd line switch -position is undefined!\n";
}
unless ( defined $name ) {
	$error .= "the cmd line switch -name is undefined!\n";
}
## check whether this information would be needed
$ENV{DBFILE} = $dbhfile;
my $db = scientistTable->new();
if ( $error =~ m/\w/ ) {
	my $test = $db->get_data_table_4_search(
		{
			'search_columns' => ['username'],
			'where'          => [ [ 'rolename', '=', 'my_value' ] ],
			'limit'          => 'limit 1'
		},
		'admin'
	);
	if ( $test->Lines() ) {
		$error = '';
		warn
"You have not given any user information, but luckily there is one other admin user installed: '@{@{$test->{data}}[0]}[0]'\n";
	}
}

unless ( defined $server_user ) {
	$error .= "the cmd line switch -server_user is undefined!\n";
}
unless ( defined $dbhfile ) {
	$error .= "the cmd line switch -dbhfile is undefined!\n";
}
unless ( defined $shared_path ) {
	$error .= "the cmd line switch -shared_path is undefined!\n";
}
unless ( defined $install_path ) {
	$error .= "the cmd line switch -install_path is undefined!\n";
}
unless ( defined $web_root ) {
	$web_root = "/var/www/html/";
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
 command line switches for install.pl

   -install_path  :your server path
   -shared_path   :the path where I create the users data directory
                   this path has to be accessible by the user that runs the
                   backend and by all the nodes - on the same absolute path
   -dbhfile       :the database configuration file used by perl
   
   -server_user   :the system user that needs to have access to all files
   -web_root      :the root of the web server - css and jscript files are installed there
                   default to '/var/www/html/'
   -options       :additional option for the SCExV server like
                   randomForest 1 ncore 4 
 	
   -help   :print this help
   -debug  :verbose output   
              
 Create the first user of the tool (admin & user role)
 
    -name      :the name of the user
    -username  :the admin username (unique)
	-pw        :the admin password
	-groupName :the admin group name
	-position  :teh admin position in this group
	
";
}

my $install_helper = stefans_libs::install_helper->new();

## I have changed the logics of the server - all served files /root/ will get located in the /var/www/http/HTPCR/ folder
sub copy_files {
	return $install_helper->copy_files(@_);
}

## user definition

if ( defined $username ) {
	my ( $pw_hashed, $unused, $salt ) = $db->_hash_pw( $username, $pw );
	unless ( $db->Get_id_for_name($username) ) {    ## new user
		$db->AddDataset(
			{
				'username'  => $username,
				'name'      => $name,
				'workgroup' => $groupName,
				'position'  => $position,
				'email'     => $email,
				'roles_list' =>
				  [ { 'rolename' => 'user' }, { 'rolename' => 'admin' } ],
				'pw'   => $pw_hashed,
				'salt' => $salt,
			}
		);
		print "I have added the new user '$username' to the db.";
	}
	unless ( $db->check_pw( undef, $username, $pw_hashed ) ) {
		warn
"The password you have given here is not valid for the axisting user!\nUse the right PW at the web frontend or change it using the change_user_pw.pl script.\n";
	}
	else {
		warn "User data OK!\n";
	}
}

## patch the main function to include the new root path

my $patcher =
  $install_helper->{'patcher'}->new( $plugin_path . "/../lib/NGS_pipeline.pm" );

my $tmp = $install_path;
$tmp =~ s/$web_root/\//;

my $options = '';
for ( my $i = 0 ; $i < @options ; $i += 2 ) {
	$options .= "\t$options[$i] => '$options[$i+1]',\n"
	  if ( defined $options[ $i + 1 ] );
}
$patcher->replace_string( "    -Debug\n", '' );
$patcher->replace_string(
	"    ##addhere",
    "    root => '$install_path',\n"
	  . "    shared_path => '$shared_path',\n"
	  . $options
);
$patcher->replace_string( "/home/slang/dbh_config.xls", $dbhfile );
$patcher->write_file();

my $postprocess = stefans_libs::database::process_finished->new( $db->{'dbh'} );
$postprocess->create();
$postprocess->AddDataset(
	{ 'module' => 'NGS mapping', 'program' => "no action" } );
$postprocess->AddDataset(
	{
		'module' => 'Random Forest Calculation',
		'program' => "/usr/local/bin/reportFluidigm.pl"
	}
);

system("make -C $plugin_path/../");
system("make install -C $plugin_path/../");

&copy_files( "$plugin_path/../root/", $install_path );
system( "cp $plugin_path/../ngs_pipeline.* " . $install_path );

unless ( -d "$install_path/users/" ) {
	mkdir("$install_path/users/");
	print "You need to allow the httpd to get access to the users dir!\n"
	  . "execute on fedora or CentOS:\n"
	  . "chcon -R system_u:object_r:httpd_sys_rw_content_t:s0 $install_path/\n";
}

system("chown -R $server_user:root $install_path");

print "\nAll server files stored in '$install_path'\n\n"
  . "If you want to set up a apache server\nyou should modify your apache2 configuration like that:\n"
  . "<VirtualHost *:80>
        ServerName localhost
        ServerAdmin email\@host
        HostnameLookups Off
        UseCanonicalName Off
        <Location $tmp>
                SetHandler modperl
                PerlResponseHandler Plack::Handler::Apache2
                PerlSetVar psgi_app \"$install_path" . "ngs_pipeline.psgi\"
        </Location>
</VirtualHost>
\nPlease see this only as a hint on how to set up apache to work with this server!\n";

print "IN case the server does not work as expected (fedora):\n"
  . "chcon -R system_u:object_r:httpd_sys_content_t:s0 $install_path\n";

print "The server user also need access to the shared_path:\n"
  . "chcon -R system_u:object_r:httpd_sys_rw_content_t:s0 $shared_path/\n";

system("mkdir $shared_path/users/");
my $patcher2 = $install_helper->{'patcher'}->new( $plugin_path . "/SysV.sh" );
$patcher2->replace_string( '###OPTIONS_NGS_SGE###',
	"-dbh_definition '$dbhfile'" );
$patcher2->write_file();
my $patcher3 =
  $install_helper->{'patcher'}->new( $plugin_path . "/systemd.sh" );
$patcher3->replace_string( '###OPTIONS_NGS_SGE###',
	"-dbh_definition '$dbhfile'" );
$patcher2->write_file();

eval { system("cp $plugin_path/SysV.sh /etc/rc.d/init.d/ngs_sge"); };
eval {
	system("cp $plugin_path/systemd.sh /etc/systemd/system/ngs_sge.service");
};
system("chmod +x /etc/rc.d/init.d/ngs_sge");
system("chkconfig ngs_sge on");

sub patch_files {
	my ( $pattern, $replace, @files ) = @_;
	my $OK;
	foreach my $file (@files) {
		next unless ( -f $file );
		my $patcher = stefans_libs::file_readers::Patcher->new($file);
		$OK = 0;
		$OK = $patcher->replace_string( $pattern, $replace );

		#	print "Replaced at $OK position(s) of file $file\n";
		$patcher->write_file() if ($OK);
	}
}
