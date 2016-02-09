package stefans_libs::database::outfiles;

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

use stefans_libs::database::workload;

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

	bless $self, $class if ( $class eq "stefans_libs::database::outfiles" );
	$self->init_tableStructure();

	return $self;

}

sub init_tableStructure {
	my ( $self, $dataset ) = @_;
	my $hash;
	$hash->{'INDICES'}    = [];
	$hash->{'UNIQUES'}    = [];
	$hash->{'variables'}  = [];
	$hash->{'table_name'} = "outfiles";
	push(
		@{ $hash->{'variables'} },
		{
			'name'         => 'work_id',
			'type'         => 'INTEGER UNSIGNED',
			'NULL'         => '0',
			'description'  => '',
			'data_handler' => 'stefans_libs::database::workload',
			'link_to'      => 'id',
		}
	);
	push(
		@{ $hash->{'variables'} },
		{
			'name'        => 'file',
			'type'        => 'VARCHAR (300)',
			'NULL'        => '0',
			'description' => '',
		}
	);
	push(
		@{ $hash->{'variables'} },
		{
			'name'        => 'type',
			'type'        => 'VARCHAR (30)',
			'NULL'        => '0',
			'description' => '',
		}
	);push(
		@{ $hash->{'variables'} },
		{
			'name'        => 'created',
			'type'        => 'TIMESTAMP',
			'NULL'        => '0',
			'description' => '',
		}
	);
	push(
		@{ $hash->{'variables'} },
		{
			'name'        => 'md5sum',
			'type'        => 'VARCHAR (32)',
			'NULL'        => '1',
			'description' => '',
		}
	);
	push( @{ $hash->{'UNIQUES'} }, ['work_id', 'file'] );

	$self->{'table_definition'} = $hash;
	$self->{'UNIQUE_KEY'}       = ['file'];

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
	$self->{'data_handler'}->{'stefans_libs::database::workload'} =
	  stefans_libs::database::workload->new( $self->{'dbh'}, $self->{'debug'} );
	$self->{'Group_to_MD5_hash'} = [];

	#$self->{'data_handler'}->{''} = some_other_table_class->new( );
	return $dataset;
}

sub _create_md5_hash {
	my ( $self, $dataset ) = @_;

	return $dataset->{'md5_sum'}
	  if ( defined $dataset->{'md5_sum'}
		&& length( $dataset->{'md5_sum'} ) == 32 );

	if ( -f $dataset->{'file'} ) {
		my $ctx = Digest::MD5->new;
		$ctx->addfile( $dataset->{'file'} );
		$dataset->{'md5sum'} = $ctx->hexdigest;
	}
	else {
		$dataset->{'md5sum'} = 'file not found';
	}
	return $dataset->{'md5sum'};
}

sub expected_dbh_type {
	return 'dbh';
}

sub AddFiles {
	my ( $self, $work_id, $files ) = @_;
	my @ret;
	while ( my ($type, $file) = each ( %$files ) ) { 
		foreach my $f ( map { if ( ref($_) eq "ARRAY"){@$_} else { $_} } $file ) {
			push ( @ret ,$self->AddDataset( {'work_id' => $work_id, 'type' => $type, 'file' => $f } ) );
		}
	}
	return @ret;
}

sub check_files_for_work_id {
	my ( $self, $id ) = @_;
	my $table = $self->get_data_table_4_search(
		{
			'search_columns' => [ $self->TableName() . '.*' ],
			'where' => [ [ $self->TableName() . '.work_id', '=', 'my_value' ] ],
		},
		$id
	);
	my @ret;
	$table->Remove_from_Column_Names( $self->TableName() . ".*" );
	foreach my $dataset ( @{ $table->GetAll_AsHashArrayRef() } ) {
		if ( -f $dataset->{'file'} ) {
			$self->Update_Dataset($dataset);
		}
		else { 
			push ( @ret, $dataset->{'file'} );
		}
	}
	return @ret;
}

1;
