use strict;
use warnings;

my ($assembly_summary_refseq,$outfile) = @ARGV;

open O, ">$outfile" or die;
print O "organism_name,taxid,species_taxid,version_status,assembly_accession,assembly_level,asm_name,ftp_path\n";


# refseq_category: 
	# reference genome
	# representative genome
	# na

# 统计每个species_taxid下有无reference genome\representative genome\Complete Genome

my %taxid_info;
open IN, "$assembly_summary_refseq" or die;
while (<IN>){
	chomp;
	next if /^$/;
	next if /^\#/;
	my @arr = split /\t/, $_;

	my $species_taxid = $arr[6];
	my $refseq_category = $arr[4]; # reference genome/representative genome/na
	my $assembly_accession = $arr[0];
	my $assembly_level = $arr[11]; # [Complete genome | Chromosome | Scaffold | Contig]
	$taxid_info{$species_taxid}{$assembly_accession} = "$refseq_category\t$assembly_level";
}
close IN;



my %selected_assembly_accession;

foreach my $species_taxid (keys %taxid_info){
	my @assembly_accession = keys %{$taxid_info{$species_taxid}};
	
	# check if this <species_taxid> has [reference genome | representative genome]
	my @ref_genome;
	my @rep_genome;

	# check if this <species_taxid> has [Complete genome]
	my @complete_genome;

	for my $item (@assembly_accession){
		my $val = $taxid_info{$species_taxid}{$item};
		my @val = split /\t/, $val;

		my $refseq_category = $val[0];
		my $assembly_level = $val[1];

		if ($refseq_category eq "reference genome"){
			push @ref_genome, $item;
		}

		if ($refseq_category eq "representative genome"){
			push @ref_genome, $item;
		}

		if ($assembly_level eq "Complete genome"){
			push @complete_genome, $item;
		}
	}

	# choose which one as this species_taxid's refseq
	my $ref_genome = scalar(@ref_genome);
	my $rep_genome = scalar(@rep_genome);
	my $complete_genome = scalar(@complete_genome);

	if ($ref_genome >= 1){
		for my $item (@ref_genome){
			$selected_assembly_accession{$species_taxid}{$item} = 1;
		}
	}elsif ($rep_genome >= 1){
		for my $item (@rep_genome){
			$selected_assembly_accession{$species_taxid}{$item} = 1;
		}
	}elsif ($complete_genome >= 1){
		# random select one complete as refseq
		my $item = $complete_genome[0];
		$selected_assembly_accession{$species_taxid}{$item} = 1;
	}else{
		# this species has no REF/REP/COMPLETE
		next;
	}
}


# output selected refseq
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

	my $version_status     = $arr[10];
	my $refseq_category    = $arr[4];
	my $asm_name           = $arr[15];
	my $ftp_path           = $arr[19];
	my $assembly_level     = $arr[11]; # Complete genome/Chromosome/Scaffold/Contig

	# output format
	my @val = ($organism_name,$taxid,$species_taxid,$version_status,$assembly_accession,$assembly_level,$asm_name,$ftp_path);
	my $val = join(",", @val);


	if (exists $selected_assembly_accession{$species_taxid}{$assembly_accession}){
		print O "$val\n";
	}
}
close IN;
close O;