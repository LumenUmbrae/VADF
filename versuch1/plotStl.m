%% Skript to plot .stl file in octave 

%filename='zylinder.stl'; % .stl file 
%filename='w210.stl';
filename='coaxial.stl'; % .stl file
5%filename='cut.stl'; % .stl file
%filename='cube.stl'; % .stl file
%filename='kugel.stl'; % .stl file
%filename='kugel2.stl';
%filename='microstrip.stl';
%%reading data from .stl file and converting to octave  
[X,Y,Z,normals,stlname]=read_stl(filename);   
%%patching stuff together and visualising
figure(1)

patch(X,Y,Z,zeros(3,columns(X)));
title(filename);
view([1,-1,0.5])    
xlabel('x')
ylabel('y')
zlabel('z')
set(1,'paperposition',[0,0,12,9])
set(1,'paperposition',[0,0,12,9])
print -dpdf strcat(stlname,"cyl.pdf")