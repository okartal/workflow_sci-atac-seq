rule cellbarcode:
    input:
        "data/indextable.tsv"
    output:
        "results/cellbarcodes.tsv"
    params:
        config['params']['cellbarcode']
    conda:
        "../envs/pandas.yaml"
    shell:
        "./../scripts/cellbarcode.py {input} {params} > {output}"
