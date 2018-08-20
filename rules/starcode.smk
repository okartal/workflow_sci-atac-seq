rule cluster_reads:
    """Clustering read pairs by alignment and Levenshtein distance.

    The edit distance parameter applies to the pair, not to each mate
    separately. For example -d4 means that the sum of edits in both mates has to
    be lower than 4 to group two pairs of sequences together.
    """
    input:
        fq1="results/{unit}_I1_post-qc.fastq",
        fq2="results/{unit}_I2_post-qc.fastq"
    output:
        "results/{unit}_clusters.tsv"
    params:
        starcode=config['params']['cluster_reads']['starcode'],
        minreads=config['params']['cluster_reads']['min reads per cluster']
    threads:
        config['threads']['starcode']
    benchmark:
        "results/benchmarks/starcode/{unit}_clusters.tsv"
    conda:
        "../envs/sci-atac.yml"
    shell:
        "starcode {params.starcode} -t {threads}"
        " -1 {input.fq1} -2 {input.fq2}"
        " | awk '{{ if($1~/N/ || $2<{params.minreads}) next; print }}'"
        " > {output}"