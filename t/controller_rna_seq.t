use strict;
use warnings;
use Test::More;


use Catalyst::Test 'NGS_pipeline';
use NGS_pipeline::Controller::rna_seq;

ok( request('/rna_seq')->is_success, 'Request should succeed' );
done_testing();
