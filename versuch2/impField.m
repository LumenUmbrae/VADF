% Aufgabe 9

% Methode zur Bestimmung der elektrischen Gitterspannungen 
% aus einem kontinuierlichen E-Feld 
%
% Eingabe
% msh             Struktur, wie sie mit cartMesh erzeugt werden kann
% field           Das konitnuierliche elektrische Feld als anonyme 
%                 Funktion. Die Funktion muss von der Form 
%                 @(r) fx(r)*([1,0,0])+fy(r)*([0,1,0])+fz(r)*([0,0,1])
%                 sein, wobei r ein dreidimensionaler Vektor ist.
%
% Rueckgabe
% fieldBow        Vektor mit den Gitterspannungen, sortiert nach dem 
%                 kanonischen Indizierungsschema fuer Kanten

function [ fieldBow ] = impField( msh, field )

% Gittereigenschaften aus struct holen
np = msh.np;
nx = msh.nx; ny = msh.ny; nz = msh.nz;
Mx = msh.Mx; My = msh.My; Mz = msh.Mz;
xmesh = msh.xmesh; ymesh = msh.ymesh; zmesh = msh.zmesh;

% Bogenspannungsvektor initieren
fieldBow = zeros(3*np,1);

% Schleife über alle Punkte
for i=1:nx
    for j=1:ny
        for k=1:nz
            % kanonischen Index n bestimmen
            n = k*j*i;
            
            % x-, y- und z-Koordinate des Gitterpunktes bestimmen
            x = xmesh(i);
            y = ymesh(j);
            z = zmesh(k);
            
            x2 = xmesh(i+1);
            y2 = ymesh(j+1);
            if (k)>=rows(zmesh)+1
              z2=z;
            else
            z2 = zmesh(k+1);
            endif
            vectors=field(x+(x2-x)/2,y+(y2-y)/2,z+(z2-z)/2);
            xvec=vectors(1);
            yvec=vectors(2);
            zvec=vectors(3);
            % Bogenwert für x-Kante mit Index n
            fieldbow(i) = xvec.*(x2-x);
            
            % Bogenwert für y-Kante mit Index n
            fieldbow(j) = yvec.*(y2-y);
            % Bogenwert für z-Kante mit Index n
            fieldbow(k) = zvec.*(z2-z);
        end
    end
end