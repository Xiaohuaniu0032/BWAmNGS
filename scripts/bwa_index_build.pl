use strict;
use warnings;
use File::Basename;
use Getopt::Long;
use FindBin qw/$Bin/;


my ($db_dir,$bwa,$db_name) = @ARGV;


my $fa = "$db_dir/$db_name\.fasta";

`less $db_dir/*.fna.gz >$fa`;
`$bwa index $fa`;
print "[Finished BWA index...]\n";