use strict;
use warnings;
use File::Basename;
use Getopt::Long;
use FindBin qw/$Bin/;

my ($ref_dir,$GCF_to_OrganismName_file,$summary_xls,$outfile) = @ARGV;

# read NC => GCF info
my %map_info_NC2GCF;
my $map_info_file = "$ref_dir/map_info/map_info.NC2GCF.xls";
open MAP, "$map_info_file" or die;
while (<MAP>){
	chomp;
	my @arr = split /\t/, $_;
	my $nc = $arr[0];
	my $gcf = $arr[1];
	$map_info_NC2GCF{$nc} = $gcf;
}
close MAP;


# read GCF => OrganismName info
my %map_info_GCF_to_Organ;
open IN, "$GCF_to_OrganismName_file" or die;
<IN>;
while (<IN>){
	chomp;
	my @arr = split /\t/;
	my $GCF = $arr[0];
	my $name = $arr[1];
	$map_info_GCF_to_Organ{$GCF} = $name;
}
close IN;


open O, ">$outfile" or die;
print O "RefSeq\tOrganismName\tReadCount\n";

open IN, "$summary_xls" or die;
<IN>;
while (<IN>){
	chomp;
	my @arr = split /\t/;
	my $NC = $arr[0];
	
	# NC => GCF
	my $GCF;
	if (exists $map_info_NC2GCF{$NC}){
		$GCF = $map_info_NC2GCF{$NC};
	}else{
		$GCF = "NA";
	}

	# GCF => Name
	my $name;
	if ($GCF ne "NA"){
		if (exists $map_info_GCF_to_Organ{$GCF}){
			$name = $map_info_GCF_to_Organ{$GCF};
		}else{
			$name = "NA";
		}
	}else{
		$name = "NA";
	}

	print O "$NC\t$name\t$arr[1]\n";
}
close IN;

close O;
