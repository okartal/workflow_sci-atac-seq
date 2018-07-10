rule fastp_pe:
    input:
        lambda wildcards: units.loc[wildcards.unit, [wildcards.read + i for i in '12']]
    output:
        fq1='results/{unit}_{read}1_post-qc.fastq',
        fq2='results/{unit}_{read}2_post-qc.fastq',
        json='results/{unit}_{read}_report.json',
        html='results/{unit}_{read}_report.html'
    params: lambda wildcards: config['params']['fastp'][wildcards.read]
    threads: config['threads']['fastp']
    benchmark: 'results/benchmarks/fastp/{unit}_{read}.tsv'
    shell:
        "fastp --in1 {input[0]} --in2 {input[1]}"
        " --out1 {output.fq1} --out2 {output.fq2}"
        " --json {output.json} --html {output.html}"
        " --thread {threads}"
        " {params}"