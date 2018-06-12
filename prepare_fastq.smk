rule prepare_fastqpe:
    """Get all fragments that are identifiable.

    Note: this uses process substitution and only works in bash apparently.
    """
    input:
        read1 = config["data"]["fastq_pe"]["read1"],
        read2 = config["data"]["fastq_pe"]["read2"],
        index1 = config["data"]["fastq_pe"]["index1"],
        index2 = config["data"]["fastq_pe"]["index2"]
    output:
        ".test/results/fragments.tsv"
    benchmark:
        ".test/benchmarks/prepare_fastqpe/fragments.tsv"
    shell:
        "paste"
        " <(gunzip -c {input.read1} | paste - - - - )"
        " <(gunzip -c {input.read2} | paste - - - - | cut -f2,4 )"
        " <(gunzip -c {input.index1} | paste - - - - | cut -f2,4 )"
        " <(gunzip -c {input.index2} | paste - - - - | cut -f2,4 )"
        " | awk -F'\t' '{{sub(/ .*$/, \"\", $1); print}}'"
        " > {output}"