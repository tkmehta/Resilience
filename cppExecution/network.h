#include <list>
#include <ctime>
#include <iostream>
#include <cstdlib>
#include <vector>
#include <numeric>
#include <algorithm>

using namespace std;

/*
class edge {
	private:
		int node1;
		int node2;
	public:
		edge(int nd1, int nd2);
};
*/

class node {
	private:
		short live;
		int degree;
		int* edges;
	public:
		node();
		~node();
		short isLive();
		int getDegree();
		int* getEdges();
		int startNode();
		int insertEdge(int nodeID);
		int removeEdge(int nodeID);
		int killNode();
		void printNode(int nodeID);
};

class network {
	private:
		int numNodes;
		int liveNodes;
		int numEdges;
		int numDamagedEdges;
		node* nodes;
	public:
		network(int numN);
		~network();
		short isLive(int nodeID);
		int getNumEdges();
		int getNumDamagedEdges();
		int getDegree(int nodeID);
		int* getEdges(int nodeID);
		int startNode(int nodeID);
		int insertEdge(int nodeID1, int nodeID2);
		int removeEdge(int nodeID1, int nodeID2);
		int getShortestPathLength(int nodeID1, int nodeID2);
		int killNode(int nodeID);
		void printNetwork(short printLiveNodes, short printDeadNodes, short printPerNodeStatus);
};
