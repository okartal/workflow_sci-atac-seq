"""Usage: python indextable.py [FILES] > [TABLE]

Produces a table in long format of index sets.

This is just some glue code.
"""

import sys
from pathlib import Path

indexfiles = sys.argv[1:]
skipfirst = True

header = ['type', 'set_id', 'sequence']
print(*header, sep='\t')

for f in indexfiles:
    path = Path(f)
    if path.is_file():
        idxset = path.name.strip(path.suffix).lower().split('_')
        if len(idxset) == 1:
            id = 1
            idxset.append(id)
        else:
            id = int(idxset[1])
            idxset[1] = id
        with path.open() as idxfile:
            if skipfirst:
                idxfile.readline()
            for seq in idxfile:
                print(*idxset, seq.strip(), sep='\t')
    else:
        sys.exit("Files missing!")
