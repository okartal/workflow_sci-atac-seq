# The main entry point of your workflow.
# After configuring, running snakemake -n in a clone of this repository should successfully execute a dry-run of the workflow.
# To execute the test workflow, run snakemake --directory .test

import pandas as pd
from snakemake.utils import validate, min_version


configfile: 'config.yaml'
# validate(config, schema="schemas/config.schema.yaml")

samples = pd.read_csv(config['samples'], index_col='id')
# validate(samples, schema="schemas/samples.schema.yaml")

units = pd.read_csv(config['units'], index_col='id')
# validate(units, schema="schemas/units.schema.yaml")

sample_unit = pd.read_csv(config['sample-unit'])
# validate(link, schema="schemas/link.schema.yaml")

##### target rules #####

rule all:
    input:
        expand('results/nextseq_{read}1_post-qc.fastq', read=['I', 'R']),
        expand('results/nextseq_{read}2_post-qc.fastq', read=['I', 'R']),
        expand('results/nextseq_{read}_report.{fmt}', read=['I', 'R'], fmt=['json', 'html']),
        'results/nextseq_clusters.tsv',
        'results/nextseq_clustercount.csv'

##### workflow rules #####

# include: "rules/prepare_fastq.smk"
# include: "rules/fastq_filter.smk"i
include: 'rules/fastp_pe.smk'
include: 'rules/starcode.smk'
include: 'rules/clustercount.smk'