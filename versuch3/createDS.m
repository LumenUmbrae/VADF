% Methode zum Erstellen der Geometriematrizen DS und DSt
%
% Eingabe
% msh           Struktur, die von cartMesh erzeugt wird. Benutzen Sie
%               hierfür die bereitgestellte Methode.
%
% Rueckgabe
% DS            DS-Matrix
% DSt           DSt-Matrix

function [ DS, DSt ] = createDS( msh )

%% nx, ny, nz und np aus msh struct holen
nx = msh.nx;
ny = msh.ny;
nz = msh.nz;
np = msh.np;


%% Erstellen der Matrix DS
% Überlegen Sie sich, wie Sie die von Matlab bereitgestellte Methode diff
% geschickt verwenden können. Achten Sie auch auf die Geisterkanten

% Gitterabstände/Schrittweiten entlang der x-Achse
%dx = [   ,   ];
dx=[diff(msh.xmesh),0]

% Gitterabstände/Schrittweiten entlang der y-Achse
%dy = [   ,   ];
dy=[diff(msh.ymesh),0]

% Gitterabstände/Schrittweiten entlang der z-Achse
%dz = [   ,   ];
dz=[diff(msh.zmesh),0]
if length(dx)!= nx ||length(dy)!= ny ||length(dz)!= nz
error("something wrong with dimension phase 1");
endif
% Diagonalvektor erstellen (erst alle x-Kante, dann alle y-Kanten und dann alle z-Kanten)
% Ist aufgrund der schwierigen Implementation schon gegeben. 
% Versuchen sie sich aber klar zu machen, 
% was die 3 komplizierten reshape und repmat Konstrukte eigentlich tun.
DSdiag = [repmat(dx, 1, ny*nz), ...
		repmat(reshape(repmat(dy, nx, 1), 1, nx*ny), 1, nz),...
		reshape(repmat(dz, nx*ny, 1), 1, np)]

% aus dem Diagonalvektor für DS die matrix erstellen (Befehl spdiags verwenden)
%DS
DS=spdiags(DSdiag', 0, length(DSdiag),length(DSdiag));

%% Das Gleiche nochmal für die Matrix DSt
dual_x=[msh.xmesh+[msh.xmesh(2:end),0]];
dual_x=dual_x(1:end-1)./2;
dual_y=[msh.ymesh+[msh.ymesh(2:end),0]];
dual_y=dual_y(1:end-1)./2;
dual_z=[msh.zmesh+[msh.zmesh(2:end),0]];
dual_z=dual_z(1:end-1)./2;
% Gitterabstände/Schrittweiten entlang der x-Achse
%dxt =
begin_dxt=dx(1)/2;
end_dxt=dx(nx-1)/2;
mid_dxt=diff(dual_x);
dxt=[ begin_dxt,mid_dxt,end_dxt]

% Gitterabstände/Schrittweiten entlang der y-Achse
%dyt = 
begin_dyt=dy(1)/2;
end_dyt=dy(ny-1)/2;
mid_dyt=diff(dual_y);
dyt=[ begin_dyt,mid_dyt,end_dyt]
% Gitterabstände/Schrittweiten entlang der z-Achse
%dzt =
begin_dzt=dz(1)/2;
end_dzt=dz(nz-1)/2;
mid_dzt=diff(dual_z);

dzt=[begin_dzt,mid_dzt,end_dzt];



% Diagonalvektor erstellen (erst alle x-Kante, dann alle y-Kanten und dann alle z-Kanten)
DStdiag = [repmat(dxt, 1, ny*nz), ...
		repmat(reshape(repmat(dyt, nx, 1), 1, nx*ny), 1, nz),...
		reshape(repmat(dzt, nx*ny, 1), 1, np)];

% aus dem Diagonalvektor für DS die matrix erstellen (Befehl spdiags verwenden)
%DSt = 
DSt =spdiags(DStdiag',0,length(DStdiag),length(DStdiag));
end