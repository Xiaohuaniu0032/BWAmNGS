import pysam
import sys
import argparse
import os
from collections import defaultdict


def parse_args():
	AP =  argparse.ArgumentParser("BWAmNGS Main Script: Summary Alignment")
	AP.add_argument('-sam',help="sam file",dest='sam')
	AP.add_argument('-n',  help='samplel name',dest='name')
	AP.add_argument('-mq', help='map quality',dest='mapq')
	AP.add_argument('-len', help='read length cutoff',dest='readLen')
	AP.add_argument('-od', help="output dir",dest="outdir")

	return AP.parse_args()

def main():
	options = parse_args()
	samfile = pysam.AlignmentFile(options.sam,'r')
	aln_seq_count = dict()
	for read in samfile:
		#print(read)
		# AlignedSegment: representing an aligned segment
		if read.is_mapped:
			if read.is_secondary or read.is_supplementary:
				continue
			
			seq_name = read.query_name
			seq = read.query_sequence
			CIGAR = read.cigartuples # 
			mapq = read.mapping_quality
			chrom = read.reference_name
			seq_len = read.infer_query_length()
			tags = read.get_tags()

			# check seq.len
			if seq_len <= int(options.readLen):
				continue

			# check mapq
			if mapq <= int(options.mapq):
				continue

			if chrom in aln_seq_count:
				aln_seq_count[chrom] += 1
			else:
				aln_seq_count[chrom] = 1

			#print(seq_name,seq,seq_len,chrom,CIGAR,mapq,tags)

	# output summary info
	outfile = "%s/%s.summary.xls" % (options.outdir,options.name)
	fh = open(outfile,'w')
	header = 'RefSeq\tReadCount\n'
	fh.write(header)
	
	for key in aln_seq_count:
		n = aln_seq_count[key]
		val = "%s\t%s" % (key,n)
		fh.write(val+'\n')

	fh.close()


	samfile.close()



if __name__ == "__main__":
	main()

