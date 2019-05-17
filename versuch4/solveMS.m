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
    eps0 = 8.854*10^(-12);
    mu0= 4*pi*10^-7;
    % Erzeugung topologische Matrizen
    [c, s, st] = createTopMats(msh);
    
    % Erzeugung geometrische Matrizen
    [ds, dst, da, dat] = createGeoMats(msh);
    
    % Erzeugung Materialmatrix Permeabilität
     Mmu = createMeps(msh, dst, dat, da, (mu./eps0).*mu0);
    
    % Berechnung Systemmatrix (mit Hauptdiagonale positiv, sonst konvergiert pcg nicht)
     A = st*Mmu*st'; 
    
    % Berechnen des Hilfsfelds mit calcHi
     hibow =calcHi(msh,jbow) ;
    
    % Ladungsvektor berechnen
     qm = st*Mmu*hibow;
    
    % Gleichungssystem lösen (bitte das Minus vor der magnetischen Ladung beachten)
    [phi, ~, ~, ~, resVec] = pcg(A, -qm, 1e-10, msh.np);

    relRes = resVec./norm(qm);  %pcg gibt relRes nur für die letzte 
                                %Iteration zurueck, so kann man sie jedoch 
                                %für alle berechnen.
                                
    
    %Magnetische Gitterspannung und Gitterfluss berechnen
    % hhbow
     hbow = st'*phi+hibow; 
     bbow = Mmu*hbow;

end
