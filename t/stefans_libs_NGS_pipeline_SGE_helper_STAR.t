#! /usr/bin/perl
use strict;
use warnings;
use Test::More tests => 2;
BEGIN { use_ok 'stefans_libs::NGS_pipeline::SGE_helper::STAR' }

my ( $value, @values, $exp );
my $stefans_libs_NGS_pipeline_SGE_helper_STAR = stefans_libs::NGS_pipeline::SGE_helper::STAR -> new();
is_deeply ( ref($stefans_libs_NGS_pipeline_SGE_helper_STAR) , 'stefans_libs::NGS_pipeline::SGE_helper::STAR', 'simple test of function stefans_libs::NGS_pipeline::SGE_helper::STAR -> new()' );

#print "\$exp = ".root->print_perl_var_def($value ).";\n";


