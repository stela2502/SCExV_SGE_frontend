package stefans_libs::NGS_pipeline::SGE_helper;

#  Copyright (C) 2015-02-06 Stefan Lang

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

use stefans_libs::NGS_pipeline::SGE_helper::BWA;
use stefans_libs::NGS_pipeline::SGE_helper::STAR;
use stefans_libs::NGS_pipeline::SGE_helper::Bowtie;

=for comment

This document is in Pod format.  To read this, use a Pod formatter,
like 'perldoc perlpod'.

=head1 NAME

stefans_libs::NGS_pipeline::SGE_helper

=head1 DESCRIPTION

A lib to create sun grid engine scripts. The lib wraps the command lines into a SGE compliant script. Simple job...

=head2 depends on


=cut

=head1 METHODS

=head2 new

new returns a new object reference of the class stefans_libs::NGS_pipeline::SGE_helper.

=cut

sub new {

	my ($class, $proc, $memfree, $mail ) = @_;

	my ($self);

	$self = {
		'default_proc' => $proc ||= 1,
		'default_memfree' => $memfree ||= '30G',
		'default_mail' => $mail ||= 'bioinformatics@med.lu.se',
		'priority' => undef,
		programs => {
			BWA  => stefans_libs::NGS_pipeline::SGE_helper::BWA->new(),
			STAR => stefans_libs::NGS_pipeline::SGE_helper::STAR->new(),
			Bowtie =>
			  stefans_libs::NGS_pipeline::SGE_helper::Bowtie->new(),
		},
	};

	bless $self, $class
	  if ( $class eq "stefans_libs::NGS_pipeline::SGE_helper" );

	return $self;

}

=head2 qsub_head

This function will create a qsub conform header and will evaluate the hash entries 'memfree' (30G), 'email' (none) and 'proc' (1).
The default values are shown in brackets.
The finishing email will always also be sent to the bioinformatics account at med.lu.se.
Change that for off site installations!

=cut

sub priority {
	my ( $self, $pri ) = @_;
	if ( defined $pri ) {
		$self->{'priority'} = $pri if ( $pri > -1024 && $pri < 1023 );
	}
	return $self->{'pri'};
}

sub qsub_head {
	my ( $self, $hash ) = @_;
	$hash->{'memfree'} ||= $self->{'default_memfree'};
	$hash->{'proc'} ||= $self->{'default_proc'};
	my $str =
	    "#\!/bin/bash\n"
	  . "#\$ -l mem_free=$hash->{'memfree'}\n"
	  . "#\$ -S /bin/bash\n"
	  . "#\$ -M $self->{'default_mail'}";
	if ( defined $hash->{'email'} ) {
		$str .= ",$hash->{'email'}";
	}
	$str .= "\n#\$ -m eas\n" . "#\$ -pe orte $hash->{'proc'}\n";
	if ( defined $self->priority){
		$str .= "\n#\$ -p ".$self->priority."\n";
	}
	return $str;
}

sub get_formbuilder_form_4 {
	my ( $self, $program, $form ) = @_;
	unless ( $self->{'programs'}->{$program} ) {
		Carp::confess("Sorry I do not support the program '$program'!\n");
	}
	return $self->{'programs'}->{$program}->add_formbuilder_form($form);
}

sub create_program_call{
	my ( $self, $program, $dataset ) = @_;
	unless ( $self->{'programs'}->{$program} ) {
		Carp::confess("Sorry I do not support the program '$program'!\n");
	}
	return $self->{'programs'}->{$program}->create_program_call($dataset);
}

1;
