function [cp,sgm,eps] = RetrieveEPs(A,Meas)

eps0 = 8.854187817*1e-12; 
f = Meas.freq(:,1);
P = Meas.Sp;
M = size(P,2);
    for k = 1:M
        cp(:,k)=(A(:,1).*P(:,k)-A(:,2))./(A(:,3)-P(:,k));
        eps(:,k) = real(cp(:,k));
        sgm(:,k) = -2*pi*f*eps0.*imag(cp(:,k));
    end
end

