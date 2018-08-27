rule fastp_pe:
    input:
        lambda wildcards: units.loc[wildcards.unit, [wildcards.read + i for i in '12']]
    output:
        fq1="results/{unit}_{read}1_qc.fastq",
        fq2="results/{unit}_{read}2_qc.fastq",
        json="results/{unit}_{read}_qc-report.json",
        html="results/{unit}_{read}_qc-report.html"
    params:
        lambda wildcards: config['params']['fastp_pe'][wildcards.read]
    threads:
        config['threads']['fastp_pe']
    benchmark:
        "results/benchmarks/fastp_pe/{unit}_{read}.tsv"
    log:
        "results/logs/fastp_pe/{unit}_{read}.log"
    conda:
        "../envs/sci-atac.yaml"
    shell:
        "fastp --in1 {input[0]} --in2 {input[1]}"
        " --out1 {output.fq1} --out2 {output.fq2}"
        " --json {output.json} --html {output.html}"
        " --thread {threads}"
        " {params}"
        " 2> {log}"