import sys
import math
import time
import datetime
import matplotlib.pyplot as mp

def mean(array):
	return sum(array)/len(array)

def stdev(array):
	avg = mean(array)
	variance = map(lambda x: (x-avg)**2, array)
	return math.sqrt(mean(variance))

def calcMean(dataList):
	meanList = [0]*len(dataList)

	for x in range(0, len(dataList)):
		if len(dataList[x]) == 0:
			meanList[x] = 0
		else:
			meanList[x] = mean(dataList[x])

	return meanList

def calcStdev(dataList):
	stdevList = [0]*len(dataList)

	for x in range(0, len(dataList)):
		if len(dataList[x]) == 0:
			stdevList[x] = 0
		else:
			stdevList[x] = stdev(dataList[x])

	return stdevList

def printInfo(numJobs, mean, stdev):
	print("Node\tNumJobs\tMean\tStdev")
	for i in range(0, len(numJobs)):
		if (numJobs[i] != 0):
			print("%i\t%i\t%i\t%.2f" %(i, numJobs[i], mean[i], stdev[i]))

def plotData(fileName):

	with open(fileName) as fileVar:
		fileContent = fileVar.readlines()

	for line in fileContent:
		splits = line.split(',')
		distn  = [float(i) for i in splits[5:len(splits)-1]]
		if sum(distn) != 9999:
			print(sum(distn))

	'''
	graph = mp.figure()

	mp.boxplot(minProb)
	mp.xlim(xmin=0, xmax=(ALPHA_RANGE+1))
	mp.xticks(list(range(1,ALPHA_RANGE+1)), [str(a) for a in alphaValues])
	mp.title("Recovery Model", size=15)
	mp.xlabel('Alpha Value', size=12)
	mp.ylabel('Minimum Recovery Probability (s)', size=12)
	mp.savefig('Plots/minProb.jpg')
	mp.close()

	graph = mp.figure()

	mp.boxplot(maxProb)
	mp.xlim(xmin=0, xmax=(ALPHA_RANGE+1))
	mp.xticks(list(range(1,ALPHA_RANGE+1)), [str(a) for a in alphaValues])
	mp.title("Recovery Model", size=15)
	mp.xlabel('Alpha Value', size=12)
	mp.ylabel('Maximum Recovery Probability (s)', size=12)
	mp.savefig('Plots/maxProb.jpg')
	mp.close()
	
	graph = mp.figure()

	mp.boxplot(avgProb)
	mp.xlim(xmin=0, xmax=(ALPHA_RANGE+1))
	mp.xticks(list(range(1,ALPHA_RANGE+1)), [str(a) for a in alphaValues])
	mp.title("Recovery Model", size=15)
	mp.xlabel('Alpha Value', size=12)
	mp.ylabel('Average Recovery Probability (s)', size=12)
	mp.savefig('Plots/avgProb.jpg')
	mp.close()
	'''
	
if __name__ == '__main__':
	plotData(sys.argv[1])
