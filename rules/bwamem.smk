rule bwa_mem:
    input:
        reads=["results/{unit}_R1_qc.fastq", "results/{unit}_R2_qc.fastq"]
    output:
        "results/{unit}.bam"
    log:
        "results/logs/bwa_mem/{unit}.log"
    params:
        index=config['params']['bwa']['index'],
        extra=r"-R '@RG\tID:{unit}\tSM:{unit}'",
        sort="none",             # Can be 'none', 'samtools' or 'picard'.
        sort_order="queryname",  # Can be 'queryname' or 'coordinate'.
        sort_extra=""            # Extra args for samtools/picard.
    threads:
        config['threads']['bwa_mem']
    wrapper:
        "0.27.1/bio/bwa/mem"
