use strict;
use warnings;

my ($assembly_summary_refseq,$outfile) = @ARGV;

open O, ">$outfile" or die;
print O "organism_name,taxid,species_taxid,version_status,assembly_accession,refseq_category,asm_name,ftp_path\n";


# refseq_category: 
	# reference genome
	# representative genome
	# na

# 首先得到每个物种所有可能的组装序列信息

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

	my @val = ($organism_name,$taxid,$species_taxid,$version_status,$assembly_accession,$refseq_category,$asm_name,$ftp_path);
	my $val = join(",", @val);

	if ($refseq_category eq "reference genome" || $refseq_category eq "representative genome"){
		# only download this kind of ref seq genome
		print O "$val\n";
	}
}
close IN;
close O;