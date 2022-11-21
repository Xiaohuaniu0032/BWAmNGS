use strict;
use warnings;

my ($assembly_summary_refseq,$outfile) = @ARGV;

open O, ">$outfile" or die;
print O "organism_name\ttaxid\tspecies_taxid\tisolate\tassembly_accession\trefseq_category\tasm_name\tftp_path\n";


# refseq_category: reference genome,representative genome,na

# 首先得到每个物种所有可能的组装序列信息



my %organism_name;

open IN, "$assembly_summary_refseq" or die;
while (<IN>){
	chomp;
	next if /^$/;
	next if /^\#/;
	my @arr = split /\t/, $_;
	my $assembly_accession = $arr[0];
	my $organism_name      = $arr[7];
	my $taxid              = $arr[5];
	my $species_taxid      = $arr[6];
	my $isolate            = $arr[9];
	my $refseq_category    = $arr[4];
	my $asm_name           = $arr[15];
	my $ftp_path           = $arr[19];

	my @val = ($organism_name,$taxid,$species_taxid,$isolate,$assembly_accession,$refseq_category,$asm_name,$ftp_path);
	my $val = join("\t", @val);

	if ($refseq_category eq "reference genome" || $refseq_category eq "representative genome"){
		push @{$organism_name{$organism_name}}, $val;
	}

	if ($taxid == 562 and $species_taxid == 562){
		if ($refseq_category eq "reference genome" || $refseq_category eq "representative genome"){
			print "$_\n";
		}
	}
}
close IN;

foreach my $organism_name (keys %organism_name){
	my @val = @{$organism_name{$organism_name}};
	print O "$organism_name\n";
	for my $val (@val){
		print O "\t$val\n";
	}
	print O "\n\n";
}

close O;