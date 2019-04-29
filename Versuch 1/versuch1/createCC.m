%Methode zur Erstellung der 1D Curl-Curl-Matrix eines einfachen
%Eigenwertproblems einer eindimensionalen Wellengleichung (TE-Mode).
%
%   Eingabe
%   n       Stuetzstellenanzahl (n>=3 fuer ord=2, n>=5 fuer ord=4)
%   ord     Ordnung des Verfahrens (ord=2 zweite oder ord=4 vierte Ordnung)
%   bc      Randbedingungen (bc=0 keine, bc=1 elektrisch, bc=2 magnetisch)
%
%   Rueckgabe
%   cc      1D Curl-Curl-Matrix

function [cc]=createCC(n, ord, bc)

    % Aufstellen der Matrix
    cc = sparse(n,n);
    
    % Eintraege eintragen
    if ord==2
        % Bestimmen der Eintraege fuer Ordnung 2 ohne Randbedingungen
        for k=1:1:n
          if (k==1)
            cc(k,k)=-2;
            cc(k,k+1)=1;
          elseif (k==n)
            cc(k,k-1)=1;
            cc(k,k)=-2;
          else  
            cc(k,k-1)=1;
            cc(k,k)=-2;
            cc(k,k+1)=1;
           endif
        endfor
        if bc==1
            % Aenderung der Matrix bei elektrischem Rand
            cc(1,2)=0;
            cc(n,n-1)=0;
        elseif bc == 2
            cc(1,2)=2;
            cc(n,n-1)=2;
            % Aenderung der Matrix bei magnetischem Rand
        elseif bc ~= 0
            error('bc kann nur die Werte 0 (elektrisch) oder 1 (magnetisch) 
            annehmen.')
        end
	elseif ord==4
        % Bestimmen der cc Matrix fuer Ordnung 4 ohne Randbedingungen
        for k=1:1:n
          if (k==1)
            cc(k,k)=-30;
            cc(k,k+1)=16;
            cc(k,k+2)=-1;
          elseif (k==2)
            cc(k,k-1)=16;
            cc(k,k)=-30;
            cc(k,k+1)=16;
            cc(k,k+2)=-1;
          elseif (k==n)
            cc(k,k-2)=-1;
            cc(k,k-1)=16;
            cc(k,k)=-30;
          elseif (k==n-1)
            cc(k,k-2)=-1;
            cc(k,k-1)=16;
            cc(k,k)=-30;
            cc(k,k+1)=16;  
          else  
            cc(k,k-2)=-1;
            cc(k,k-1)=16;
            cc(k,k)=-30;
            cc(k,k+1)=16;
            cc(k,k+2)=-1;
           endif
        endfor
        
        if bc==1
            % Aenderung der Matrix bei elektrischem Rand
            cc(1,2)=0;
            cc(1,3)=0;
            cc(2,2)=-29;
            cc(n,n-1)=0;
            cc(n,n-2)=0;
            cc(n-1,n-1)=-29;
        elseif bc==2
            % Aenderung der Matrix bei magnetischem Rand
            cc(1,2)=32;
            cc(1,3)=-2;
            cc(2,2)=-31;
            cc(n,n-1)=32;
            cc(n,n-2)=-2;
            cc(n-1,n-1)=-31;
        elseif bc~=0
            error('bc kann nur die Werte 0 (elektrisch) oder 1 (magnetisch) annehmen.')
        end
        cc=1/12.*cc;
	else
		error('Ordnung %d ist noch nicht implementiert.', n)
    end

end
