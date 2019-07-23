% Methode zur Darstellung des diskreten Gitterspannung eBow. 
%
% Eingabe
% msh               Ein kartesisches Gitter msh, erzeugt von cartMesh
% eBow              Die diskrete Gitterspannung, sortiert nach
%                   kanonischer Indizierung
% indz              Die Tiefe (z-Ebene) der Betrachtung

function plotEBow( msh, eBow, indz )


%% Interpolation der elektrischen Gitterspannung
[~,eField] = fitInt(msh, eBow);

% Spezifikationen des kartesischen Gitters
nx = msh.nx;
ny = msh.ny;
np = msh.np;

Mx = msh.Mx;
My = msh.My;
Mz = msh.Mz;

xmesh = msh.xmesh;
ymesh = msh.ymesh;

eX = eField(:,1:np);
eY = eField(:,np+1:2*np);
eZ = eField(:,2*np+1:3*np);

abValE = sqrt(eX.*eX.+eY.*eY.+eZ.*eZ); %bestimmen des Betrages des Feldes an jedem Punkt

%herausziehen des Punkte einer x-y-Ebene

Ev = abValE((indz-1)*Mz+1:indz*Mz);

toPlot = reshape(Ev, nx,ny)';

surf( xmesh, ymesh ,toPlot);

%{
%% Berechnung des Betrages des interpolierten elektrischen Gitterflusses
X = zeros(nx,ny); % x-Koordinaten der Punkte
Y = zeros(nx,ny); % y-Koordinaten der Punkte
E = zeros(nx,ny); % Betrag des elektrischen Feldes

for i = 1:nx
   for j = 1:ny
       n = 1 + (i-1)*Mx + (j-1)*My + (indz-1)*Mz;
       
       % Bestimmen der Koordinaten des Punktes
%       X(i,j) = 
%       Y(i,j) = 
       
       % Berechnen des Betrages des elektrischen Feldes
%       E(i,j) = 
   end
end

%% Darstellen des elektrischen Feldes in einem surface plot
 %}

end