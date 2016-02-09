use strict;
use warnings;
use Test::More;


use Catalyst::Test 'NGS_pipeline';
use NGS_pipeline::Controller::utilities;

ok( request('/utilities')->is_success, 'Request should succeed' );
done_testing();
