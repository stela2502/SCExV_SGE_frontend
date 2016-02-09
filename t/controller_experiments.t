use strict;
use warnings;
use Test::More;


use Catalyst::Test 'NGS_pipeline';
use NGS_pipeline::Controller::experiments;

ok( request('/experiments')->is_success, 'Request should succeed' );
done_testing();
