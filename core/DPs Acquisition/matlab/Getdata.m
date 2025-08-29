function [Q, open_short_flag]= Getdata(datapath,kwds,outpath,outfile,info,mode)
    if nargin<5
        kwds = {'open','short','water','MUT'};
    end
    if nargin<12
        mode = 'average';
    end

   
    dirtxt=dir(fullfile(datapath, '*.txt'));
    open_short_flag = zeros(1,length(kwds));
    hw = waitbar(0, 'Reading raw data, please waiting');
    for n = 1:length(kwds)
        fg = 0;
        cn = 1;
        for k = 1:length(dirtxt)
            t_str = ((n-1)*length(dirtxt)+k)/length(kwds)/length(dirtxt);
            wstr = ['Reading raw data, completed ',num2str(round(t_str*100)), '%'];    
            waitbar(t_str,hw,wstr);
                if strncmpi(dirtxt(k).name,kwds{n},length(kwds{n}))
                    t = data_import(fullfile(datapath, dirtxt(k).name));
                    freq{n,cn} = t(:,1);
                    Sp{n,cn} = t(:,2)+1i*t(:,3);
                    cn = cn+1;
                    fg = 1;
                end 
        end
        tm(n) = cn - 1;
        if strcmp('open',kwds{n})&&fg
            open_short_flag(n) = 1;
        end
        if strcmp('short',kwds{n})&&fg
            open_short_flag(n) = 2;
        end
        if fg==0
            disp(['Please check the argument kwds: ' num2str(kwds{n})]);
            disp('Pay attention to the spelling of letters (The keyword matching rule is: the keyword should match the filename forward and be case-insensitive; for example, the Ethanol keyword will match ethanol3.txt but not methanol3.txt)');
            error('The keyword of filename do not match.');
        end
    end
    close(hw);
    
    switch mode
        case 'average'
        data = averagemode(Sp,freq);
        kwds_show = kwds;
        disp('NOTE:   average mode was chosen');
        case 'individual'
        data = individualmode(Sp,freq);
        kwds_show = repmat(kwds(1),1,tm(1));
        temp = repmat(open_short_flag(1),1,tm(1));
        for k = 2:length(kwds)
            kwds_show = [kwds_show, repmat(kwds(k),1,tm(k))];
            temp = [temp, repmat(open_short_flag(k),1,tm(k))];
        end
        open_short_flag = temp;
        disp('NOTE:   individual mode was chosen');
        otherwise
            warning('Please specify accurate mode');
    end
            
            
    
    Ns = 90;
    t = repmat(' ',1, Ns);
    disp_t0 = {'RowNum(data)','Keywords','StartFreq(MHz)','StopFreq(MHz)','Samples'};
    for n = 1:length(disp_t0)
        np = (1:length(disp_t0{n}))+(n-1)*floor(length(t)/length(disp_t0));
        t(np) = disp_t0{n};
    end
    disp(t);

    for k = 1:length(data)
        t = repmat(' ',1, Ns);
        p = data(k).freq;
        tdis(k,:) = {num2str(k),kwds_show{k},num2str(p(1)/1e+6),num2str(p(end)/1e+6),num2str(length(p))};
    end
    q = getmaxlength(tdis);
    for k = 1:length(data)
        t = repmat(' ',1, Ns);
        disp_t = tdis(k,:);
        for n = 1:length(disp_t)
            np = (1:length(disp_t{n}))+(n-1)*floor(length(t)/length(disp_t))+floor((length(disp_t0{n})-q(n))/2);
            t(np) = disp_t{n};
        end
    disp(t);
    end
    for k = 1:length(data)
        Q.Sp(:,k) = data(k).Sp;
        Q.freq(:,k) = data(k).freq;
    end
     Q.info = info;
     if exist(outpath)==0 
        mkdir(outpath);  
     end
     readdata = Q;
     save(fullfile(outpath,outfile),'readdata');

end

function q = getmaxlength(a)
    [nx,ny] = size(a);
    for ky = 1:ny
        q(ky) = length(a{1,ky});
        for kx = 2:nx
            p = length(a{kx,ky});
            if q(ky) < p
                q(ky) = p;
            end
        end
    end
end

function q = averagemode(Sp,freq)
    [px,py] = size(Sp);
    for n = 1:px
        s = 0;
        for k = 1:py
            s = s+ Sp{n,k};
        end
        q(n).Sp = s/py;
        q(n).freq = freq{n,1};
    end
end

function q = individualmode(Sp,freq)
    [px,py] = size(Sp);
    for n = 1:px
        for k = 1:py
            q((n-1)*py+k).Sp = Sp{n,k};
            q((n-1)*py+k).freq = freq{n,k};
        end
                
    end
end
