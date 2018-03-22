#include "network.h"

// List of arguments
// 1. number of nodes
// 2. initial degree of the network
// 3. lower helper nodes degree limit
// 4. upper helper nodes degree limit
// 5. alpha
// 6. failed path weight

const time_t ctt = time(0);

int main(int argc, char** argv) {

	if (argc != 7) {
		cout << "Please enter the following mandatory parameters:" << endl;
		cout << "1. number of nodes    (int)" << endl;
		cout << "2. initial degree     (int)" << endl;
		cout << "3. lower helper limit (int)" << endl;
		cout << "4. upper helper limit (int)" << endl;
		cout << "5. alpha              (float)" << endl;
		cout << "6. failed path weight (float)" << endl;
		return 1;
	}

	int numNodes = atoi(argv[1]);
	int initDegree = atoi(argv[2]);
	float lowerLimit = atof(argv[3]);
	float upperLimit = atof(argv[4]);
	float alpha = atof(argv[5]);
	float failedPathWeight = atof(argv[6]);

	cout << "The simulation parameters have been set to the following values:" << endl;
	cout << "number of nodes   : " << numNodes << endl;
	cout << "initial degree    : " << initDegree << endl;
	cout << "lower helper limit: " << lowerLimit << endl;
	cout << "upper helper limit: " << upperLimit << endl;
	cout << "alpha             : " << alpha << endl;
	cout << "failed path weight: " << failedPathWeight << endl;

	clock_t startTime = clock();
	cout << "Simulation start at " << asctime(localtime(&ctt));

	// Seed random number
	srand(time(0));

	// Initialize and construct network A
	network netA(numNodes);
	
	for (int i = 0; i <= initDegree; i++) {
		for (int j = i+1; j <= initDegree; j++) {
			netA.insertEdge(i, j);
		}
	}

	for (int i = initDegree + 1; i < numNodes; i++) {
		int degConnNodes = 0;
		int* connNodes = new int[i]();
		for (int j = 0; j < initDegree; j++) {
			int degCounter = 0;
			int probAttach = rand() % ((netA.getNumEdges() * 2) - degConnNodes - j) + 1;
			for (int k = 0; k < i; k++) {
				if (connNodes[k] == 0) {
					int nodeDeg = netA.getDegree(k);
					degCounter += nodeDeg;
					if (probAttach <= degCounter) {
						netA.insertEdge(i, k);
						degConnNodes += nodeDeg + 1;
						connNodes[k] = 1;
						break;
					}
				}
			}
		}
		delete [] connNodes;
	}

	// Initialize and construct network B
	network netB(numNodes);

	// Generate the arrival order
	int* arrOrder = new int[numNodes];
	int* arrNodes = new int[numNodes];
	for (int i = 0; i < numNodes; i++) {
		arrOrder[i] = -1;
		arrNodes[i] = -1;
	}
	int numNodesRem = numNodes;
	int degArrivedNodes = 0;
	for (int i = 0; i < numNodes; i++) {
		float probCounter = 0;
		float probOrder = rand() / (float)RAND_MAX;
		for (int j = 0; j < numNodes; j++) {
			if (arrNodes[j] == -1) {
				float nodeProb = ((1-alpha) * netA.getDegree(j) / (float)((netA.getNumEdges()*2) - degArrivedNodes)) + (alpha / numNodesRem);
				probCounter += nodeProb;
				if (probOrder <= probCounter) {
					arrOrder[i] = j;
					arrNodes[j] = i;
					degArrivedNodes += netA.getDegree(j);
					numNodesRem--;
					break;
				}
			}
		}
	}
	
	// Initialize the graphi
	int degArrA = 0;
	for (int i = 0; i <= initDegree; i++) {
		for (int j = i+1; j <= initDegree; j++) {
			netB.insertEdge(arrOrder[i], arrOrder[j]);
		}
		degArrA += netA.getDegree(arrOrder[i]);
	}

	// Construct the remaining network
	for (int i = initDegree + 1; i < numNodes; i++) {
		int degConnNodesA = 0;
		int degConnNodesB = 0;
		int* connNodes = new int[i]();
		for (int j = 0; j < initDegree; j++) {
			float probCounter = 0;
			float probAttach = rand() / (float)RAND_MAX;
			for (int k = 0; k < i; k++) {
				if (connNodes[k] == 0) {
					int l = arrOrder[k];
					float degA = degArrA - degConnNodesA;
					float degB = (netB.getNumEdges() * 2) - degConnNodesB - j;
					float local = netB.getDegree(l) / degB;
					float global = (netA.getDegree(l) + netB.getDegree(l)) / (degA + degB);
					float nodeProb = ((1 - alpha) * global) + (alpha * local);
					probCounter += nodeProb;
					if (probAttach <= probCounter) {
						netB.insertEdge(arrOrder[i], l);
						degConnNodesA += netA.getDegree(l);
						degConnNodesB += netB.getDegree(l);
						connNodes[k] = 1;
						break;
					}
				}
			}
		}
		delete [] connNodes;
		degArrA += netA.getDegree(arrOrder[i]);
	}
	
	delete [] arrOrder;
	delete [] arrNodes;

	netA.printNetwork(0, 0, 0);
	netB.printNetwork(0, 0, 0);
	clock_t endTime = clock();
	cout << "Simulation end at " << asctime(localtime(&ctt));

	cout << "Total run time is " << float(endTime - startTime) / CLOCKS_PER_SEC << "s." << endl;
	cout << "Finished successfully." << endl;
	
	return 0;
}
