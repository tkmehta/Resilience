from itertools import izip_longest

num_nodes = 10000.0
dists = {}
count = {}

deviation = {}
for i in range(0, 11):
    dists[i/10.0] = []
    deviation[i/10.0] = []
    count[i/10.0] = 0 
with open("out10k.dat", 'r') as fin:
    index = 0
    for s in fin:
        s_split = s.split(',')
        if len(s_split) > 0:
            dist = map(float, s_split[5:])
            index += 1
            dist[-1] = num_nodes - sum(dist[0:-2])
            dist = [x / num_nodes for x in dist]
            assert sum(dist) >= .99 
            alpha = float(s_split[4])
            dists[alpha] = [x + y for x,y in izip_longest(dist, dists[alpha], fillvalue=0)] 
            count[alpha] = count[alpha] + 1
for i in range(0, 11):
    dists[i/10.0] = [x/count[i/10.0] for x in dists[i/10.0]]
for i in [0, 8, 9, 10]:
    print "alpha: ",
    print i/10.0
    print dists[i/10.0]

with open("out10k.dat", 'r') as fin:
    for s in fin:
        s_split = s.split(',')
        if len(s_split) > 0:
            dist = map(float, s_split[5:])
            dist[-1] = num_nodes - sum(dist[0:-2])
            dist = [x / num_nodes for x in dist]
            alpha = float(s_split[4])
            deviation[alpha] = [y+(x - z)**2 for x,y,z in izip_longest(dist, deviation[alpha], dists[alpha], fillvalue=0)] 
for i in range(0, 11):
    deviation[i/10.0] = [x/count[i/10.0] for x in deviation[i/10.0]]
    print deviation[i/10.0]
