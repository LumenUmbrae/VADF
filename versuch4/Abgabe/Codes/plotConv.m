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

% e) eine Box mit eps = 1, metallischer Block wird später über vorgegebene Potentiale eingeprägt
 boxesE(1).box = [1, msh.nx, 1, msh.ny, 1, msh.nz];
 boxesE(1).value = 1;
% epsE =  boxMesher(msh, boxesE, defaultvalue);

% e) eps = 1 mit metallischem Block, Kondensator mit Sprung
% Variante e) Potentiale im metallischen Block und am Rand
 boxesPotE(1).box = [1, msh.nx, 1, 1, 1 , msh.nz];
 boxesPotE(1).value = 0;
 boxesPotE(2).box = [1,msh.nx,msh.ny,msh.ny,1,msh.nz];
 boxesPotE(2).value = 1;
 boxesPotE(3).box = [1, floor(msh.nx/2), floor(msh.ny/2), msh.ny, 1, msh.nz];
 boxesPotE(3).value = 1;
% potE = boxMesher(msh, boxesPotE, NaN);
%q = zeros(msh.np, 1);
% [ phiE, ebowE, dbowE, relResE] = solveES( msh, epsE, potE, q);

% Berechnen der Permittivit�t mit boxMesher
eps = boxMesher(msh, boxesE, defaultvalue);


% Berechnen des Potentials mit boxMesher
pot = boxMesher(msh, boxesPotE, NaN);


% Erstellen des Ladungsvektors
q = zeros(msh.np,1);

% L�sen des Gleichungssystems mit dem ES-Solver
bc = 0;
[phi, ebow, dbow, relRes] = solveES( msh, eps, pot, q, bc);

% Plot
figure(1); 

clf;
semilogy(relRes, 'LineWidth', 2);
xlabel('Anzahl der Iterationen n');
ylabel('relatives Residuum');
