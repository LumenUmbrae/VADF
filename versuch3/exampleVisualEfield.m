clear all;
%% Aufgabe Visualisierung E-Feld 

% Erstellen des Meshs und benötigter Geometrie-Matrizen
xmesh = linspace(-3,3,16);
ymesh = linspace(-3,3,16);
zmesh = linspace(1,3,3);

msh = cartMesh(xmesh, ymesh, zmesh);

%% Erzeugen benötigter Geometriematrizen
[DS, DSt] = createDS(msh);
[DA] = createDA(DS);
[DAt] = createDA(DSt);

DSDiag = diag(DS);
DAtDiag = diag(DAt);

%% Spezifikation des kartesischen Gitters 
Mx = msh.Mx;
My = msh.My;
Mz = msh.Mz;

np = msh.np;
nx = msh.nx;
ny = msh.ny;
nz = msh.nz;

%% Berechnung von dBow
for k=1:1:nz
  for j=1:1:ny
    for i=1:1:nx
        
        n = 1+(i-1)*Mx+(j-1)*My+(k-1)*Mz;
        
        x = xmesh(i);
        y = ymesh(j);
        z = zmesh(k);
  dBow(n+2*np)=0;
  if(i==nx)
    dBow(n)=0;
    
  else
    if(n<My)
      x1=(x+xmesh(i+1))/2;
      y1=y+((y-ymesh(j+1))/4);
    
    elseif(n>(np-My))
      x1=(x+xmesh(i+1))/2;
      y1=y-((y-ymesh(j-1))/4);
    
    else
      x1=(x+xmesh(i+1))/2;
      y1=y;
    endif
   dBow(n)=(x1/((x1^2+y1^2)^(3/2)))*DAtDiag(n);
  endif
  
  if(n>((nx*ny)-nx))
   dBow(n)=0;
    
  else
    if(j==1 && x==xmesh(1) )
      y1=(y+ymesh(j+1))/2;
      x1=x+((xmesh(i+1)+x)/4);
      
    elseif(j==ny && x==xmesh(nx))
      y1=(y+ymesh(j+1))/2;
      x1=x-((xmesh(i-1)+x)/4);
      
    else
      x1=x;
      y1=(y+ymesh(j+1))/2;
      
    endif 
    dBow(n+np)=(y1/((x1^2+y1^2)^(3/2)))*DAtDiag(n+np);
  endif
 
endfor
endfor
endfor

dBow2=dBow';
%% Isotrope Permittivität
eps_r = ones(3*np,1);
%PEC
bc = 1;
Deps = createDeps( msh, DA, DAt, eps_r, bc );
Meps = createMeps( DAt, Deps, DS );
MepsInv = nullInv( Meps );

eBow = MepsInv * dBow2;


figure(1);
plotEBow(msh,eBow,2);
title('Isotropes E-Feld');
xlabel('x');
ylabel('y');
zlabel('Elektrisches Feld E in V/m');

##figure(2);
##plotEdgeVoltage(msh,eBow,2,[bc bc bc bc bc bc]);
##title('Isotropes E-Feld');
##xlabel('x in m');
##ylabel('y in m');


% Folge-Aufgabe: Anisotrope Permittivität
%eps_r(1:np) =

%bc = ; % PEC
##Deps = createDeps( msh, DA, DAt, eps_r, bc );
##Meps = createMeps( DAt, Deps, DS );
##MepsInv = nullInv( Meps );
##
##eBow = MepsInv * dBow2;
##
##figure(3);
##plotEBow(msh,eBow,2);
##title('Anisotropes E-Feld');
##xlabel('x');
##ylabel('y');
##zlabel('Elektrisches Feld E in V/m');
##
##figure(4);
##%plotEdgeVoltage(msh,eBow,2,[bc bc bc bc bc bc]);
##title('Anisotropes E-Feld');
