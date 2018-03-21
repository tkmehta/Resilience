#include "network.h"

// List of arguments
// 1. number of runs
// 2. number of nodes
// 3. k
// 4. alpha
// 5. fracs
// 6. failed path weight

const time_t ctt = time(0);

int main(int argc, char** argv) {

	if (argc != 7) {
		cout << "Please enter the following mandatory parameters:" << endl;
		cout << "1. number of runs     (int)" << endl;
		cout << "2. number of nodes    (int)" << endl;
		cout << "3. k                  (int)" << endl;
		cout << "4. alpha              (float)" << endl;
		cout << "5. fracs              (float)" << endl;
		cout << "6. failed path weight (float)" << endl;
		return 1;
	}

	int numRuns = atoi(argv[1]);
	int numNodes = atoi(argv[2]);
	int k = atoi(argv[3]);
	float alpha = atof(argv[4]);
	float fracs = atof(argv[5]);
	float failedPathWeight = atof(argv[6]);

	cout << "The simulation parameters have been set to the following values:" << endl;
	cout << "number of runs    : " << numRuns << endl;
	cout << "number of nodes   : " << numNodes << endl;
	cout << "k                 : " << k << endl;
	cout << "alpha             : " << alpha << endl;
	cout << "fracs             : " << fracs << endl;
	cout << "failed path weight: " << failedPathWeight << endl;

	clock_t startTime = clock();
	cout << "Simulation start at " << asctime(localtime(&ctt));

	clock_t endTime = clock();
	cout << "Simulation end at " << asctime(localtime(&ctt));

	network networkA(10);
	networkA.insertEdge(0, 2);
	networkA.insertEdge(5, 6);
	networkA.insertEdge(1, 8);
	networkA.insertEdge(5, 2);
	networkA.insertEdge(6, 8);
	networkA.insertEdge(3, 5);
	networkA.insertEdge(8, 2);
	networkA.insertEdge(1, 9);
	networkA.printNetwork(true, true, true);
	networkA.killNode(6);
	networkA.startNode(6);
	networkA.printNetwork(true, true, true);
	
	cout << "Total run time is " << float(endTime - startTime) / CLOCKS_PER_SEC << "s." << endl;
	cout << "Finished successfully." << endl;
	
	return 0;
}
