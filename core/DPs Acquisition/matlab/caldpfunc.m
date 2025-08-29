function [ep,sg] = caldpfunc(sp,cp,f)

w = 2*pi*f;
ep0 = 8.854187817e-12;

sn = length(sp);
a1 = cp(:,:,1);
a2 = cp(:,:,2);
a3 = cp(:,:,3);

t = size(sp{1});
p = prod(t)/prod(t(1:2));
a1 = repmat(a1,1,p);
a2 = repmat(a2,1,p);
a3 = repmat(a3,1,p);

for i = 1:sn
    s = sp{i};
    s = reshape(s,length(f),[]);
    cdp = (s.*a1-a2)./(a3-s);
    ep{i} = reshape(real(cdp),size(sp{i}));
    sg{i} = reshape(-w*ep0.*imag(cdp),size(sp{i}));
end

end

