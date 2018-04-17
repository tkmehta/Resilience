%run for different values and generate output


%variables
%alpha=0:0.1:1;
clear
clc
p = parallel.defaultClusterProfile;
numprocs = feature ('numcores'); % maximum is number of physical cores
poolobj=parpool(p,numprocs);%generate a parallel pool
tic
alpha=0:1:1;
k=1; 
node_number=1000;
number_of_runs=100;
fracs=0.05;
failed_path_weight=100;

healer_count_run = zeros(number_of_runs, length(fracs));
healer_count = 0;

for i=1:length(alpha)
    fprintf('alpha is %f',alpha(i));
    
	parfor m=1:number_of_runs
        [alpha(i), m]
        if rem(m,10)==0
            m
        end
		[healer_count_run(m,:),legend(m)] = gen_graph_no_recovery(alpha(i),node_number,k,fracs,failed_path_weight);
    end
    healer_count(i)=sum(healer_count_run(:))/number_of_runs;
end

%plot(alpha,max_recovery_time);
%hold
total_time=toc;
plot(alpha, healer_count);
delete (gcp);
