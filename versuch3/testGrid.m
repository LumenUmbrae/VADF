xM = [0 1 2 3];
yM = [0 1 2];
zM = [0];

msh = cartMesh(xM, yM, zM);

eBx = [1 2 3 0 1 2 3 0 1 2 3 0]';
eBy = [3 3 3 2 2 2 1 1 1 0 0 0 0]';
eBz = [0 0 0 0 0 0 0 0 0 0 0 0]';

eB = [eBx;eBy;eBz];


% fitInt(msh, eB);

plotEBow(msh,eB, 1);

