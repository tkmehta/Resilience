function [hist] = gen_PA_graph(node_number,k)
	%failed_path_weight=10;%length of a path after failure
	adj_A=zeros(node_number,node_number);
    
	%Build seed graph as a clique with k+1 nodes each with degree k
	%for i=1:k+1%initialize
    %    for j = 1:k+1
    %        if (i ~=j)
    %            adj_A(i,j)=1;
    %            adj_A(j,i)=1;
    %        end
    %    end
    %end
    
    adj_A(1, 1)=k;
    
    target_degree=sum(adj_A,1);%calculate once in the beginning and update every time, for speed up
    total_degree=sum(target_degree);% some speed up, bottlenecks found after profiling
	for i=2:node_number
	%     target_degree=sum(adj_A,1);
	%     total_degree=sum(adj_A(:));
	%     prob=target_degree/total_degree;
% 		target_degree=sum(adj_A,1);
% 		total_degree=sum(target_degree);% some speed up, bottlenecks found after profiling
        %total_degree=sum(adj_A(:));
		prob=target_degree/total_degree;
		prob=prob(1:i);
        
  		remaining_indexes=1:i;
		for j=0:k-1% we look at each previous node
			R = randsample(i,1,true,prob);%choose a node from present nodes
			adj_A(i,remaining_indexes(R)) = adj_A(i,remaining_indexes(R)) + 1;
			adj_A(remaining_indexes(R),i)= adj_A(remaining_indexes(R),i) + 1;
            target_degree(i)=target_degree(i)+1;
            target_degree(remaining_indexes(R))=target_degree(remaining_indexes(R))+1;
            total_degree=total_degree+2;
            prob = target_degree/total_degree;
            prob = prob(1:i);
		end
	
	end
	
	degA=sum(adj_A,1);
    %hist = histcounts(degA, 0:5000);
    
    spec = zeros(1, 1000);
    for i=1:1000
        a = (2*i-1);
        b = 2*i;
        spec(1, i) = sum(degA(1, a:b));
    end
    hist = histcounts(spec, 0:5000);
end

