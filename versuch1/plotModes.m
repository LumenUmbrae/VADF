%Skript zur Darstellung der ersten beiden Eigenmoden. Verwendet createCC 
%(Erstellung der Systemmatrix) und solveCC (Loesen des Eigenwertproblems).

% setzen der parameter n, ord, bc, L
n=100;
ord=4;
bc=2;
L=5;

% Erstellen der CC matrix
  cc=createCC(n, ord, bc);

% Gitterschrittweite bestimmen
  dx=L/(n-1);
% Loesen der Eigenwertgleichung mit solveCC
  [kx, modes] = solveCC(cc, dx);

% Sonderbetrachtung fuer magnetische Randbedingungen
if bc==2
    % Loesche ersten Mode, denn er ist nur die statische Loesung (konstant)
    modes=modes(:,2);
end

% x-Koordinaten fuer jede Stuetzstelle in einen Vektor schreiben
  for a=1:1:n
    xKoord(a) = -dx+a*dx;
  endfor
% Grundmode und 2.Mode plotten
figure(1)
hold all
plot(xKoord,modes(:,1));
plot(xKoord,modes(:,2));

hold off
legend({'erster Mode','zweiter Mode'},'Location','Southeast')
xlabel('x in m')
ylabel('Amplitude E-Feld (ohne Einheit)')
set(1,'papersize',[12,9])
set(1,'paperposition',[0,0,12,9])
print -dpdf modes.pdf