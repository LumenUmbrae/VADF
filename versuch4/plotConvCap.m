%   Aufgabe 6
%
%   Erstellt einen Graphen, in dem die Kapazit�t der Kondensatorkon-
%   figuration e) �ber der Anzahl der Gitterpunkte np aufgetragen ist.

%   Sie k�nnen nahezu analog zu Aufgabe 5 vorgehen. Sie m�ssen die
%   Berechnung noch auf das Kovergenzverhalten hinsichtlich des Gitters
%   anpassen. Sie ben�tigen daher die Kapazit�t. Berechnen Sie diese
%   mit calcCap(msh, ebow, dbow).

% Parameter und Initialisierungen
N = 50;
stuetzstellen = 5:2:(N+5);
cap = zeros(N/2+1,1);
nrgridpoints = zeros(N/2+1,1);

for i = 1:length(stuetzstellen)
    
    n = stuetzstellen(i);
    
    % Erstellen des kartesischen Gitters mit cartMesh
    xmesh = linspace(0,1,n);
    ymesh = linspace(0,1,n);
    zmesh = linspace(0,1,5);
    msh = cartMesh(xmesh,ymesh,zmesh);
	
    % Berechnen der Permittivit�t mit boxMesher
    % defaultvalue = 
    % ...
    
    % Erstellen des Potentialvektors mit den eingepr�gten Potentialen (auch mit boxMesher)
    % ...
	
    % Berechnen der Feldverteilung
    bc = 0;
    q = zeros(msh.np, 1);
    [phi, ebow, dbow, relRes] = solveES( msh, eps, pot, q, bc);
    
    % Berechnen und speichern der Kapazit�t
    cap(i) = calcCap(msh, ebow, dbow);
	
    % Anzahl der Gitterpunkte speichern
    % nrgridpoints(i) = 
end

% Plot
figure(1); clf;
plot(nrgridpoints, cap, 'b.-', 'LineWidth', 2);
xlabel('Anzahl der Punkte np');
ylabel('Numerisch berechnete Kapazitaet des Kondensators / F');