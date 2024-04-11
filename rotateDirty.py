import re
import sys

if len(sys.argv) != 2:
    print("Usage: python script.py input_file")
    sys.exit(1)

input_file = sys.argv[1]

with open(input_file, 'r') as file:
    for line in file:
        if not re.match(r'^(ATOM|HETATM)', line):
            print(line, end='')
            continue

        tmp = list(line)

        newZ = tmp[38:46]
        newY = tmp[46:54]

        c = ''.join(newZ)
        if '-' not in c:
            c = re.sub(r'\s([0-9])', r'-\1', c)
        else:
            c = re.sub(r'-([0-9])', r' \1', c)
        newZ = list(c)

        for i in range(8):
            tmp[38 + i] = newY[i]
            tmp[46 + i] = newZ[i]

        print(''.join(tmp), end='')
