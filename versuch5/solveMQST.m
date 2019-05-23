% Aufgabe 6
%
% Einfacher Solver fuer magnetoquasistatische Probleme im Zeitbereich
%
%   Eingabe
%   msh        Kanonisches kartesisches Gitter
%   mui         Inverse Permeabilitaet entsprechend Methode createMmui
%   kap         Leitfaehigkeit kappa, die entsprechend Methode createMeps
%               berechnet werden kann.
%   abow_init   Anfangswert für die DGL (3*np-by-1)
%   jsbow_t     Stromgitterfluss (Erregung), als Funktion der Zeit
%   time        Zeit-Vektor
%
%   Rückgabe
%   abow        Integriertes magnetisches Vektorpotential
%   hbow        Magnetische Gitterspannung
%   bbow        Magnetischer Gitterfluss
%   jbow        Elektrischer Stromfluss 
%   ebow        Elektrische Gitterspannung
%   bc          Randbedingungen (0=magnetisch, 1=elektrisch)

function [abow, hbow, bbow, jbow, ebow] = solveMQST(msh, mui, kap, abow_init, jsbow_t, time, bc)

    % Erzeugung topologische Matrizen
    [c, s, st] = createTopMats(msh);
        
    % Erzeugung geometrische Matrizen
    [ds, dst, da, dat] = createGeoMats(msh);
        
    % Erzeugung Materialmatrix inverse Permeabilitaet
    mmui = createMmui(msh, ds, dst, da, mui, bc);
    mkap = createMeps(msh, ds, da, dat, kap, bc);
    
    % Anzahl der Zeitpunkte auslesen
    nt = length(time);
       
    % Speichermatrizen fuer die Felder zu bestimmten Zeiten
    np = msh.np;
    ebow = zeros(3*np, nt);
    bbow = zeros(3*np, nt);
    hbow = zeros(3*np, nt);
    jbow = zeros(3*np, nt);    
    
    % Initialisierung
    abow_t = abow_init;

    % Zeitintegrationsschleife
    %% wenn man n t Punkte hat dann n-1 tau intervale
    for i=1:(nt-1)
      
        tau = time(i+1)-time(i);
      
      

      % Alten Feldwert des Vektorpotentials speichern
       abow_t_old = abow_t;
      
      % Systemmatrix erstellen At
       A =c'*mmui*c+(1/tau)*mkap;
      
      % Rechte Seite rhs fuer diesen Zeitschritt bestimmen
       je = jsbow_t(time(i+1));
       rhs = je + (1/tau)*mkap*abow_t_old;  
      
      % Gleichungssystem loesen
      abow_t = pcg(A,rhs,1e-6,500);
      
      % Update der elektrischen Gitterspannung ebow_t 
	  % Rückwärtsdifferenzenquotienten verwenden, nicht Formel aus Vorbereitung!
       ebow_t = -(abow_t-abow_t_old)/tau; %% e = -(1/dt)*a from rotE=-(1/dt)*B 
           
      % Magnetische Gitterspannung, magnetischen Fluss und
      % Stromgitterfluss für diesen Zeitschritt speichern
      abow(:,i) = abow_t; %% A
      ebow(:,i) = ebow_t; %% E
      bbow(:,i) = c*abow_t; %% rot A
      hbow(:,i) = mmui*bbow(:,i); %%mu*B
      jbow(:,i) = mkap*ebow_t; %% kap*E
    end
end