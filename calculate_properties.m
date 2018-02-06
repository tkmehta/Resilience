function [giant_component,component_list] = calculate_properties(graph_adj)
%calculate properties of graph 
component_list = conncomp(graph(graph_adj));
giant_component=find(component_list==mode(component_list));
end

