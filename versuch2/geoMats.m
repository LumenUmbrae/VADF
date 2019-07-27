% Aufgabe 4

% Methode zur Berechnung der C, S und St (S-Schlange) Matrizen
%
% Eingabe
% msh        Die Datenstruktur, die mit cartMesh erzeugt werden kann
%
% Rueckgabe
% c           Die C-Matrix des primaeren Gitters
% s           Die S-Matrix des primaeren Gitters
% st          Die S-Matrix des dualen Gitters

function [ c, s, st ] = geoMats( msh )

% Bestimmen von Mx, My, Mz sowie np aus struct msh
  np=msh.np;
  Mx=1:
  My=msh.nx;
  Mz=My*msh.ny;

% Px Matrix erzeugen
    x_row=[1:np,1:(np-Mx)];
    x_col=[1:np,2:np];
    x_werte=[-ones(1,np),ones(1,np-Mx)];
    Px=sparse(x_row,x_col,x_werte,np,np);

% Py-Matrix erzeugen
    y_row=[1:np,1:(np-My)];
    y_col=[1:np,1+My:np];
    y_werte=[-ones(1,np),ones(1,np-My)];
    Py=sparse(y_row,y_col,y_werte,np,np);

% Pz-Matrix erzeugen
    z_row=[1:np,1:(np-Mz)];
    z_col=[1:np,1+Mz:np];
    z_werte=[-ones(1,np),ones(1,np-Mz)];
    Pz=sparse(z_row,z_col,z_werte,np,np);

% Matrix derselben Groesse, gefuellt mit Nullen
  Matrix_zero=sparse(np,np);

% Aufbau der C, S und St Matrizen aus den P-Matrizen
  c=[Matrix_zero, -Pz, Py; Pz, Matrix_zerot, -Px; -Py, Px, Matrix_zero];
  s=[Px, Py, Pz];
  st=[-Px', -Py', -Pz'];

end