% Aufgabe 10
%
% plotConvSolveMQST(msh,mui,kappa,jsbow,jbow_mqs_f,tend,f,ntmax, bc) stellt den 
% relativen Fehlers der Lösung im Zeitbereich abhängig
% von der Schrittweite bezüglich der Lösung im Frequenzbereich in der
% 2-Norm (siehe norm(A,p)) dar.
%
%   Parameter
%   msh            Kanonisches kartesisches Gitter
%   mui            Inverse Permeabilität entsprechend Methode createMmui
%   kappa          Leitfähigkeit entsprechend Methode createMeps
%   jsbow          Stromgitterfluss (Erregung)
%   jbow_mqs_f     Referenzlösung im Frequenzbereich
%   periods        Anzahl der zu simulierenden Perioden des Zeitsignals
%   tend           Endzeitpunkt
%   f              Frequenz der Anregung
%   nperperiodMax  Maximale Stützstellenzahl pro Periode
%   bc             Randbedingungen (0=magnetisch, 1=elektrisch)

function plotConvSolveMQST(msh, mui, kappa, jsbow, jbow_mqs_f, periods, tend, f, nperperiodMax, bc)

% Kreisfrequenz
 omega = 2*pi*f;

% Samples pro Periode als Vektor für Konvergenzstudie 
nperperiod_vec=floor(linspace(5,nperperiodMax,5));

% Initialisierung des Fehlers
errorTimeDomain = zeros(length(nperperiod_vec),1);
errorPhasorReal = zeros(length(nperperiod_vec),1);
errorPhasorImag = zeros(length(nperperiod_vec),1);

% Anfangswert für die Lösung der DGL im Zeitbereich wählen
 abow_init = zeros(3*msh.np,1);

for k=1:length(nperperiod_vec)

    nperperiod = nperperiod_vec(k);
    nt = periods*nperperiod + 1;
    time = linspace(0,tend,nt);
    
	% Löse MQS im Zeitbereich
    [~, ~, ~, jbow_mqs_t,~] = solveMQST(msh, mui, kappa, abow_init, jsbow, time, bc);

    % Transformation der Frequenzbereichslösung in den Zeitbereich
      jbow_mqs_f_t = abs(jbow_mqs_f).*cos(omega*time+angle(jbow_mqs_f));
    
    % Vergleich von Zeitlösung zur Frequenzlösung im Zeitbereich
    % -> Implementierung der Fehlernorm aus der Aufgabenstellung
##    norm1_t = norm(jbow_mqs_t-jbow_mqs_f_t);
##    norm2_t = norm(jbow_mqs_f_t);
##    errorTimeDomain(k) = max(norm1_t)/max(norm2_t);

    for j=1:nt
    errorNormeachTimeStep=norm(jbow_mqs_t(:,j)-jbow_mqs_f_t(:,j));
    referenceNormEachTimeStep=norm(jbow_mqs_f_t(:,j));
  endfor
  errorTimeDomain(k)=max(errorNormeachTimeStep)/(referenceNormEachTimeStep);


	% Vergleich von Zeitlösung zur Frequenzlösung im Frequenzbereich
    % (Vergleich der Phasoren)

    % Real- und Imaginärteil der Stromdichte aus Zeitsignal bestimmen
    t_real = 1/f;
    t_imag = 3/(4*f);
    jbow_re_t = zeros(3*msh.np,1);
    jbow_im_t = zeros(3*msh.np,1);
    for j = 1:3*msh.np
        jbow_re_t(j) = interp1(time,jbow_mqs_t(j,:),t_real);
        jbow_im_t(j) = interp1(time,jbow_mqs_t(j,:),t_imag);
    end

    % Fehler Real- und Imaginärteil
    errorPhasorReal(k) = norm(jbow_re_t-real(jbow_mqs_f),2)/norm(real(jbow_mqs_f),2);
    errorPhasorImag(k) = norm(jbow_im_t-imag(jbow_mqs_f),2)/norm(imag(jbow_mqs_f),2);
end

% Plot Vergleich im Zeitbereich
figure(11)
 loglog(nperperiod_vec,errorTimeDomain,'-x','LineWidth',2)
xlabel('Anzahl der Stuetzstellen pro Periode')
ylabel('Relativer Fehler im Zeitbereich')

% Plot Vergleich im Frequenzbereich (Vergleich der Phasoren)
figure(12)
 loglog(nperperiod_vec,errorPhasorReal,'-x','LineWidth',2)
hold all
 loglog(nperperiod_vec,errorPhasorImag,'-x','LineWidth',2)
hold off
xlabel('Anzahl der Stuetzstellen pro Periode')
ylabel('Relativer Fehler im Frequenzbereich')
legend('Realteil','Imaginaerteil')