% Aufgabe 10

% Skript, das die diskreten Felder a) und b) mithilfe eines Vektor-
% feldes visualisiert.
% Verwendet werden die Methoden aus den vorherigen Aufgabe.

%% Aufgabe 9
% Beispielgitter erzeugen (3D)
nxy=2
    xmesh=1:1:nxy;
    for i=1:1:2*nxy-1
      xmesh=[xmesh, 1:1:nxy];
      xmesh
    endfor
    
    ymesh=ones(nxy, 1)';
    
    for i=2:1:nxy
       ymesh=[ymesh, i.*ones(nxy, 1)'];
    endfor
    ymesh=[ymesh,ymesh];
    
    zmesh = [];
    for i=0:1:nxy-1
      zmesh = [zmesh, i*ones(nxy*nxy,1)'];
    endfor
    zmesh
    a=columns(xmesh)
    a2=columns(ymesh)
    b=columns(zmesh)
%% msh struct berechnen
msh = cartMesh(xmesh, ymesh, zmesh);

%% anonymous function der beiden gegebenen Felder bestimmen
 f1 = @(x,y,z)([1./x.^2, 0.01*x, y+z]);
% f2 = 

%% Bogengröße der beiden Felder mithilfe von impField bestimmen
fbow1 = impField( msh, f1 );
%fbow2 = impField( msh, f2 );

%% diskretes Feld fbow mithilfe von plotArrowfield plotten
figure;
plotEdgeVoltage(msh, fbow1);
figure;
plotEdgeVoltage(msh, fbow2);
