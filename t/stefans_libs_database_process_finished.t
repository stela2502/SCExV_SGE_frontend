#! /usr/bin/perl
use strict;
use warnings;
use Test::More tests => 2;
BEGIN { use_ok 'stefans_libs::database::process_finished' }

my ( $value, @values, $exp );
my $obj = stefans_libs::database::process_finished -> new();
is_deeply ( ref($obj) , 'stefans_libs::database::process_finished', 'simple test of function stefans_libs::database::process_finished -> new()' );

#print "\$exp = ".root->print_perl_var_def($value ).";\n";


