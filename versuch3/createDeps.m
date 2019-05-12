% Methode zur Erstellung der Materialmatrix Deps.
%
% Eingabe 
%	msh         kartesisches Gitter, erzeugt von cartMesh
% 	DA          Die DA Matrix, erzeugt von createDA (DS) 
% 	DAt         Die DAt Matrix, erzeugt von createDA (DSt) 
%	eps_r       Ein Vektor der Länge np, in dem die relativen
%               Epsilon-Werte für alle Elemente in kanonischer
%               Indizierung eingetragen sind.
%   bc          bc=0 für keine Randbedingungen
%				bc=1 für elektrische Randbedingungen
%
% Rückgabe 
%	Deps        Die Matrix Deps der gemittelten Permittivitäten


function [ Deps ] = createDeps( msh, DA, DAt, eps_r, bc )

if size(eps_r,1) == msh.np
    eps_r = [eps_r;eps_r;eps_r];
end

% für diese Funktion brauchen wir die folgenden Größen des Meshes
nx = msh.nx;
ny = msh.ny;
nz = msh.nz;
np = msh.np;
Mx = msh.Mx;
My = msh.My;
Mz = msh.Mz;

% Berechnen der Permittivität aus der relativen Permittivität
eps0 = 8.854187817*10^-12;
eps =eps0*eps_r; 

% Nur die Diagonale der DA und DAt Matrix ist besetzt, also brauchen wir nur die Diagonale
At = diag(DAt);
A  = diag(DA);

% Berechnen der Flächen für die Flächen in x-, y- und z-Richtung
Atx = At(1:np);
Aty = At(np+1:2*np); 
Atz = At(np*2+1:3*np); 

Ax = A(1:np); 
Ay = A(np+1:2*np);
Az = A(2*np+1:3*np);

% Erstellen der Vektoren für die gemittelten epsilon Werte für x-, y- und z-Flächen
meanEpsX = zeros(np, 1);
meanEpsY = zeros(np, 1);
meanEpsZ = zeros(np, 1);

% Gehe durch alle Punkte und setze die gemittelten epsilon Werte für x-, y- und z-Flächen
% Beachten Sie, dass manche Indizes in der Formel im Skript kleiner als 1 werden können und
% damit speziell behandelt werden müssen (if anweisung)
eps_x=eps(1:np);
eps_y=eps(np+1:2*np);
eps_z=eps(2*np+1:3*np);

for i = 1:nx
    for j = 1:ny
        for k = 1:nz
          n=1+(i-1)*Mx+(j-1)*My+(k-1)*Mz;
          %% alle Richtungen
          meanEpsX(n)= eps_x(n)*Ax(n);
          meanEpsY(n)= eps_y(n)*Ay(n);
          meanEpsZ(n)= eps_z(n)*Az(n);
          if n > Mz
            meanEpsX(n)+=(eps_x(n-Mz)*Ax(n-Mz));
            meanEpsY(n)+=(eps_y(n-Mz)*Ay(n-Mz));
          endif
          
          if n > My
            meanEpsX(n)+=(eps_x(n-My)*Ax(n-My));
            meanEpsZ(n)+=(eps_z(n-My)*Az(n-My));
          endif
          
          if n > Mx
            meanEpsY(n)+=(eps_y(n-Mx)*Ay(n-Mx));
            meanEpsZ(n)+=(eps_z(n-Mx)*Az(n-Mx));
          endif
          if n > Mz + My
            meanEpsX(n)+=(eps_x(n-Mz-My)*Ax(n-Mz-My));
          endif
           if n > Mx + My
            meanEpsZ(n)+=(eps_z(n-Mx-My)*Az(n-Mx-My));
          endif
          if n > Mx + Mz
            meanEpsY(n)+=(eps_y(n-Mx-Mz)*Ay(n-Mx-Mz));
          endif
          meanEpsX(n)/=(4*Atx(n));
          meanEpsY(n)/=(4*Aty(n));
          meanEpsZ(n)/=(4*Atz(n));
        
        end
    end
end
    
    
    
    


%% Randbedingungen

% Spezialfall nur bei PEC Rand (bc=1)
if bc==1
    for i=1:nx
        for j=1:ny
            for k=1:nz
            n=1+(i-1)*Mx+(j-1)*My+(k-1)*Mz;
            if k==1 || k==nz
             meanEpsX(n)=0; 
             meanEpsY(n)=0;
            endif
            if j==1 || j==ny
             meanEpsX(n)=0; 
             meanEpsZ(n)=0;
             endif
             if i==1 || i==nx
             meanEpsZ(n)=0; 
             meanEpsY(n)=0;
            
            endif
            end
        end
    end
end
%%% Magnetische Randbedigugen normale Komponente =0
if bc==2
    for i=1:nx
        for j=1:ny
            for k=1:nz
            n=1+(i-1)*Mx+(j-1)*My+(k-1)*Mz;
            if k==1 || k==nz
             meanEpsZ(n)=0; 
            
            endif
            if j==1 || j==ny
             meanEpsY(n)=0; 
             
             endif
             if i==1 || i==nx
             meanEpsX(n)=0; 
             
            
            endif
            end
        end
    end
end
    
% Matrix Deps mithilfe des Diagonalenvektors (spdiags) erzeugen
Deps = spdiags([meanEpsX; meanEpsY; meanEpsZ], 0, 3*np, 3*np);
    
end