%run for different values and generate output


%variables
%alpha=0:0.1:1;
clear
clc
%p = parallel.defaultClusterProfile;
%numprocs = feature ('numcores'); % maximum is number of physical cores
%poolobj=parpool(p,numprocs);%generate a parallel pool
tic
k=1:1:1; 
node_number=2000;
number_of_runs=100;

histfinal = zeros(length(k), 5000);

for i=1:length(k)
    for m=1:number_of_runs
        [i, m]
        hist(m,:) = gen_PA_graph(node_number, k(i));
    end

    histfinal(i, :)=sum(hist, 1)/number_of_runs;
    histfinal(i, :)=histfinal(i, :)/node_number;
end


%for i=1:number_of_runs
 %   dev(i) = histfinal - hist(i, :);
%end

%plot(alpha,max_recovery_time);
%hold
total_time=toc
%delete (gcp);
