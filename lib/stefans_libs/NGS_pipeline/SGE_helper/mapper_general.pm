package stefans_libs::NGS_pipeline::SGE_helper::mapper_general;

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
use HTML::Entities;

=for comment

This document is in Pod format.  To read this, use a Pod formatter,
like 'perldoc perlpod'.

=head1 NAME

stefans_libs::NGS_pipeline::SGE_helper::mapper_general

=head1 DESCRIPTION

A set of general functionalities like reference genome location finders etc.

=head2 depends on


=cut

=head1 METHODS

=head2 new

new returns a new object reference of the class stefans_libs::NGS_pipeline::SGE_helper::mapper_general.

=cut

sub new {

	my ($class) = @_;

	my ($self);

	$self = {};

	bless $self, $class
	  if ( $class eq "stefans_libs::NGS_pipeline::SGE_helper::mapper_general" );

	return $self;

}

=head2 fastqc_file

The fastcq_file function does at the moment only support the usage of the -t option evaluating thze 'proc' number of processors to use.

=cut

sub fastqc_file {
	my ( $self, $file, $hash ) = @_;
	mkdir ($hash->{'fastqc_path'}) unless ( -d $hash->{'fastqc_path'});
	my $ret = "fastqc $file";
	#$ret .= " -o $hash->{'fastqc_path'}" if ( defined $hash->{'fastqc_path'} );
	$ret .= " -t $hash->{'proc'}" if ( $hash->{'proc'} > 1 );
	my $ofile = $file;
	$ofile =~ s/.fastq.?g?z?$/_fastqc/;
	return $ret . "\n", $ofile."/fastqc_report.html";
}

=head2 samtools_file

The samtools_file uses samtools to convert the sam to bam, to sort the bam and to flagstat the bam.
It will remove a trailing .sam or trailing .SAM and create a .bam and a sorted.bam file from the sam file.

=cut

sub samtools_file {
	my ( $self, $file, $hash ) = @_;

	#samtools view -S xy.sam -b | samtools sort -\@ 10 - xy
	$file =~ s/ .([Ss][Aa][Mm])$//;
	my $ret = "samtools view -S $file.$1 -b | samtools sort ";
	$ret .= "-\@ $hash->{'proc'}" if ( $hash->{'proc'} > 1 );
	$ret .= " - $file\n" . "samtools flagstat $file.bam\n", "$file.bam";
}

=head2 genomeCoverageBed_file

genomeCoverageBed_file will remove a trailing .sam or trailing .SAM and expect a .bam which is sorted.

=cut

sub genomeCoverageBed_file {
	my ( $self, $file, $hash ) = @_;

	#genomeCoverageBed -bg -split -ibam xy.bam -g genome_sizes > xy.sorted.bed

	$file =~ s/.([SsBb][Aa][Mm])$//;
	my $ret =
	    "genomeCoverageBed -bg -split -ibam $file.$1 -g "
	  . $self->file_location( $hash->{'version'}, "chrom_size", 'not used' )
	  . " > $file.sorted.bed\n";
	return $ret, "$file.sorted.bed";
}

=head2 bedGraphToBigWig_file

bedGraphToBigWig_file  will remove a trailing .sam or trailing .SAM and expect a .bam which is sorted (name .sorted.bed).
=cut

sub bedGraphToBigWig_file {
	my ( $self, $file, $hash ) = @_;
	$file =~ s/.([SsBb][Aa][Mm])$//;
	my $ret =
	    "bedGraphToBigWig $file.sorted.bed "
	  . $self->file_location( $hash->{'version'}, "chrom_size", 'not used' )
	  . " $file.sorted.bw\n";
	return $ret, "$file.sorted.bw";
}

sub add_formbuilder_form {
	my ( $self, $form ) = @_;
	my $info = $self->{'options'};
	my ( @v, $h, $d, $i );
	foreach my $name ( @{ $self->{'order'} } ) {
		## radio button
		$d = $info->{$name}->{'default'};
		print "add_formbuilder_form -> $name\n";
		@v = @{ $info->{$name}->{'values'} };
		$h = HTML::Entities::encode_entities( $info->{$name}->{'help'} );
		if ( scalar(@v) == 2 && $v[1] eq "yes" ) {
			if ( $d eq 'yes' ) {
				$form->field(
					'type'    => 'radio',
					'value'   => 'Yes',
					'name'    => $name,
					'comment' => $h,
					'options' => [ 'No', 'Yes' ],
				);
			}
			else {
				$form->field(
					'type'    => 'radio',
					'value'   => 'No',
					'options' => [ 'No', 'Yes' ],
					'name'    => $name,
					'comment' => $h,
				);
			}
			next;
		}
		$i = 0;
		$form->field(
			'options' => [@v],
			'value'   => $d,
			'name'    => $name,
			'comment' => $h
		);
	}
	return $self;
}

=head2 create_options_string ( $dataset )

This function converts the return dataset from the web frontend into an options string for the command line.

=cut

sub create_options_string {
	my ( $self, $dataset ) = @_;
	my $str = '';
	my $tmp;
	foreach my $name ( @{ $self->{'order'} } ) {
		next unless ( defined $dataset->{$name} );
		if ( my @problems = $dataset->{$name} =~ m/([\{\}\[\]\(\);\<\>\&\\])/g )
		{
			warn
"option '$name' might be an tried attack on the server containing the strings '"
			  . join( "', '", @problems )
			  . "' -> option ignored\n";
			next;
		}
		print "$name type '$self->{'options'}->{$name}->{'type'}' \n";
		if ( $self->{'options'}->{$name}->{'type'} eq "perl_logic" ) {
			$str .= $self->$name( $dataset->{$name} );
		}
		elsif ( $self->use_option( $name, $dataset->{$name} ) ) {
			$tmp = $name;
			$name =~ s/^_//;
			if ( length($name) == 1 ) {
				$str .=
				  " -$name" . $self->get_option_value( $tmp, $dataset->{$tmp} );
			}
			else {
				$str .= " --$name"
				  . $self->get_option_value( $tmp, $dataset->{$tmp} );
			}
		}
	}
	return $str;

}

sub set_defaults {
	my ( $self, $dataset ) = @_;
	foreach my $name ( keys %{ $self->{'options'} } ) {
		next unless ( defined $dataset->{$name} );
		$self->{'options'}->{$name}->{'default'} = $dataset->{$name};
	}
	return $self;
}

sub use_option {
	my ( $self, $name, $id ) = @_;
	return 0 if ( $id eq "No" );
	return 0 if ( $id == undef );
	return $self;
}

sub get_option_value {
	my ( $self, $name, $id ) = @_;
	my $str = $id;
	if ( $str eq "Yes" || $str eq "No" ) {
		return '';
	}
	return ' ' . $str;
}

sub file_location {
	my ( $self, $genomeName, $fileType, $prog ) = @_;
	my $return = '';
	$prog = lc($prog);
	if ( $fileType eq "index" ) {
		$return = "/share/apps/data/indicies/" . $prog . "/";
	}
	elsif ( $fileType eq "chrom_size" ) {
		$return = "/share/apps/data/genomes/";
	}
	else {
		## explain which $fileType we support
		Carp::confess(
			"Sorry I only support the types 'index' and 'chrom_size'\n");
	}
	if ( $genomeName =~ m/^mm/ ) {
		$return .= "mouse/$genomeName/";
	}
	elsif ( $genomeName =~ m/^hg/ ) {
		$return .= "human/$genomeName/";
	}
	else {
		Carp::confess("Sorry I do not support the genomeName '$genomeName'\n");
	}
	if ( $fileType eq "chrom_size" ) {
		$return .= $genomeName . "_chrom_sizes.txt";
	}
	elsif ( ref($self) =~ m/bowtie2?/ || ref($self) eq "stefans_libs::NGS_pipeline::SGE_helper::HISAT" ) {
		$return .= $genomeName;
	}
	return $return;
}

1;
