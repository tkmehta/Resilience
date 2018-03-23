%run for different values and generate output


%variables
%alpha=0:0.1:1;
clear
clc
p = parallel.defaultClusterProfile;
numprocs = feature ('numcores'); % maximum is number of physical cores
poolobj=parpool(p,numprocs);%generate a parallel pool
tic
alpha=0:0.1:1;
k=3; 
node_number=1000;
number_of_runs=100;
fracs=0.05;
failed_path_weight=100;

max_recovery_time_run=zeros(number_of_runs,length(fracs));
avg_recovery_time_run=zeros(number_of_runs,length(fracs));

max_recovery_time=0;
avg_recovery_time=0;

for i=1:length(alpha)
    fprintf('alpha is %f',alpha(i));
    
	parfor m=1:number_of_runs
        [m, alpha(i)]
		[max_recovery_time_run(m,:),avg_recovery_time_run(m,:),legend(m)] = gen_graph(alpha(i),node_number,k,fracs,failed_path_weight);
    end
    max_recovery_time(i)=sum(max_recovery_time_run(:))/number_of_runs;
    avg_recovery_time(i)=sum(avg_recovery_time_run(:))/number_of_runs;
end

%plot(alpha,max_recovery_time);
%hold
total_time=toc
plot(alpha,avg_recovery_time);
delete (gcp);
