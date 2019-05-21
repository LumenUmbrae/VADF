% Aufgabe 7

% Erstellen eines kartesischen Gitters
xmesh = linspace(0,1,11);
ymesh = linspace(0,1,11);
zmesh = linspace(0,1,11);

msh = cartMesh(xmesh, ymesh, zmesh);

Mx = msh.Mx;
My = msh.My;
Mz = msh.Mz;
np = msh.np;

% Erstellen des Strom-Vektors (kanonischen Index berechnen und benutzen)
% x=0.5, y=0.5 z sollte 2000A sein
j_bow=zeros(3*np,1);
for i=1:1:msh.nx
  for j=1:1:msh.ny
    for k=1:1:msh.nz
      n=1+(i-1)*Mx+(j-1)*My+(k-1)*Mz;
      if xmesh(i)==0.5 && ymesh(j)==0.5 || xmesh(i)==0.4 && ymesh(j)==0.5 ...
         || xmesh(i)==0.4 && ymesh(j)==0.4 || xmesh(i)==0.5 && ymesh(j)==0.4
        j_bow(2*np+n)=250;
      endif
    endfor
  endfor
endfor

    
  




% Berechnen des Hilfsfeldes
 hiBow = calcHi(msh,j_bow);

% Plotten des Hilfsfeldes
figure(1); clf;
plotEdgeVoltage (msh, hiBow, ceil(msh.nz/2), [0, 0, 0, 0, 0, 0]);
xlabel('x')
ylabel('y');