#! /usr/bin/perl
use strict;
use warnings;
use Test::More tests => 5;
BEGIN { use_ok 'stefans_libs::NGS_pipeline::SGE_helper' }

my ( $value, @values, $exp );
my $obj = stefans_libs::NGS_pipeline::SGE_helper->new();
is_deeply(
	ref($obj),
	'stefans_libs::NGS_pipeline::SGE_helper',
	'simple test of function stefans_libs::NGS_pipeline::SGE_helper -> new()'
);

$value = $obj->qsub_head( {} );
is(
	$value , '#!/bin/bash' . "\n"
	  . '#$ -l mem_free=30G' . "\n"
	  . '#$ -S /bin/bash' . "\n"
	  . '#$ -M bioinformatics@med.lu.se' . "\n"
	  . '#$ -m eas' . "\n"
	  . '#$ -pe orte 1'."\n",
	"right default script"
);
$obj = stefans_libs::NGS_pipeline::SGE_helper->new(32,'2G','Stefan.Lang@med.lu.se' );
$value = $obj->qsub_head( {} );
is(
	$value , '#!/bin/bash' . "\n"
	  . '#$ -l mem_free=2G' . "\n"
	  . '#$ -S /bin/bash' . "\n"
	  . '#$ -M Stefan.Lang@med.lu.se' . "\n"
	  . '#$ -m eas' . "\n"
	  . '#$ -pe orte 32'."\n",
	"right default script - changed settings"
);

$value = $obj->qsub_head( {'email' => 'bioinformatics@med.lu.se', 'proc' => 10, 'memfree' => '100G' } );
is(
	$value , '#!/bin/bash' . "\n"
	  . '#$ -l mem_free=100G' . "\n"
	  . '#$ -S /bin/bash' . "\n"
	  . '#$ -M Stefan.Lang@med.lu.se,bioinformatics@med.lu.se' . "\n"
	  . '#$ -m eas' . "\n"
	  . '#$ -pe orte 10'."\n",
	"right default script - changed settings"
);
#print "\$exp = ".root->print_perl_var_def($value ).";\n";

