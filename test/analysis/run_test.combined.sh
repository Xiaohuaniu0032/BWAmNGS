# bwa
/usr/bin/bwa mem /data/fulongfei/git_repo/BWAmNGS/db/Pan_Bacterial_Research_Panel/Pan_Bacterial_Research_Panel.fasta /data/fulongfei/git_repo/BWAmNGS/test/combined_fq/test.combined.fastq >/data/fulongfei/git_repo/BWAmNGS/test/analysis/test.combined.sam

# summary align

/home/fulongfei/miniconda3/bin/python3 /data/fulongfei/git_repo/BWAmNGS/scripts/Summary_Align.py -sam /data/fulongfei/git_repo/BWAmNGS/test/analysis/test.combined.sam -n test.combined -mq 40 -len 100 -od /data/fulongfei/git_repo/BWAmNGS/test/analysis
# annot

perl /data/fulongfei/git_repo/BWAmNGS/scripts/annot_species.pl /data/fulongfei/git_repo/BWAmNGS/db/Pan_Bacterial_Research_Panel /data/fulongfei/git_repo/BWAmNGS/db/map_info/map_info_GCF_and_OrganismName.xls /data/fulongfei/git_repo/BWAmNGS/test/analysis/test.combined.summary.xls /data/fulongfei/git_repo/BWAmNGS/test/analysis/test.combined.annot.species.xls
