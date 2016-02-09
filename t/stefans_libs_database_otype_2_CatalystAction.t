#! /usr/bin/perl
use strict;
use warnings;
use Test::More tests => 4;
BEGIN { use_ok 'stefans_libs::database::otype_2_CatalystAction' }

$ENV{'DBFILE'} = "/home/slang/dbh_config.xls";

my ( $value, @values, $exp );

my $obj =
  stefans_libs::database::otype_2_CatalystAction->new(
	variable_table->getDBH() );
is_deeply( ref($obj), 'stefans_libs::database::otype_2_CatalystAction',
'simple test of function stefans_libs::database::otype_2_CatalystAction -> new()'
);

$obj->create();

$value = $obj->AddDataset(
	{ 'type' => 'text', 'module' => 'NGS_SGE', 'action' => 'html_view/index/' }
);
ok( $value, 'managed to add a root file type handler' );

$value = $obj->AddDataset(
	{ 'type' => 'html', 'module' => 'NGS_SGE', 'action' => 'html_view/index/' }
);
$value = $obj->AddDataset(
	{ 'type' => 'text', 'module' => 'FUN', 'action' => 'fun_view/index/' } );

$value = $obj->Populate();

#print "\$exp = " . root->print_perl_var_def($value) . ";\n";
$exp = {
	'NGS_SGE' => {
		'html' => 'html_view/index/',
		'text' => 'html_view/index/'
	},
	'FUN' => {
		'text' => 'fun_view/index/'
	}
};
is_deeply ( $value, $exp, "Populate");



#print "\$exp = ".root->print_perl_var_def($value ).";\n";