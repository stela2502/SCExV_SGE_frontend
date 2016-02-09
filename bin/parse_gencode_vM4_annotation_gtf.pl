#! /usr/bin/perl -w

#  Copyright (C) 2015-09-11 Stefan Lang

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

=head1 parse_gencode_vM4_annotation_gtf.pl

This tool can get information on a list of gene_ids. The format of the gene_ids is gtf file dependant.

To get further help use 'parse_gencode_vM4_annotation_gtf.pl -help' at the comman line.

=cut

use Getopt::Long;
use strict;
use warnings;

use FindBin;
my $plugin_path = "$FindBin::Bin";

my $VERSION = 'v1.0';

use stefans_libs::flexible_data_structures::data_table;
use stefans_libs::root;

my ( $help, $debug, $database, @restrict, @gene_ids, $gtf);

Getopt::Long::GetOptions(
	 "-gene_ids=s{,}"    => \@gene_ids,
	 "-gtf=s"    => \$gtf,
	 "-restrict=s{,}" => \@restrict,
	 "-help"             => \$help,
	 "-debug"            => \$debug
);

my $warn = '';
my $error = '';

unless ( defined $gene_ids[0]) {
	$warn .= "the cmd line switch -gene_ids is undefined!\n";
}
elsif ( -f $gene_ids[0] ) {
	open ( IN, "<$gene_ids[0]" );
	@gene_ids = map { chomp(); $_; } <IN>;
	close ( IN );
}

unless ( -f $gtf) {
	$error .= "the cmd line switch -gtf is undefined!\n";
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
 command line switches for parse_gencode_vM4_annotation_gtf.pl

   -gene_ids  :the gene IDs you want to add (all if empty)
   -gtf       :the gtf file you want to parse
   -restrict  :an optional restriction which values to report like 'objtag=gene'

   -help           :print this help
   -debug          :verbose output
   

"; 
}



#chr1    HAVANA  gene    3073253 3074322 .       +       .       gene_id "ENSMUSG00000102693.1"; transcript_id "ENSMUSG00000102693.1"; gene_type "TEC"; gene_status "KNOWN"; gene_name "RP23-271O17.1"; transcript_type "TEC"; transcript_status "KNOWN"; transcript_name "RP23-271O17.1"; level 2; havana_gene "OTTMUSG00000049935.1";



my $data = data_table->new();
my ( $hash, $use, $check );
$use = { map { $_ => 1 } @gene_ids };
if ( defined $restrict[0]) {
	foreach my $restrict ( @restrict ){ 
		if ( $restrict=~ m/(.*)=(.*)/ ){
			if ( ref($check ->{$1}) eq "HASH") {
				$check ->{$1}->{$2} = 1;
			}
			else{
				$check ->{$1} = {$2 => 1};
			}
		}
	}
}
warn "I open the gtf file '$gtf'\n" if ( $debug);
open ( IN, "<$gtf" ) or die "I could not open the gft file '$gtf'\n$!\n";
my $exon_level;
my $exon_use= {'objtag' => {'exon' => 1}};
while ( <IN> ) {
	$hash = &hash_line($_);
	warn root::get_hashEntries_as_string( $hash, 3, "Parsed OK?") if ( $debug);
	unless ( $data->Lines()){
		$data->Add_2_Header(['chr', 'start', 'end', 'objtag']);
		$data->Add_2_Header( [ sort keys $hash ] );
		$exon_level = $data->copy();
	}
	$data->Add_2_Header( [ sort keys $hash ] );
	$data->AddDataset( $hash ) if ( &useThis( $hash ) );
	if ( &useThis( $hash, $exon_use )) {
		$exon_level->Add_2_Header( [ sort keys $hash ] );
		$exon_level -> AddDataset( $hash );
		print "added line $_\n";
	}
}
close ( IN );

$exon_level ->define_subset ( 'data', ['start','end']);

#print $exon_level->AsString();


$exon_level = $exon_level->pivot_table ( {
		'grouping_column' => 'gene_id',
		'Sum_data_column' => 'data',
		'Sum_target_columns' => [ 'transcriptLength' ],
		'Suming_function' => sub {
			my $sum = 0;
			for ( my $i = 0; $i < @_; $i+=2 ){ 
				$sum += $_[$i+1] - $_[$i];
			}
			return $sum;
		}
});
my $exon_index = $exon_level->createIndex('gene_id');
my $data_index = $data->createIndex('gene_id');
my $id = $data->Add_2_Header('transcriptLength');
#print $exon_level->AsString();
foreach my $geneid ( keys %$data_index ) {
	#print "geneid = $geneid; data_index = @{$data_index->{$geneid}}[0]; exon_index = @{$exon_index->{$geneid}}[0]\n";
	@{@{$data->{'data'}}[@{$data_index->{$geneid}}[0]]}[$id] = @{@{$exon_level->{'data'}}[@{$exon_index->{$geneid}}[0]]}[1];
}


print $data -> AsString();


sub useThis {
	my ( $hash, $CHECK ) = @_;
	$CHECK ||= $check;
	if ( defined $gene_ids[0] ) {
		return 0 unless ( $use ->{ $hash->{'gene_id'} } );
	}
	if ( ref ($CHECK) eq "HASH" ){
		foreach ( keys %$CHECK ) {
			return 0 unless ($CHECK->{$_}->{$hash->{$_}});
		}
	}
	return 1;
}


sub hash_line {
	my ( $line ) = @_;
	my @line = split("\t", $line );
	my $hash;
	$hash->{'chr'} = $line[0];
	$hash->{'database'} = $line[1];
	$hash->{'objtag'} = $line[2];
	$hash->{'start'} = $line[3];
	$hash->{'end'} = $line[4];
	$hash->{'orientation'} = $line[6];
	for ( my $i = 5; $i < @line; $i++ ){
		if ( $line[$i] =~ m/;/ ){
			map { if ( $_ =~ m/\s*([\w_]*)\s+"(.*)"\s*/ ) { $hash->{$1} = $2;} } split(/;/,$line[$i]);
		}
	}
	warn root::get_hashEntries_as_string( $hash, 3, "Parsed OK?") if ( $debug);

	return $hash;
}
