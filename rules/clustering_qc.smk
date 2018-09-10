rule clustering_qc:
    input:
        "results/{unit}_I_clusters.tsv"
    output:
        "results/{unit}_I_clusters_qc.tsv"
    params:
        config['params']['clustering']['qc min reads']
    benchmark:
        "results/benchmarks/clustering_qc/{unit}_I_clusters_qc.tsv"
    shell:
        "awk '{{OFS=\"\t\"}} {{ if($1~/N/ || $2<{params}) next; gsub(\"/\",\"\",$1); print }}' {input}"
        " > {output}"