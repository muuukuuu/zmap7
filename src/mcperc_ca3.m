function mcperc_ca3() % autogenerated function wrapper
    %report_this_filefun(mfilename('fullpath'));
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    
    % This is a comleteness determination test
    
    [bval,xt2] = histcounts(ZG.newt2.Magnitude,-2:0.1:6);
    l = max(find(bval == max(bval)));
    magco0 =  xt2(l);
    
    dat = [];
    
    %for i = magco0-0.6:0.1:magco0+0.2
    for i = magco0-0.5:0.1:magco0+0.7
        l = ZG.newt2.Magnitude >= i - 0.0499;
        nu = sum(l);
        if sum(l) >= 25
            %[bv magco stan,  av] =  bvalca3(ZG.newt2(l,:),2);
            [mw bv2 stan2,  av] =  bmemag(ZG.newt2.subset(l));
            try %in case something goes wrong
                synthb_aut
            catch
                res2=nan
            end
            dat = [dat ; i res2];
        else
            dat = [dat ; i NaN];
        end
        
    end
    
    j =  min(find(dat(:,2) < 10 ));
    if isempty(j); Mc90 = NaN ;
    else;
        Mc90 = dat(j,1);
    end
    
    j =  min(find(dat(:,2) < 5 ));
    if isempty(j); Mc95 = NaN ;
    else;
        Mc95 = dat(j,1);
    end
    
    j =  min(find(dat(:,2) < 10 ));
    if isempty(j); j =  min(find(dat(:,2) < 15 )); end
    if isempty(j); j =  min(find(dat(:,2) < 20 )); end
    if isempty(j); j =  min(find(dat(:,2) < 25 )); end
    j2 =  min(find(dat(:,2) == min(dat(:,2)) ));
    %j = min([j j2]);
    
    Mc = dat(j,1);
    magco = Mc;
    prf = 100 - dat(j2,2);
    if isempty(magco); magco = NaN; prf = 100 -min(dat(:,2)); end
    %disp(['Completeness Mc: ' num2str(Mc) ]);
    
    
    
end
