function info = Getmyinfo(datapath,filename)
    if nargin<2
        dirxls=dir(fullfile(datapath, '*.xls*'));
        if length(dirxls) == 1
            filename = dirxls;
        elseif length(dirxls)>1
            filename = 'Info.xlsx';
        end
    end

    datadir = fullfile(datapath,filename);
    try
        [data,item] = xlsread(datadir);
        
        info.flag = data(:,1);
        info.temperature = data(:,2);
        info.Nmeas = data(:,3);
        info.item = item;


    catch
        info.flag= [];
        info.temperature = 37;
        info.Nmeas = [];
        info.item = {};
        warning('Infomation file was not found.The default temperature(37°„C) will be used');
    end


end

