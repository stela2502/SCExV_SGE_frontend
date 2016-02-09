package stefans_libs::NGS_pipeline::Menue;

#  Copyright (C) 2014-08-25 Stefan Lang

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

#use FindBin;
#use lib "$FindBin::Bin/../lib/";
use strict;
use warnings;

=for comment

This document is in Pod format.  To read this, use a Pod formatter,
like 'perldoc perlpod'.

=head1 NAME

stefans_libs::HTpcrA::Menus

=head1 DESCRIPTION

The HTpcrA menu helper

=head2 depends on


=cut

=head1 METHODS

=head2 new

new returns a new object reference of the class stefans_libs::HTpcrA::Menus.

=cut

sub new {

	my ($class) = @_;

	my ($self);

	$self = {
		'foi' => [
			[ 'Preprocess script',    '/preprocess/Preprocess.R' ],
			[ 'Analysis script',      '/RScript.R' ],
			[ 'Grouping information', '/Sample_Colors.xls' ],
			[ 'affected genes',       '/GOI.xls' ],
			[ 'Processed PCR data',   '/merged_data_Table.xls' ],
		]
	};

	bless $self, $class if ( $class eq "stefans_libs::NGS_pipeline::Menue" );

	$self->Reinit();

	return $self;

}

sub Reinit {
	my ($self) = @_;
	$self->{'main2pos'} = {
		'Upload fastq' => 0,
		'Jobs'         => 1,

		#		'ChIP seq'           => 3,
		#		'RNA seq' => 2,
		#		'DNA seq'        => 1,
		#		'Utilities'       => 3,
	};
	$self->{'require_role'} = {
		'admin' => {
			'main'    => [ 'Administration', '/administration/index' ],
			'entries' => [['AddUser', '/administration/AddUser/'] ],
		}
	};
	$self->{'main'} = [
		[ 'Upload fastq', '/start/' ],
		[ 'Jobs',         '/experiments/index' ],

		#		[ 'DNA seq', '/dna_seq/index' ],
		#		[ 'RNA seq',        '/rna_seq/index' ],
		#		[ 'ChIP seq',       "/chip_seq/index" ],
		#		[ 'Utilities',       "/utilities/index" ]
	];
	## second level menu
	$self->{'entries'} = [
		[],    ## 'Upload'
		[],    ## 'Jobs'

		#		[], ## 'RNA seq'
		#		[], ## 'ChIP seq'
		#		[], ## 'Utilities'
	];
	return $self;
}

=head2 Add ( $main, $link, $name )

Add and entry to the menue -> If you add a main entry you must give me the link for the main entry and NO name for the subentry!

=cut

sub Add {
	my ( $self, $main, $link, $name ) = @_;
	unless ( defined $self->{'main2pos'}->{$main} ) {
		$self->{'main2pos'}->{$main} = scalar( @{ $self->{'main'} } );
		push( @{ $self->{'main'} }, [ $main, $link ] );
		@{ $self->{'entries'} }[ $self->{'main2pos'}->{$main} ] = [];
		Carp::confess("You must not give me a name for the link!")
		  if ( defined $name );
	}
	else {
		push(
			@{ @{ $self->{'entries'} }[ $self->{'main2pos'}->{$main} ] },
			[ $name, $link ]
		);
	}
	return $self;
}

sub menu {
	my ( $self, $c ) = @_;
	my @values;
	$self->Reinit();
	foreach my $role ( keys %{$self->{'require_role'}} ) {
		if ( $c->check_user($role, 1) ){
			push ( @{$self->{'main'}}, $self->{'require_role'}->{$role}->{'main'});
			push ( @{$self->{'entries'}}, $self->{'require_role'}->{$role}->{'entries'});
		}
	}
	for ( my $i = 0 ; $i < @{ $self->{'main'} } ; $i++ ) {
		$_ = @{ $self->{'main'} }[$i];
		my @array;
		push(
			@values,
			{
				'link'    => $c->uri_for( @$_[1] ),
				'name'    => @$_[0],
				'objects' => \@array
			}
		);
		foreach ( @{ @{ $self->{'entries'} }[$i] } ) {
			push( @array,
				{ 'link' => $c->uri_for( @$_[1] ), 'name' => @$_[0] } );
		}
	}
	return @values;
}

1;
