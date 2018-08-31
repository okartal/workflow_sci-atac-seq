rule bwa_mem:
    input:
        reads=["results/{unit}_R1_qc.fastq", "results/{unit}_R2_qc.fastq"]
    output:
        "results/{unit}.sam"
    log:
        "results/logs/bwa_mem/{unit}.log"
    benchmark:
        "results/benchmarks/bwa_mem/{unit}.tsv"
    params:
        index=config['params']['bwa_mem']['index'],
        extra=r"-R '@RG\tID:{unit}\tSM:{unit}'",
        sort=config['params']['bwa_mem']['sort'],               # Can be 'none', 'samtools' or 'picard'.
        sort_order=config['params']['bwa_mem']['sort_order'],   # Can be 'queryname' or 'coordinate'.
        sort_extra=config['params']['bwa_mem']['sort_extra']    # Extra args for samtools/picard.
    threads:
        config['threads']['bwa_mem']
    wrapper:
        "0.27.1/bio/bwa/mem"
