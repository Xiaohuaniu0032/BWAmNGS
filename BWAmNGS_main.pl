use strict;
use warnings;
use File::Basename;
use Getopt::Long;
use FindBin qw/$Bin/;


my ($fastq,$ref,$bwa,$py,$fq_name,$mapq,$len_cutoff,$outdir);

GetOptions(
	"fq:s"   =>   \$fastq, 
	"r:s"    =>   \$ref,       # Default: $Bin/db/Pan_Bacterial_Research_Panel/Pan_Bacterial_Research_Panel.fasta
	"bwa:s"  =>   \$bwa,       # Default: /usr/bin/bwa
	"py:s"   =>   \$py,        # Default: /usr/bin/python3
	"n:s"    =>   \$fq_name,
	"mq:i"   =>   \$mapq,      # Default: 40
	"len:i"  =>   \$len_cutoff,# Default: 100bp 
 	"od:s"   =>   \$outdir,
	) or die;


# default value

if (not defined $mapq){
	$mapq = 40;
}

if (not defined $len_cutoff){
	$len_cutoff = 100;
}

if (not defined $bwa){
	$bwa = "/usr/bin/bwa";
}


if (not defined $py){
	$py = "/usr/bin/python3";
}

if (not defined $ref){
	$ref = "$Bin/db/Pan_Bacterial_Research_Panel/Pan_Bacterial_Research_Panel.fasta";
}

my $runsh = "$outdir/run\_$fq_name\.sh";

open SH, ">$runsh" or die;
print SH "\# bwa\n";
my $sam = "$outdir/$fq_name\.sam";
print SH "$bwa mem $ref $fastq >$sam\n\n";

print SH "\# summary align\n\n";
print SH "$py $Bin/scripts/Summary_Align.py -sam $sam -n $fq_name -mq $mapq -len $len_cutoff -od $outdir\n";

print SH "\# annot\n\n";
my $ref_dir = dirname($ref);
my $GCF_to_OrganName_file = "$Bin/db/map_info/map_info_GCF_and_OrganismName.xls";
my $summary_file = "$outdir/$fq_name\.summary.xls";
my $annot_file = "$outdir/$fq_name\.annot.species.xls";
print SH "perl $Bin/scripts/annot_species.pl $ref_dir $GCF_to_OrganName_file $summary_file $annot_file\n";
close SH;

`chmod 755 $runsh`;
