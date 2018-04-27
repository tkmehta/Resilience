from itertools import izip_longest

tenk = True 
dists = {}
count = {}
if tenk:
    filename = "finalout10k67.dat"
    num_nodes = 10000.0
else:
    filename = "out1k.dat"
    num_nodes = 1000.0
deviation = {}
dostandev = False
k = 0
for i in range(0, 11):
    dists[i/10.0] = []
    deviation[i/10.0] = []
    count[i/10.0] = 0 
with open(filename, 'r') as fin:
    index = 0
    for s in fin:
        s_split = s.split(',')
        if len(s_split) > 0:
            dist = map(float, s_split[11:])
            k = int(s_split[1])
            index += 1
            try:
                #dist[-1] = num_nodes - sum(dist[0:-2])
                dist = [x / num_nodes for x in dist]
                assert dist[-1] > 0
            except AssertionError:
                print "Last value: ", dist[-1]
                print "Index: ", index
                print "Filename: ", filename
                print dist[8]
                raise AssertionError
            try:
                for i in range(0, 2*k - 1):
                    assert dist[i] == 0
            except AssertionError:
                print "Non-zero number of nodes with degree less than 2k"
                print "Index: ", index
            try:
                assert sum(dist) >= .99 and sum(dist) <=1.01 
            except AssertionError:
                print "Distribution Sum: ", sum(dist)
                print "Alpha: ", float(s_split[4])
                print "Index: ", index
                raise AssertionError
            alpha = float(s_split[4])
            dists[alpha] = [x + y for x,y in izip_longest(dist, dists[alpha], fillvalue=0)] 
            count[alpha] = count[alpha] + 1
for i in range(0, 11):
    dists[i/10.0] = [x/count[i/10.0] for x in dists[i/10.0]]
print "AVERAGE DEGREE DISTRIBUTION"
print "AVERAGE DEGREE DISTRIBUTION"
print "AVERAGE DEGREE DISTRIBUTION"
print "AVERAGE DEGREE DISTRIBUTION"
print "AVERAGE DEGREE DISTRIBUTION"
print "AVERAGE DEGREE DISTRIBUTION"
for i in [0, 8, 9, 10]:
    print "alpha: ",
    print i/10.0
    print dists[i/10.0]
if dostandev:
    with open(filename, 'r') as fin:
        for s in fin:
            s_split = s.split(',')
            if len(s_split) > 0:
                dist = map(float, s_split[11:])
                dist[-1] = num_nodes - sum(dist[0:-2])
                dist = [x / num_nodes for x in dist]
                alpha = float(s_split[4])
                deviation[alpha] = [y+(x - z)**2 for x,y,z in izip_longest(dist, deviation[alpha], dists[alpha], fillvalue=0)] 
    print "STANDARD DEVIATION OF DEGREE DISTRIUBTION"
    print "STANDARD DEVIATION OF DEGREE DISTRIUBTION"
    print "STANDARD DEVIATION OF DEGREE DISTRIUBTION"
    print "STANDARD DEVIATION OF DEGREE DISTRIUBTION"
    print "STANDARD DEVIATION OF DEGREE DISTRIUBTION"
    print "STANDARD DEVIATION OF DEGREE DISTRIUBTION"
    for i in range(0, 11):
        deviation[i/10.0] = [x/count[i/10.0] for x in deviation[i/10.0]]
        deviation[i/10.0] = [x**(1/2.0) for x in deviation[i/10.0]]
        print "alpha: ", i/10.0
        print "alpha: ", i/10.0
        print "alpha: ", i/10.0
        print "alpha: ", i/10.0
        print deviation[i/10.0]
