import string
import subprocess
import sys

import pandas as pd

files = sys.argv[1:]

fastq2tab = string.Template(
    "gunzip -c $file"
    " | paste - - - -"
    " | awk -F'\t' '{{OFS=\"\t\"; sub(/ .*$$/, \"\", $$1); print}}'"
    " | cut -f 1,2,4")

reader = (subprocess.Popen(fastq2tab.substitute(file=f), shell=True, stdout=subprocess.PIPE) for f in files)

reader_df = (pd.read_table(read.stdout, names=["seqid", "seq", "qual"], index_col=["seqid"]) for read in reader)

reads = pd.concat(reader_df, axis=1, keys="i1 i2 r1 r2".split())
