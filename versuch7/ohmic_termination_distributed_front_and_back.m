function [Rmat] = ohmic_termination_distributed_front_and_back(np, R)
% Return R matrix for ohmic termination at all port edges at back side

 Xedges = [5,7,9,11,2405,2407,2409,2411];
 Yedges = [2418,2419,2426,2427,4818,4819,4826,4827];

 Rmat = sparse(3*np,3*np); 
 for k=1:8
 Rmat(Xedges(k),Xedges(k))=R*8;
 Rmat(Yedges(k),Yedges(k))=R*8;
 endfor
end
