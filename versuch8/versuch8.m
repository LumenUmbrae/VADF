%% Wähle inhomogen oder homogen
material_option = 'homogen';
% material_option = 'inhomogen';

%% Materialdaten und rot-Operator der Leitung laden
if strcmp( material_option, 'homogen' )
    mur = 1;
    epsr = 0.9;
	[Meps,Mmui,C] = setupProblem(epsr,mur);
elseif strcmp( material_option, 'inhomogen' )
    load material_data
    Mepsi = Mepsi_inhomogen;
    Mmui = Mmui_inhomogen;
    % Erstellen der nicht-inversen Kapazitätsmatrix
    Meps=nullInv(Mepsi);
else
    error('unknown material option. material_option should be either homogen or inhomogen')
end

% Initialisierung
nx=4; ny=4; nz=151;
np=nx*ny*nz;
Mx=1; My=nx; Mz=nx*ny;
h=sparse(3*np,1);
e=sparse(3*np,1);

% checks correct size of mesh. Otherwise generates exception.
assert(np==size(Mmui,1)/3)

%% R-Matrix erstellen
R = 50;
Rmat = ohmic_termination_distributed_front_and_back(np, R);

%% Simulation in Zeitbereich
% initialisiere Feldwerte und Parameter
nts = 1500;
dt = 2.1e-11;
time = 0:dt:(nts*dt);
fmax = 1e9;

% Sampling-Frequenz der Zeitdiskretisierung
Fs = 1./dt; 
fprintf('Sampling-Frequenz: %d Hz\n',Fs);

% index used for current and voltage measurements
idx2measure = 5;

% Initialisierung
ebow = zeros(3*np,1);
hbow = zeros(3*np,1);
U1 = zeros(1,nts);
I1 = zeros(1,nts);
U2 = zeros(1,nts);
I2 = zeros(1,nts);

% Anregungssignal (verteilter eingeprägter Strom von Außen- zu Innenleiter an vorderer Stirnfläche)
je = gauss_pulse(time, fmax, np, true);

% Zeitschleife
tic;
for k=2:nts
    dt = time(k) - time(k-1); 
        
    [hbow,ebow] = leapfrog(hbow, ebow, je(:,k), Mmui, Meps, C, Rmat, dt);

    % Spannung und Strom f�r Ein- und Ausgang
    U1(k) = ebow(5);
    I1(k) = sum(abs(je(:,k))) - U1(k)/R;
    U2(k) = ebow(2405);
    I2(k) = -U2(k)/R;
    
end
time_TD = toc;

figure(1)
subplot(2,2,1)
plot(time(2:end),U1);
xlabel('Zeit in s')
ylabel('U_1 in V')
title('Eingangsspannung im Zeitbereich')

subplot(2,2,2)
plot(time(2:end),I1);
xlabel('Zeit in s')
ylabel('I_1 in A')
title('Eingangsstrom im Zeitbereich')

subplot(2,2,3)
plot(time(2:end),U2);
xlabel('Zeit in s')
ylabel('U_2 in V')
title('Ausgangsspannung im Zeitbereich')

subplot(2,2,4)
plot(time(2:end),I2);
xlabel('Zeit in s')
ylabel('I_2 in V')
title('Ausgangsstrom im Zeitbereich')


%% Transformation in den Frequenzbereich zur Auswertung der Impedanz

% Anzahl an Samples Ns, zero-padding zp, Anzahl an Samples für fft N und maximale zu plottende Frequenz fmax2plot
Ns = length(time);
zp = 10000;
N = 2^(nextpow2(Ns+zp));
fmax2plot = 200*10^6;

% Transformation der Eingangsgrößen
[U1_fft,freq]=fftmod(U1,N,Fs);
I1_fft=fftmod(I1,N,Fs);

% Transformation der Ausgangsgrößen
U2_fft=fftmod(U2,N,Fs);
I2_fft=fftmod(I2,N,Fs);
        
% Darstellung der Spannungen und Ströme an Ein-/Ausgang im Frequenzbereich
figure(2)
subplot(2,2,1)
plot(freq,abs(U1_fft));
xlabel('Frequenz in Hz')
ylabel('U_1 in V')
title('Eingangsspannung im Frequenzbereich')
xlim([0 2*fmax]);

subplot(2,2,2)
plot(freq,abs(I1_fft));
xlabel('Frequenz in Hz')
ylabel('I_1 in A')
title('Eingangsstrom im Frequenzbereich')
xlim([0 2*fmax]);

subplot(2,2,3)
plot(freq,abs(U2_fft));
xlabel('Frequenz in Hz')
ylabel('U_2 in V')
title('Ausgangsspannung im Frequenzbereich')
xlim([0 2*fmax]);

subplot(2,2,4)
plot(freq,abs(I2_fft));
xlabel('Frequenz in Hz')
ylabel('I_2 in A')
title('Ausgangsstrom im Frequenzbereich')
xlim([0 2*fmax]);    

        
%% Darstellung der Ein-/Ausgangsimpedanz im Frequenzbereich

% Berechnung Ein- und Ausgangsimpedanz im Frequenzbereich
Z1_fft=U1_fft./I1_fft;
Z2_fft=U2_fft./I2_fft;

figure(3);
plot(freq,abs(Z1_fft),'k-');
xlabel('Frequenz in Hz');
ylabel('Z_1 in \Omega');
title('Eingangsimpedanz');
xlim([0 fmax2plot]);
ylim([12 22]);

figure(4);
plot(freq,abs(Z2_fft),'b-');
xlabel('Frequenz in Hz');
ylabel('Z_2 in \Omega');
title('Ausgangsimpedanz');
xlim([0 fmax2plot]);
ylim([45 55]);

                
%% Auswertung Wellengrößen
    
Zwsqrt = sqrt(R);

a1 = (1/2)*(U1_fft./Zwsqrt.+I1_fft.*Zwsqrt);
b1 = (1/2)*(U1_fft./Zwsqrt.-I1_fft.*Zwsqrt);
b2 = (1/2)*(U2_fft./Zwsqrt.-I2_fft.*Zwsqrt);
%
S11 = b1./a1;
S21 = b2./a1;

energy = abs(S11).^2+abs(S21).^2

% Darstellung Energie und Wellengr��en
figure(5);
plot(freq, abs(S11),freq,abs(S21),freq,energy);
xlabel('Frequenz in Hz')
ylabel('S-Parameter in \Omega')
title('S-Parameter und Energie')
legend('S11','S21','Energie')
xlim([0 fmax2plot]);
        
%% Auswertung Rechenzeit Frequenzbereich (FD) <-> Zeitbereich (TD)
% dieses Jahr nicht Teil des Versuchs