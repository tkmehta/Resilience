function [histexact] = gen_coev_exact(alpha, node_number,k)
	%failed_path_weight=10;%length of a path after failure
	adj_A=zeros(node_number,node_number);
    
	%Build seed graph as a clique with k+1 nodes each with degree k
	for i=1:k+1%initialize
        for j = 1:k+1
            if (i ~=j)
                adj_A(i,j)=1;
                adj_A(j,i)=1;
            end
        end
    end
    target_degree=sum(adj_A,1);%calculate once in the beginning and update every time, for speed up
    total_degree=sum(target_degree);% some speed up, bottlenecks found after profiling
	for i=k+1:node_number
	%     target_degree=sum(adj_A,1);
	%     total_degree=sum(adj_A(:));
	%     prob=target_degree/total_degree;
% 		target_degree=sum(adj_A,1);
% 		total_degree=sum(target_degree);% some speed up, bottlenecks found after profiling
        %total_degree=sum(adj_A(:));
		prob=target_degree/total_degree;
		prob=prob(1:i-1);
		remaining_indexes=1:i-1;
		for j=0:k-1% we look at each previous node
			R = randsample(i-1-j,1,true,prob);%choose a node from present nodes
			adj_A(i,remaining_indexes(R))=1;
			adj_A(remaining_indexes(R),i)=1;
            target_degree(i)=target_degree(i)+1;
            target_degree(remaining_indexes(R))=target_degree(remaining_indexes(R))+1;
            total_degree=total_degree+2;
			prob(R)=[];
			remaining_indexes(R)=[];
		end
	
	end
	
	degA=sum(adj_A,1);
	
	
	
	%%
	% preferential graph B
	
	adj_B=zeros(node_number,node_number);
	%first we have to choose the order of nodes for connecting new graphs
	%we generate node_number random number, 
	orders=1:node_number;
	
	%now we have the order of nodes, we do the same as above, but this timewith a weighted probability
	%we connect the first k nodes
	 for i=1:k+1%initialize
        for j = 1:k+1
            if (i ~=j)
                adj_B(orders(i),orders(j))=1;
                adj_B(orders(j),orders(i))=1;
            end
        end
    end
    %do these calculations once outside the for loop, and update each value
    %inside the loop once to improve speed
    dl=sum(adj_B,1);%local degree of each node (in Network B)
	dg=sum(adj_A,1)+dl;%degree of each node globally (in Network A and B)
	dl_total=sum(adj_B(:));%total sum of degrees (in Network B)
	dg_total=sum(adj_A(:))+dl_total;%global degree across both networks
    for i=k+1:node_number % for each of newly arrived nodes from orders(:)
		prob=alpha*dl/dl_total+(1-alpha)*dg/dg_total;   
		prob=prob(orders(1:i-1));
		remaining_indexes=1:i-1;
		for j=0:k-1% we look at k previous node
			R = randsample(i-1-j,1,true,prob);%choose a node from present nodes
			adj_B(orders(i),orders(remaining_indexes(R)))=1;
			adj_B(orders(remaining_indexes(R)),orders(i))=1;
            dl(orders(i))=dl(orders(i))+1;%update dl and dg here
            dg(orders(i))=dg(orders(i))+1;
            dl(orders(remaining_indexes(R)))=dl(orders(remaining_indexes(R)))+1;%update dl and dg here
            dg(orders(remaining_indexes(R)))=dg(orders(remaining_indexes(R)))+1;
            dl_total=dl_total+2;%update dg_total and dl_total here
            dg_total=dg_total+2;
			prob(R)=[];
			remaining_indexes(R)=[];
		end
	%     for j=1:i-1% we look at previously arrived nodes
	%         dl=sum(adj_B(:,orders(j)));%local degree of node (in Network B)
	%         dg=sum(adj_A(:,orders(j)))+dl;%degree of node globally (in Network A and B)
	%         dl_total=sum(adj_B(:));%total sum of degrees (in Network B)
	%         dg_total=sum(adj_B(:))+dl_total;%global degree across both networks
	%         prob=alpha*dl/dl_total+(1-alpha)*dg/dg_total;%probability of choosing the specific edge
	%         t=rands(index_rand);%pick a random number
	%         index_rand=index_rand+1;
	%         if(t<=prob)%we generate the edge
	%             adj_B(orders(j),orders(i))=1;
	%             adj_B(orders(i),orders(j))=1;
	%         end
	%     end
	
    end
	degB=sum(adj_B,1);
	
    histexact = histcounts(degA+degB, 0:5000);
end

