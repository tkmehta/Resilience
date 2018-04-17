%run for different values and generate output


%variables
clear
clc
%p = parallel.defaultClusterProfile;
%numprocs = feature ('numcores'); % maximum is number of physical cores
%poolobj=parpool(p,numprocs);%generate a parallel pool
tic
alpha=1;
k=20; 
node_number=1000;
number_of_runs=10;

histfinal_random = zeros(length(k), 5000);
histfinal_exact = zeros(length(k), 5000);

for i=1:length(k)
    for m=1:number_of_runs
        [i, m]
        hist(m,:) = gen_coev_rand(alpha, node_number, k(i));
        hist2(m, :) = gen_coev_exact(alpha, node_number, k(i));
    end

    histfinal_random(i, :)=sum(hist, 1)/number_of_runs;
    histfinal_random(i, :)=histfinal_random(i, :)/node_number;
    
    histfinal_exact(i, :)=sum(hist2, 1)/number_of_runs;
    histfinal_exact(i, :)=histfinal_exact(i, :)/node_number;
end


%for i=1:number_of_runs
 %   dev(i) = histfinal - hist(i, :);
%end

%plot(alpha,max_recovery_time);
%hold
total_time=toc
%delete (gcp);
