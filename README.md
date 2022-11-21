# BWAmNGS


## Download `assembly_summary_refseq.txt`

`wget https://ftp.ncbi.nlm.nih.gov/genomes/refseq/assembly_summary_refseq.txt`

```
#   See ftp://ftp.ncbi.nlm.nih.gov/genomes/README_assembly_summary.txt for a description of the columns in this file.
# assembly_accession    bioproject      biosample       wgs_master      refseq_category taxid   species_taxid
   organism_name   infraspecific_name      isolate version_status  assembly_level  release_type    genome_rep
      seq_rel_date    asm_name        submitter       gbrs_paired_asm paired_asm_comp ftp_path        excluded_from_refseq    relation_to_type_material       asm_not_live_date
GCF_000001215.4 PRJNA164        SAMN02803731            reference genome        7227    7227    Drosophila melanogaster                 latest  Chromosome      Major   Full    2014/08/01      Release 6 plus ISO1 MT  The FlyBase Consortium/Berkeley Drosophila Genome Project/Celera Genomics       GCA_000001215.4 identical       https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/215/GCF_000001215.4_Release_6_plus_ISO1_MT                 na
GCF_000001405.40        PRJNA168                        reference genome        9606    9606    Homo sapiens
                    latest  Chromosome      Patch   Full    2022/02/03      GRCh38.p14      Genome Reference Consortium     GCA_000001405.29        different       https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/405/GCF_000001405.40_GRCh38.p14                    na

```

## `assembly_summary_refseq.txt` file format

See: https://ftp.ncbi.nlm.nih.gov/genomes/README_assembly_summary.txt for detail introduction.

Column  1: "assembly_accession"
Column  2: "bioproject"
Column  3: "biosample"
Column  4: "wgs_master"
Column  5: "refseq_category"
	Values: [reference genome | representative genome | na]
Column  6: "taxid"
Column  7: "species_taxid"
> The species taxid will differ from the organism taxid (column 6) only when the organism was reported at a sub-species or strain level.
Column  8: "organism_name"
Column  9: "infraspecific_name"
Column 10: "isolate"
Column 11: "version_status"
Column 12: "assembly_level"
	Values: [Complete genome | Chromosome | Scaffold | Contig]
Column 13: "release_type"
Column 14: "genome_rep"
Column 15: "seq_rel_date": Sequence release date
Column 16: "asm_name": Assembly name
Column 17: "submitter"
Column 18: "gbrs_paired_asm"
Column 19: "paired_asm_comp"
Column 20: "ftp_path": the path to the directory on the NCBI genomes FTP site from which data for this genome assembly can be downloaded.
Column 21: "excluded_from_refseq"
Column 22: "relation_to_type_material"
Column 23: "asm_not_live_date" 



## Main methods
1. BWA align
2. Filter reads based on alignment information (CIGAR/Read.Length/Align.Length/Mismatch.Num/MAPQ)
3. Map align information into species information

## Main reads filter parameters
1. read.length: 
2. MAPQ:
3. Remove SECONDARY/SUPPLEMENTARY

## Download your refseq database
Before using this pipeline, you need to download refseq genomes as your ref database.
Please provide a `taxid.list` file to automatically download all the species' ref seq genome.

## `taxid.list` file format
One line for a taxid. Only first column will be used. 

```
511145,Escherichia coli str. K-12 substr. MG1655
386585,Escherichia coli O157:H7 str. Sakai

```

## Test





## FAQ
