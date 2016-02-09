use strict;
use warnings;

use NGS_pipeline;

my $app = NGS_pipeline->apply_default_middlewares(NGS_pipeline->psgi_app);
$app;

