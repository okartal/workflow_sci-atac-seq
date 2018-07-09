# Snakemake workflow: single-cell combinatorially indexed ATAC-seq

[![Snakemake](https://img.shields.io/badge/snakemake-≥3.12.0-brightgreen.svg)](https://snakemake.bitbucket.io)
[![Build Status](https://travis-ci.org/snakemake-workflows/workflow_atac-seq.svg?branch=master)](https://travis-ci.org/snakemake-workflows/workflow_atac-seq)

This workflow processes data from combinatorially indexed ATAC-seq libraries.

* QC on insert and index reads
* Processing reads
  * align insert reads to reference genome
  * cluster index reads into consensus sequence groups
* Demultiplex and filter alignment
* cell profiling
  * signal peak extraction
  * nucleosome positioning
  * transcription factor binding
  * cell classification
* population profiling
  * diversity
  * clustering

## Authors

* Önder Kartal (@okartal)

## Usage

### Step 1: Install workflow

If you simply want to use this workflow, download and extract the [latest release](https://github.com/snakemake-workflows/workflow_atac-seq/releases).
If you intend to modify and further develop this workflow, fork this repository. Please consider providing any generally applicable modifications via a pull request.

In any case, if you use this workflow in a paper, don't forget to give credits to the authors by citing the URL of this repository and, if available, its DOI (see above).

### Step 2: Configure workflow

Configure the workflow according to your needs via editing the file `config.yaml`.

### Step 3: Execute workflow

Test your configuration by performing a dry-run via

    snakemake -n

Execute the workflow locally via

    snakemake --cores $N

using `$N` cores or run it in a cluster environment via

    snakemake --cluster qsub --jobs 100

or

    snakemake --drmaa --jobs 100

See the [Snakemake documentation](https://snakemake.readthedocs.io) for further details.

## Testing

Tests cases are in the subfolder `.test`. They should be executed via continuous integration with Travis CI.
