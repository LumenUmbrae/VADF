%   Aufgabe 5
%
%   Erstellt einen Graphen, in dem das relative Residuum �ber der Anzahl
%   der Iterationen aufgetragen ist.

% Erstellen eines kartesischen Gitters
xmesh = linspace(0,1,11);
ymesh = linspace(0,1,11);
zmesh = linspace(0,1,11);
msh = cartMesh(xmesh, ymesh, zmesh);

% Gew�hlten Kondensator definieren (Materialien, Potentiale)
% ...

% Berechnen der Permittivit�t mit boxMesher
eps = boxMesher(   ,   ,   );


% Berechnen des Potentials mit boxMesher
pot = boxMesher(   ,   ,   );


% Erstellen des Ladungsvektors
q = zeros(msh.np,1);

% L�sen des Gleichungssystems mit dem ES-Solver
bc = 0;
[phi, ebow, dbow, relRes] = solveES( msh, eps, pot, q, bc);

% Plot
figure(1); clf;
semilogy(relRes, 'LineWidth', 2);
xlabel('Anzahl der Iterationen n');
ylabel('relatives Residuum');
