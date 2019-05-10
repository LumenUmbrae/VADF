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

for i=1:1:np
  
  if(msh(i+np)~=msh(i+1+np))
    dBow(i)=0

    if(i<My)
      x=(msh(i)+msh(i+1))/2;
      y=msh(i+np)+((msh(i+np)-msh(i+np+My))/4);
    
    elseif(i>(np-My))
      x=(msh(i)+msh(i+1))/2;
      y=msh(i+np)-((msh(i+np)-msh(i+np+My))/4);
    
    else
      x=(msh(i)+msh(i+1))/2;
      y=msh(i+np);
    endif
    
  else
   dBow(i)=(x/((x^2+y^2)^(3/2)))*DAtDiag(i);
  endif

endfor


for i=(np+1):1:2*np
  
  if(i>(np-My))
   dBow(i)=0;
   
    if(msh(i)~=msh(i-1))
      y=(msh(i)+msh(i+My))/2;
      x=msh(i-np)+((msh(i-np+1)+msh(i-np))/4);
    elseif(msh(i)~=msh(i+1))
      y=(msh(i)+msh(i+My))/2;
      x=msh(i-np)-((msh(i-np-1)+msh(i-np))/4);
    else
      x=msh(i-np);
      y=(msh(i)+msh(i+1))/2;
    endif 
    
  else
    dBow(i)=(y/((x^2+y^2)^(3/2)))*DAtDiag(i);
  endif
 
endfor


%% Isotrope Permittivität
eps_r = ones(3*np,1);

%bc = ; % PEC
Deps = createDeps( msh, DA, DAt, eps_r, bc );
Meps = createMeps( DAt, Deps, DS );
MepsInv = nullInv( Meps );

eBow = MepsInv * dBow;

figure(1);
plotEBow(msh,eBow,2);
title('Isotropes E-Feld');
xlabel('x');
ylabel('y');
zlabel('Elektrisches Feld E in V/m');

figure(2);
plotEdgeVoltage(msh,eBow,2,[bc bc bc bc bc bc]);
title('Isotropes E-Feld');
xlabel('x in m');
ylabel('y in m');


% Folge-Aufgabe: Anisotrope Permittivität
%eps_r(1:np) =

%bc = ; % PEC
Deps = createDeps( msh, DA, DAt, eps_r, bc );
Meps = createMeps( DAt, Deps, DS );
MepsInv = nullInv( Meps );

eBow = MepsInv * dBow;

figure(3);
plotEBow(msh,eBow,2);
title('Anisotropes E-Feld');
xlabel('x');
ylabel('y');
zlabel('Elektrisches Feld E in V/m');

figure(4);
plotEdgeVoltage(msh,eBow,2,[bc bc bc bc bc bc]);
title('Anisotropes E-Feld');
