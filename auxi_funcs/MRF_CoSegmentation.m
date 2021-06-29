function [CM_map,labels] = MRF_CoSegmentation(Cosup,lambda,t1_feature,t2_feature,fx,fy)
[h,w]   = size(Cosup);
CoNs  = max(Cosup(:));
idx_Co = label2idx(Cosup);
%% R-adjacency neighborhood system
for i = 1:CoNs
    index_vector = idx_Co{i};
    [location_x location_y] = ind2sub(size(Cosup),index_vector);
    location_center(i,:) = [round(mean(location_x)) round(mean(location_y))];
end
adj_mat = zeros(CoNs);
for i=2:h-1
    for j=2:w-1
        label = Cosup(i,j);
        if (label ~= Cosup(i+1,j-1))
            adj_mat(label, Cosup(i+1,j-1)) = 1;
        end
        if (label ~= Cosup(i,j+1))
            adj_mat(label, Cosup(i,j+1)) = 1;
        end
        if (label ~= Cosup(i+1,j))
            adj_mat(label, Cosup(i+1,j)) = 1;
        end
        if (label ~= Cosup(i+1,j+1))
            adj_mat(label, Cosup(i+1,j+1)) = 1;
        end
    end
end
adj_mat_1 = double((adj_mat + adj_mat')>0);
R = 2*round(sqrt(h*w/CoNs));
adj_mat = zeros(CoNs);
for i=1:CoNs
    for j = i:CoNs
        if ((location_center(i,1) - location_center(j,1))^2 + (location_center(i,2) - location_center(j,2))^2 < R^2)
            adj_mat (i,j) = 1;
        end
    end
end
adj_mat = double((adj_mat + adj_mat')>0);
adj_mat_2 = adj_mat - eye(CoNs);
adj_mat = adj_mat_1|adj_mat_2;
%% edgeWeights
edgeWeights = zeros(sum(adj_mat(:)),4);
[node_x node_y] = find(adj_mat ==1);
edgeWeights(:,1) = node_x; % index of node 1
edgeWeights(:,2) = node_y; % index of node 2
for i = 1:sum(adj_mat(:))
    index_node_x = edgeWeights(i,1);
    index_node_y = edgeWeights(i,2);
    feature_t1_x = t1_feature(:,index_node_x);
    feature_t1_y = t1_feature(:,index_node_y);
    feature_t2_x = t2_feature(:,index_node_x);
    feature_t2_y = t2_feature(:,index_node_y);
    Dpq_t1(i) = norm(feature_t1_x-feature_t1_y,2)^2;
    Dpq_t2(i) = norm(feature_t2_x-feature_t2_y,2)^2;
    dist(i) = max(norm(location_center(index_node_x,:)-location_center(index_node_y,:),2),1);
end
sigma_t1 = mean(Dpq_t1);
sigma_t2 = mean(Dpq_t2);
Vpq_t1 = exp(-Dpq_t1/(2*sigma_t1));
Vpq_t2 = exp(-Dpq_t2/(2*sigma_t2));
th_Vpq = exp(-0.5);
for i =  1:sum(adj_mat(:))
    if Vpq_t1(i) > th_Vpq && Vpq_t2(i) > th_Vpq
        Vpq(i) = Vpq_t1(i)*Vpq_t2(i);
    elseif Vpq_t1(i) > th_Vpq && Vpq_t2(i) <= th_Vpq
        Vpq(i) = (1-Vpq_t1(i))*Vpq_t2(i);
    elseif Vpq_t1(i) <= th_Vpq && Vpq_t2(i) > th_Vpq
        Vpq(i) = Vpq_t1(i)*(1-Vpq_t2(i));
    else
        Vpq(i) = (Vpq_t1(i)*Vpq_t2(i) + (1-Vpq_t1(i))*(1-Vpq_t2(i)))/2;
    end
end
% for i =  1:sum(adj_mat(:))
%     if Dpq_t1(i) <= sigma_t1 && Dpq_t2(i) <= sigma_t2
%         Vpq(i) = exp(-Dpq_t1(i)/(2*sigma_t1)-Dpq_t2(i)/(2*sigma_t2));
%     elseif Dpq_t1(i) <= sigma_t1 && Dpq_t2(i) > sigma_t2
%         Vpq(i) = exp(Dpq_t1(i)/(2*sigma_t1)-1-Dpq_t2(i)/(2*sigma_t2));
%     elseif Dpq_t1(i) > sigma_t1 && Dpq_t2(i) <= sigma_t2
%         Vpq(i) = exp(-Dpq_t1(i)/(2*sigma_t1)+Dpq_t2(i)/(2*sigma_t2)-1);
%     else
%         Vpq(i) = exp(-1);
%     end
% end
Vpq = Vpq ./dist;
edgeWeights(:,3) = (1 - lambda)*Vpq;                  % node 1 ---> node 2
edgeWeights(:,4) = (1 - lambda)*Vpq;                  % node 2 ---> node 1
%% calculate W
for i = 1:CoNs
    idx = find(node_y==i);
    W_temp(i) = sum(Vpq(idx));
end
W = max(W_temp);
%% termWeights
Ic1 = fx/max(fx);
Ic2 = fy/max(fy);
T_theory1 = graythresh(Ic1); 
T_theory2 = graythresh(Ic2); 
termWeights = zeros(CoNs,2);
termWeights_sp = lambda*(-log(Ic1/2/T_theory1))+lambda*(-log(Ic2/2/T_theory2));
termWeights_sp(Ic1>2*T_theory1&Ic2>2*T_theory2) = 0;
termWeights_tp = lambda*(-log(1 - Ic1/2/T_theory1))+lambda*(-log(1 - Ic2/2/T_theory2));
termWeights_tp(Ic1>2*T_theory1&Ic2>2*T_theory2) = W;
termWeights(:,1) = real(termWeights_sp);
termWeights(:,2) = real(termWeights_tp);
%% graph-cut;
% use the graphCutMex download from https://github.com/aosokin/graphCutMex_BoykovKolmogorov.
% Yuri Boykov and Vladimir Kolmogorov, An experimental comparison of Min-Cut/Max-Flow algorithms for energy minimization in vision, 
% IEEE TPAMI, 26(9):1124-1137, 2004.
addpath('GC');
[cut, labels] = graphCutMex(termWeights, edgeWeights);
%% CM calculation
idx_Co = label2idx(Cosup);
for i = 1:size(t1_feature,2)
    index_vector = idx_Co{i};
    CM_map(index_vector) = labels(i);
end
CM_map =reshape(CM_map,[size(Cosup,1) size(Cosup,2)]);
