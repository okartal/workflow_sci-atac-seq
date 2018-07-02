rule starcode:
    """Clustering read pairs by alignment and Levenshtein distance. 
    """
    input:
        fq1='results/{unit}_{sample}_I1.filtered.fastq',
        fq2='results/{unit}_{sample}_I2.filtered.fastq'
    output: 'results/{unit}_{sample}_barcode-clusters.tsv'
    log: 'logs/starcode/{unit}_{sample}_barcode-clusters.log'
    params: config['params']['starcode']
    threads: config['threads']['starcode']
    shell:
        "starcode {params} -t {threads} -1 {input.fq1} -2 {input.fq2}"
        " > {output} 2> {log}"