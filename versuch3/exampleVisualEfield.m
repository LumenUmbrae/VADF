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

D=@(x,y)(1/((x^2+y^2)^(3/2))*[x;y]);

%% Berechnung von dBow
for k=1:nz
  for j=1:ny
    for i=1:nx
      
      n = 1+(i-1)*Mx+(j-1)*My+(k-1)*Mz;
      
      x=xmesh(i);
      y=ymesh(j);
      z=zmesh(k);    
      if i==nx
      dBow(n)=0;
      
      else
        
        if y==ymesh(1)
          x1=(xmesh(i+1)-x)/2+x;
          y1=y+((y-ymesh(j+1))*0.25);

        elseif y==ymesh(ny)
          x1=x1=(xmesh(i+1)-x)/2+x;
          y1=y-((y-ymesh(j-1))*0.25);
          
        else
          x1=(xmesh(i+1)-x)/2+x;
          y1=y;
        endif
      
      dBow(n)=D(x1,y1)(1);
      
    endif
    
      if y==ymesh(ny)
        dBow(n+np)=0;
      
    else
      
      if x==xmesh(1)
        x1=(xmesh(i+1)-x)*0.25+x;
        y1=(ymesh(j+1)-y)/2+y;
        
      elseif x==xmesh(nx)
        x1=x-(x-xmesh(i-1))*0.25;
        y1=(ymesh(j+1)-y)/2+y;
        
      else
        x1=x;
        y1=y1=(ymesh(j+1)-y)/2+y;
      endif
      
      dBow(n+np)=D(x1,y1)(2);     
     endif
    endfor
  endfor
 endfor 

  Dz=zeros(np,1);
  dBow=[dBow';Dz];
  
%% Isotrope Permittivität
eps_r = ones(3*np,1);

bc = 1; % PEC
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
eps_r(1:np) = 1;
eps_r(np+1:2*np) = 4;
eps_r(2*np+1:3*np)= 1;

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
