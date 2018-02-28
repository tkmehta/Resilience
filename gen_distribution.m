%run for different values and generate output


%variables
%alpha=0:0.1:1;
alpha=0:.5:1;
k=8; 
node_number=1000;
number_of_runs=1000;
fracs=0.05;
failed_path_weight=100;

deg_count = zeros(length(alpha), 1001);
tic
    for i=1:length(alpha)
        fprintf('alpha is %f',alpha(i));
    
        for m=1:number_of_runs
           [alpha(i), m]
           	deg_count(i, :) = deg_count(i, :) + gen_evo_graph(alpha(i),node_number,k);
        end
            deg_count(i, :) = deg_count(i, :)/number_of_runs;
    end


%plot(alpha,max_recovery_time)g
%hold
total_time=toc;
%bar(deg_count);