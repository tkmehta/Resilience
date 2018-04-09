#include "network.h"

// List of arguments
// 1. number of nodes
// 2. initial degree of the network
// 3. healer nodes degree threshold
// 4. dead nodes degree threshold
// 5. alpha
// 6. verbose

const time_t ctt = time(0);

int main(int argc, char** argv) {

	if (argc != 7) {
		cout << "Please enter the following mandatory parameters:" << endl;
		cout << "1. number of nodes    (int)" << endl;
		cout << "2. initial degree     (int)" << endl;
		cout << "3. healer threshold   (int)" << endl;
		cout << "4. dead threshold     (int)" << endl;
		cout << "5. alpha              (float)" << endl;
		cout << "6. verbose            (0|1)" << endl;
		return 1;
	}

	int numNodes = atoi(argv[1]);
	int initDegree = atoi(argv[2]);
	float healerThres = atof(argv[3]);
	float deadThres = atof(argv[4]);
	float alpha = atof(argv[5]);
	int verbose = atoi(argv[6]);

	clock_t startTime = clock();
	if (verbose == 1) {
		cout << "The simulation parameters have been set to the following values:" << endl;
		cout << "number of nodes   : " << numNodes << endl;
		cout << "initial degree    : " << initDegree << endl;
		cout << "healer threshold  : " << healerThres << endl;
		cout << "dead threshold    : " << deadThres << endl;
		cout << "alpha             : " << alpha << endl;
		cout << "verbose           : " << verbose << endl;

		cout << "Simulation start at " << asctime(localtime(&ctt));
	}

	// Seed random number
	srand(ctt);

	// Initialize and construct network A
	network netA(numNodes);
	
	for (int i = 0; i <= initDegree; i++) {
		for (int j = i+1; j <= initDegree; j++) {
			netA.insertEdge(i, j);
		}
	}

	for (int i = initDegree + 1; i < numNodes; i++) {
		int degConnNodes = 0;
		short* connNodes = new short[i]();
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

	if (verbose == 1) {
		cout << "Finished constructing network A." << endl;
		netA.printNetwork(0, 0, 0);
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
		float probOrder = (float)((int)(rand() / (float)RAND_MAX * 1000)) / 1000;
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
		short* connNodes = new short[i]();
		for (int j = 0; j < initDegree; j++) {
			float probCounter = 0;
			float probAttach = (float)((int)(rand() / (float)RAND_MAX * 1000)) / 1000;
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

	if (verbose == 1) {
		cout << "Finished constructing network B." << endl;
		netB.printNetwork(0, 0, 0);
	}

	// Construct combined network
	network netC(numNodes);

	for (int i = 0; i < numNodes; i++) {
		int* edgesA = netA.getEdges(i);
		int* edgesB = netB.getEdges(i);
		for (int j = 0; j < netA.getDegree(i); j++) {
			netC.insertEdge(i, edgesA[j]); 
		}
		for (int j = 0; j < netB.getDegree(i); j++) {
			netC.insertEdge(i, edgesB[j]); 
		}
	}

	// Print the degree distribution
	int highestDeg = 0;
	for (int i = 0; i < numNodes; i++) {
		highestDeg = max(highestDeg, netC.getDegree(i)/2);
	}

	int* degDist = new int[highestDeg]();
	for (int i = 0; i < numNodes; i++) {
		degDist[(netC.getDegree(i)/2)-1]++;
	}

	cout << numNodes << ",";
	cout << initDegree << ",";
	cout << healerThres << ",";
	cout << deadThres << ",";
	cout << alpha << ",";
	for (int i = 0; i < (highestDeg-1); i++) {
		cout << degDist[i] << ",";
	}
	cout << degDist[highestDeg-1] << endl;

	/*
	int numDeadNodes = 0;
	int* deadNodes = new int[numNodes];
	float** recProbEdges = new float*[numNodes];
	for (int i = 0; i < numNodes; i++) {
		deadNodes[i] = -1;
		recProbEdges[i] = new float[numNodes]();
	}
	for (int i = 0; i < numNodes; i++) {
		if ((netC.getDegree(i) / 2) >= deadThres) {
			netC.killNode(i);
			deadNodes[numDeadNodes] = i;
			numDeadNodes++;
		}
	}

	if (verbose == 1) {
		cout << "Finished constructing combined network." << endl;
		netC.printNetwork(0, 0, 0);
	}
	
	for (int i = 0; i < numNodes; i++) {
		if (((netC.getDegree(i) / 2) >= healerThres) && ((netC.getDegree(i) / 2) < deadThres)) {
			float numer = (netC.getDegree(i) / 2) - (healerThres - 1);
			for (int j = 0; j < numDeadNodes; j++) {
				int spLength = netC.getShortestPathLength(i, deadNodes[j]);
				int* edges = netC.getEdges(deadNodes[j]);
				float denom = netC.getNumDamagedEdges() * spLength;
				for (int k = 0; k < netC.getDegree(deadNodes[j]); k++) {
					recProbEdges[deadNodes[j]][edges[k]] += numer / denom;
				}
			}
		}
	}

	float minRecProb = 999999999;
	float maxRecProb = 0;
	float sumRecProb = 0;
	float numRecProb = 0;
	float avgRecProb = 0;
	for (int i = 0; i < numNodes; i++) {
		for (int j = 0; j < numNodes; j++) {
			if (recProbEdges[i][j] != 0) {
				minRecProb = min(minRecProb, recProbEdges[i][j]);
				maxRecProb = max(maxRecProb, recProbEdges[i][j]);
				sumRecProb += recProbEdges[i][j];
				numRecProb++;
			}
		}
	}
	avgRecProb = sumRecProb / numRecProb;
	
	delete [] deadNodes;
	for (int i = 0; i < numNodes; i++) {
		delete [] recProbEdges[i];
	}
	delete [] recProbEdges;

	clock_t endTime = clock();
	if (verbose == 1) {
		cout << "Minimum Edge Recovery: " << minRecProb << endl;
		cout << "Maximum Edge Recovery: " << maxRecProb << endl;
		cout << "Average Edge Recovery: " << avgRecProb << endl;

		cout << "Simulation end at " << asctime(localtime(&ctt));

		cout << "Total run time is " << float(endTime - startTime) / CLOCKS_PER_SEC << "s." << endl;
		cout << "Finished successfully." << endl;
	} else {
		cout << numNodes << ",";
		cout << initDegree << ",";
		cout << healerThres << ",";
		cout << deadThres << ",";
		cout << alpha << ",";
		cout << minRecProb << "," << maxRecProb << "," << avgRecProb << endl;
	}
	*/
	return 0;
}
