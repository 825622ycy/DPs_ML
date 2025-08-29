clear;clc;close all;

%--------------Step1 Read the measurement data --------------
info_data.inpath = '';
info_data.infofile = 'Info.xlsx';
info_data.outpath = info_data.inpath;
info_data.outfile = 'data.mat';
info_data.kwds = {};

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

Ver.index = [ 6 ]; 
Ver.id = [ 70]; 
Ver.conc = [ 100 ];
Ver.N = 1;

temperature = data.info.temperature(Ver.index); 
Nrep = Ver.N*ones(1,length(Ver.id)); 
Meas.Sp  = data.Sp(:,Ver.index);
Meas.freq = data.freq(:,Ver.index);


[Meas.di,Meas.sgm,Meas.eps] = RetrieveEPs(A,Meas);
[Ver.di,Ver.sgm,Ver.eps] =  GetRefEPs(Ver,Nrep,temperature,f);
