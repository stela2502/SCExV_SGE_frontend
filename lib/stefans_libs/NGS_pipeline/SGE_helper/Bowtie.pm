package stefans_libs::NGS_pipeline::SGE_helper::Bowtie;

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

stefans_libs::NGS_pipeline::SGE_helper::Tophat

=head1 DESCRIPTION

The STAR specific part of the lib

=head2 depends on


=cut

=head1 METHODS

=head2 new

new returns a new object reference of the class stefans_libs::NGS_pipeline::SGE_helper::Tophat.

the bowtie manual used bowtie 1.1.1

http://bowtie-bio.sourceforge.net/manual.shtml

=cut

sub new {

	my ($class) = @_;

	my ($self);

	$self = {
		'threads_option' => 'p',
		'order' => ['bowtie_version', 'q', 'f', 'r', '_5', '_3', 'I','X','y', 'n','l', 'v', 'best', 'a', 'k'],
		'options' => {    ## key = option name, value = arrayref with options
			'bowtie_version' => {
				'values'  => [ '1.1.1', '2' ],
				'default' => '2',
				'help' => 'define which bowtie version to use',
				'type' => 'perl_logic'
			},
			'q' => {
				'values'  => [ 'no', 'yes' ],
				'default' => 'yes',
				'help' =>
'The query input files (specified either as <m1> and <m2>, or as <s>) are FASTQ files (usually '.
'having extension .fq or .fastq). This is the default. See also: --solexa-quals and --integer-quals.',
				'type' => 'program',
			},
			'f' => {
				'values'  => [ 'no', 'yes' ],
				'default' => 'no',
				'help' =>
'The query input files (specified either as <m1> and <m2>, or as <s>) are FASTA files (usually '.
'having extension .fa, .mfa, .fna or similar). All quality values are assumed to be 40 on the Phred quality scale.',
				'type' => 'program',
			},
			'r' => {
				'values'  => [ 'no', 'yes' ],
				'default' => 'no',
				'help' =>
'The query input files (specified either as <m1> and <m2>, or as <s>) are Raw files: one sequence per'.
' line, without quality values or names. All quality values are assumed to be 40 on the Phred quality scale.',
				'type' => 'program',
			},
			'_5' => {
				'values'  => [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ],
				'default' => 'not set',
				'help' =>
'Trim <int> bases from high-quality (left) end of each read before alignment (default: 0).'
			},
			'_3' => {
				'values'  => [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ],
				'default' => 'not set',
				'help' =>
'Trim <int> bases from low-quality (right) end of each read before alignment (default: 0).',
				'type' => 'program',
			},
			'I' => {
				'values'   => [ 0, 100, 200, 300, 400, 500 ],
				'default' => '0',
				'help' =>
'The minimum insert size for valid paired-end alignments. E.g. if -I 60 is specified and a '.
'paired-end alignment consists of two 20-bp alignments in the appropriate orientation with a 20-bp gap'.
' between them, that alignment is considered valid (as long as -X is also satisfied). A 19-bp gap would not be'.
' valid in that case. If trimming options -3 or -5 are also used, the -I constraint is applied with respect to '.
				'the untrimmed mates. Default: 0.', 'type' => 'program',
			},
			'X' => {
				'values' => [
					100,  250,  400,  600,  800, 1000,
					2000, 3000, 4000, 5000, 6000
				],
				'default' => 250,
				'help' =>
				  'The maximum insert size for valid paired-end alignments. '.
'E.g. if -X 100 is specified and a paired-end alignment consists of two 20-bp alignments in the proper'.
' orientation with a 60-bp gap between them, that alignment is considered valid (as long as -I is also satisfied).'.
' A 61-bp gap would not be valid in that case. If trimming options -3 or -5 are also used, the -X constraint is '.
'applied with respect to the untrimmed mates, not the trimmed mates. Default: 250.',
				'type' => 'program',
			},
			'y' => {
				'values'  => [ 'no', 'yes' ],
				'default' => 'no',
				'help' =>
'Try as hard as possible to find valid alignments when they exist, including paired-end alignments. '.
'This is equivalent to specifying very high values for the --maxbts and --pairtries options. This mode is'.
' generally much slower than the default settings, but can be useful for certain problems. This mode is slower'.
' when (a) the reference is very repetitive, (b) the reads are low quality, or (c) not many reads have valid alignments.',
				'type' => 'program',
			},
			'n' => {
				'values'  => [ 0, 1, 2, 3 ],
				'default' => 0,
				'help' => 'Mismatches in the first (l) seed bases of the read',
				'type' => 'program',
			},
			'l' => {
				'values'  => [ 5, 6, 7, 8, 9, 10, '...' ],
				'default' => 10,
				'help'    => 'Seed length (5 or more)',
				'type'    => 'program',
			},
#			'e' => {
#				'values'  => 'text',
#				'default' => 'not set',
#				'help' =>
#'The sum of the Phred quality values at all mismatched positions (not just in the seed) may not exceed ',
#'E (set with -e). Where qualities are unavailable (e.g. if the reads are from a FASTA file), the Phred quality defaults to 40.',
#				'type' => 'program',
#			},
			'v' => {
				'values'  => [ 0, 1, 2, 3, 4, 5 ],
				'default' => 'not set',
				'help' =>
'In -v mode, alignments may have no more than V mismatches, where V may be a number from 0 through '.
'3 set using the -v option. Quality values are ignored. The -v option is mutually exclusive with the -n option.',
				'type' => 'program',
			},
			'best' => {
				'values'  => [ 'no', 'yes' ],
				'default' => 'no',
				'help' =>
'Bowtie guarantees the reported alignment(s) are "best" in terms of the number of mismatches, and that '.
'the alignments are reported in best-to-worst order. Bowtie is somewhat slower when --best is specified.',
				'type' => 'program',
			},
			'a' => {
				'values'  => ['not set', 'no', 'yes' ],
				'default' => 'not set',
				'help' =>
'Specifying -a instructs bowtie to report all valid alignments, subject to the alignment policy: '.
'-v 2. In this case, bowtie finds 5 inexact hits in the E. coli genome; 1 hit (the 2nd one listed) has 1 '.
'mismatch, and the other 4 hits have 2 mismatches. Four are on the reverse reference strand and one is on'.
' the forward strand. Note that they are not listed in best-to-worst order.',
				'type' => 'program',
			},
			'k' => {
				'values'  => [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 ],
				'default' => 'not set',
				'help' =>
'Specifying -k 3 instructs bowtie to report up to 3 valid alignments. In this'.
' case, a total of 5 valid alignments exist (see Example 1); bowtie reports 3 out of those 5. -k can be'.
				' set to any integer greater than 0.',
				'type' => 'program',
			},

		},
	};

	bless $self, $class
	  if ( $class eq "stefans_libs::NGS_pipeline::SGE_helper::Bowtie" );

	return $self;

}
sub create_program_call{
	my ( $self, $dataset ) = @_;
	return $self-> create_options_string( $dataset );
}

sub bowtie_version{
	my ( $self, $id ) = @_;
	return "bowtie" if ($id ==0);
	return "bowtie2";
}

sub test {
	my ($self) = @_;
	return $self->file_location( 'mm10', "chrom_size", 'bowtie' );
}

1;
