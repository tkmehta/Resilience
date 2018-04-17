%run for different values and generate output
clear
clc
p = parallel.defaultClusterProfile;
numprocs = feature ('numcores'); % maximum is number of physical cores
poolobj=parpool(p,numprocs);%generate a parallel pool

%variables
%alpha=0:0.1:1;
alpha=0:1:1;
k=1; 
node_number=1000;
number_of_runs=100;
fracs=0.05;
failed_path_weight=100;

deg_count = zeros(length(alpha), 1001);
tic
    parfor i=1:length(alpha)
        fprintf('alpha is %f',alpha(i));
    
        for m=1:number_of_runs
           [alpha(i), m]
           	deg_count(i, :) = deg_count(i, :) + gen_graph_only(alpha(i),node_number,k);
        end
            deg_count(i, :) = deg_count(i, :)/number_of_runs;
    end


%plot(alpha,max_recovery_time)g
%hold
total_time=toc;
delete (gcp);
%bar(deg_count);