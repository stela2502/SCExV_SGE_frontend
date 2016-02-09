#! /usr/bin/perl
use strict;
use warnings;
use Test::More tests => 4;
BEGIN { use_ok 'stefans_libs::NGS_pipeline::SGE_helper::HISAT' }

my ( $value, @values, $exp );
my $obj = stefans_libs::NGS_pipeline::SGE_helper::HISAT->new();
is_deeply( ref($obj), 'stefans_libs::NGS_pipeline::SGE_helper::HISAT',
'simple test of function stefans_libs::NGS_pipeline::SGE_helper::HISAT -> new()'
);

$value = $obj->create_program_call(
	{
		'filename'     => 'someFastqFile.fq.gz',
		'version'      => 'hg19',
		'type'         => 'RNA',
		'paired_fastq' => '',
		'path'         => '/tmp/perltest',
		'proc'         => 4
	}
);
ok(
	$value eq "hisat -x /share/apps/data/indicies/hisat/human/hg19/hg19 -p 4 "
	  . "-1 /tmp/perltest/someFastqFile.fq.gz > /tmp/perltest/HISAT/someFastqFile.sam 2> /tmp/perltest/HISAT/someFastqFile.sam.log\n",
	"right prog call unpaired"
);

$value = $obj->create_program_call(
	{
		'filename'     => 'someFastqFile.fq.gz',
		'paired_fastq'  => 'someFastqFile_2.fq.gz',
		'version'      => 'hg19',
		'type'         => 'RNA',
		'path'         => '/tmp/perltest',
		'proc'         => 4
	}
);

ok(
	$value eq "hisat -x /share/apps/data/indicies/hisat/human/hg19/hg19 -p 4 "
	  . "-1 /tmp/perltest/someFastqFile.fq.gz -2 /tmp/perltest/someFastqFile_2.fq.gz "
	  . "> /tmp/perltest/HISAT/someFastqFile_paired.sam 2> /tmp/perltest/HISAT/someFastqFile_paired.sam.log\n",
	"right prog call paired"
);

#print "\$exp = ".root->print_perl_var_def($value ).";\n";

