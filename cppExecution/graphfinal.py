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

	avgProb = [0. for a in range(0,ALPHA_RANGE)]

	avgProbRand = [0. for a in range(0,ALPHA_RANGE)]

	count = [0. for a in range(0, ALPHA_RANGE)]

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
		avgProb[index] = avgProb[index] + float(splits[7])

		avgProbRand[index] = avgProbRand[index] + float(splits[10])
		
		count[index] = count[index] + 1

	avgRecoveryTime = avgProb
	avgRecoveryTimeRand = avgProbRand

	for a in range(0, ALPHA_RANGE):
		avgRecoveryTime[a] = count[a]/avgRecoveryTime[a]
		avgRecoveryTimeRand[a] = count[a]/avgRecoveryTimeRand[a]

	print avgRecoveryTime[::-1]

	mp.rc('text', usetex=True)
	mp.rc('font', family='serif')
	
	graph = mp.figure()

	mp.plot(alphaValues, avgRecoveryTime[::-1])
	mp.title("Targetted Failure Recovery", size=15)
	mp.xlabel(r'$\rho$ Value', size=12)
	mp.ylabel('Average Recovery Time', size=12)
	mp.savefig('Plots/avgProbn' + fileName + ' ' + str(datetime.datetime.now()) + '.jpg')
	mp.close()
	
	graph = mp.figure()

	mp.plot(alphaValues, avgRecoveryTimeRand[::-1])
	mp.title("Randomized Failure Recovery", size=15)
	mp.xlabel(r'$\rho$ Value', size=12)
	mp.ylabel('Average Recovery Time', size=12)
	mp.savefig('Plots/avgProbRandn' + fileName + ' ' + str(datetime.datetime.now()) + '.jpg')
	mp.close()

if __name__ == '__main__':
	plotData(sys.argv[1])
