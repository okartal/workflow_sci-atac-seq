
def get_fastq(wildcards):
    """Get paths of fastq files for each sequencing unit.
    """    
    return units.loc[wildcards.unit, [wildcards.read + i for i in '12']]

def is_multiplexed(unit):
    """Test if sequencing units contain multiplexed samples.
    """
    return None

def is_barcoded(unit):
    """Test if reads are barcoded.

    The test assumes that reads in the fastq files are already tagged with a
    barcode combination (aka they are 'debarcoded/demultiplexed') if no index
    reads are given in the sequencing units table.
    """
    return None