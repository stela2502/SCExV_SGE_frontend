use strict;
use warnings;
use Test::More;


use Catalyst::Test 'NGS_pipeline';
use NGS_pipeline::Controller::debug;

ok( request('/debug')->is_success, 'Request should succeed' );
done_testing();
