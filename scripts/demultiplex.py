import string
import subprocess
import sys

import pandas as pd

files = sys.argv[1:]

fastq2tab = string.Template(
    "cat $file"
    " | paste - - - -"
    " | awk -F'\t' '{{OFS=\"\t\"; sub(/ .*$$/, \"\", $$1); print}}'")

reader = (subprocess.Popen(fastq2tab.substitute(file=f), shell=True, stdout=subprocess.PIPE) for f in files)

reader_df = (pd.read_table(read.stdout, names=["id", "sequence", "plus", "quality"], index_col=["id"]) for read in reader)

reads = pd.concat(reader_df, axis=1, join='inner', keys='I1 I2 R1 R2'.split())

reads.reset_index().to_csv(sys.stdout, sep='\t', index=True)

# either write a pythom program or do some bash magic
# produce an index file that is used by awk to get the IDs of each cluster, embarassingly parallel if we produce a file for each cluster with seq_numbers first
perl -ne 'print if $. == 1 or $. % 4 == 1' nextseq_I1_post-qc.fastq | cut -f1 -d ' ' > index.txt
awk 'NR==FNR{a[$0]; next} (FNR in a)' {cluster}_seqnum.txt index.txt > {cluster}_seqid.txt
# e.g. <(head -n1 nextseq_clusters.tsv | cut -f3 | tr "," "\n") to get seqnum.txt of first cluster
# then use {cluster}_seqid and fastq to make {cluster}_R{1,2}.fastq or better yet demultiplex samples to get {unit}_{sample}_{cluster}_R{1,2}.fastq
# then map and deduplicate