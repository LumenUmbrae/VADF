function [jvalue] = gauss_pulse(t, fmax)

% value
omega = 2*pi*fmax;
sigma = sqrt(ln(10))/(pi*fmax);
tm = t-.sqrt(6*sigma*ln(10));
jvalue = exp(-tm.^2 ./ (2*sigma^2));
end