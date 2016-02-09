package stefans_libs::database::workload;

#  Copyright (C) 2010 Stefan Lang

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

use stefans_libs::database::variable_table;
use base variable_table;

use stefans_libs::database::scientistTable;

##use some_other_table_class;

use strict;
use warnings;

sub new {

	my ( $class, $dbh, $debug ) = @_;

	Carp::confess(
		"$class : new -> we need a acitve database handle at startup!, not "
		  . ref($dbh) )
	  unless ( ref($dbh) =~ m/::db$/ );

	my ($self);

	$self = {
		debug => $debug,
		dbh   => $dbh
	};

	bless $self, $class if ( $class eq "stefans_libs::database::workload" );
	$self->init_tableStructure();

	$self->{'select_new'} =
	  "SELECT id , script, type FROM " . $self->TableName() . " WHERE state = 0 ";
	$self->{'select_running'} =
	    "SELECT id , script, state, module, type FROM "
	  . $self->TableName()
	  . " WHERE state > 0 ";
	return $self;

}

sub init_tableStructure {
	my ( $self, $dataset ) = @_;
	my $hash;
	$hash->{'INDICES'}    = [];
	$hash->{'UNIQUES'}    = [];
	$hash->{'variables'}  = [];
	$hash->{'table_name'} = "workload";
	push(
		@{ $hash->{'variables'} },
		{
			'name'         => 'username',
			'type'         => 'VARCHAR (40)',
			'NULL'         => '0',
			'description'  => 'the scientist username',
			'data_handler' => 'scientistTable',
			'link_to'      => 'username',
		}
	);
	push(
		@{ $hash->{'variables'} },
		{
			'name'         => 'type',
			'type'         => 'VARCHAR (40)',
			'NULL'         => '0',
			'description'  => 'there are two types 1: normal - one script one qsub call, 2: multiple - one cript to be broken down into <lines> 1 processor qsub calls',
		}
	);
	push(
		@{ $hash->{'variables'} },
		{
			'name'        => 'module',
			'type'        => 'VARCHAR (100)',
			'NULL'        => '0',
			'description' => 'the NGS_pipeline plugin that creates data',
		}
	);
	push(
		@{ $hash->{'variables'} },
		{
			'name'        => 'info1',
			'type'        => 'VARCHAR (100)',
			'NULL'        => '0',
			'description' => 'info1 from the module',
		}
	);
	push(
		@{ $hash->{'variables'} },
		{
			'name'        => 'info2',
			'type'        => 'VARCHAR (100)',
			'NULL'        => '0',
			'description' => 'info2 from the module',
		}
	);
	push(
		@{ $hash->{'variables'} },
		{
			'name'        => 'fail_info',
			'type'        => 'VARCHAR (100)',
			'NULL'        => '0',
			'description' => 'a short information of why this did fail.',
		}
	);
	push(
		@{ $hash->{'variables'} },
		{
			'name'        => 'creationtime',
			'type'        => 'TIMESTAMP',
			'NULL'        => '0',
			'description' => 'an automatic timestamp',
		}
	);
	push(
		@{ $hash->{'variables'} },
		{
			'name'        => 'changetime',
			'type'        => 'TIMESTAMP',
			'NULL'        => '0',
			'auto_update' => 1,
			'description' => 'an automatic timestamp',
		}
	);
	push(
		@{ $hash->{'variables'} },
		{
			'name'    => 'script',
			'type'    => 'VARCHAR(400)',
			'NULL'    => '0',
			'default' => 0,
			'description' =>
			  'the script to be executed (absolute path on the server)',
		}
	);
	push(
		@{ $hash->{'variables'} },
		{
			'name'    => 'state',
			'type'    => 'INTEGER',
			'NULL'    => '1',
			'default' => 0,
			'description' =>
'and internal state 0=new; -1=processed by backend; PID=processed by SGE; -3=finished OK; -100=broken',
		}
	);
	push( @{ $hash->{'UNIQUES'} }, ['creationtime'] );

	$self->{'table_definition'} = $hash;
	$self->{'UNIQUE_KEY'}       = ['creationtime'];

	$self->{'table_definition'} = $hash;

	$self->{'_tableName'} = $hash->{'table_name'}
	  if ( defined $hash->{'table_name'} )
	  ; # that is helpful, if you want to use this class without any variable tables

	##now we need to check if the table already exists. remove that for the variable tables!
	unless ( $self->tableExists( $self->TableName() ) ) {
		$self->create();
	}
	## Table classes, that are linked to this class have to be added as 'data_handler',
	## both in the variable definition and here to the 'data_handler' hash.
	## take care, that you use the same key for both entries, that the right data_handler can be identified.
	$self->{'data_handler'}->{'scientistTable'} =
	  scientistTable->new( $self->{'dbh'}, $self->{'debug'} );

	#$self->{'data_handler'}->{''} = some_other_table_class->new( );
	return $dataset;
}

sub DO_ADDITIONAL_DATASET_CHECKS {
	my ( $self, $dataset ) = @_;

	$dataset->{'state'}     ||= 0;
	$dataset->{'fail_info'}     ||= 'none';
	$self->{'error'} .= ref($self) . ":: Database has been updated - I need a type! \n"
	  unless (defined $dataset->{'type'});

	return 0 if ( $self->{'error'} =~ m/\w/ );
	return 1;
}

sub check_new {
	my ($self) = @_;
	$self->{'use_this_sql'} = $self->{'select_new'};
	return $self->get_data_table_4_search(
		{
			'search_columns' => [ 'id', 'script', 'type' ],
			'where'          => [],
		},
	);
}

sub get_running {
	my ($self) = @_;
	$self->{'use_this_sql'} = $self->{'select_running'};
	return $self->get_data_table_4_search(
		{
			'search_columns' => [ 'id', 'script', 'state', 'module', 'type' ],
			'where'          => [],
		},
	);
}


sub get_processes_for_all_users{
	my ( $self ) = @_;
	my $table = $self->get_data_table_4_search(
		{
			'search_columns' => [ ref($self) . '.*' ],
			'where' => [ ],
			'limit' => 'limit 100',
		},
	);
	$table->Remove_from_Column_Names( $self->TableName() . "." );
	$table->calculate_on_columns(
		{
			'data_column'   => 'state',
			'target_column' => 'state',
			'function'      => sub {
				my $hash = {
					'-3'   => 'finished',
					'0'    => 'new',
					'-1'   => 'processing',
					'-100' => 'failed',
				};
				return $hash->{ $_[0] }
				  if ( defined $hash->{ $_[0] } );
				return "queued";
			  }
		}
	);
	return $table;
}

sub get_processes_for_user {
	my ( $self, $username ) = @_;
	my $table = $self->get_data_table_4_search(
		{
			'search_columns' => [ ref($self) . '.*' ],
			'where' => [ [ ref($self) . '.username', '=', 'my_value' ] ],
			'limit' => 'limit 100',
		},
		$username
	);
	$table->Remove_from_Column_Names( $self->TableName() . "." );
	$table->calculate_on_columns(
		{
			'data_column'   => 'state',
			'target_column' => 'state',
			'function'      => sub {
				my $hash = {
					'-3'   => 'finished',
					'0'    => 'new',
					'-1'   => 'processing',
					'-100' => 'failed',
				};
				return $hash->{ $_[0] }
				  if ( defined $hash->{ $_[0] } );
				return "queued";
			  }
		}
	);
	return $table;
}

sub finish {
	my ( $self, $id ) = @_;
	$self->{'dbh'}->do( 'update '
		  . $self->TableName()
		  . " set state = -3 , changetime = NOW() where id = $id;" );
	return 1;
}

sub process {
	my ( $self, $id ) = @_;
	$self->{'dbh'}->do( 'update '
		  . $self->TableName()
		  . " set state = -1, changetime = NOW() where id = $id;" );
	return 1;
}

sub process_SGE {
	my ( $self, $id, $PID ) = @_;
	$self->{'dbh'}->do( 'update '
		  . $self->TableName()
		  . " set state = $PID, changetime = NOW() where id = $id;" );
	return 1;
}

sub failed {
	my ( $self, $id, $cause ) = @_;
	unless ( defined $id ) {
		$self->{'use_this_sql'} =
"Select id,username, info1, info2, changetime, script, state, module from "
		  . $self->TableName
		  . " where state = -100";
		return $self->get_data_table_4_search(
			{
				'search_columns' => [
					'id',         'username', 'info1', 'info2',
					'changetime', 'script',   'state', 'module'
				],
				'where' => [],
			},
		);
	}
	$self->{'dbh'}->do( 'update '
		  . $self->TableName()
		  . " set state = -100, changetime = NOW(), fail_info = '$cause'  where id = $id"
	);
	return 1;
}

sub expected_dbh_type {
	return 'dbh';

	#return 'database_name';
}

1;
