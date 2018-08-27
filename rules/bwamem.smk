rule bwa_mem:
    input:
        reads=["results/{unit}_{read}1_post-qc.fastq", "results/{unit}_{read}1_post-qc.fastq"]
    output:
        "{unit}.bam"
    log:
        "results/logs/bwa_mem/{sample}.log"
    params:
        index="genome",
        extra=r"-R '@RG\tID:{unit}\tSM:{unit}'",
        sort="none",             # Can be 'none', 'samtools' or 'picard'.
        sort_order="queryname",  # Can be 'queryname' or 'coordinate'.
        sort_extra=""            # Extra args for samtools/picard.
    threads:
        config['threads']['bwa mem']
    wrapper:
        "0.27.1/bio/bwa/mem"
