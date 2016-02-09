#! /usr/bin/perl
use strict;
use warnings;
use Test::More tests => 10;
use stefans_libs::root;
use Digest::MD5 qw(md5_hex);
BEGIN { use_ok 'stefans_libs::database::scientistTable' }

$ENV{'DBFILE'} = "/home/slang/dbh_config.xls";

my $scientistTable = scientistTable->new('geneexpress');

$scientistTable->{'dbh'}->do('drop table role_list');
$scientistTable->{'dbh'}->do('drop table roles');

$scientistTable = scientistTable->new();

$scientistTable->create();

$scientistTable->{'data_handler'}->{'action_group_list'}->AddDataset(
	[
		{
			'name'        => 'BioInformatics',
			'description' => 'Help people in the lab'
		},
		{
			'name'        => 'TCF7L2',
			'description' => 'Clarify the influence of TCF7L2 on T2D'
		},
		{ 'name' => 'Mitochondria', 'description' => 'no idea' }
	]
  );


#|  1 | Stefan Lang    | Leif Groop     | TCF7         | postdoc     | Stefan.Lang@med.lu.se           |
#|  2 | Yuedan Zhou    | Leif Groop     | TCF7         | PhD student | Yuedan.Zhou@med.lu.se           |
#|  3 | Marloes Dekker | Charlotte Ling | Mitochondria | postdoc     | marloes.dekker_nitert@med.lu.se |

  is_deeply( ref($scientistTable), 'scientistTable',
	'simple test of function scientistTable -> new()' );

#$scientistTable->create();

$scientistTable->AddDataset(
	{
		'username'  => 'med-sal',
		'name'      => 'Stefan Lang',
		'workgroup' => 'Shamit Soneji',
		'position'  => 'postdoc',
		'action_gr_id' =>  0,
		'roles_list_id' =>  0,
		'email' => 'Stefan.Lang@med.lu.se'
	}
);

#print $scientistTable->{'last_insert_stm'}."\n";

$scientistTable->AddDataset(
	{
		'username'  => 'yuedan',
		'name'      => 'Yuedan Zhou',
		'workgroup' => 'Leif Groop',
		'position'  => 'PhD student',
		'action_gr_id' => 0,
		'roles_list_id' =>  0,
		'email' => 'Yuedan.Zhou@med.lu.se'
	}
);

#print $scientistTable->{'last_insert_stm'}."\n";

$scientistTable->AddDataset(
	{
		'username'  => 'marloes',
		'name'      => 'Marloes Dekker',
		'workgroup' => 'Leif Groop',
		'position'  => 'postdoc',
		'action_gr_id' => 0,
		'roles_list_id' =>  0,
		'email'     => 'marloes.dekker_nitert@med.lu.se'
	}
);

#print $scientistTable->{'last_insert_stm'}."\n";

my ( $value, @values, $expected );

$value = $scientistTable->Get_id_for_name('med-sal');

is_deeply( $value, 1, "search for name" );


is_deeply(
	$scientistTable->AddRole( { 'username' => 'med-sal', 'role' => 'admin' } ),
	1,
	"we can add a role"
);
is_deeply(
	$scientistTable->AddRole( { 'username' => 'med-sal', 'role' => 'guest' } ),
	1,
	"we can add a role"
);

is_deeply( $scientistTable->user_has_role( 'med-sal', 'admin' ),
	1, "user has role 'admin'" );
is_deeply( $scientistTable->user_has_role( 'med-sal', 'guest' ),
	1, "user has role 'guest'" );

is_deeply( $scientistTable->user_has_role( 'med-sal', 'test_user' ),
	0, "and if a role does not exist we get a 0 back" );

$scientistTable->{'data_handler'}->{'role_list'}
  ->UpdateList( { 'list_id' => 1, 'other_ids' => [ 1, 2 ] } );

is_deeply( $scientistTable->user_has_role( 'med-sal', 'power-user' ),
	1, "we can add roles by updating the list" );
is_deeply( $scientistTable->user_has_role( 'med-sal', 'guest' ),
	0, "we can remove roles by updating the list" );

