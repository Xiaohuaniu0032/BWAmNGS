use strict;
use warnings;
use FindBin qw/$Bin/;
use File::Basename;

my ($taxid_list,$refseq_download_xls,$outdir) = @ARGV;

my %download_taxid;
open IN, "$taxid_list" or die;
while (<IN>){
	chomp;
	next if /^$/;
	my @arr = split /\,/, $_;
	my $taxid = $arr[0];
	$download_taxid{$taxid} = 1;
}
close IN;

# get ftp path
my %ftp_path;

open IN, "$refseq_download_xls" or die;
<IN>;
while (<IN>){
	chomp;
	my @arr = split /\,/, $_;
	my $taxid = $arr[2];
	my $ftp_path = $arr[-1];
	my $basename = basename($ftp_path);
	my $fasta_abs_path = $ftp_path.'/'.$basename.'_genomic.fna.gz';
	if (exists $download_taxid{$taxid}){
		push @{$ftp_path{$taxid}}, $fasta_abs_path;
	}
}
close IN;

# 检查哪些taxid不在下载数据库中
foreach my $taxid (keys %download_taxid){
	if (exists $ftp_path{$taxid}){
		my @path = @{$ftp_path{$taxid}};
		for my $p (@path){
			print "$taxid\t$p\n";
		}
	}else{
		print "$taxid\tNA\n";
	}
}


# download
foreach my $item (keys %ftp_path){
	my @path = @{$ftp_path{$item}};
	for my $path (@path){
		my $fa_name = basename($path);
		my $dirname = dirname($path);
		my $basename = basename($dirname); # log file prefix
		my $wget_log = "$outdir/$basename.wget.log";
		print "[Downloading $fa_name ...]\n";
		chdir $outdir;
		`wget $path >$wget_log 2>&1`;

		# check *.wget.log file for if downloaded successfully
	}
}
