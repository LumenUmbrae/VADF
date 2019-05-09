%Skript zur Ueberpruefung der Orthogonalitaet

% Setzen der parameter n, ord, bc, L
n=6;
ord=2;
bc=0;
L=1;

% Erstellen der CC matrix
  cc=createCC(n,ord,bc);

% Gitterschrittweite bestimmen
  dx=L/(n-1);

% Loesen der Eigenwertgleichung mit solveCC
  [kx,modes] = solveCC(cc,dx)

% Ueberpruefung der Orthogonalitaet der Eigenvektoren
  orthogonal=modes*modes';
  imagesc(orthogonal);