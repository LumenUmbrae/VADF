function [hnew,enew]=leapfrog(hold, eold, js, Mmui, Meps, c, Rmat, dt)

% Berechnen der neuen magnetischen Spannung
% hnew = 
hnew = hold-dt*Mepsi*c*eold;

% Berechnen der neuen elektrischen Spannung
% enew = 
enew = nullinv(nullinv(Rmat).+Meps./dt)*(Meps./dt*eold .+c'*hnew-js);
end