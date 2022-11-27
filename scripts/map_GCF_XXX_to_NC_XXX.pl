use strict;
use warnings;
use File::Basename;
use Getopt::Long;
use FindBin qw/$Bin/;

my ($ref_db_dir,$outfile) = @ARGV;


open O, ">$outfile" or die;
#print O "NC\tGCF\n";

# NC => GCF (one GCF_xxx.fna.gz may contain multi >NC)

my @fa = glob "$ref_db_dir/*.fna.gz";
for my $fa (@fa){
	#print "$fa\n";
	my $fa_bname = basename($fa);
	my @fa_bname = split /\_/, $fa_bname;
	my $GCF = "$fa_bname[0]\_$fa_bname[1]";

	my $NC;
	open IN, "gunzip -dc $fa |" or die;
	while (<IN>){
		chomp;
		next if /^$/;
		if (/^\>/){
			my $NC = (split /\s+/, $_)[0];
			$NC =~ s/^\>//;
			print O "$NC\t$GCF\n";
		}
	}
	close IN;
}






