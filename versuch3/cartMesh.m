% Methode zur Erstellung einer Struktur, in der die einzelnen Punkte des
% Gitters sortiert nach dem kanonischen Indizierungsschema in einem
% dreidimensionalem Vektor (x,y,z) abgelegt werden. Ausserdem wird die
% Anzahl der Punkte in x-,y-,z-Richtung und die Einzelkoordinaten der
% Punkte in jede Richtung gespeichert. Die Struktur basiert auf der
% Annahme, dass es sich um ein kartesisches Gitter handelt.
%
% Eingabe
% xmesh        Die x-Koordinaten der Punkte des Gitters (eindimensionaler 
%              Vektor) 
% ymesh        Die y-Koordinaten der Punkte des Gitters (eindimensionaler 
%              Vektor) 
% zmesh        Die z-Koordinaten der Punkte des Gitters (eindimensionaler 
%              Vektor) 
%
% Rueckgabe
% msh          Struktur bestehend aus: 
%              nx = Anzahl der Punkte in x-Richtung
%              ny = Anzahl der Punkte in y-Richtung
%              nz = Anzahl der Punkte in z-Richtung
%              np = Anzahl der Punkte insgesamt
%              xmesh = wie xmesh aus der Eingabe
%              ymesh = wie ymesh aus der Eingabe
%              zmesh = wie zmesh aus der Eingabe
%              Mx = Inkrement in x-Richtung
%              My = Inkrement in y-Richtung
%              Mz = Inkrement in z-Richtung

function [ msh ] = cartMesh( xmesh, ymesh, zmesh )

nx = length(xmesh);
ny = length(ymesh);
nz = length(zmesh);

np = nx*ny*nz;

msh.Mx = 1;
msh.My = nx;
msh.Mz = nx*ny;

% Definieren der Struktur
msh.nx = nx;
msh.ny = ny;
msh.nz = nz;
msh.np = np;
msh.xmesh = xmesh;
msh.ymesh = ymesh;
msh.zmesh = zmesh;

end

