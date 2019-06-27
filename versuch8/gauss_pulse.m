function [j] = gauss_pulse(t, fmax, np, distributed)

% value
omega = 2*pi*fmax;
sigma = sqrt(2*log(100)/omega^2);
t0 = sqrt(2*sigma^2 * log(1000));
tm = t - t0;
jvalue = exp(-tm.^2 / (2*sigma^2));

j = sparse(3*np,length(t));
if distributed
	% set j in a way that the current is distributed over the entire port face
    XfacesPlus = [5,9];
    YfacesPlus = [2,3];
    XfacesMinus = [7,11];
    YfacesMinus= [10,11];
    j(XfacesPlus,:) = [jvalue/8; jvalue/8];
    j(XfacesMinus,:) = -[jvalue/8; jvalue/8];
    j(YfacesPlus + np,:) = [jvalue/8; jvalue/8];
    j(YfacesMinus + np,:) = -[jvalue/8; jvalue/8];
else
	% set j in a way that one edge in the port face is excited by the entire current
    j(2 + np) = jvalue;
end
