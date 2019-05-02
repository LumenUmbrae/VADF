% Aufgabe 8

% Skript zur Darstellung der relativen Anzahl der Fehlerkanten als
% doppel-logarithmischer Graph
nxyMax = 100;
relOccurence = zeros(1,nxyMax);
for nxy=1:nxyMax
    % Gittererzeugung: kartesisches Gitter mit nxy Punkten in x- und y-
    % Richtung. Es handelt sich um ein ebenes Gitter (x-y-Ebene) mit z = 1
    xmesh=linspace(1,nxy,nxy);
    ymesh=linspace(1,nxy,nxy);
    zmesh=1;
   
    msh=cartMesh(xmesh,ymesh,zmesh);
    % Geisterkanten finden
    edg = boundEdg(msh);
    % Geisterkanten zaehlen
    n=0;
    for i=1:rows(edg)
      if edg(i) == 0
        n=n+1;
      endif
    endfor
    % Berechnen der relativen Anzahl für dieses nxy
    relOccurence(nxy) = n./rows(edg);
end

% Darstellen der relativen Anzahl als doppel-logarithmischer Graph
figure;
plot(1:nxyMax,relOccurence, 'LineWidth', 2);
legend('Relativer Anteil von Geisterkanten');
xlabel('N_{xy}');
ylabel('Rel. Anteil');
title(['Relative Anzahl der Geisterkanten bei N_x bzw. N_y von 1 bis ',...
       num2str(nxyMax)]);
ylim([min(relOccurence),max(relOccurence)])
print -dpdf plotBoundEdg.pdf