#include "network.h"

/*
edge::edge(int nd1, int nd2) {	node1 = nd1;
	node1 = nd1;
	node2 = nd2;
}
*/

node::node() {
	startNode();
}

int node::startNode() {
	if (live == 1) {
		return 1;
	}
	degree = 0;
	live = 1;
	return 0;
}

short node::isLive() {
	return live;
}

int node::getDegree() {
	return degree;
}

int* node::getEdges() {
	return edges;
}

int node::insertEdge(int nodeID) {
	if (live == 0) {
		return 1;
	}
	if (degree == 0) {
		edges = new int(nodeID);
	} else {
		int* tmpEdges = new int[degree+1];
		for (int i = 0; i < degree; i++) {
			tmpEdges[i] = edges[i];
		}
		tmpEdges[degree] = nodeID;
		delete [] edges;
		edges = tmpEdges;
	}
	degree++;
	return 0;
}

int node::removeEdge(int nodeID) {
	if ((live == 0) || (degree == 0)) {
		return 1;
	}
	int* tmpEdges = new int[degree-1];
	int j = 0;
	for (int i = 0; i < degree; i++) {
		if (edges[i] != nodeID) {
			tmpEdges[j] = edges[i];
			j++;
		}
		if ((j == (degree - 1)) && (i < (degree-1))) {
			return 1;
		}
	}
	delete [] edges;
	edges = tmpEdges;
	degree--;
	return 0;
}

int node::killNode() {
	if (live == 0) {
		return 1;
	}
	if (degree != 0) {
		delete[] edges;
	}
	degree = 0;
	live = 0;
	return 0;
}

void node::printNode(int nodeID) {
	cout << "Node " << nodeID;
	if (live == 0) {
		cout << " (dead)";
	} else {
		cout << " (live)";
		if (degree == 0) {
			cout << ": Deg " << degree << " | No Edges";
		} else {
			cout << ": Deg " << degree << " | Edges ";
			for (int i = 0; i < (degree - 1); i++) {
				cout << edges[i] << ", ";
			}
			cout << edges[degree-1];
		}
	}
	cout << endl;
}

network::network(int numN) {
	numNodes = numN;
	liveNodes = numNodes;
	numEdges = 0;
	nodes = new node[numNodes];
}

int network::getNumEdges() {
	return numEdges;
}

int network::getDegree(int nodeID) {
	return nodes[nodeID].getDegree();
}

int network::startNode(int nodeID) {
	if (nodes[nodeID].startNode() != 0) {
		cout << "ERROR: Unable to start node " << nodeID << "." << endl;
		return 1;
	}
	liveNodes++;
	return 0;
}

int network::insertEdge(int nodeID1, int nodeID2) {
	if (nodes[nodeID1].isLive() == 0) {
		cout << "ERROR: Edge (" << nodeID1 << "," << nodeID2 << ") cannot be inserted because node " << nodeID1 << "is dead." << endl;
		return 1;
	}
	if (nodes[nodeID2].isLive() == 0) {
		cout << "ERROR: Edge (" << nodeID1 << "," << nodeID2 << ") cannot be inserted because node " << nodeID2 << "is dead." << endl;
		return 1;
	}
	if (nodes[nodeID1].insertEdge(nodeID2) != 0) {
		cout << "ERROR: Edge (" << nodeID1 << "," << nodeID2 << ") cannot be inserted." << endl;
		return 1;
	}
	if (nodes[nodeID2].insertEdge(nodeID1) != 0) {
		nodes[nodeID1].removeEdge(nodeID2);
		cout << "ERROR: Edge (" << nodeID1 << "," << nodeID2 << ") cannot be inserted." << endl;
		return 1;
	}
	numEdges++;
	return 0;
}

int network::removeEdge(int nodeID1, int nodeID2) {
	if (nodes[nodeID1].removeEdge(nodeID2) != 0) {
		cout << "ERROR: Edge (" << nodeID1 << "," << nodeID2 << ") cannot be removed." << endl;
		return 1;
	}
	if (nodes[nodeID2].removeEdge(nodeID1) != 0) {
		nodes[nodeID1].insertEdge(nodeID2);
		cout << "ERROR: Edge (" << nodeID1 << "," << nodeID2 << ") cannot be removed." << endl;
		return 1;
	}
	numEdges--;
	return 0;
}

int network::killNode(int nodeID) {
	if (nodes[nodeID].isLive() == 0) {
		return 1;
	}
	int nodeDegree = nodes[nodeID].getDegree();
	if (nodeDegree != 0) {
		int* nodeEdges = nodes[nodeID].getEdges();
		for (int i = 0; i < nodeDegree; i++) {
			if (nodes[nodeEdges[i]].removeEdge(nodeID) != 0) {
				for (int j = 0; j < i; j++) {
					nodes[nodeEdges[j]].insertEdge(nodeID);
				}
				cout << "ERROR: Unable to kill node " << nodeID << "." << endl;
				return 1;
			}
		}
	}
	if (nodes[nodeID].killNode() != 0) {
		cout << "ERROR: Unable to kill node " << nodeID << "." << endl;
		return 1;
	}
	liveNodes--;
	numEdges -= nodeDegree;
	return 0;
}

void network::printNetwork(short printLiveNodes, short printDeadNodes, short printPerNodeStatus) {
	cout << "**********************************************************" << endl;
	cout << "Following is the status of the network: " << endl;
	cout << "Number of Nodes     : " << numNodes << endl;
	cout << "Number of Live Nodes: " << liveNodes << endl;
	cout << "Number of Dead Nodes: " << (numNodes - liveNodes) << endl;
	cout << "Number of Edges     : " << numEdges << endl;
	if (printLiveNodes == 1) {
		cout << endl << "List of live nodes: ";
		for (int i = 0; i < numNodes; i++) {
			if (nodes[i].isLive() == 1) {
				cout << i << ", ";
			}
		}
		cout << "done." << endl;
	}
	if (printDeadNodes == 1) {
		cout << endl << "List of dead nodes: ";
		for (int i = 0; i < numNodes; i++) {
			if (nodes[i].isLive() == 0) {
				cout << i << ", ";
			}
		}
		cout << "done." << endl;
	}
	if (printPerNodeStatus == 1) {
		cout << endl << "Status of each node is as following: " << endl;
		for (int i = 0; i < numNodes; i++) {
			nodes[i].printNode(i);
		}
	}
	cout << "**********************************************************" << endl;
}

