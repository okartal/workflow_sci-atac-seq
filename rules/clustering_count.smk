rule clustering_count:
    """Count number of clusters by size (=number of read pairs). 
    """
    input:
        "results/{unit}_I_clusters_qc.tsv"
    output:
        "results/{unit}_I_clusters_count.csv"
    benchmark:
        "results/benchmarks/clustering_count/{unit}_I_clusters_count.tsv"
    shell:
        "cut -f2 {input} | sort -n | uniq -c"
        " | sed -e '1i\\\ncount,size' -e 's/ *//' -e 's/ /,/' "
        " > {output}"