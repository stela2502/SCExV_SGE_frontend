use strict;
use warnings;
use Test::More;
use FindBin;

my $plugin_path = "$FindBin::Bin";

$ENV{'DBFILE'} = "/home/slang/dbh_config_test.xls";
my ( $value, @values, $exp);
## the logics is implemented in the executable $plugin_path/../bin/reportFluidigm.pl
BEGIN { use_ok 'stefans_libs::database::workload' }

unless ( -d  "$plugin_path/../../HTpcrA-0.60/root/tmp/FluidigmRF_Test_Run/" ){
	warn "You need to have a development files for the HTpcrA server in folder $plugin_path/../../HTpcrA-0.60 !\n";
	done_testing();
	exit 0;
}

my $db = stefans_libs::database::workload->new(variable_table->getDBH() );
$value = $db->check_new();
is_deeply( @{$value->{'data'}}[0], [1,	'/home/slang/workspace/NGS_pipeline/t/data/Outpath/shared_path/FluidigmRF_Test_Run/RandomForestStarter.sh'],"New workload is unchanged from reciever call" );
$db -> finish( 1 );
## create the outfiles!!!
unlink ( '/home/slang/workspace/NGS_pipeline/t/data/Outpath/shared_path/FluidigmRF_Test_Run/RandomForest_transfereBack.tar.gz'  );
system ( 'touch /home/slang/workspace/NGS_pipeline/t/data/Outpath/shared_path/FluidigmRF_Test_Run/RandomForestdistRFobject.RData');
system ( 'touch /home/slang/workspace/NGS_pipeline/t/data/Outpath/shared_path/FluidigmRF_Test_Run/RandomForestdistRFobject_genes.RData');
mkdir ( "$plugin_path/../../HTpcrA-0.60/root/tmp/FluidigmRF_Test_Run" ) unless (-d "$plugin_path/../../HTpcrA-0.60/root/tmp/FluidigmRF_Test_Run"); ## create the target path for this test data!

## now I should be able to start the sender script. But I need to make sure, that the reciever is running locally.

#my $pid = fork || exec "perl -I $plugin_path/../../HTpcrA-0.60/lib/ $plugin_path/../../HTpcrA-0.60/script/htpcra_server.pl"; ## hope this does work!
#sleep(10);
system ( "perl -I $plugin_path/../lib/ $plugin_path/../bin/reportFluidigm.pl -workload_id 1" );

foreach ( qw(RandomForestdistRFobject_genes.RData  RandomForestdistRFobject.RData  RandomForest_transfereBack.tar.gz) ){
	ok( -f "$plugin_path/../../HTpcrA-0.60/root/tmp/FluidigmRF_Test_Run/$_", "File $_ was created!" );
	unlink (  "$plugin_path/../../HTpcrA-0.60/root/tmp/FluidigmRF_Test_Run/$_" );
}
#sleep(10);
#system ( "kill -9 $pid");

done_testing();