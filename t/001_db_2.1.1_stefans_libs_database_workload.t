#! /usr/bin/perl
use strict;
use warnings;
use Test::More tests => 10;
BEGIN { use_ok 'stefans_libs::database::workload' }
$ENV{'DBFILE'} = "/home/slang/dbh_config.xls";

my ( $value, @values, $exp );
my $obj = stefans_libs::database::workload->new( variable_table->getDBH() );
$obj->create();
is_deeply(
	ref($obj),
	'stefans_libs::database::workload',
	'simple test of function stefans_libs::database::workload -> new()'
);

ok(
	$value = $obj->AddDataset(
		{
			'username' => 'med-sal',
			'module'   => 'NGS sequencing',
			'info1'    => 'genome:mm10',
			'info2'    => 'Alignement type:DNA',
			'script'   => '/some/path/to/a/script.sh'
		}
	),
	"Add a work entry"
);
$value = @{ $obj->_select_all_for_DATAFIELD( 1, 'id' ) }[0];
delete( $value->{'creationtime'} );
delete( $value->{'changetime'} );

is_deeply(
	$value,
	{
		'username' => 'med-sal',
		'module'   => 'NGS sequencing',
		'info1'    => 'genome:mm10',
		'info2'    => 'Alignement type:DNA',
		'state'    => 0,
		'id'       => 1,
		'fail_info' => 'none',
		'script'   => '/some/path/to/a/script.sh',
	}, 'db entry is OK'
);

$value = $obj->check_new();
is_deeply( [ @{$value->{'header'}}, @{@{$value->{'data'}}[0]} ], [ 'id', 'script', 1, '/some/path/to/a/script.sh'], "get the new entry using check_new()");

$obj->process(1);
$value = @{ $obj->_select_all_for_DATAFIELD( 1, 'id' ) }[0];
ok( $value->{'state'} == -1, 'process' );

$value = $obj->check_new();
@{$value->{'data'}}[0] ||= [];
is_deeply( [ @{$value->{'header'}}, @{@{$value->{'data'}}[0]} ], [ 'id', 'script'], "new entry is lost check_new()");

$obj->process_SGE(1, 3421);
$value = @{ $obj->_select_all_for_DATAFIELD( 1, 'id' ) }[0];
ok( $value->{'state'} == 3421, 'process_SGE' );

$obj->finish(1);
$value = @{ $obj->_select_all_for_DATAFIELD( 1, 'id' ) }[0];
ok( $value->{'state'} == -3, 'finish' );

$obj->failed(1);
$value = @{ $obj->_select_all_for_DATAFIELD( 1, 'id' ) }[0];
ok( $value->{'state'} == -100, 'faile' );

#print "\$exp = ".root->print_perl_var_def($value ).";\n";

