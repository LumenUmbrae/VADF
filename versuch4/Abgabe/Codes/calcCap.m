%   Methode zur Berechnung der Kapazität eines Plattenkondensators
%
%   Eingabe
%   msh           kartesisches Gitter, wie es von cartMesh erzeugt wird.
%   ebow          Ein Vektor nach dem kanonischen Indizierungsprinzip,
%                 gefüllt mit den elektrischen Gitterspannungen.
%   dbow          Ein Vektor nach dem kanonischen Indizierungsprinzip,
%                 gefüllt mit den elektrischen Gitterfluessen
% 
%   Rückgabe
%   cap           Die Kapazität des Kondensators


function cap = calcCap( msh, ebow, dbow )

% Berechnen der elektrischen Spannung zwischen den Platten
% line gibt den Integrationspfad an, wobei hier entlang der y-Achse
% integriert wird, da die Platten in der XZ-Ebene liegen

% Eine Beschreibung der Argumente von intEdge ist in intEdge.m zu finden
 line.u = 1;
 line.v = floor(msh.ny/2);
 line.w = 1;
 line.length = msh.ny-1;
 line.normal = [0,1,0];
U = intEdge(msh, ebow, line);

% Berechnen der Ladung auf den Kondensatorplatten mit dem Gauss'schen 
% Gesetz, surface gibt die Integrationsfläche an, die hier in y-Richtung
% gerichtet ist. Eine Beschreibung der Argumente von intSurf ist in intSurf.m zu finden.
 surface.ul = 1;
 surface.uh = msh.nx;
 surface.vl = 1;
 surface.vh = msh.nz;
 surface.normal = [0,1,0];
 surface.w = 0;
Q = intSurf(msh, dbow, surface);

% Berechnen der Kapazität aus Q und U
 cap = Q/U;

end
