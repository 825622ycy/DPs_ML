clc;clear

snr = [100,50,10];
nr = 50; 
f = (1e9:5e7:1e10)';
load('F:\ycy\comsol\liver\gendata2\data\Meas.mat')
sp_meas1{1,1} = reshape(Meas.Sp(:,11:20),[181 9 50]);% tumor
sp_meas1{1,2} = reshape(Meas.Sp(:,1:10),[181 9 50]);% nomal

sp_meas{1,1} = sp_meas1{1,1}(:,1:6,:);% tumor
sp_meas{1,2} = sp_meas1{1,2}(:,1:6,:);% nomal



load('F:\ycy\comsol\liver\gendata2\data\A_parameter.mat')
cp = reshape(A,[181 9 5 3]);

cp1 = squeeze(cp(:,1:6,5,:));

sp_addnoise = addnoisefunc(sp_meas,snr,nr,1);


[ep_ns,sg_ns] = caldpfunc(sp_addnoise,cp1,f);



% note:
% dim-1: frequency
% dim-2: thickness
% dim-3: samples with given individual difference percentage
% dim-4: noise level (SNR)
% dim-5: samples with given noise level

%% 
samplemk = 2:5;

[sample,label,label_size]= featurefunc(ep_ns,sg_ns,samplemk);

sample = single(sample);
label = single(label);
label_size = single(label_size);


