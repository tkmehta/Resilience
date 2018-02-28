function [deg] = gen_evo_graph(alpha,node_number,k)
%First, create permutations
%Second, generate graph according to permutations
%Create permutations
    local_indices = 1:node_number;
    global_indices = zeros(1, node_number);
%Flip coin with probability 1-alpha for heads. If heads, then add index to
%global list.
    global_head = 1;
    for i = 1: numel(local_indices)
        if bias_coin(1 - alpha) == true
            global_indices(global_head) = local_indices(i);
            global_head = global_head+1;
        end
    end
%Remove global indices from local indices
    local_indices = setdiff(local_indices, global_indices);
    global_indices = global_indices(1:node_number-size(local_indices, 2));

%Permute local indices in each graph
    local_A = local_indices(randperm(size(local_indices, 2)));
    local_B = local_indices(randperm(size(local_indices, 2)));

%Construct graph based on above graph order. 
%Global indices are not permuted, i.e. if index i is in global indices
%then the ith node in both graphs will be node i
%Otherwise, proceed linearly through the local lists. 
    adj_A = zeros(node_number, node_number);
    adj_B = zeros(node_number, node_number);
    
    deg_A = zeros(1,node_number);
    deg_B = zeros(1,node_number);
    
    total_deg_A = 0;
    total_deg_B = 0;
    
    indices_A = zeros(1,k);
    indices_B = zeros(1,k);

    head = 1;
    global_head = 1;
    %Initialize graph
    for t = 1:node_number
        if ~isempty(global_indices) && global_head <= length(global_indices) && global_indices(global_head) == t
            %global stuff
            indices_A(t) = t;
            indices_B(t) = t;
            global_head = global_head+1;
        else
            %local stuff
            indices_A(t) = local_A(head);
            indices_B(t) = local_B(head);
            head = head + 1;
        end
    end
    
    for i = 1:k
        for j = 1:k
            adj_A(indices_A(i), indices_A(j)) = 1;
            adj_B(indices_B(i), indices_B(j)) = 1;
            deg_A(indices_A(i)) = deg_A(indices_A(i)) + 1;
            deg_A(indices_A(j)) = deg_A(indices_A(j)) + 1;
            deg_B(indices_B(i)) = deg_B(indices_B(i)) + 1;
            deg_B(indices_B(j)) = deg_B(indices_B(j)) + 1;
            total_deg_A = total_deg_A + 2;
            total_deg_B = total_deg_B + 2;
        end
    end
    
    %Build graph
    
    
    for t=k+1:node_number
        remaining_indices_A=1:t-1;
        remaining_indices_B=1:t-1;
        for i=1:k   
            func_deg_A = deg_A;
            func_deg_B = deg_B;
            for j=1:length(global_indices)
                func_deg_A(global_indices(j)) = deg_A(global_indices(j)) + deg_B(global_indices(j));
                func_deg_B(global_indices(j)) = deg_A(global_indices(j)) + deg_B(global_indices(j));
            end
            
            prob_A = func_deg_A(indices_A(1:t-1-(i-1))) / sum(func_deg_A(indices_A(1:t-1)));
            prob_B = func_deg_B(indices_B(1:t-1-(i-1))) / sum(func_deg_B(indices_B(1:t-1)));
            
            R_A = randsample(t-1-(i - 1), 1, true, prob_A);
            if adj_A(indices_A(remaining_indices_A(R_A)), indices_A(t)) ~= 1
                adj_A(indices_A(remaining_indices_A(R_A)), indices_A(t)) = 1;
                adj_A(indices_A(t), indices_A(remaining_indices_A(R_A))) = 1;
                deg_A(indices_A(remaining_indices_A(R_A))) = deg_A(indices_A(R_A)) + 1;
                deg_A(indices_A(t)) = deg_A(indices_A(t)) + 1;
                remaining_indices_A(R_A) = [];
            end
            
            R_B = randsample(t-1-(i-1), 1, true, prob_B);
            if adj_B(indices_B(remaining_indices_B(R_B)), indices_B(t)) ~= 1
                adj_B(indices_B(remaining_indices_B(R_B)), indices_B(t)) = 1;
                adj_B(indices_B(t), indices_B(remaining_indices_B(R_B))) = 1;
                deg_B(indices_B(remaining_indices_B(R_B))) = deg_B(indices_B(remaining_indices_B(R_B))) + 1;
                deg_B(indices_B(t)) = deg_B(indices_B(t)) + 1;
                remaining_indices_B(R_B) = [];
            end
        end
    end
    
    deg = histc(deg_A + deg_B, 0:1:1000);
end

function [heads] = bias_coin(p)
    sample = randsample(2, 1, true, [p, 1-p]);
    if sample == 1
        heads = true;
    else
        heads = false;
    end
end