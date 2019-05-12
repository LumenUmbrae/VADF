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
dxt = diff(mesh.xmesh);
	dxt = [dxt dxt(nx-1)/2]; 
	dxt(1) = dxt(1)/2;
	dyt = diff(mesh.ymesh);
	dyt = [dyt dyt(ny-1)/2];
	dyt(1) = dyt(1)/2;
	dzt = diff(mesh.zmesh);
	dzt = [dzt dzt(nz-1)/2];
	dzt(1) = dzt(1)/2;
% Gitterabstände/Schrittweiten entlang der x-Achse
%dxt =
dxt = diff(mesh.xmesh);
	dxt = [dxt, dxt(nx-1)/2]; 
	dxt(1) = dxt(1)/2;

% Gitterabstände/Schrittweiten entlang der y-Achse
%dyt = 
dyt = diff(mesh.ymesh);
	dyt = [dyt, dyt(ny-1)/2];
	dyt(1) = dyt(1)/2;
% Gitterabstände/Schrittweiten entlang der z-Achse
%dzt =
dzt = diff(mesh.zmesh);
	dzt = [dzt, dzt(nz-1)/2];
	dzt(1) = dzt(1)/2;





% Diagonalvektor erstellen (erst alle x-Kante, dann alle y-Kanten und dann alle z-Kanten)
DStdiag = [repmat(dxt, 1, ny*nz), ...
		repmat(reshape(repmat(dyt, nx, 1), 1, nx*ny), 1, nz),...
		reshape(repmat(dzt, nx*ny, 1), 1, np)];

% aus dem Diagonalvektor für DS die matrix erstellen (Befehl spdiags verwenden)
%DSt = 
DSt =spdiags(DStdiag',0,length(DStdiag),length(DStdiag));
end