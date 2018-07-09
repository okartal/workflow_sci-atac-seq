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
