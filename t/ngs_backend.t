## here we check the script /bin/ngs_pipeline_backend.pl
#! /usr/bin/perl
use strict;
use warnings;
use Test::More tests => 44;
BEGIN { use_ok 'stefans_libs::database::workload' }
BEGIN { use_ok 'stefans_libs::database::process_finished' }


$ENV{'DBFILE'} = "/home/slang/dbh_config.xls";
my ( $value, @values, $exp );
use FindBin;
my $plugin_path = "$FindBin::Bin";

my $backend_call =
    "perl -I $plugin_path/../lib $plugin_path/../bin/ngs_pipeline_backend.pl"
  . " -root_path $plugin_path/data/Outpath/"    ## totally unused at the moment!
  . " -dbh_definition $ENV{'DBFILE'}" . " -frequency 1"    ## speed it up!
  . " -pid_file $plugin_path/data/Outpath/ngs_pipeline_backend.pid "
  . " -log_file $plugin_path/data/Outpath/ngs_pipeline_backend.log ";

mkdir("$plugin_path/data/Outpath/") unless ( -d "$plugin_path/data/Outpath/" );
unlink("$plugin_path/data/Outpath/ngs_pipeline_backend.log")
  if ( -f "$plugin_path/data/Outpath/ngs_pipeline_backend.log" );
unlink("$plugin_path/data/Outpath/reportFluidigm.log")
  if ( -f "$plugin_path/data/Outpath/reportFluidigm.log");

$0 .= ".pl";    ## select the same database as the running $backend_call
my $db = stefans_libs::database::workload->new( variable_table->getDBH() );
$db->create();    ## drop and re-create
$db->AddDataset(
	{
		'username' => 'med-sal',
		'module'   => 'NGS sequencing',
		'type'     => 'normal',
		'info1'    => 'genome:mm10',
		'info2'    => 'Alignement type:DNA',
		'script'   => "$plugin_path/data/some_null_script.sh"
	}
);
$value = $db->check_new();
is_deeply(
	[ @{ $value->{'header'} }, @{ @{ $value->{'data'} }[0] } ],
	[
		'id', 'script', 'type', 1, "$plugin_path/data/some_null_script.sh",
		'normal'
	],
	"Added the null script"
);
system("rm $plugin_path/data/Outpath/ngs_pipeline_backend.pid")
  if ( -f "$plugin_path/data/Outpath/ngs_pipeline_backend.pid" );
## start the backend
system($backend_call );
sleep(2);

unless (
	ok(
		-f "$plugin_path/data/Outpath/ngs_pipeline_backend.pid",
		"backend process started"
	)
  )
{
	die "Epic fail!\n";
}
$exp = 0;
foreach ( 1 .. 4 ) {
	## the process will fail as the SGE is not installed on the development platform
	## and if the system is installed the some_null_script.sh is no SGE script :-)
	if ( $db->failed()->Lines() ) {
		$exp = 1;
		last;
	}
	sleep(2);
}
ok( $exp, 'The workload entry has changed state to failed as expected' );
## do some more tests!

$db->AddDataset(
	{
		'username' => 'med-sal',
		'module'   => 'Random Forest Calculation',
		'type'     => 'multiple',
		'info1'    => 'localhost:3000/randomforest/index/',
		'info2'    => 'cc246ec82dbc0796e21ba9ac550b671ec75f6e19',
		'script' =>
"$plugin_path/data/Outpath/shared_path/FluidigmRF_Test_Run/RandomForestStarter.sh"
	}
);
$value = $db->check_new();
is_deeply(
	[ @{ $value->{'header'} }, @{ @{ $value->{'data'} }[0] } ],
	[
		'id',
		'script',
		'type',
		2,
"$plugin_path/data/Outpath/shared_path/FluidigmRF_Test_Run/RandomForestStarter.sh",
		'multiple'
	],
	"Added the multiple null script"
);
foreach ( 1 .. 9 ) {
	## the process will fail as the SGE is not installed on the development platform
	## and if the system is installed the some_null_script.sh is no SGE script :-)
	if ( $db->failed()->Lines() == 2 ) {
		$exp = 1;
		for ( 0 .. 33 ) {
			$exp =
"$plugin_path/data/Outpath/shared_path/FluidigmRF_Test_Run/qsub_multiple_script_$_.sh";
			unlink($exp)
			  if ( ok( -f $exp, "created temp qsub script '$exp'" ) );
		}

# ok ( -f "$plugin_path/data/Outpath/shared_path/FluidigmRF_Test_Run/pids.txt" , "created temp pids.txt"); ## is not created due to
		last;
	}
	sleep(5);
}
ok( $exp, 'The workload entry has changed state to failed as expected' );
my $postprocess = stefans_libs::database::process_finished->new($db->{'dbh'} );
$postprocess -> create();
$postprocess -> AddDataset( {'module' =>  'Random Forest Calculation', 'program' => "$plugin_path/../bin/reportFluidigm.pl -log_file $plugin_path/data/Outpath/reportFluidigm.log" } );
$db->process_SGE( 2, 23423 )
  ;    ## trick the tool into beliving the data has been processed!
$value = $db->get_running();


is_deeply(
	[ @{ $value->{'header'} }, @{ @{ $value->{'data'} }[0] } ],
	[
		'id',
		'script',
		'state','module',
		'type',
		2,
"$plugin_path/data/Outpath/shared_path/FluidigmRF_Test_Run/RandomForestStarter.sh",
		23423,'Random Forest Calculation',
		'multiple'
	],
	"The multiple job has been reactivated"
);

foreach ( 1 .. 9 ) {
	## the process will fail as the SGE is not installed on the development platform
	## and if the system is installed the some_null_script.sh is no SGE script :-)
	sleep(2);
}
print $db->failed()->AsString();

### finish the backend script!
ok( -f "$plugin_path/data/Outpath/ngs_pipeline_backend.log",
	"backend log has been created" );
ok( -f "$plugin_path/data/Outpath/reportFluidigm.log",
	"backend reportFluidigm log has been created" );

open( IN, "<$plugin_path/data/Outpath/ngs_pipeline_backend.pid" );
my $pid = <IN>;
close(IN);
print "The backend ($pid) is being killed now\n";
system("kill -9 $pid");
system("rm $plugin_path/data/Outpath/ngs_pipeline_backend.pid");
