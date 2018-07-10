rule starcode:
    """Clustering read pairs by alignment and Levenshtein distance.

    The edit distance parameter applies to the pair, not to each mate
    separately. For example -d4 means that the sum of edits in both mates has to
    be lower than 4 to group two pairs of sequences together.
    """
    input:
        fq1='results/{unit}_I1_post-qc.fastq',
        fq2='results/{unit}_I2_post-qc.fastq'
    output: 'results/{unit}_clusters.tsv'
    params: config['params']['starcode']
    threads: config['threads']['starcode']
    log: 'results/logs/starcode/{unit}_clusters.log'
    benchmark: 'results/benchmarks/starcode/{unit}_clusters.tsv'
    shell:
        "starcode {params} -t {threads} -1 {input.fq1} -2 {input.fq2}"
        " > {output} 2> {log}"