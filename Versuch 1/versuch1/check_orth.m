%Skript zur Überprüfung der Orthogonalität

% Setzen der parameter n, ord, bc, L
n=5;
ord=4;
bc=2;
L=1;

% Erstellen der CC matrix
  cc=createCC(n,ord,bc);

% Gitterschrittweite bestimmen
  dx=L/(n-1);

% Lösen der Eigenwertgleichung mit solveCC
  [kx,modes] = solveCC(cc,dx)

% Überprüfung der Orthogonalität der Eigenvektoren
  orthogonal=modes*modes';
  imagesc(orthogonal);