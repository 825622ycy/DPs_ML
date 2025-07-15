function A = GetParaA(Cali,mode,Nrep)

    if nargin<3
        Nrep = 3;
    end
    if nargin<2
        mode = 2;
    end
    
 [nx ny] = size(Cali.EP);
 for k = 1:ny
     if isreal(Cali.EP(:,k))&&(sum(abs(Cali.EP(:,k)))==0)
         p(k) = 1;
     else
         p(k) = 0;
     end
 end
    k0 = find(p==1); 
    switch mode
        case 1
        if length(k0)>1
            error('only one short should be specified in mode 1' );
        end
        s1 = (Cali.Sp(:,k0));
        EP = Cali.EP;
        EP(:,k0)=[];
        Sp = Cali.Sp;
        Sp(:,k0)=[];
        p2 = EP(:,1);p3 = EP(:,2);
        s2 = Sp(:,1);s3 = Sp(:,2);     
        A1 = (s1.*(p3-p2)-(s3.*p3-s2.*p2))./(s3-s2);
        A2 = (s1.*(s2.*p3-s3.*p2)-s2.*s3.*(p3-p2))./(s3-s2);
        A3 = s1;  
        A = [A1(:),A2(:),A3(:)];
        case 2
        s = repmat(Cali.Sp(:,1),1,Nrep(1));
        for k = 2:length(Nrep)
            s = [s,repmat(Cali.Sp(:,k),1,Nrep(k))];
        end
        s1 = s(:,k0);
        EP = Cali.EP;
        EP(:,k0) = [];
        s(:,k0) = [];
        w = ny-length(k0);
        for n = 1:nx
            Ax = zeros(ny,3);
            Ax(1:w,:) = [-s(n,:).', ones(w,1),EP(n,:).'];
            Ax(w+1:ny,3) = ones(ny-w,1);
            b(1:w) = (EP(n,:).*s(n,:)).';
            b(w+1:ny) = s1(n,:).';
            x = (Ax'*Ax)\(Ax')*b(:); 
            A(n,:) = x.';
        end
        otherwise
            warning('Specified mode cannot been implimented')
    end
end

