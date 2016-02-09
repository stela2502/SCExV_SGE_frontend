#! /usr/bin/perl
use strict;
use warnings;
use Test::More tests => 7;
BEGIN { use_ok 'stefans_libs::NGS_pipeline::SGE_helper::mapper_general' }

my ( $value, @values, $exp );
my $obj = stefans_libs::NGS_pipeline::SGE_helper::mapper_general -> new();
is_deeply ( ref($obj) , 'stefans_libs::NGS_pipeline::SGE_helper::mapper_general', 'simple test of function stefans_libs::NGS_pipeline::SGE_helper::mapper_general -> new()' );

is( $obj->file_location( 'mm10', "index", 'bowtie' ),'/share/apps/data/indicies/bowtie/mouse/mm10/', "wrong index information for bowtie - not the right caller" );
is( $obj->file_location( 'mm10', "index", 'STAR' ),'/share/apps/data/indicies/STAR/mouse/mm10/', 'right index for STAR' );
is( $obj->file_location( 'mm10', "index", 'BWA' ),'/share/apps/data/indicies/BWA/mouse/mm10/', 'right index for BWA' );

is( $obj->file_location( 'mm10', "chrom_size", 'bowtie' ), '/share/apps/data/genomes/mouse/mm10/mm10_chrom_sizes.txt', 'right bowtie chrom size' );
is( $obj->file_location( 'mm10', "chrom_size", 'STAR' ), '/share/apps/data/genomes/mouse/mm10/mm10_chrom_sizes.txt', 'right STAR chrom size' );



#print "\$exp = ".root->print_perl_var_def($value ).";\n";


