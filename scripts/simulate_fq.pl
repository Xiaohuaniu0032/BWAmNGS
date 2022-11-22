use strict;
use warnings;
use File::Basename;
use Getopt::Long;
use FindBin qw/$Bin/;

my ($fasta,$read_len,$depth_x,$outdir);

GetOptions(
	"fa:s"    =>  \$fasta,
	"len:i"   =>  \$read_len,   # Default: 150
	"d:i"     =>  \$depth_x,    # Default: 50X
	"od:s"    =>  \$outdir,
	) or die;


# default value
if (not defined $read_len){
	$read_len = 150;
}

if (not defined $depth_x){
	$depth_x = 50;
}


my $qual_ascii = '0'; # Phred + 33;

my %fasta;
my $header;

if ($fasta =~ /\.fna.gz/){
	open FA, "gunzip -dc $fasta |" or die;
}else{
	open FA, "$fasta" or die;
}

while (<FA>){
	chomp;
	next if /^$/;
	if (/^\>/){
		# header
		if ($_ !~ /plasmid/){
			$header = (split /\s+/, $_)[0];
			$header =~ s/^\>//;
		}else{
			$header = "SKIP";
		}
	}else{
		if ($header ne "SKIP"){
			push @{$fasta{$header}}, $_;
		}
	}
}
close FA;

my %fasta_final;
foreach my $h (keys %fasta){
	my @seq = @{$fasta{$h}};
	my $seq = join("", @seq);
	$fasta_final{$h} = $seq;
}

print "refseq\tgenome.len\tsimulate.read.num\n";

foreach my $h (keys %fasta_final){
	my $seq = $fasta_final{$h};
	my $seq_len = length($seq);
	my $read_num = int($depth_x * $seq_len / $read_len);
	# read_len * read_num / seq_len = depth_x

	print "$h\t$seq_len\t$read_num\n";

	open O, ">$outdir/$h\.fastq" or die;

	my $i = 1;
	while ($i <= $read_num){
		my $rand_max = $seq_len - $read_len;
		my $pos = int(rand($rand_max)); # pos range [0,seq_len-$read_len]
		my $sub_seq = substr($seq,$pos,$read_len);
		my $seq_header = "$h\_seq".$i.'_pos'.$pos;
		my $qual_seq = $qual_ascii x $read_len;

		print O "\@$seq_header\n";
		print O "$sub_seq\n";
		print O "+\n";
		print O "$qual_seq\n";

		$i += 1;
	}

	close O;
}




