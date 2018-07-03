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

link = pd.read_csv(config['link'])
# validate(link, schema="schemas/link.schema.yaml")

##### target rules #####

rule all_results:
    input:
        expand('results/nextseq_multiplex_{read}{number}.post-qc.fastq',
            read=['I', 'R'], number=[1, 2]),
        'results/nextseq_multiplex_barcode-clusters.tsv',
        'results/nextseq_multiplex_barcode-clusters_count.csv'
        
rule all_reports:
    input:
        expand('reports/fastp/nextseq_multiplex_{read}.{file}',
            read=['I', 'R'], file=['html', 'json'])

##### workflow rules #####

# include: "rules/prepare_fastq.smk"
# include: "rules/fastq_filter.smk"i
include: 'rules/fastp_pe.smk'
include: 'rules/starcode.smk'
include: 'rules/clustercount.smk'