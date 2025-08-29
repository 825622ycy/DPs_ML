function dispinfo(y)
data(:,1) = y.flag;
data(:,2) = y.temperature;
data(:,3) = y.Nmeas;
item = y.item;

disp('Measurement Infomation is Following:');

Ns = 90;
N0= 10;
disp(repmat('-',1, Ns))
t = repmat(' ',1, Ns);
t(1:3) = 'No.';
for n = 1:size(item,2)
    np = (1:length(item{1,n}))+(n-1)*floor(length(t)/size(item,2))+N0;
    t(np) = item{1,n};
end
disp(t);
disp(repmat('.',1, Ns))
q = getmaxlength(data);
for k = 1:length(y.Nmeas)
    t = repmat(' ',1, Ns);
    t(1:length(num2str(k))) = num2str(k);
    for n = 1:size(item,2)
        if n==1
            np = (1:length(item{k+1,n}))+(n-1)*floor(length(t)/size(item,2))+N0;
            t(np) = item{k+1,n};
        else
            d = num2str(data(k,n-1));
            np = (1:length(d))+(n-1)*floor(length(t)/size(item,2))+N0+floor((length(item{1,n})-q(n-1))/2);
            t(np) = d;
        end
    end
    disp(t);

end
disp(repmat('-',1, Ns));

end

function q = getmaxlength(a)
    [nx,ny] = size(a);
    
    for ky = 1:ny
        q(ky) = length(num2str(a(1,ky)));
        for kx = 2:nx
            p = length(num2str(a(kx,ky)));
            if q(ky) < p
                q(ky) = p;
            end
        end
    end
end