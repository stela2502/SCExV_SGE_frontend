#! /usr/bin/perl -w

#  Copyright (C) 2015-09-18 Stefan Lang

#  This program is free software; you can redistribute it 
#  and/or modify it under the terms of the GNU General Public License 
#  as published by the Free Software Foundation; 
#  either version 3 of the License, or (at your option) any later version.

#  This program is distributed in the hope that it will be useful, 
#  but WITHOUT ANY WARRANTY; without even the implied warranty of 
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
#  See the GNU General Public License for more details.

#  You should have received a copy of the GNU General Public License 
#  along with this program; if not, see <http://www.gnu.org/licenses/>.

=head1 summary_bam_files.pl

This tool uses samtools idxstats to produce a summary over a list of bam files

To get further help use 'summary_bam_files.pl -help' at the comman line.

=cut

use Getopt::Long;
use strict;
use warnings;

use stefans_libs::flexible_data_structures::data_table;


use FindBin;
my $plugin_path = "$FindBin::Bin";

my $VERSION = 'v1.0';


my ( $help, $debug, $database, @bams);

Getopt::Long::GetOptions(
	 "-bams=s{,}"    => \@bams,

	 "-help"             => \$help,
	 "-debug"            => \$debug
);

my $warn = '';
my $error = '';

unless ( -f $bams[0]) {
	$error .= "the cmd line switch -bams is undefined!\n";
}


if ( $help ){
	print helpString( ) ;
	exit;
}

if ( $error =~ m/\w/ ){
	print helpString($error ) ;
	exit;
}

sub helpString {
	my $errorMessage = shift;
	$errorMessage = ' ' unless ( defined $errorMessage); 
 	return "
 $errorMessage
 command line switches for summary_bam_files.pl

   -bams       :<please add some info!>

   -help           :print this help
   -debug          :verbose output
   

"; 
}


my ( $task_description);

$task_description .= 'perl '.$plugin_path .'/summary_bam_files.pl';
$task_description .= " -bams '".join("' '",@bams)."'" if (defined $bams[0]);



## Do whatever you want!

my $res = data_table->new();
$res -> Add_2_Header( [ 'file', 'mapped', 'unmapped', 'percent mapped'] );

my ($m, $u, $data);
foreach my $bam  (@bams) {
	open ( IN , "samtools idxstats $bam |" ) ;
	$data = data_table->new();
	$data-> Add_2_Header( [ 'chr', 'length', 'mapped', 'unmapped' ] );
	$data->parse_from_string ( [<IN>] );
	$m = &sum(@{$data->GetAsArray('mapped')});
	$u = &sum(@{$data->GetAsArray('unmapped')});
	$res -> AddDataset( { 'file' => $bam , 'mapped' => $m, 'unmapped' => $u, 'percent mapped' => $m / ( $m + $u ) *100 } );
} 

print $res -> AsString();


sub sum {
	my $ret = 0;
	map{ $ret += $_ } @_;
	return $ret;
}	
