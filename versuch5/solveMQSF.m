% Aufgabe 4
%
% Einfacher Solver fuer magnetoquasistatische Probleme im Frequenzbereich
%
%   Eingabe
%   msh         Kanonisches kartesisches Gitter
%   mui         Inverse Permeabilitaet entsprechend Methode createMmui
%   kap         Diskrete gemittelte Leitfähigkeit
%   jsbow       Stromgitterfluss (Erregung), als Funktion der Zeit
%   f           Frequenz tder Anregung
%
%   Rückgabe
%   abow        Integriertes magnetisches Vektorpotential
%   hbow        Magnetische Gitterspannung
%   bbow        Magnetische Gitterfluss
%   jbow        Stromgitterfluss
%   relRes      Relatives Residuum fuer jeden Iteraionsschritt
%   bc          Randbedingungen (0=magnetisch, 1=elektrisch)

function [abow, hbow, bbow, jbow, relRes] = solveMQSF(msh, mui, kap, jsbow, f, bc)

    % Anzahl der Rechenpunkte des Gitters
    np = msh.np;

    % Erzeugung topologische Matrizen
    [c, ~, ~] = createTopMats(msh);
        
    % Erzeugung geometrische Matrizen
    [ds, dst, da, dat] = createGeoMats(msh);       
    
    % Erzeugung der Materialmatrix
    mmui = createMmui(msh, ds, dst, da, mui, bc);
    mkap = createMeps(msh, ds, da, dat, kap, bc);

    % Berechnung der Kreisfrequenz
     omega = 2*pi*f;   
    
    % Berechnung Systemmatrix A und rechte Seite rhs
     A = c'*mmui*c+i.*omega.*mkap;
     rhs = jsbow;

    % Einträge der Geisterkanten aus Systemmatrix und rechter Seite
    % streichen (da pcg sonst nicht konvergieren würde, ausprobieren!)
    idxGhostEdges = getGhostEdges(msh);
    idxAllEdges = 1:(3*np);
    idxExistingEdges = setdiff(idxAllEdges,idxGhostEdges);
    A_reduced = A(idxExistingEdges,idxExistingEdges);
    rhs_reduced = rhs(idxExistingEdges);
   
    % Initialisieren der Lösung
     abow = zeros(rows(A),1);
    
    % Vorkonditionierer wählen (hier Jacobi)
     M = diag(diag(A_reduced));
   
    % Gleichungssystem loesen
    [abow_reduced, flag, relRes, iter, resVec] = pcg(A_reduced, rhs_reduced, 1e-6, 1000, M);
    if flag == 0
      fprintf('pcg: converged at iteration %2d to a solution with relative residual %d.\n',iter,relRes);
    else
      error('pcg: some error ocurred, please check flag output.')
    end
    relRes = resVec./norm(rhs_reduced);
    
    % A und rhs zur�ck auf ursprüngliche Gr��e bringen
    abow(idxExistingEdges) = abow_reduced;
    rhs(idxExistingEdges) = rhs_reduced;
    
    % Magnetische Gitterspannung, magnetischen Fluss und Stromgitterfluss
    % berechnen
     bbow = c*abow; 
     hbow = mmui*bbow;
     jbow = -i*omega*mkap*abow;
end
