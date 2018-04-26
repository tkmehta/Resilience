from itertools import izip_longest

tenk = True 
dists = {}
count = {}
if tenk:
    filename = "out10k.dat"
    num_nodes = 10000.0
else:
    filename = "out1k.dat"
    num_nodes = 1000.0

best_range = {}
pen_range = {}
for i in range(0, 11):
    best_range[i/10.0] = []
    pen_range[i/10.0] = []

with open(filename, 'r') as fin:
    index = 0
    for s in fin:
        s_split = s.split(',')
