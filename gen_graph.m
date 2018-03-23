function [max_recovery_time,avg_recovery_time,legends] = gen_graph(alpha,node_number,k,fracs,failed_path_weight)
	%failed_path_weight=10;%length of a path after failure
    test_A=0;%if non zero -> only generate A, if zero -> generate both a and b
	adj_A=zeros(node_number,node_number);
    legends.alpha=alpha;
    legends.k=k;
    legends.node_number=node_number;
    legends.fracs=fracs;
    
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
	orders=zeros(1,node_number);
	%rands=rand(1,node_number);
	remaining_nodes=1:node_number;
	%the below parameters are used for finding the order of nodes " \alpha*(1/n_r)+(1-\alpha)*(d/2e) 
	n_r=node_number;
	e=sum(adj_A(:))/2;%total number of edges of network A
	d=sum(adj_A,1);%degree of each node of A
	for i=1:node_number
		probs=(d/(2*e));%probabilities of remaining nodes
        %probs=alpha/n_r+(1-alpha)*(d/(2*e));%probabilities of remaining nodes
		probs=probs/sum(probs);%normalize
        probs = (1 - alpha)*probs + alpha/n_r;
		rand_number=rand(1);%get a random value
		%check where the number lies between the probabilities
		index=0;
		while(rand_number>0)
			index=index+1;
			rand_number=rand_number-probs(index);
		end
		%index shows the chosen number
		orders(i)=remaining_nodes(index);%add to order
		remaining_nodes(index)=[];%remove from remaining nodes
		d(index)=[];
		n_r=n_r-1;
	end
	
	%now we have the order of nodes, we do the same as above, but this timewith a weighted probability
	%we connect the first k nodes
	rands=rand(1,(node_number^2)/2+1);
	for i=2:k%initialize
		adj_B(orders(1),orders(i))=1;
		adj_B(orders(i),orders(1))=1;
	end
	index_rand=1;
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
	% 
	% deg=sort(deg);
	
	%%
	%Failure 
	%Do the following for all of Fracs
	for frac_index=1:length(fracs)
        frac=fracs(frac_index);
		%avg_total_deg = sum(sum(adj_A + adj_B))/(node_number);
		
		deg_total=degA+degB;
        if (test_A)
            deg_total=degA;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
		[nodes_sorted,deg_indexes] = sort(deg_total,'descend');
		max_healer = 15*k;
		high_deg_nodes=nodes_sorted(nodes_sorted>max_healer);
		
		%choose a fraction of high degree nodes randomly
		%failed_indexes_sorted=randsample(length(high_deg_nodes),floor(length(high_deg_nodes)*frac));
		%failed_node_index=deg_indexes(failed_indexes_sorted);%indexes of failed nodes
		failed_node_index=deg_indexes(1:floor(length(high_deg_nodes)));%indexes of failed nodes
		
        %specify healers
        min_healer = 10*k+1;
        
        healer_indexes=find(deg_total >= min_healer & deg_total <= max_healer);
        xhealer = intersect(failed_node_index, healer_indexes);
        healer_indexes= setxor(healer_indexes, xhealer);
		%now we kill them
		
		adj_total=adj_A+adj_B;
        if(test_A)
            adj_total=adj_A;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
		adj_total_failed=adj_total;%failed graph with 0 for failures
		adj_total_path=adj_total;%failed graph with failed_path_weight for failures
		for i=1:length(failed_node_index)
			for j=1:node_number
				%following only works for symmetric adjacency matrix
				if (adj_total(failed_node_index(i), j) ~= 0)
					adj_total_failed(failed_node_index(i),j)=0;
					adj_total_failed(j,failed_node_index(i))=0;
					adj_total_path(failed_node_index(i),j)=failed_path_weight;
					adj_total_path(j,failed_node_index(i))=failed_path_weight;
				end
			end
		end
		
		%get statistics from failed node : giant component size , number of
		%components, 
		%[giant_component,component_list] = calculate_properties(adj_total_failed);
		
		deg_total=sum(adj_total_failed,1);
		
		%%
		%Calculate recovery time
		
		%First find the shortest path between each damaged edge and each high
		%degree node
		%Find damaged edges
		[row, col] = find(adj_total_path == failed_path_weight);
		damaged_edges = [row, col];
		%Find wealthy nodes using avg_degree as threshold
        avg_total_deg=sum(adj_total_failed(:))/(node_number); %not used now. instead using min_healer -1
		%wealthy_nodes = find(sum(adj_total_failed) > avg_total_deg);
        wealthy_nodes = healer_indexes;
        if isempty(wealthy_nodes)
            pp=1
        end
		%Shorest path length between each damaged edge and each wealthy node
		damaged_graph = graph(adj_total_path);
		path_length = zeros(length(damaged_edges), length(wealthy_nodes));
		recovery_probability = zeros(length(damaged_edges), length(wealthy_nodes));
		dist = distances(damaged_graph);%pairwise distances of all nodes in damaged_graph, used for recovery calculation
		for i=1:length(damaged_edges)
			for j=1:length(wealthy_nodes)
				%path_length(i,j) = max( [shortestpath(damaged_graph, damaged_edges(i, 1), wealthy_nodes(j)), shortestpath(damaged_graph, damaged_edges(i, 2), wealthy_nodes(j))]);
				path_length(i,j) = 1+min( dist( damaged_edges(i, 1), wealthy_nodes(j)), dist(damaged_edges(i, 2), wealthy_nodes(j)));
				recovery_probability(i, j) = (deg_total(wealthy_nodes(j)) - min_healer)/(length(damaged_edges)*path_length(i,j));
			end
		end
		
		edge_recovery_prob=sum(recovery_probability, 2);
		min_probability = min(edge_recovery_prob);% sum over columns, some of resources for each damaged node
		avg_prob=mean(edge_recovery_prob);
		avg_recovery_time(frac_index)=1/avg_prob;
		max_recovery_time(frac_index)=1/min_probability;
	end
end

