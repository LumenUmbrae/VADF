%   Methode zur Berechnung der Kapazit�t eines Plattenkondensators
%
%   Eingabe
%   msh           kartesisches Gitter, wie es von cartMesh erzeugt wird.
%   ebow          Ein Vektor nach dem kanonischen Indizierungsprinzip,
%                 gef�llt mit den elektrischen Gitterspannungen.
%   dbow          Ein Vektor nach dem kanonischen Indizierungsprinzip,
%                 gef�llt mit den elektrischen Gitterfluessen
% 
%   R�ckgabe
%   cap           Die Kapazit�t des Kondensators


function cap = calcCap( msh, ebow, dbow )

% Berechnen der elektrischen Spannung zwischen den Platten
% line gibt den Integrationspfad an, wobei hier entlang der y-Achse
% integriert wird, da die Platten in der XZ-Ebene liegen

% Eine Beschreibung der Argumente von intEdge ist in intEdge.m zu finden
% line.u = 
% line.v = 
% line.w = 
% line.length = 
% line.normal = 
U = intEdge(msh, ebow, line);

% Berechnen der Ladung auf den Kondensatorplatten mit dem Gauss'schen 
% Gesetz, surface gibt die Integrationsfl�che an, die hier in y-Richtung
% gerichtet ist. Eine Beschreibung der Argumente von intSurf ist in intSurf.m zu finden.
% surface.ul = 
% surface.uh = 
% surface.vl = 
% surface.vh = 
% surface.normal = 
% surface.w = 
Q = intSurf(msh, dbow, surface);

% Berechnen der Kapazit�t aus Q und U
% cap =

end
