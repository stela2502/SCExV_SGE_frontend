use strict;
use warnings;
use Test::More;


use Catalyst::Test 'NGS_pipeline';
use NGS_pipeline::Controller::dna_seq;

ok( request('/dna_seq')->is_success, 'Request should succeed' );
done_testing();
