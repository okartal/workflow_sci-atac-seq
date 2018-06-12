# The main entry point of your workflow.
# After configuring, running snakemake -n in a clone of this repository should successfully execute a dry-run of the workflow.


configfile: ".test/config.yaml"


rule all:
    input:
        ".test/results/fragments.tsv"
        # The first rule should define the default target files
        # Subsequent target rules can be specified below. They should start with all_*.


include: "rules/prepare_fastq.smk"
