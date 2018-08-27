# The main entry point of your workflow.
# After configuring, running snakemake -n in a clone of this repository should successfully execute a dry-run of the workflow.
# To execute the test workflow, run snakemake --directory .test

import pandas as pd
from snakemake.utils import validate, min_version


configfile: 'config.yaml'
# validate(config, schema="schemas/config.schema.yaml")

samples = pd.read_csv(config['data']['samples'], index_col='id')
# validate(samples, schema="schemas/samples.schema.yaml")

units = pd.read_csv(config['data']['units'], index_col='id')
# validate(units, schema="schemas/units.schema.yaml")

sample_unit = pd.read_csv(config['data']['sample-unit'])
# validate(link, schema="schemas/link.schema.yaml")

##### target rules #####

rule all:
    input:
        expand('results/{unit}_{read}1_qc.fastq', unit=units.index.values, read=['I', 'R']),
        expand('results/{unit}_{read}2_qc.fastq', unit=units.index.values, read=['I', 'R']),
        expand('results/{unit}_{read}_qc-report.{fmt}', unit=units.index.values, read=['I', 'R'], fmt=['json', 'html']),
        expand('results/{unit}_I_clusters.tsv', unit=units.index.values),
        expand('results/{unit}_I_clusters_qc.tsv', unit=units.index.values),
        expand('results/{unit}_I_clusters_count.csv', unit=units.index.values),
        expand('results/{unit}.bam', unit=units.index.values)


##### workflow rules #####

include: 'rules/fastp_pe.smk'
include: 'rules/starcode.smk'
include: 'rules/clustering_qc.smk'
include: 'rules/clustering_count.smk'
include: 'rules/bwamem.smk'