% Aufgabe 1,3,4,7,8,9
clear all;
%% Aufgabe 1
% -------------------------------------------------------------------------
% ------------ Problem modellieren ----------------------------------------
% -------------------------------------------------------------------------
% Konsolenausgabe
disp('Gitter erstellen')
% Erstellen des Gitters mit cartMesh
% xmesh = 
% ymesh = 
% zmesh = 
% msh = cartMesh(xmesh, ymesh, zmesh);

 xmesh = [1 2 3 4 5 6];
 ymesh = [1 2 3 4 5];
 zmesh = [1 2 3 4 5 6];
 msh = cartMesh(xmesh, ymesh, zmesh);

 np = msh.np;
 nx = msh.nx;
 ny = msh.ny;
 nz = msh.nz;
 Mx = msh.Mx;
 My = msh.My;
 Mz = msh.Mz;
 
 
 %Bestimmen der Abstände
 dX = [diff(xmesh), 0];
 dY = [diff(ymesh), 0];
 dZ = [diff(zmesh), 0];
 
 [ds, dst, da, dat] = createGeoMats(msh);

% tempM = eye(nx,nx).+diag(ones(nx-1,1),1); Bestimmen der dualen kantenlängen
 dDX = 0.5*dX*(eye(nx,nx).+diag(ones(nx-1,1),1));
 dDY = 0.5*dY*(eye(ny,ny).+diag(ones(ny-1,1),1));
 dDZ = 0.5*dZ*(eye(nz,nz).+diag(ones(nz-1,1),1));

% Randbedingung für alle Raumrichtungen definieren [xmin, xmax, ymin, ymax, zmin, zmax] (0 = magnetisch, 1 = elektrisch)

 bc = [ 1, 1, 1, 1, 1, 1] 

% Erstellen von jsbow
jsbow = zeros(3*np,1);

jsbow(84) = 1000;
jsbow(93) = -1000;
jsbow(267) = -1000;
jsbow(268) = 1000;

%TODO: Kapa und Mui von den Punkten auf die Flächen mitteln. Inverse von permeabilität bestimen mit der Formel, nihct nur inverse

% Erstellen der Materialverteilung mui und kappa mithilfe von boxmesher
disp('Materialmatrizen erstellen')
% boxeskappa(1).box = [ ,  ,  ,  ,  , ];
% boxeskappa(1).value = 
% kappa = boxMesher(msh, boxeskappa, ...);


%{
LeiterSchichten
%erstellen der kappas in die jeweiligen Richtungen
direcktionShift = 0;
kappa = zeros(3*np, 1);
i=1;
anzCondLayer = 2;
anzNodes = anzCondLayer*nx*nz

% x-Richtung
for i<=nz
  j =1;
  for j<=anzCondLayer
    k = 1;
    for k<=nx
      n = k*Mx+j*My+z*Mz;
      fac = 1;
      if k==nx
        fac = 0;
      endif
      if j==0|
      kappa(n) = 
      
      
    endfor
  endfor  
endfor
  




boxeskappa(1).box = [ 1, nx-1 , 1,  6,  1, 1]; 
boxeskappa(1).value = 0.5*10E6; %Leitwert von Fe
kappaI1 = boxMesher(msh, boxeskappa, 0);


boxeskappa(1).box = [ 1, nx-1 , 2,  6,  2, 2]; %obere Grenzschicht, Mitte
boxeskappa(1).value = 0.5*10E6; %Leitwert von Fe
kappaI2 = boxMesher(msh, boxeskappa, 0);

kappaI = kappaI1.+kappaI2;

boxeskappa(1).box = [ 1, 6 , 1,  5,  1, 1]; %untere Schicht
boxeskappa(1).value = 0.5*10E6; %Leitwert von Fe
kappaJ1 = boxMesher(msh, boxeskappa, 0);


boxeskappa(1).box = [ 1, 6 , 1,  5,  2, 2];
boxeskappa(1).value = 0.5*10E6; %Leitwert von Fe
kappaJ2 = boxMesher(msh, boxeskappa, 0);

kappaJ = kappaJ1.+kappaJ2;

boxeskappa(1).box = [ 1, 6 , 1,  6,  1, 1];
boxeskappa(1).value = 10E6; %Leitwert von Fe
kappaK = boxMesher(msh, boxeskappa, 0);

kappa = [kappaI; kappaJ; kappaK];
%}

boxeskappa(1).box = [ 1, 6, 1,  6,  1, 1];
boxeskappa(1).value = 10E6; %Leitwert von Fe
kappa = boxMesher(msh, boxeskappa, 0);

% boxesmu(1).box = [ ,  ,  ,  ,  , ];
% boxesmu(1).value = 
% mu = boxMesher(msh, boxesmu, ...);


boxesmu(1).box = [ 1, 6 , 1,  6,  1, 1];
boxesmu(1).value = 5000E-7 * 4*pi; %permabilität von Fe
mu = boxMesher(msh, boxesmu, pi*4E-7);

% Inverse Permeabilität berechnen (siehe Hinweis Aufgabe 1)
mui = nullInv(mu);


%% Aufgabe 3
% -------------------------------------------------------------------------
% ----------- Lösen des magnetostatischen Problems ------------------------
% -------------------------------------------------------------------------
solve_statik = true;
if solve_statik
	disp('Loesung des statischen Problems')
    
	% Solver benutzen, um A-Feld zu bestimmen
	[abow_ms, hbow_ms, bbow_ms, relRes] = solveMSVec(msh, mui, jsbow);
	
	% Grafisches Darstellen des magnetischen Vektorpotentials, am besten 
    % unter der Verwendung verschiedener Ebenen
	figure(1)
	plotEdgeVoltage(msh, abow_ms, 3,  bc)
	title('Statische Loesung des Vektorpotentials')

    % Grafisches Darstellen der z-Komponente des B-Feldes
##	  surf(xmesh,ymesh,
end

% Verschiebt diese Zeile zur nächsten Aufgabe, wenn Aufgabe 3 abgeschlossen ist
return


%% Aufgabe 5
% -------------------------------------------------------------------------
% ----------- Magnetoquasistatisches Problem im Frequenzbereich -----------
% -------------------------------------------------------------------------
disp('L�sung des quasistatischen Problems im Frequenzbereich')

% Frequenz festlegen
 f = 50;
 omega = 2*pi*f;
  
% Löser ausführen
[abow_mqs_f, hbow_mqs_f, bbow_mqs_f, jbow_mqs_f, relRes] = solveMQSF(msh, mui,...
                                                         kappa, jsbow, f, bc);

% Grafisches Darstellen der Stromdichte auf der Oberfläche der leitfähigen
% Platte (Real- und Imaginärteil)
figure(3)
plotEdgeVoltage(msh,real(jbow_mqs_f),2,bc)
title(['Realteil der Stromdichte auf der Plattenoberflaeche, '  ...
      'Quasistatik, Frequenzbereich'])
xlabel('x')
ylabel('y')

figure(4)
plotEdgeVoltage(msh,imag(jbow_mqs_f),2,bc)
title(['Imaginaerteil der Stromdichte auf der Plattenoberflaeche, '  ...
      'Quasistatik, Frequenzbereich'])
xlabel('x')
ylabel('y') 


%% Aufgabe 7
% -------------------------------------------------------------------------
% ----------- Magnetoquasistatisches Problem im Zeitbereich --------------
% -------------------------------------------------------------------------
disp('Loesung des quasistatischen Problems im Zeitbereich')

% Zeitparameter so setzen, dass drei Perioden durchlaufen werden
periods =   3                % Anzahl an Perioden 50Hz -> 0.02s 
nperperiod =     50            % Anzahl an Zeitpunkten pro Periode
tend =        0.06              % Endzeit
nt =        periods*nperperiod   % Gesamtzahl an Zeitpunkten
time =  linspace(0,tend,nt)                    % Zeit-Vektor

% Anfangswert für die Lösung der DGL wählen
 abow_init = zeros(np,1);

% Anregung jsbow als Funktion der Zeit
 jsbow_t = @(t)(jsbow*sin(omega*t));

% Lösen des MQS-Problems
[abow_mqs_t, hbow_mqs_t, bbow_mqs_t, jbow_mqs_t, ebow_mqs_t] = solveMQST(msh, mui, kappa, abow_init, jsbow_t, time, bc);

% Index für Plot wählen
i = 3; j = 2; k = 2;
idx2plot = 1 + (i-1)*Mx + (j-1)*My + (k-1)*Mz;

% Vektorpotential (Lösung der DGL) für gewählte primäre Kante (idx2plot) über die Zeit plotten
figure(5)
plot(time,abow_mqs_t(idx2plot,:));
title('Loesung des quasistatischen Problems im Zeitbereich');
xlabel('Zeit');
ylabel('Vektorpotential abow_{mqs,t}');

% Stromdichteverteilung für gewählte duale Fläche (idx2plot) über die Zeit plotten
figure(6)
plot(time,jbow_mqs_t(idx2plot,:));
title('Loesung des quasistatischen Problems im Zeitbereich');
xlabel('Zeit');
ylabel('Strom jbow_{mqs,t}');
%{

%% Aufgabe 8
% -------------------------------------------------------------------------
% ----------     Vergleich Frequenzbereich <=> Zeitbereich        ---------
% ---------- Transformation Lösung Frequenzbereich in Zeitbereich ---------
% ----------          Vergleich Real- und Imaginärteil            ---------
% -------------------------------------------------------------------------
disp('Vergleich Frequenzbereich <=> Zeitbereich')

% Transformation der Frequenzbereichslösung in den Zeitbereich
% abow_mqs_f_t = ;
% jbow_mqs_f_t = ;

% Vektorpotential (Lösung der DGL) Frequenzbereich vs. Zeitbereich für gewählte duale Fläche (idx2plot) über die Zeit plotten
figure(7)
plot(time,abow_mqs_t(idx2plot,:),'b-');
hold on
plot(time,abow_mqs_f_t(idx2plot,:),'g--');
hold off
title('Vergleich Zeitloesung zu Frequenzloesung')
xlabel('Zeit t')
ylabel('Vektorpotential abow_{mqs,t}')
legend('Zeitloesung','Frequenzloesung')

% Stromdichte-Lösung Frequenzbereich vs. Zeitbereich für gewählte duale Fläche (idx2plot) über die Zeit plotten
figure(8)
plot(time,jbow_mqs_t(idx2plot,:),'b-');
hold on
plot(time,jbow_mqs_f_t(idx2plot,:),'g--');
hold off
title('Vergleich Zeitloesung zu Frequenzloesung')
xlabel('Zeit t')
ylabel('Strom jbow_{mqs,t}')
legend('Zeitloesung','Frequenzloesung')

% Vergleich von Zeitlösung zur Frequenzlösung im Zeitbereich
% -> Implementierung der Fehlernorm aus der Aufgabenstellung
% ...
% ...
% ...
% errorTimeVSfrequency = 
% fprintf('Relativer Fehler im Zeitbereich: %e\n',errorTimeVSfrequency);

%% Aufgabe 9
% -------------------------------------------------------------------------
% ----------     Vergleich Frequenzbereich <=> Zeitbereich        ---------
% ---------- Transformation Lösung Zeitbereich in Frequenzbereich ---------
% ----------               Vergleich der Phasoren                 ---------
% -------------------------------------------------------------------------

% (Vergleich der Phasoren)

% Transformation der Zeitbereichslösung in den Frequenzbereich
% Bestimmung von Real- und Imaginärteil des komplexen Phasors,
% der aus dem Zeitsignal gewonnen werden kann
    % t_real =
    % t_imag =
    jbow_re_t = zeros(3*msh.np,1);
    jbow_im_t = zeros(3*msh.np,1);
    for i = 1:3*msh.np
    %    jbow_re_t(i) = interp1(...);
    %    jbow_im_t(i) = ...
    end


% Vergleich von Real- und Imaginärteil des Phasors aus dem Zeitbereich
% mit dem Phasor aus der Frequenzbereichslösung (Implementierung der Formel aus Aufgabenstellung)
% errorPhasorReal = ...
% errorPhasorImag = ...
% fprintf('Relativer Fehler Realteil: %e\n',errorPhasorReal);
% fprintf('Relativer Fehler Imaginärteil: %e\n',errorPhasorImag);
  
% Plot: gleiches Feldbild für Phasoren des Zeitintegration zum optischen 
% Vergleich mit den Plots, die man für die Phasoren des Frequenzbereiches
% erhalten hat
figure(9)
plotEdgeVoltage(msh,jbow_re_t, 2, bc)
title(['Realteil der Stromdichte auf der Plattenoberflaeche, '  ...
      'Quasistatik, Zeitbereich'])
xlabel('x')
ylabel('y')
zlabel('z')
figure(10)
plotEdgeVoltage(msh,jbow_im_t, 2, bc)
title(['Imaginaerteil der Stromdichte auf der Plattenoberflaeche, '  ...
      'Quasistatik, Zeitbereich'])
xlabel('x')
ylabel('y')
zlabel('z')


%% Aufgabe 10
% -------------------------------------------------------------------------
% -------------- Konvergenz des Fehlers der Zeitintegration ---------------
% -------------------------------------------------------------------------

% Konvergenz des Fehlers der Zeitintegration
% nperperiodMax = 100
% plotConvSolveMQST(msh,mui,kappa,jsbow_t,jbow_mqs_f,periods,tend,f,nperperiodMax,bc);
%}