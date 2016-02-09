use strict;
use warnings;
use Test::More;


use Catalyst::Test 'NGS_pipeline';
use NGS_pipeline::Controller::chip_seq;

ok( request('/chip_seq')->is_success, 'Request should succeed' );
done_testing();
