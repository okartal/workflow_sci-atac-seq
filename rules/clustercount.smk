rule clustercount:
    """Count number of clusters by size (=number of read pairs). 
    """
    input: 'results/{unit}_{sample}_barcode-clusters.tsv'
    output: 'results/{unit}_{sample}_barcode-clusters_count.csv'
    shell:
        "cut -f2 {input} | sort -n | uniq -c"
        " | sed -e '1i\\\ncount,size' -e 's/ *//' -e 's/ /,/' "
        " > {output}"