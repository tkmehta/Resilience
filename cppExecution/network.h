#include <ctime>
#include <iostream>
#include <cstdlib>

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
		node* nodes;
	public:
		network(int numN);
		int startNode(int nodeID);
		int insertEdge(int nodeID1, int nodeID2);
		int removeEdge(int nodeID1, int nodeID2);
		int killNode(int nodeID);
		void printNetwork(short printLiveNodes, short printDeadNodes, short printPerNodeStatus);
};
