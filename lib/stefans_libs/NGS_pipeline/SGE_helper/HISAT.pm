package stefans_libs::NGS_pipeline::SGE_helper::HISAT;
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

stefans_libs::NGS_pipeline::SGE_helper::HISAT

=head1 DESCRIPTION

The BWA specific part of the lib

=head2 depends on


=cut


=head1 METHODS

=head2 new

new returns a new object reference of the class stefans_libs::NGS_pipeline::SGE_helper::BWA.

=cut

sub new{

	my ( $class ) = @_;

	my ( $self );

	$self = {
  	};

  	bless $self, $class  if ( $class eq "stefans_libs::NGS_pipeline::SGE_helper::HISAT" );

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
	return $self->file_prefix($dataset).'.sam';
}

sub create_program_call {
	my ( $self, $dataset ) = @_;
	$dataset->{'fastq2'} ||= '';
	$dataset->{'mapper_path'} ||= "$dataset->{'path'}/../HISAT/";
	mkdir ($dataset->{'mapper_path'}) unless -d ( $dataset->{'mapper_path'} );
	#hisat -x /hvd/data0/worker/indicies/hisat/human/hg19/hg19 -1 CN1_FCC4EKGACXX_L7_HUMymxTBAERABPEI-13_1.fq.gz -2 CN1_FCC4EKGACXX_L7_HUMymxTBAERABPEI-13_2.fq.gz > CN1_FCC4EKGACXX_L7_HUMymxTBAERABPEI-13.sam
	my $cmd = "hisat -x "
	  . $self->file_location( $dataset->{'version'}, 'index', 'hisat' )
	  . " --threads $dataset->{'proc'}"
	  . " -1 $dataset->{'path'}/$dataset->{'filename'}";
	$cmd.=  " -2 $dataset->{'path'}/$dataset->{'paired_fastq'}" if ( $dataset->{'paired_fastq'} =~ m/\w/ ); 
	$cmd  .= " > ". $self->main_ofile($dataset)
	  . " 2> ". $self->main_ofile($dataset).".log";
	Carp::confess ( "Not supported for alignments of DNA fragments" ) if ( $dataset->{'type'} eq 'DNA' );
	return $cmd."\n";
}

sub get_formbuilder_form{
	my ( $self ) = @_;
}

1;
