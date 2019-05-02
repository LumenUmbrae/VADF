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
              line(point,pointx);
            endif
		
            % y-Kante zeichnen, falls keine Geisterkante vorliegt
            if i!=ny
              pointy=point;
              pointy(2)=ymesh(j+1);
              line(point,pointy);
            endif
            % z-Kante zeichnen, falls keine Geisterkante vorliegt
            if i!=nz
              pointz=point;
              pointz(1)=zmesh(k+1);
              line(point,pointz);
            endif
        end
    end
end
xlabel('x');ylabel('y');zlabel('z');