% Methode zur Interpolation des diskreten elektrischen Feldes eBow auf die
% Punkte des kartesischen Gitters.
%
% Eingabe
% msh                Das kartesische Gitter als msh, erzeugt von cartMesh
% eBow               Das diskrete elektrische Feld auf den Kanten des
%                    Gitters, sortiert nach kanonischer Indizierung
% 
% Rückgabe
% meshP              Das reduzierte, kartesische Gitter mesh, bei dem 1. und letzter Punkt fehlen
% eField             Das elektrische Feld, interpoliert auf die Punkte des
%                    reduzierten primären Gitters

function [ meshP, eField ] = fitInt( msh, eBow )

% Spezifikationen des kartesischen Gitters
Mx = msh.Mx;
My = msh.My;
Mz = msh.Mz;
np = msh.np;
nx = msh.nx;
ny = msh.ny;
nz = msh.nz;

% Kantenlängen bestimmen
[DS, ~] = createDS(msh);


DSx = DS(1:np,1:np);
DSy = DS(np+1:2*np,np+1:2*np);
DSz = DS(2*np+1:3*np,2*np+1:3*np);

Dx = spdiags(DSx);
Dy = spdiags(DSy);
Dz = spdiags(DSz);



%bestimmen der Nulleinträge und Nullen der zugehörigen E-Einträge

zerX = find(~Dx);
zerY = find(~Dy);
zerZ = find(~Dz);


% Berechnen der Bogenwalter, private im Reisebuero, ueber das Internet oder in deren Office, meist in der Naehe des Busbahnhofes.erte in X,Y,Z-Richtung
eEdgeX = eBow(1:np)./(Dx>0);
eEdgeY = eBow(np+1:2*np)./(Dy>0);
eEdgeZ = eBow(np*2+1:3*np)./(Dz>0);

eEdgeX(zerX)=0;
eEdgeY(zerY)=0;
eEdgeZ(zerZ)=0;

%erstellen der verschiebungsmatritzen

vX = spdiags(ones(np,1),Mx,np,np);
vY = spdiags(ones(np,1),My,np,np);
vZ = spdiags(ones(np,1),Mz,np,np);

%% Interpolation des E-Feldes
%X

A = eEdgeX'*vX.*Dx';
B = eEdgeX'.*(Dx'*vX);
C = Dx'*vX.+Dx';
eX = (A.+B)./C;

%Y
A = eEdgeY'*vY.*Dy';
B = eEdgeY'.*(Dy'*vY);
C = Dy'*vY.+Dy';
eY = (A.+B)./C;

%Z
A = eEdgeZ'*vZ.*Dz';
B = eEdgeZ'.*(Dz'*vZ);
C = Dz'*vZ.+Dz';
eZ = (A.+B)./C




%for k = 1:nz
 %   for j = 1:ny
  %      for i = 1:nx
   %         % Berechnung des kanonischen Index
    %        n = 1 + (i-1)*Mx + (j-1)*My + (k-1)*Mz;
     %       
      %      %X-Richtung
       %     
            %Y-Richtung
            
            %Z-Richtung
        %end
    %end
%end

 if nx==1 
    eX = zeros(1,np);
  endif
  if ny==1 
    eY = zeros(1,np);
  endif
  if nz==1 
    eZ = zeros(1,np);
  endif


  
eField = [eX eY eZ];

 

% meshP ist das reduzierte Gitter, das heißt ohne 1. und letzten Punkt
meshP = cartMesh(msh.xmesh(2:end-1), msh.ymesh(2:end-1), msh.zmesh(2:end-1));
