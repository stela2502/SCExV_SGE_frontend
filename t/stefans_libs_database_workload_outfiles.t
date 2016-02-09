#! /usr/bin/perl
use strict;
use warnings;
use Test::More tests => 2;
BEGIN { use_ok 'stefans_libs::database::workload::outfiles' }

my ( $value, @values, $exp );
my $obj = stefans_libs::database::workload::outfiles -> new();
is_deeply ( ref($obj) , 'stefans_libs::database::workload::outfiles', 'simple test of function stefans_libs::database::workload::outfiles -> new()' );

#print "\$exp = ".root->print_perl_var_def($value ).";\n";


