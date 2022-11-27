use strict;
use warnings;
use File::Basename;
use Getopt::Long;
use FindBin qw/$Bin/;

my ($assembly_summary_refseq,$outfile) = @ARGV;

open O, ">$outfile" or die;
print O "assembly_accession\torganism_name\n";

open IN, "$assembly_summary_refseq" or die;
while (<IN>){
	chomp;
	next if /^$/;
	next if /^\#/;
	my @arr = split /\t/;
	my $GCF = $arr[0];
	my $organism_name = $arr[7];
	print O "$GCF\t$organism_name\n";
}
close IN;
close O;