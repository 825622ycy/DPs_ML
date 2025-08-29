function q = ReadCaliRawdata(C,flag_read)
    inpath =C.inpath;
    infofile = C.infofile;
    outpath = C.outpath;
    outfile = C.outfile;
    kwds = C.kwds;
    modetype = C.modetype;
    if flag_read==0 && exist(fullfile(outpath,outfile))
        a = load(fullfile(outpath,outfile));
        b = whos('-file',fullfile(outpath,outfile));
        q = a.(b.name);
        disp('Note: using the existed DATA:');
        disp(['      ',fullfile(outpath,outfile)]);
    else
        info = Getmyinfo(inpath,infofile);
        dispinfo(info);
        [q,~] = Getdata(inpath,kwds,outpath,outfile,info,modetype); %%mode : 'average'(default); 'individual' ; %open_short_flag: 1 open 2 short 0 others
    end
end

