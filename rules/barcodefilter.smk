rule barcodefilter:
    """Assign fragment IDs to filtered clusters.

    This rule produces a table that associates each sequenced template with a cluster.
    """
    input:
        clusters='results/{unit}_{sample}_barcode-clusters.tsv',
        index='results/{unit}_{sample}_I1.post-qc.fastq'
    output:
    params: config['params']['barcodefilter']
    shell:
