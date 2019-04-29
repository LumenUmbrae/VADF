%Loest das Eigenwertproblem einer Matrix und gibt Wellenzahlen,
%berechnet aus Eigenwerten und Gitterschrittweite, und 
%Eigenvektoren geordnet aus. Bereinigt _nicht_ von unphysikalischen Moden.
%
%   Eingabe
%   cc          Curl-Curl-Matrix
%   dx          Gitterschrittwete
%
%   Rueckgabe
%   kx          Wellenzahlen (aufsteigend)
%   modes       Eigenmoden (geordnet entsprechend kx)

function [kx ,modes]=solveCC(cc, dx)

    % Bestimmen der Eigenwerte und -vektoren mit eig
    [eigenvectors,eigenvalues] = eigs(cc,rows(cc));
    
    
    % Bestimmen der Wellenzahlen aus den Eigenwerten
    for i=1:1:rows(cc)
      k(i)=(sqrt(-eigenvalues(i,i)/dx));
    endfor
    
    % Sortieren der Wellenzahlen. Sortierindex mit zurueckgeben lassen !
    [kx,m]=sort(k);
    % Sortieren der Eigenvektoren mithilfe des Sortierindexes und damit
    eigenvectors_sort=sort(eigenvectors',m);
    % Bestimmung der Moden.
    modes_dummy=eigenvectors_sort';
     for l=1:rows(cc)
      modes_dummy(:,rows(cc)-l+1)=eigenvectors_sort'(:,l);
    endfor
    modes=modes_dummy;  
  
end