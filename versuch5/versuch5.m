% Aufgabe 1,3,4,7,8,9
clear all;
close all;
%% Aufgabe 1
% -------------------------------------------------------------------------
% ------------ Problem modellieren ----------------------------------------
% -------------------------------------------------------------------------
% Konsolenausgabe
disp('Gitter erstellen')
% Erstellen des Gitters mit cartMesh

 xmesh = [1 2 3 4 5 6];
 ymesh = [1 2 3 4 5 6];
 zmesh = [1 2 3 4 5];
 msh = cartMesh(xmesh, ymesh, zmesh);

 np = msh.np;
 nx = msh.nx;
 ny = msh.ny;
 nz = msh.nz;
 Mx = msh.Mx;
 My = msh.My;
 Mz = msh.Mz;


% Randbedingung für alle Raumrichtungen definieren [xmin, xmax, ymin, ymax, zmin, zmax] (0 = magnetisch, 1 = elektrisch)

bc = [ 0, 0, 0, 0, 0, 0] 

% Erstellen von jsbow
jsbow = zeros(3*np,1);

jsbow(87) = 1000;
jsbow(93) = -1000;
jsbow(267) = -1000;
jsbow(268) = 1000;

% Erstellen der Materialverteilung mui und kappa mithilfe von boxmesher
disp('Materialmatrizen erstellen');

boxeskappa(1).box = [ 1, 6, 1,  6,  1, 1];
boxeskappa(1).value = 5.8*10^7; %Leitwert von Fe
kappa = boxMesher(msh, boxeskappa, 0);


boxesmu(1).box = [ 1, 6 , 1,  6,  1, 1];
boxesmu(1).value = 1000E-7 * 4*pi; %permabilität von Fe
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
  xlabel('x')
  ylabel('y')

    % Grafisches Darstellen der z-Komponente des B-Feldes
	  bbow_ms_z=bbow_ms(2*msh.np+1+2*nx*ny:2*msh.np+3*nx*ny);
    
    [X,Y]=meshgrid(xmesh,ymesh);
    
    
    toplot=reshape(bbow_ms_z,nx,ny);
    figure(2)
    surf(X,Y,toplot');
end

% Verschiebt diese Zeile zur nächsten Aufgabe, wenn Aufgabe 3 abgeschlossen ist


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
tend =        periods/f            % Endzeit
nt =        periods*nperperiod   % Gesamtzahl an Zeitpunkten
time =  linspace(0,tend,nt)                    % Zeit-Vektor

% Anfangswert für die Lösung der DGL wählen
 abow_init =zeros(3*np,1);

% Anregung jsbow als Funktion der Zeit
 jsbow_t = @(t)(jsbow*cos(omega*t));

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

%return


%% Aufgabe 8
% -------------------------------------------------------------------------
% ----------     Vergleich Frequenzbereich <=> Zeitbereich        ---------
% ---------- Transformation Lösung Frequenzbereich in Zeitbereich ---------
% ----------          Vergleich Real- und Imaginärteil            ---------
% -------------------------------------------------------------------------
disp('Vergleich Frequenzbereich <=> Zeitbereich')

% Transformation der Frequenzbereichslösung in den Zeitbereich
time
 abow_mqs_f_t = abs(abow_mqs_f).*cos(omega*time+angle(abow_mqs_f));
 jbow_mqs_f_t = abs(jbow_mqs_f).*cos(omega*time+angle(jbow_mqs_f));

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
 norm1_t = norm(jbow_mqs_t-jbow_mqs_f_t);
 norm2_t = norm(jbow_mqs_f_t);
 errorTimeVSfrequency = max(norm1_t)/max(norm2_t)
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
     t_real = 0;
     t_imag = 3/(f*4);
    jbow_re_t = zeros(3*msh.np,1);
    jbow_im_t = zeros(3*msh.np,1);
    for k = 1:3*msh.np
        jbow_re_t(k) = interp1(time,jbow_mqs_t(k,:),t_real);
        jbow_im_t(k) = interp1(time,jbow_mqs_t(k,:),t_imag);
    end


% Vergleich von Real- und Imaginärteil des Phasors aus dem Zeitbereich
% mit dem Phasor aus der Frequenzbereichslösung (Implementierung der Formel aus Aufgabenstellung)
 errorPhasorReal = norm(jbow_re_t-real(jbow_mqs_f))./norm(real(jbow_mqs_f));
 errorPhasorImag = norm(jbow_im_t-imag(jbow_mqs_f))./norm(imag(jbow_mqs_f));
 fprintf('Relativer Fehler Realteil: %e\n',errorPhasorReal);
 fprintf('Relativer Fehler Imaginärteil: %e\n',errorPhasorImag);
  
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
 nperperiodMax = 100
 plotConvSolveMQST(msh,mui,kappa,jsbow_t,jbow_mqs_f,periods,tend,f,nperperiodMax,bc);
