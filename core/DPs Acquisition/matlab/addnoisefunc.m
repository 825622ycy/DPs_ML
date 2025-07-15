function sp_noise = addnoisefunc(sp,snr,nr,myseed)

if nargin == 4
    rng(myseed);
end
sn = length(sp);


for k = 1:length(snr)
    for i = 1:sn
        sp_real = real(sp{i});
        sp_imag = imag(sp{i});
        tr = repmat(sp_real,1,1,1,nr).*(1+1/snr(k)*randn([size(sp{i}),nr]));
        ti = repmat(sp_imag,1,1,1,nr).*(1+1/snr(k)*randn([size(sp{i}),nr]));
        sp_noise{i}(:,:,:,k,:) = tr+1i*ti;
    end
end
end