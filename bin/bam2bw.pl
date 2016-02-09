#! /usr/bin/perl -w

#  Copyright (C) 2015-09-15 Stefan Lang

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

=head1 bam2bw.pl

The perl script reads from the inpath and creates a list of qsub scripts to convert all bam files to bw files dropping all intermediates.

To get further help use 'bam2bw.pl -help' at the comman line.

=cut

use Getopt::Long;
use strict;
use warnings;

use stefans_libs::NGS_pipeline::SGE_helper::mapper_general;

use FindBin;
my $plugin_path = "$FindBin::Bin";

my $VERSION = 'v1.0';


my ( $help, $debug, $database, $path, @options, $options);

Getopt::Long::GetOptions(
	 "-path=s"    => \$path,
	 "-options=s{,}"    => \@options,

	 "-help"             => \$help,
	 "-debug"            => \$debug
);

my $warn = '';
my $error = '';

unless ( -d $path) {
	$error .= "the cmd line switch -path is undefined!\n";
}
unless ( defined $options[0]) {
	$error .= "the cmd line switch -options is undefined!\nI need to know at least the genome like mm10 (genome=mm10)\n";
}
else {
	$options = { map { if ( $_ =~ m/^(.*)=(.*)$/ ) {$1 => $2} else {chomp($_); $_ => 1} } @options};
}
unless( defined $options->{'genome'} ) {
	$error .= "I need to know at least the genome like mm10 (genome=mm10)\n"
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
 command line switches for bam2bw.pl

   -path       :<please add some info!>
   -options       :<please add some info!> you can specify more entries to that

   -help           :print this help
   -debug          :verbose output
   

"; 
}


my ( $task_description);

$task_description .= 'perl '.$plugin_path .'/bam2bw.pl';
$task_description .= " -path $path" if (defined $path);
$task_description .= ' -options '.join( ' ', @options ) if ( defined $options[0]);


my $qsub_head = 
'#!/bin/bash
#$ -S /bin/bash
#$ -M Stefan.Lang@med.lu.se
#$ -m eas
#$ -pe orte 4
#$ -l mem_free=1G
';
## Do whatever you want!

my ( @tmp, $fcore, $script, $helper, $thisdir, $line );

chdir( $path );
$thisdir = `pwd`;
chomp($thisdir);
$helper = stefans_libs::NGS_pipeline::SGE_helper::mapper_general->new();

open ( IN , "ls *.bam |" );
while ( <IN> ) {
	next if ( $_ =~ m/sorted.bam$/ );
	print "bam file $_" if ($debug);
	$_ =~ m/(.*).bam$/;
	$fcore = $1;
	$script = $qsub_head;
	if ( $options->{'samfile'} ) {
	$line = "samtools view -S $thisdir/$fcore.bam -b |  samtools sort -\@ 4 -l 4 - $thisdir/$fcore.sorted\n";
	}
	else {
	$line .= "samtools sort -\@ 4 -l 4  $thisdir/$fcore.bam  $thisdir/$fcore.sorted\n";
	}
	if ( -f "$fcore.sorted.bam" ) {
		$line = "#$line";
	}
	$script .= $line;
	$line = "samtools index $thisdir/$fcore.sorted.bam\n";
	if ( -f "$fcore.sorted.bam.bai" ) {
		$line = "#$line";
	}
	$script .= $line;
	$line =  "bedtools genomecov -bg -split -ibam $thisdir/$fcore.sorted.bam -g " . $helper->file_location($options->{'genome'}, "chrom_size", "unused")."  > $thisdir/$fcore.genomeCoverage\n";
	if ( -f "$fcore.genomeCoverage" ) {
		$line = "#$line";
	}
	$script .= $line;
	$line = "bedGraphToBigWig  $thisdir/$fcore.genomeCoverage ".$helper->file_location($options->{'genome'}, "chrom_size", "unused")." $thisdir/$fcore.bw\n";
	if ( -f "$fcore.bw" ){
		$line = "#$line";
	}
	$script .= $line;

	if ( &script_is_working($script) ) {
		open ( OUT , ">BAM2bw_$fcore.sh" ) or die "I could not create the script file 'BAM2bw_$fcore.sh'\n$!\n";
		print OUT $script;
		print $script if ( $debug );
		system ( "qsub BAM2bw_$fcore.sh" ) unless ( $debug);
	}
	else {
		warn "file $fcore.bam has already been converted to bw!\n";
	}
}

sub script_is_working {
	my ( $script ) = @_;
	my $ret = 0;
	map { $ret ++ unless ( $_ =~ m/^#/ ) } split("\n",$script );
	return $ret;
}
