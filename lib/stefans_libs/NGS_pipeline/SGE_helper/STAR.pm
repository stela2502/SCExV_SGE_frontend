package stefans_libs::NGS_pipeline::SGE_helper::STAR;

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
use base 'stefans_libs::NGS_pipeline::SGE_helper::mapper_general';

=for comment

This document is in Pod format.  To read this, use a Pod formatter,
like 'perldoc perlpod'.

=head1 NAME

stefans_libs::NGS_pipeline::SGE_helper::STAR

=head1 DESCRIPTION

The STAR specific part of the lib

=head2 depends on


=cut

=head1 METHODS

=head2 new

new returns a new object reference of the class stefans_libs::NGS_pipeline::SGE_helper::STAR.

=cut

sub new {

	my ($class) = @_;

	my ($self);

	$self = {
		'threads_option' => 'runThreadN',
		'genome'         => 'genomeDir',
		'order'          => [],
		'options'        => {
			'genomeDir' => {
				'type'    => 'perl_logic',
				'values'  => ['need to be set internally!'],
				'default' => 'not set',
				'help' =>
				  'Please select a genome version you want to map against',
			},
			'outSAMtype' => {
				'type'    => 'perl_logic',
				'values'  => [ 'Unsorted', 'SortedByCoordinate' ],
				'default' => 'SortedByCoordinate',
				'help' =>
				  'Make STAR output files directly in BAM sorted file format.',
			},
			'chimSegmentMin' => {

			}
		},
	};

	bless $self, $class
	  if ( $class eq "stefans_libs::NGS_pipeline::SGE_helper::STAR" );

	return $self;

}

sub file_prefix {
	my ( $self, $dataset ) = @_;
	my $last;
	$dataset->{'mapper_ofile'} = $dataset->{'filename'};
	$dataset->{'mapper_ofile'} = [ split(/\./,$dataset->{'mapper_ofile'}) ];
	$last = pop ( @{$dataset->{'mapper_ofile'}});
	if ( lc($last) =~m/gz/ ){
		$self->{'gzip'} = 1;
		$last = pop ( @{$dataset->{'mapper_ofile'}});
	}
	else {
		$self->{'gzip'} = 0;
	}
	$dataset->{'mapper_ofile'} = join(".", @{$dataset->{'mapper_ofile'}} );
	if ( $dataset->{'paired_fastq'} =~ m/\w/ ) {
		$dataset->{'mapper_ofile'} .= "_paired";
	}
	return $dataset->{'mapper_path'}.$dataset->{'mapper_ofile'}
}

sub main_ofile {
	my ( $self, $dataset ) = @_;
	return $self->file_prefix($dataset).'Aligned.sortedByCoord.out.bam';
}

sub create_program_call {
	my ( $self, $dataset ) = @_;
	$dataset->{'fastq2'} ||= '';
	$dataset->{'mapper_path'} ||= "$dataset->{'path'}/../STAR/";
	mkdir ($dataset->{'mapper_path'}) unless ( -d $dataset->{'mapper_path'} );
	my $gzip = '';
	if ( $dataset->{'filename'} =~ m/gz$/ ) {
		$gzip = "--readFilesCommand zcat ";
	}
	my $cmd = "STAR --genomeDir "
	  . $self->file_location( $dataset->{'version'}, 'index', 'STAR' )
	  . " --runThreadN $dataset->{'proc'}"
	  . " --readFilesIn $dataset->{'path'}$dataset->{'filename'}";
	$cmd.=  " $dataset->{'path'}$dataset->{'paired_fastq'}" if ( $dataset->{'paired_fastq'} =~ m/\w/ ); 
	$cmd  . "$gzip --outFileNamePrefix ". $self->file_prefix($dataset)
	  . " --outSAMtype BAM SortedByCoordinate"
	  ;
	$cmd .= " --alignEndsType EndToEnd --alignIntronMax 1" if ( $dataset->{'type'} eq 'DNA' );
	return $cmd."\n";
}

sub genomeDir {
	Carp::confess("function genomeDir not implemented\n");
}

sub genome {
	Carp::confess("function genome not implemented\n");
}

sub get_formbuilder_form {
	my ($self) = @_;
}

1;
