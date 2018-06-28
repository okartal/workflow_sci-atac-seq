rule fastp_pe:
    input:
        lambda wildcards: units.loc[wildcards.unit, [wildcards.read + i for i in '12']]
    output:
        fq1='results/{unit}_{sample}_{read}1.filtered.fastq',
        fq2='results/{unit}_{sample}_{read}2.filtered.fastq',
        json='reports/fastp/{unit}_{sample}_{read}.json',
        html='reports/fastp/{unit}_{sample}_{read}.html'
    params:
        lambda wildcards: config['params']['fastp'][wildcards.read] + " -R 'fastp report for samples {}'".format(",".join(link[link.unit == 'nextseq']['sample']))
    threads: config['threads']['fastp']
    benchmark:
        'benchmarks/fastp/{unit}_{sample}_{read}.tsv'
    shell:
        "fastp --in1 {input[0]} --in2 {input[1]}"
        " --out1 {output.fq1} --out2 {output.fq2}"
        " --json {output.json} --html {output.html}"
        " --thread {threads}"
        " {params}"