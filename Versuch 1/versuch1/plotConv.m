%Skript fuer die Darstellung des Konvergenzverhaltens der Loesung der
%eindimensionalen Wellengleichung. Verwendet createCC (Erstellung der
%Systemmatrix) und solveCC (Loesen des Eigenwertproblems).
%
%   Eingabe
%   L           Abmessung/Laenge des eindimensionalen Gebietes
%   nmax        Maximale Stuetzstelleanzahl
%   kxind       Betrachtete Mode (Grundmode=1)
%
%   Rueckgabe
%   figure(1)   Plot Konvergenzverhalten kx, linear (wird abgespeichert in
%               plotConv.pdf)
%   figure(2)   Plot Konvergenzverhalten fehler, doppelt-logarithmisch (wird
%               abgespeichert in plotConvloglog.pdf)

% Setzen der Parameter
nmax = 100;
L = 1;
kxind = 1;
nOrd2 = 3:nmax;
nOrd4 = 5:nmax;
dx=@(n)(L./(n.-1));

% Konvergenzstudie fuer Ordnung 2 und keine Randbedingung
disp('Konvergenzstudie fuer Ordnung 2 und keine Randbedingung')
kxOrd2bc0 = zeros(length(nOrd2),1);
for i=1:length(nOrd2)
  n = nOrd2(i);
  kx=solveCC(createCC(n,2,0),dx(n));
  kxOrd2bc0(i) =kx(kxind) ;
end;


% Konvergenzstudie fuer Ordnung 4 und keine Randbedingung
disp('Konvergenzstudie fuer Ordnung 4 und keine Randbedingung')
kxOrd4bc0 = zeros(length(nOrd4),1);
for i=1:length(nOrd4)
  n = nOrd4(i);
kx=solveCC(createCC(n,4,0),dx(n));
  kxOrd4bc0(i) =kx(kxind) ;
end;

% Konvergenzstudie fuer Ordnung 2 und elektrische Randbedingung
disp('Konvergenzstudie fuer Ordnung 2 und elektrische Randbedingung')
kxOrd2bc1 = zeros(length(nOrd2),1);
for i=1:length(nOrd2)
  n = nOrd2(i);
kx=solveCC(createCC(n,2,1),dx(n));
  kxOrd2bc1(i) =kx(kxind) ;
end;

% Konvergenzstudie fuer Ordnung 4 und elektrische Randbedingung
disp('Konvergenzstudie fuer Ordnung 4 und elektrische Randbedingung')
kxOrd4bc1 = zeros(length(nOrd4),1);
for i=1:length(nOrd4)
  n = nOrd4(i);
kx=solveCC(createCC(n,4,1),dx(n));
  kxOrd4bc1(i) =kx(kxind) ;
end;


% Formel fuer analytische Luesung
 kxAna=@(n)(ones(length(n),1)*(pi/L));


% Plot fuer die Wellenzahl ueber Stuetzstellenanzahl
figure(1)
hold on
plot(nOrd2,kxAna(nOrd2));
plot(nOrd2,kxOrd2bc0);
plot(nOrd4,kxOrd4bc0);
plot(nOrd2,kxOrd2bc1);
plot(nOrd4,kxOrd4bc1);
hold off
legend({'analytische Wellenzahl',...
        'zweite Ordnung ohne Randbed.','vierte Ordnung ohne Randbed.',...
        'zweite Ordnung mit Randbed.','vierte Ordnung mit Randbed.'
       },...
        'Location','Southeast')
xlabel('Stuetzstellenanzahl')
ylabel('Wellenzahl in 1/m')
set(1,'papersize',[12,9])
set(1,'paperposition',[0,0,12,9])
print -dpdf plotConv.pdf

% Plot fuer den relativen Wellenzahlfehler ueber Gitterschrittweite (loglog)
figure(2)
clf
hold on
plot(dx(nOrd2),abs(kxOrd2bc0-kxAna(nOrd2)));
plot(dx(nOrd4),abs(kxOrd4bc0-kxAna(nOrd4)));
plot(dx(nOrd2),abs(kxOrd2bc1-kxAna(nOrd2)));
plot(dx(nOrd4),abs(kxOrd4bc1-kxAna(nOrd4)));
hold off
%%%
%%% Ich weiss nicht

legend({'zweite Ordnung ohne Randbed.','vierte Ordnung ohne Randbed.',...
        'zweite Ordnung mit Randbed.','vierte Ordnung mit Randbed.'
       }, 'Location','Southeast')
xlabel('Gitterschrittweite')
ylabel('rel. Fehler der Wellenzahl')
set(2,'papersize',[12,9])
set(2,'paperposition',[0,0,12,9])
print -dpdf plotConvloglog.pdf