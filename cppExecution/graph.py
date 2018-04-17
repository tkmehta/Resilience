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

	ALPHA_RANGE=11
	alphaValues = [(a * 0.1) for a in range(0,ALPHA_RANGE)]

	minProb = [[] for a in range(0,ALPHA_RANGE)]
	maxProb = [[] for a in range(0,ALPHA_RANGE)]
	avgProb = [[] for a in range(0,ALPHA_RANGE)]

	minProbRand = [[] for a in range(0,ALPHA_RANGE)]
	maxProbRand = [[] for a in range(0,ALPHA_RANGE)]
	avgProbRand = [[] for a in range(0,ALPHA_RANGE)]

	with open(fileName) as fileVar:
		fileContent = fileVar.readlines()

	for line in fileContent:
		splits = line.split(',')
		alpha = float(splits[4])
		index = 0
		for a in range(0,ALPHA_RANGE):
			if str(alphaValues[a]) == str(alpha):
				index = a
				break
		minProb[index].append(1/float(splits[5]))
		maxProb[index].append(1/float(splits[6]))
		avgProb[index].append(1/float(splits[7]))

		minProbRand[index].append(1/float(splits[8]))
		maxProbRand[index].append(1/float(splits[9]))
		avgProbRand[index].append(1/float(splits[10]))

	graph = mp.figure()

	mp.boxplot(minProb)
	mp.xlim(xmin=0, xmax=(ALPHA_RANGE+1))
	mp.xticks(list(range(1,ALPHA_RANGE+1)), [str(a) for a in alphaValues])
	mp.title("Recovery Model", size=15)
	mp.xlabel('Alpha Value', size=12)
	mp.ylabel('Minimum Recovery Probability (s)', size=12)
	mp.savefig('Plots/minProbn1kd413.jpg')
	mp.close()

	graph = mp.figure()

	mp.boxplot(maxProb)
	mp.xlim(xmin=0, xmax=(ALPHA_RANGE+1))
	mp.xticks(list(range(1,ALPHA_RANGE+1)), [str(a) for a in alphaValues])
	mp.title("Recovery Model", size=15)
	mp.xlabel('Alpha Value', size=12)
	mp.ylabel('Maximum Recovery Probability (s)', size=12)
	mp.savefig('Plots/maxProbn1kd413.jpg')
	mp.close()
	
	graph = mp.figure()

	mp.boxplot(avgProb, notch=True)
	mp.xlim(xmin=0, xmax=(ALPHA_RANGE+1))
	mp.xticks(list(range(1,ALPHA_RANGE+1)), [str(a) for a in alphaValues])
	mp.title("Recovery Model", size=15)
	mp.xlabel('Alpha Value', size=12)
	mp.ylabel('Average Recovery Probability (s)', size=12)
	mp.savefig('Plots/avgProbn1kd413.jpg')
	mp.close()
	
	graph = mp.figure()

	mp.boxplot(minProbRand)
	mp.xlim(xmin=0, xmax=(ALPHA_RANGE+1))
	mp.xticks(list(range(1,ALPHA_RANGE+1)), [str(a) for a in alphaValues])
	mp.title("Recovery Model", size=15)
	mp.xlabel('Alpha Value', size=12)
	mp.ylabel('Minimum Recovery Probability (s)', size=12)
	mp.savefig('Plots/minProbRandn1kd413.jpg')
	mp.close()

	graph = mp.figure()

	mp.boxplot(maxProbRand)
	mp.xlim(xmin=0, xmax=(ALPHA_RANGE+1))
	mp.xticks(list(range(1,ALPHA_RANGE+1)), [str(a) for a in alphaValues])
	mp.title("Recovery Model", size=15)
	mp.xlabel('Alpha Value', size=12)
	mp.ylabel('Maximum Recovery Probability (s)', size=12)
	mp.savefig('Plots/maxProbRandn1kd413.jpg')
	mp.close()
	
	graph = mp.figure()

	mp.boxplot(avgProbRand)
	mp.xlim(xmin=0, xmax=(ALPHA_RANGE+1))
	mp.xticks(list(range(1,ALPHA_RANGE+1)), [str(a) for a in alphaValues])
	mp.title("Recovery Model", size=15)
	mp.xlabel('Alpha Value', size=12)
	mp.ylabel('Average Recovery Probability (s)', size=12)
	mp.savefig('Plots/avgProbRandn1kd413.jpg')
	mp.close()

if __name__ == '__main__':
	plotData(sys.argv[1])
