use strict;
use warnings;
use Test::More tests => 8;
use stefans_libs::database::scientistTable;

$ENV{'DBFILE'} = "/home/slang/dbh_config.xls";

BEGIN { use_ok 'stefans_libs::WEB_Objects::scientistTable' }

my ( $value, @values, $exp, $temp );
my $object =
  stefans_libs_WEB_Objects_scientistTable->new(
	scientistTable->new( scientistTable->getDBH() ) );
is_deeply( ref($object), 'stefans_libs_WEB_Objects_scientistTable', "new" );

is_deeply(
	WEB_Objects_scientist_table_Role_List->new(
		role_list->new( scientistTable->getDBH() )
	  )->isa('stefans_libs_database_list_object'),
	1,
'WEB_Objects_scientist_table_Role_List -> isa stefans_libs_database_list_object'
);

@values = $object->get_formdef_array();
$exp    = [
	{
		'required' => '1',
		'value'    => undef,
		'name'     => 'username',
		'label'    => 'username'
	},
	{
		'required' => '1',
		'value'    => undef,
		'name'     => 'name',
		'label'    => 'name'
	},
	{
		'required' => '1',
		'value'    => undef,
		'name'     => 'workgroup',
		'label'    => 'workgroup'
	},
	{
		'required' => '1',
		'value'    => undef,
		'name'     => 'position',
		'label'    => 'position'
	},
	{
		'required' => '1',
		'value'    => undef,
		'name'     => 'email',
		'label'    => 'email'
	},
	{
		'required' => '1',
		'value'    => undef,
		'name'     => 'pw',
		'type'     => 'password',
		'label'    => 'pw'
	},
	{
		'required' => '1',
		'value'    => undef,
		'name'     => 'salt',
		'type'     => 'hidden',
		'label'    => 'salt'
	},
	{
		'options' =>
		  { '1' => 'BioInformatics', '2' => 'TCF7L2', '3' => 'Mitochondria', },
		'value'    => [],
		'name'     => 'action_gr_id',
		'multiple' => '1'
	},
	{
		'options' => {
			'4' => 'guest',
			'1' => 'admin',
			'3' => 'user',
			'2' => 'power-user',
		},
		'value'    => [],
		'name'     => 'roles_list_id',
		'multiple' => '1'
	}
];
is_deeply( \@values, $exp, "get_formdef_array (empty)" );

#print "\$exp = ".root->print_perl_var_def(\@values ).";\n";

## the problem here is, that the salt is very variable and the server has no way to store a specific salt.
## so to check whether the password is OK I would need to check whether I can log in using the scientisTable->check_pw( $c, $user, $pw, $old_pw, $salt )
## great - here I need a catalyst object ($c) great, but I need only two functions:
#$c->user( <some variable> );
#$c->session->{'user'} = $user;

$object->link_to_id(1);
@values = $object->get_formdef_array();

#print "\$exp = " . root->print_perl_var_def(\@values) . ";\n";
$exp = [
	{
		'name'     => 'username',
		'required' => '1',
		'value'    => 'med-sal',
		'label'    => 'username'
	},
	{
		'name'     => 'name',
		'required' => '1',
		'value'    => 'Stefan Lang',
		'label'    => 'name'
	},
	{
		'value'    => 'Stefan Lang',
		'required' => '1',
		'name'     => 'workgroup',
		'label'    => 'workgroup'
	},
	{
		'label'    => 'position',
		'value'    => 'CEO',
		'required' => '1',
		'name'     => 'position'
	},
	{
		'name'     => 'email',
		'required' => '1',
		'value'    => 'Stefan.Lang@med.lu.se',
		'label'    => 'email'
	},
	{
		'type'     => 'password',
		'label'    => 'pw',
		'name'     => 'pw',
		'required' => '1',
		'value'    => 'hidden'
	},
	{
		'required' => '1',
		'value'    => 'hidden',
		'name'     => 'salt',
		'type'     => 'hidden',
		'label'    => 'salt'
	},
	{
		'options' => {
			'3' => 'Mitochondria',
			'1' => 'BioInformatics',
			'2' => 'TCF7L2'
		},
		'name'     => 'action_gr_id',
		'multiple' => '1',
		'value'    => ['1']
	},
	{
		'options' => {
			'4' => 'guest',
			'3' => 'user',
			'1' => 'admin',
			'2' => 'power-user'
		},
		'name'     => 'roles_list_id',
		'multiple' => '1',
		'value'    => [ '1', '3' ]
	}
];
$values[8]->{'value'} = [ sort @{ $values[8]->{'value'} } ];
$values[5]->{'value'} = 'hidden';
$values[6]->{'value'} = 'hidden';
is_deeply( \@values, $exp, "get_formdef_array" );

$value = $object->process_my_values(
	{
		'username'      => 'med-sal',
		'name'          => 'Stefan Lang',
		'workgroup'     => 'Stefan Lang',
		'position'      => 'CEO',
		'email'         => 'Stefan.Lang@med.lu.se',
		'pw'            => 'ein wirklich neues PW',
		'roles_list_id' => [ 1, 3 ],
		'action_gr_id'  => [1],
	}
);

## now I want to check whether the password has become updated
my $c = basic_c->new();
is_deeply(
	$object->{'db_object'}->check_pw(
		$c,
		'med-sal',
		$object->{'db_object'}->_hash_pw( 'med-sal', 'ein wirklich neues PW' )
	),
	1,
	'the SU password was changed correctly'
);

## lets try to create a new user!
$object =
  stefans_libs_WEB_Objects_scientistTable->new(
	scientistTable->new( scientistTable->getDBH() ) );
$value = $object->process_my_values(
	{
		'username'      => 'slang',
		'name'          => 'Stefan Thomas Lang',
		'workgroup'     => 'Stefan Lang',
		'position'      => 'owner',
		'email'         => 'st.t.lang@gmx.de',
		'pw'            => 'some stupid password',
		'roles_list_id' => [3],
		'action_gr_id'  => [1],
	}
);
is_deeply( $value, 4, "Create a new user" );
$value = $object->{'db_object'}->get_data_table_4_search(
	{
		'search_columns' => ['*'],
		'where'          => [ [ 'username', '=', 'my_value' ] ],
	},
	'slang'
);

$value=  $value->get_line_asHash(0);
$value->{'scientists.salt'} = 'hidden';
$value->{'scientists.pw'} = 'hidden';
$exp = {
  'role_list.list_id' => '2',
  'scientists.workgroup' => 'Stefan Lang',
  'scientists.roles_list_id' => '2',
  'scientists.name' => 'Stefan Thomas Lang',
  'action_group_list.list_id' => '5',
  'action_group_list.id' => '7',
  'scientists.pw' => 'hidden',
  'roles.rolename' => 'user',
  'scientists.salt' => 'hidden',
  'scientists.id' => '4',
  'scientists.action_gr_id' => '5',
  'role_list.others_id' => '3',
  'scientists.position' => 'owner',
  'scientists.email' => 'st.t.lang@gmx.de',
  'role_list.id' => '5',
  'action_groups.id' => '1',
  'action_groups.description' => 'Help people in the lab',
  'roles.id' => '3',
  'action_group_list.others_id' => '1',
  'action_groups.name' => 'BioInformatics',
  'scientists.username' => 'slang'
};

is_deeply( $value,	$exp, "checked the new user" );

#print "\$exp = " . root->print_perl_var_def( $value ) . ";\n";

package basic_c;

sub new {
	my $self = {};
	bless $self, 'basic_c';
	return $self;
}

sub user {
}

sub session {
	return {};
}
