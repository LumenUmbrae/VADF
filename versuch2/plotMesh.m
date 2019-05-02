% Aufgabe 2

% Methode zum Plotten des mit cartMesh erzeugten kartesischen Gitters.
%
% Eingabe
% msh           Struktur, wie sie mit cartMesh erzeugt werden kann.

function [  ] = plotMesh( msh )
  

% Zuweisen von nx, nz, nz, xmesh, ymesh und zmesh
nx=msh.nx;
ny=msh.ny;
nz=msh.nz;
xmesh=msh.xmesh;
ymesh=msh.ymesh;
zmesh=msh.zmesh;

% Zeichnen aller Kanten mithilfe einer Dreifachschleife
figure;
for i=1:nx
    for j=1:ny
        for k=1:nz
		point=[xmesh(i);ymesh(j);zmesh(k)];
            % x-Kante zeichnen, falls keine Geisterkante vorliegt
            if i!=nx
              pointx=point;
              pointx(1)=xmesh(i+1);
              line([point(1),pointx(1)],[point(2),pointx(2)],[point(3),pointx(3)]);
            endif
		
            % y-Kante zeichnen, falls keine Geisterkante vorliegt
            if j!=ny
              pointy=point;
              pointy(2)=ymesh(j+1);
              line([point(1),pointy(1)],[point(2),pointy(2)],[point(3),pointy(3)]);
            endif
            % z-Kante zeichnen, falls keine Geisterkante vorliegt
            if k!=nz
              pointz=point;
              pointz(3)=zmesh(k+1);
               line([point(1),pointz(1)],[point(2),pointz(2)],[point(3),pointz(3)]);
            endif
        end
    end
end
xlabel('x');ylabel('y');zlabel('z');