% Einfacher Solver für elektrostatische Probleme.
%
%   Eingabe
%   msh         Kanonisches kartesisches Gitter
%   mu          Permeabilität entsprechend Methode createMmu
%   jbow        Stromgitterfluss entsprechend Methode calcHi
%
%   Rückgabe
%   hbow        Magnetische Gitterspannung
%   bbow        Magnetische Gitterfluss
%   relRes      Relatives Residuum für jeden Iterationsschritt

function [hbow, bbow, relRes] = solveMS(msh, mu, jbow)

    % Erzeugung topologische Matrizen
    [~, ~, st] = createTopMats(msh);
    
    % Erzeugung geometrische Matrizen
    [ds, ~, da, dat] = createGeoMats(msh);
    
    % Erzeugung Materialmatrix Permeabilität
    % Mmu = 
    
    % Berechnung Systemmatrix (mit Hauptdiagonale positiv, sonst konvergiert pcg nicht)
    % A = 
    
    % Berechnen des Hilfsfelds mit calcHi
    % hibow = 
    
    % Ladungsvektor berechnen
    % qm = 
    
    % Gleichungssystem lösen (bitte das Minus vor der magnetischen Ladung beachten)
    [phi, ~, ~, ~, resVec] = pcg(A, -qm, 1e-10, msh.np);

    relRes = resVec./norm(qm);  %pcg gibt relRes nur für die letzte 
                                %Iteration zurueck, so kann man sie jedoch 
                                %für alle berechnen.
                                
    
    %Magnetische Gitterspannung und Gitterfluss berechnen
    % hhbow
    % hbow = 
    % bbow =

end
