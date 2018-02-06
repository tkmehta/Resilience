// resilience_graph.cpp 
//Parameter and Function Definition is the same as 


#include <iostream>
#include <cstdlib>
using namespace std;

//variables used in simulation
struct alpha {
double alpha_start;
double alpha_end;
double alpha_step;
};
int kk=5;
int node_number=1000;
int number_of_runs=200;
double fracs=0.9;
int failed_path_weight=60;

// struct used to return results of function
struct graph_result {
    double max_recovery_time;
    int avg_recovery_time;
};

//function for generating the graphs, failing them, and recovery model
graph_result gen_graph (alpha alpha_input,int node_number,int kk,double fracs,int failed_path_weight);


int main()
{	
	struct alpha alpha_input;
	alpha_input.alpha_start=0;
	alpha_input.alpha_end=1;
	alpha_input.alpha_step=0.025;
	
	struct graph_result graph_out;

	graph_out=gen_graph (alpha_input, node_number, kk, fracs, failed_path_weight);
	cout<<"done"<<"\n";
	int a;
	cin>>a;

	return 0;
}





graph_result gen_graph (alpha alpha_input,int node_number,int kk,double fracs,int failed_path_weight)
{
	//variables used in function
	int *target_degree=new int [node_number];
	int total_degree=0;
	int *prob=new int [node_number];
	int temp;
	int i,j,k;
	//generate adj_A and adj_B
	int **adj_A=new int*[node_number];
	int **adj_B=new int*[node_number];
	for ( i=0;i<node_number;i++)
	{
		adj_A[i]=new int [node_number];
		adj_B[i]=new int [node_number];
	}

	//make all zero
	for ( i=0;i<node_number;i++)
		for( j=0;j<node_number;j++)
		{
			adj_A[i][j]=0;
			adj_B[i][j]=0;
		}
			
	//now we generate graph A
	//at the beginning, first K nodes are connected to first node
	for ( i=1;i<kk;i++)
	{
		adj_A[1][i]=1;
		adj_A[i][1]=1;
	}

	//generate A
	for ( i=kk;i<node_number;i++)
	{
		//initialize target degree and total degree
		for ( j=0;j<node_number;j++)
		{
			temp=0;
			for( k=0;k<node_number;k++)
			{
				temp=temp+adj_A[k][1];
			}
			target_degree[j]=temp;
			total_degree=total_degree+target_degree[j];
		}
		//initialize prob
		for ( j=0;j<node_number;j++)
			prob[j]=target_degree[j]/total_degree;

		//we have to choose k nodes from previous nodes with probability relative to prob

	}






	graph_result out;
	out.avg_recovery_time=0;
	out.max_recovery_time=0;



	return out;
}