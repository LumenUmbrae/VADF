function [Y,freq]=fftmod(y,N,Fs)
% Liefert das positive Frequenzspektrum (Y) eines Zeitsignals
% (y) und die dazugehörige Frequenzachse (freq).
%
% Input:
%   y       Signal im Zeitbereich
%   N       Anzahl Samples (inkl. zero-padding)
%   Fs      Sampling-Frequenz
%
% Output:
%   Y       Signal im Frequenzbereich
%   freq    Frequenzachse

% max. darstellbare Frequenz (Abtast-Theorem)
fmax = 2*Fs;

% Frequenzabstand bestimmen
df = Fs/N;

% Frequenzpunkte (x-Achse des Spektrums) bis fmax bestimmen
freq = 0:df:fmax;

% Spektrum mithilfe der fft bestimmen
spectrum = fft(y,N);

% Spektrum normalisieren
spectrum_norm = spectrum/N;

% einseitiges Amplituden-Spektrum bestimmen
Y = spectrum_norm(1:length(freq));

end