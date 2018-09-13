#!/usr/bin/env python3
import sys
import itertools as it

import pandas as pd

def generate_barcode(combinations):
    for record in combinations:
        barcode = "".join([i.sequence for i in record])
        yield [i.set_id for i in record] + [barcode]

def to_barcode(itable, arrangement=None):
    arr = arrangement.split('-')
    assert set(arr) == {'i5', 'i7', 'r5', 'r7'}
    index_groups = [itable[itable.type == i].itertuples(index=False) for i in arr]
    combinations = it.product(*index_groups)
    barcodes = generate_barcode(combinations)
    header = [i + 'set' for i in arr] + ['sequence']
    return pd.DataFrame(barcodes, columns=header)

fpath = sys.argv[1]

indextable = pd.read_table(fpath, header=0)

(indextable
 .pipe(to_barcode, arrangement=sys.argv[2])
 .to_csv(sys.stdout, sep='\t', index=False)
)
