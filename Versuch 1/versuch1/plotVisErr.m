%Skript zur Darstellung der Diskretisierungsfehler eines Zylinders.
%
%   Eingabe
%   nmax        Maximale Stützstellenanzahl
%
%   Rückgabe
%   figure(1)   Plot Fehler doppelt-logarithmisch (wird abgespeichert 
%               in plotVisErrloglog.pdf)

% Parameter setzen
nmax=100000;   %100000
r=1;
h=5;

% Vektor mit verschiedener Anzahl von Dreicken
nd=3:nmax;

% Berechnung von diskreter Oberfläche und Volumen 
 oberflaecheDiskrete = 2.*nd.*r.*(1/2.*r.*sin(2.*pi./nd).+sin(pi./nd).*h);
 volumenDiskrete = 1/2.*r.^2.*sin(2.*pi./nd).*nd.*h;

% Berechnung von analytischer Oberfläche und Volumen 
 oberflaecheAnalytisch = 2.*pi.*r.*(r.+h);
 volumenAnalytisch = pi.*r.^2.*h;

% Berechnung von Oberflächen- und Volumenfehler
 oberflaechenFehler = abs(oberflaecheDiskrete-oberflaecheAnalytisch);
 volumenFehler = abs(volumenDiskrete-volumenAnalytisch);


% Plotten der beiden Fehler über nd
figure(1)
    loglog(nd,oberflaechenFehler,nd,volumenFehler)
    xlabel('Anzahl Dreiecke Deckelfläche')
    ylabel('relativer Fehler')
    legend({'Oberflächenfehler',...
            'Volumenfehler'},...
            'Location','Northeast')
    set(1,'papersize',[12,9])
    set(1,'paperposition',[0,0,12,9])
    print -dpdf plotVisErrloglog.pdf
    
    
% nd für Fehler kleiner als 10^(-5) finden
%Marc 
%for i=1:columns(nd)
%  if (volumenFehler(i)<10^-5)
%    Dreiecke=i+2
%    break;
%  endif
%endfor
for i=1:columns(nd)
  if oberflaechenFehler(i)<10^(-5) && volumenFehler(i)<10^(-5)
    Dreiecke = i+2
    break;
    endif
endfor



