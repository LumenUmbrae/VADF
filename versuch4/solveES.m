%   Einfacher Solver für elektrostatische Probleme
%
%   Eingabe
%   msh         Kanonisches kartesisches Gitter
%   eps         Permittivität entsprechend Methode createMeps
%   pots        Potentiale entsprechend Methode boxMesher
%   q           Ladungsvektor entsprechend Methode boxMesher
%
%   Rückgabe
%   phi         Potentialvektor Lösung
%   ebow        Elektrische Gitterspannung
%   dbow        Elektrischer Gitterfluss
%   relRes      Relatives Residuum für jeden Iterationsschritt

function [phi, ebow, dbow, relRes] = solveES(msh, eps, pots, q)

    % Erzeugung topologische Matrizen
    [~, ~, st] = createTopMats(msh);
    
    % Erzeugung geometrische Matrizen
    [ds, ~, da, dat] = createGeoMats(msh);
	
    % Erzeugung der Materialmatrix der Permittivität mit createMeps
    % Meps = 
        
    % Berechnung Systemmatrix
    % A = 
        
    % Modifikation Systemmatrix und Ladungsvektor mit modPots
    % [A, q] = 
	
    % Gleichungssystem lösen mit pcg
	[x, ~, ~, ~, resVec] = pcg(A, q, 1e-13, msh.np);

	% Bestimmung des Residuums
    relRes = resVec./norm(q);   % pcg gibt relRes nur für die letzte 
                                % Iteration zurück, so kann man sie jedoch 
                                % für alle berechnen.
	
	% phi aus x bestimmen (eingeprägte Potentiale wieder einfügen)
	% phi = 
	
    % Elektrische Gitterspannung und Gitterfluss berechnen
    % ebow =     
    % dbow =     
                                
end
