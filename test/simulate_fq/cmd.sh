dir='/data/fulongfei/git_repo/BWAmNGS/db/Pan_Bacterial_Research_Panel'

fa="$dir/GCF_000005845.2_ASM584v2_genomic.fna.gz"
perl /data/fulongfei/git_repo/BWAmNGS/scripts/simulate_fq.pl -fa $fa -od $PWD -d 5

fa="$dir/GCF_000008865.2_ASM886v2_genomic.fna.gz"
perl /data/fulongfei/git_repo/BWAmNGS/scripts/simulate_fq.pl -fa $fa -od $PWD -d 10

fa="$dir/GCF_000240185.1_ASM24018v2_genomic.fna.gz"
perl /data/fulongfei/git_repo/BWAmNGS/scripts/simulate_fq.pl -fa $fa -od $PWD -d 20

fa="$dir/GCF_000013425.1_ASM1342v1_genomic.fna.gz"
perl /data/fulongfei/git_repo/BWAmNGS/scripts/simulate_fq.pl -fa $fa -od $PWD -d 30
