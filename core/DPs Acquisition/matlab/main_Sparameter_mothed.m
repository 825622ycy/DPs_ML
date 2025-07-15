clear;clc;close all;

%--------------Step1 Read the measurement data --------------
info_data.inpath = '';
info_data.infofile = 'Info.xlsx';
info_data.outpath = info_data.inpath;
info_data.outfile = 'data.mat';

info_data.modetype = 'average'; 
flag_read = 1;
data = ReadCaliRawdata(info_data,flag_read);


Cali.index = [1 3 4 5]; 
Ref.id = [1 3 6 7];  
Ref.conc = [100 100 100 100]; 
Cali.N = 1;
CalAmode = 2; 

temperature = data.info.temperature(Cali.index); 
Nrep = Cali.N*ones(1,length(Ref.id)); 
f = data.freq(:,2);
[Cali.EP,~,~] =  GetRefEPs(Ref,Nrep,temperature,f);
Cali.Sp = data.Sp(:,Cali.index);

A = GetParaA(Cali,CalAmode,Nrep);
save(fullfile(info_data.outpath,'A_parameter.mat'),'A');
save(fullfile(info_data.outpath,'Cali.mat'),'Cali');

Ver.index = [ 6  7 8 9]; 
Ver.id = [ 16  16 16 16]; 
Ver.conc = [ 100 100 100 100 ];
Ver.N = 1;

temperature = data.info.temperature(Ver.index); 
Nrep = Ver.N*ones(1,length(Ver.id)); 
Meas.Sp  = data.Sp(:,Ver.index);
Meas.freq = data.freq(:,Ver.index);


[Meas.di,Meas.sgm,Meas.eps] = RetrieveEPs(A,Meas);
[Ver.di,Ver.sgm,Ver.eps] =  GetRefEPs(Ver,Nrep,temperature,f);

w = 2*pi*f;
ep0 = 8.854*10e-12;

addpath('');
eps0 = 8.854187817*1e-12; 

ref_nomor_im = RefEPfunc_im33(13,37,100,f);
ref_nomor_re = RefEPfunc_re33(13,37,100,f);
ref_tumor_im = Cancer_im33(5,37,100,f);
ref_tumor_re = Cancer_re33(5,37,100,f);
% ref_tumor_im = RefEPfunc_im33(67,37,100,f);
% ref_tumor_re = RefEPfunc_re33(67,37,100,f);
ref_nomor_sg = -2*pi*f*eps0.*ref_nomor_im;
ref_nomor_ep = ref_nomor_re;
ref_tumor_sg = -2*pi*f*eps0.*ref_tumor_im;
ref_tumor_ep = ref_tumor_re; 
Ver_sgm = cat(2,ref_nomor_sg,ref_tumor_sg);
Ver_eps = cat(2,ref_nomor_ep,ref_tumor_ep);

%%
meas_sg = Meas.sgm;
meas_ep = Meas.eps;
% ver_sg = Ver.sgm(2:192,:);
% ver_ep = Ver.eps(2:192,:);
ver_sg = Ver_sgm;
ver_ep = Ver_eps;
% f = f(1:181,:);
subplot(221)
% figure
plot(f,meas_sg(:,1))
hold on
plot(f,ver_sg(:,1))
xlabel('Frequency(MHz)');ylabel('Conductivity(S/m)')
legend('cond_normal_Meas','cond_normal_Ref');

subplot(222)
plot(f,meas_sg(:,2))
hold on
plot(f,ver_sg(:,2))
xlabel('Frequency(MHz)');ylabel('Conductivity(S/m)')
legend('cond_cancer_Meas','cond_cancer_Ref');

subplot(223)
plot(f,meas_ep(:,1))
hold on
plot(f,ver_ep(:,1))
xlabel('Frequency(MHz)');ylabel('Permittivity')
legend('eps_normal_Meas','eps_normal_Ref');

subplot(224)
plot(f,meas_ep(:,2))
hold on
plot(f,ver_ep(:,2))
xlabel('Frequency(MHz)');ylabel('Permittivity')
legend('eps_cancer_Meas','eps_cancer_Ref');


error_sgm=abs(meas_sg(:,2)-ver_sg(:,2))./(ver_sg(:,2));
error_eps=abs(meas_ep(:,2)-ver_ep(:,2))./(ver_ep(:,2));

mean_sgm = mean(error_sgm);
mean_eps = mean(error_eps);

