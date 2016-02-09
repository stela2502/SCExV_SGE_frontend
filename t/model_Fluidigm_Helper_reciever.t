use strict;
use warnings;
use Test::More;
use FindBin;

my $plugin_path = "$FindBin::Bin";

$ENV{'DBFILE'} = "/home/slang/dbh_config_test.xls";

BEGIN { use_ok 'NGS_pipeline::Model::Fluidigm_Helper' }
BEGIN { use_ok 'stefans_libs::NGS_pipeline::SGE_helper' }
BEGIN { use_ok 'stefans_libs::database::workload' }

my ( $value, @values,$exp );

my $obj = NGS_pipeline::Model::Fluidigm_Helper->new();
ok(
	ref($obj) eq 'NGS_pipeline::Model::Fluidigm_Helper',
	'object eq NGS_pipeline::Model::Fluidigm_Helper'
);
my $c = test::c->new();
$c->model('work') -> create();
@values = $obj -> register_RandomForest_job ( $c , { 'session' => 'FluidigmRF_Test_Run',  'key' => 'qnnFHOBMvQovquEojBg2uA', 'rpage' => '/randomforest/index/' } , upload->new( $plugin_path."/data/RandomForest_transfer.tar.gz" ) );

warn "Error: ". $values[1] unless ( $values[0] );

my $path = $obj ->path( $c, 'FluidigmRF_Test_Run' );

foreach ( 0 .. 31 ) {
	my $fn = "randomForest_worker_";
	ok( -f $path . "$fn$_.R", "$fn$_.R" );
	system("rm $fn$_.R");
}
foreach ( 1 .. 2 ) {
	my $fn = "randomForest";
	ok( -f $path . "$fn$_.R", "$fn$_.R" );
	system("rm $fn$_.R");
}
ok(
		-f $path . "RandomForest_transfer.tar.gz",
		'RandomForest_transfer.tar.gz'
	);
	
## now check the db!
my $db = $c->model('work');
is_deeply( @{$db->check_new()->{'data'}}[0], [1,	'/home/slang/workspace/NGS_pipeline/t/data/Outpath/shared_path/FluidigmRF_Test_Run/RandomForestStarter.sh', 'multiple'],"New workload created" );


done_testing();

package upload;
use strict;
use warnings;

sub new {
	my ( $name, $filename ) = @_;
	my $self = {'filename' => $filename };
	bless $self, $name;
	return $self;
}
sub filename{
	my ( $self ) = @_;
	my @tmp = split("/", $self->{'filename'} );
	return pop( @tmp );
}

sub copy_to {
	my ( $self, $to ) = @_;
	return system ( "cp $self->{'filename'} $to" );
}


package test::c;
use strict;
use warnings;

use FindBin;

sub new {
	my $self = {
		'config' => {
			'shared_path' => "$FindBin::Bin" . "/data/Outpath/shared_path/",
		  }

	};
	bless $self, shift;
	return $self;
}

sub req{
	return test::c::req ->new();
}

sub config {    ## Catalyst function
	return shift->{'config'};
}

sub model {     ## Catalyst function
	my ( $self, $name ) = @_;
	if ( $name eq "SGE_Helper_Module" ) {
		$self->{$name} ||= stefans_libs::NGS_pipeline::SGE_helper->new();
		return $self->{$name};
	}
	elsif ( $name eq "work" ){
		$self->{$name} ||= stefans_libs::database::workload->new(variable_table->getDBH() );
		return $self->{$name};
	}
	else {
		die "module $name not implemented in the helper c object\n";
	}
}

sub get_session_id {    ## Catalyst function
	return 1234556778;
}


package test::c::req;
use strict;
use warnings;
sub new{
	my $s = {};
	bless $s, shift;
	return $s;
}

sub address {
	return "localhost:3000";
}

