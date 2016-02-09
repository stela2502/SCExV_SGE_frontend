#!/usr/bin/env perl
use strict;
use warnings;
use Test::More 'no_plan';
use Digest::MD5;
use FindBin;

my $plugin_path = "$FindBin::Bin";

$ENV{'DBFILE'} = "/home/slang/dbh_config.xls";

use Test::WWW::Mechanize::Catalyst 'NGS_pipeline';
use stefans_libs::flexible_data_structures::data_table;

my $mech = Test::WWW::Mechanize::Catalyst->new();
my ($OK);
$mech->get_ok("https://localhost/") or print $mech->content();

$mech->get_ok("https://localhost/login") or print $mech->content();
$OK = 1;
$mech->form_number(1);
$mech->field( 'username', 'med-sal' );
$mech->field( 'password', 'TEST' );
$mech->click_button( value => 'Submit' );
$mech->content_contains("http://localhost/administration/ModifyUser/")
  or $OK = 0;
$mech->content_contains("http://localhost/logout")               or $OK = 0;
$mech->content_contains("http://localhost/administration/index") or $OK = 0;
$mech->content_contains("<h1>Start Page for the NGS_Pipeline web tool</h1>")
  or $OK = 0;
&check('Initial login');

$mech->get_ok("http://localhost/start/") or print $mech->content();
$mech->content_contains("Add paired FASTQ files (optional):") or $OK = 0;
system (" rm -Rf $plugin_path/../root/users/med-sal/scripts/" ) if ( -d "$plugin_path/../root/users/med-sal/scripts/" );
&check('Start analysis page');


$OK = 1;
$mech->form_number(1);
$mech->field( 'program', 'STAR' );
$mech->field( 'fastq1', "$plugin_path/data/some_testA1.fq" );
$mech->field( 'fastq2', "$plugin_path/data/some_testA1.2.fq" );
$mech->field( 'genomeName' ,'mm10');
$mech->field( 'orderKey', 'A' );
$mech->field( 'type', 'RNA');
$mech->field( 'organism', 'mouse');
$mech->field( 'celltype', 'test cells');
$mech->field( 'group', 'test1');
$mech->field( 'version', 'mm10');
$mech->click_button( value => 'Submit' );

my $opath = "$plugin_path/../root/users/med-sal/scripts/";
ok( -d $opath, "the scripts folder has been created ($plugin_path/../root/users/med-sal/scripts/), $!" );
## I do not check the scripts here, as they are created and any other check is way easier when the program is available.



sub check {
	my $STR = shift;
	$STR ||= 'No info';
	unless ($OK) {
		my $ofile = "$plugin_path/data/Outpath/".join("_",split(/\s/,$STR)).".html";
		open ( OUT , ">$ofile" ) or die $!;
		print OUT $mech->content();
		close ( OUT );
		system ( "firefox $ofile&");
		warn $STR . " NOT OK\n";
		$OK = 1;
	}
	else {
		print $STR. " OK\n";
	}
}
