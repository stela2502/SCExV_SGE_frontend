#! /usr/bin/perl
use strict;
use warnings;
use Test::More tests => 7;
use stefans_libs::root;
BEGIN { use_ok 'stefans_libs::NGS_pipeline::SGE_helper::Bowtie' }

my ( $value, @values, $exp );
my $obj = stefans_libs::NGS_pipeline::SGE_helper::Bowtie->new();
is_deeply( ref($obj), 'stefans_libs::NGS_pipeline::SGE_helper::Bowtie',
'simple test of function stefans_libs::NGS_pipeline::SGE_helper::Bowtie -> new()'
);

is(
	$obj->file_location( 'mm10', "index", 'bowtie' ),
	'/share/apps/data/indicies/bowtie/mouse/mm10/mm10',
	"right chrom_size for bowtie - not the right caller"
);

my $form = form->new();
$obj->add_formbuilder_form($form);

#print "\$exp = ".root->print_perl_var_def( $form->{'fields'} ).";\n";

$exp = [ {
  'name' => 'bowtie_version',
  'value' => '1',
  'info' => 'define which bowtie version to use',
  'options' => {
  '0' => '1.1.1',
  '1' => '2'
}
}, {
  'type' => 'radio',
  'value' => '1',
  'name' => 'q',
  'info' => 'The query input files (specified either as <m1> and <m2>, or as <s>) are FASTQ files (usually having extension .fq or .fastq). This is the default. See also: --solexa-quals and --integer-quals.'
}, {
  'type' => 'radio',
  'value' => '0',
  'name' => 'f',
  'info' => 'The query input files (specified either as <m1> and <m2>, or as <s>) are FASTA files (usually having extension .fa, .mfa, .fna or similar). All quality values are assumed to be 40 on the Phred quality scale.'
}, {
  'type' => 'radio',
  'info' => 'The query input files (specified either as <m1> and <m2>, or as <s>) are Raw files: one sequence per line, without quality values or names. All quality values are assumed to be 40 on the Phred quality scale.',
  'value' => '0',
  'name' => 'r'
}, {
  'options' => {
  '7' => '8',
  '0' => '1',
  '9' => '10',
  '3' => '4',
  '4' => '5',
  '1' => '2',
  '6' => '7',
  '2' => '3',
  '8' => '9',
  '5' => '6'
},
  'info' => 'Trim <int> bases from high-quality (left) end of each read before alignment (default: 0).',
  'name' => '_5',
  'value' => 'not set'
}, {
  'options' => {
  '8' => '9',
  '5' => '6',
  '2' => '3',
  '6' => '7',
  '4' => '5',
  '1' => '2',
  '3' => '4',
  '9' => '10',
  '0' => '1',
  '7' => '8'
},
  'value' => 'not set',
  'name' => '_3',
  'info' => 'Trim <int> bases from low-quality (right) end of each read before alignment (default: 0).'
}, {
  'options' => {
  '5' => '500',
  '2' => '200',
  '1' => '100',
  '4' => '400',
  '3' => '300',
  '0' => '0'
},
  'info' => 'The minimum insert size for valid paired-end alignments. E.g. if -I 60 is specified and a paired-end alignment consists of two 20-bp alignments in the appropriate orientation with a 20-bp gap between them, that alignment is considered valid (as long as -X is also satisfied). A 19-bp gap would not be valid in that case. If trimming options -3 or -5 are also used, the -I constraint is applied with respect to the untrimmed mates. Default: 0.',
  'name' => 'I',
  'value' => '0'
}, {
  'value' => '1',
  'name' => 'X',
  'info' => 'The maximum insert size for valid paired-end alignments. E.g. if -X 100 is specified and a paired-end alignment consists of two 20-bp alignments in the proper orientation with a 60-bp gap between them, that alignment is considered valid (as long as -I is also satisfied). A 61-bp gap would not be valid in that case. If trimming options -3 or -5 are also used, the -X constraint is applied with respect to the untrimmed mates, not the trimmed mates. Default: 250.',
  'options' => {
  '1' => '250',
  '4' => '800',
  '8' => '4000',
  '5' => '1000',
  '6' => '2000',
  '2' => '400',
  '7' => '3000',
  '3' => '600',
  '10' => '6000',
  '9' => '5000',
  '0' => '100'
}
}, {
  'value' => '0',
  'name' => 'y',
  'info' => 'Try as hard as possible to find valid alignments when they exist, including paired-end alignments. This is equivalent to specifying very high values for the --maxbts and --pairtries options. This mode is generally much slower than the default settings, but can be useful for certain problems. This mode is slower when (a) the reference is very repetitive, (b) the reads are low quality, or (c) not many reads have valid alignments.',
  'type' => 'radio'
}, {
  'options' => {
  '3' => '3',
  '0' => '0',
  '2' => '2',
  '1' => '1'
},
  'info' => 'Mismatches in the first (l) seed bases of the read',
  'name' => 'n',
  'value' => '0'
}, {
  'info' => 'Seed length (5 or more)',
  'name' => 'l',
  'value' => '5',
  'options' => {
  '1' => '6',
  '4' => '9',
  '2' => '7',
  '6' => '...',
  '5' => '10',
  '0' => '5',
  '3' => '8'
}
}, {
  'options' => {
  '3' => '3',
  '0' => '0',
  '5' => '5',
  '2' => '2',
  '1' => '1',
  '4' => '4'
},
  'name' => 'v',
  'value' => 'not set',
  'info' => 'In -v mode, alignments may have no more than V mismatches, where V may be a number from 0 through 3 set using the -v option. Quality values are ignored. The -v option is mutually exclusive with the -n option.'
}, {
  'type' => 'radio',
  'info' => 'Bowtie guarantees the reported alignment(s) are "best" in terms of the number of mismatches, and that the alignments are reported in best-to-worst order. Bowtie is somewhat slower when --best is specified.',
  'name' => 'best',
  'value' => '0'
}, {
  'type' => 'radio',
  'info' => 'Specifying -a instructs bowtie to report all valid alignments, subject to the alignment policy: -v 2. In this case, bowtie finds 5 inexact hits in the E. coli genome; 1 hit (the 2nd one listed) has 1 mismatch, and the other 4 hits have 2 mismatches. Four are on the reverse reference strand and one is on the forward strand. Note that they are not listed in best-to-worst order.',
  'value' => '0',
  'name' => 'a'
}, {
  'value' => 'not set',
  'name' => 'k',
  'info' => 'Specifying -k 3 instructs bowtie to report up to 3 valid alignments. In this case, a total of 5 valid alignments exist (see Example 1); bowtie reports 3 out of those 5. -k can be set to any integer greater than 0.',
  'options' => {
  '12' => '13',
  '1' => '2',
  '4' => '5',
  '11' => '12',
  '5' => '6',
  '8' => '9',
  '2' => '3',
  '6' => '7',
  '7' => '8',
  '3' => '4',
  '10' => '11',
  '0' => '1',
  '9' => '10'
}
} ];

is_deeply( $form->{'fields'}, $exp, 'The form has been built as expected' );


$value = $obj->create_options_string( { 'bowtie_version' => 0, 'k' => '{\\\\\\ & sh login root' } );
is( $value , "bowtie", "bowtie_version 0 = bowtie + potential attack identified" );

$value = $obj->create_options_string( { 'bowtie_version' => 1, 'X' => '3', 'best' => 1 } );
is( $value , "bowtie2 -X 600", "bowtie_version 1 = bowtie2 -X 400 --best" );

$value = $obj->create_options_string( { 'bowtie_version' => 1, 'X' => '3', 'best' => 0 } );
is( $value , "bowtie2 -X 600 --best", "bowtie_version 1 = bowtie2 -X 400 --best" );

#print "\$exp = ".root->print_perl_var_def($value ).";\n";

package form;
use strict;
use warnings;

sub new {
	my ($class) = @_;
	my $self = { fields => [] };
	bless $self, $class;
	return $self;
}

sub field {
	my ( $self, %hash ) = @_;
	push( @{ $self->{'fields'} }, \%hash );
}

1;
