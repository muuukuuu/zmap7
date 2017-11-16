function bdepth_ratio() % autogenerated function wrapper
    % This subroutine assigns creates a grid with
    % spacing dx,dy (in degreees). The size will
    % be selected interactiVELY. The bvalue in each
    % volume around a grid point containing ni earthquakes
    % will be calculated as well as the magnitude
    % of completness
    %   Stefan Wiemer 1/95
    % turned into function by Celso G Reyes 2017
    
    % fixed all incorrect calls to bmemag
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    
    
    disp ('This is /src/bdepth_ratio.m');
    
        % get the grid parameter
        % initial values
        %
        dx = 0.1;
        dy = 0.1 ;
        ni = 1000;
        ra = ZG.ra
        Nmin = 50;
        stan2 = nan;
        stan = nan;
        prf = nan;
        av = nan;
        mid_point = 5;
        top_zonet = 0;
        top_zoneb = 5;
        bot_zonet = 7;
        bot_zoneb = 15;
        topstan2 = nan;
        botstan2 = nan;
        topstan = nan;
        botstan = nan;
        topav = nan;
        botav = nan;
        use_old_win = 1;
        lab1 = 'b-value-depth-ratio:';
        
        
        % make the interface
        %
        figure_w_normalized_uicontrolunits(...
            'Name','Depth Ratio Grid Input Parameter [TO BE CHANGED:CGR]',...
            'NumberTitle','off', ...
            'NextPlot','new', ...
            'units','points',...
            'Visible','off', ...
            'MenuBar','none',...
            'Position',[ ZG.wex+200 ZG.wey-200 650 300]);
        axis off
        labelList2=[' Automatic Mcomp (max curvature) | Fixed Mc (Mc = Mmin) | Automatic Mcomp (90% probability) | Automatic Mcomp (95% probability) | Best (?) combination (Mc95 - Mc90 - max curvature)'];
        
        labelPos = [0.2 0.60 0.6  0.08];
        hndl2=uicontrol(...
            'Style','popup',...
            'Position',labelPos,...
            'Units','normalized',...
            'String',labelList2,...
            'callback',@callbackfun_001);
        
        % set(hndl2,'value',5);
        
        
        % creates a dialog box to input grid parameters
        %
        %
        
        % mid_point_field=uicontrol('Style','edit',...
        %     'Position',[.47 .80 .12 .08],...
        %     'Units','normalized','String',num2str(mid_point),...
        %     'callback',@callbackfun_002);
        
        top_zonet_field=uicontrol('Style','edit',...
            'Position',[.36 .80 .06 .06],...
            'Units','normalized','String',num2str(top_zonet),...
            'callback',@callbackfun_003);
        top_zoneb_field=uicontrol('Style','edit',...
            'Position',[.36 .74 .06 .06],...
            'Units','normalized','String',num2str(top_zoneb),...
            'callback',@callbackfun_004);
        
        bot_zonet_field=uicontrol('Style','edit',...
            'Position',[.78 .80 .06 .06],...
            'Units','normalized','String',num2str(bot_zonet),...
            'callback',@callbackfun_005);
        bot_zoneb_field=uicontrol('Style','edit',...
            'Position',[.78 .74 .06 .06],...
            'Units','normalized','String',num2str(bot_zoneb),...
            'callback',@callbackfun_006);
        
        freq_field=uicontrol('Style','edit',...
            'Position',[.30 .50 .12 .08],...
            'Units','normalized','String',num2str(ni),...
            'callback',@callbackfun_007);
        
        
        freq_field0=uicontrol('Style','edit',...
            'Position',[.70 .50 .12 .08],...
            'Units','normalized','String',num2str(ra),...
            'callback',@callbackfun_008);
        
        freq_field2=uicontrol('Style','edit',...
            'Position',[.30 .40 .12 .08],...
            'Units','normalized','String',num2str(dx),...
            'callback',@callbackfun_009);
        
        freq_field3=uicontrol('Style','edit',...
            'Position',[.30 .30 .12 .08],...
            'Units','normalized','String',num2str(dy),...
            'callback',@callbackfun_010);
        
        tgl1 = uicontrol('Style','checkbox',...
            'string','Number of Events:',...
            'Position',[.09 .50 .2 .08], 'callback',@callbackfun_011,...
            'Units','normalized');
        
        set(tgl1,'value',1);
        
        tgl2 =  uicontrol('Style','checkbox',...
            'string','OR: Constant Radius',...
            'Position',[.47 .50 .2 .08], 'callback',@callbackfun_012,...
            'Units','normalized');
        
        
        freq_field4=uicontrol('Style','edit',...
            'Position',[.30 .20 .12 .08],...
            'Units','normalized','String',num2str(Nmin),...
            'callback',@callbackfun_013);
        
        
        close_button=uicontrol('Style','Pushbutton',...
            'Position',[.60 .05 .15 .12 ],...
            'Units','normalized','callback',@callbackfun_014,'String','Cancel');
        
        go_button1=uicontrol('Style','Pushbutton',...
            'Position',[.20 .05 .15 .12 ],...
            'Units','normalized',...
            'callback',@under_construction, ...@callbackfun_015,...
            'String','Go');
        Nmin;
        text(...
            'Position',[0.20 .75 0 ],...
            'FontSize',ZmapGlobal.Data.fontsz.m ,...
            'FontWeight','bold',...
            'String','Please choose an Mc estimation option   ');
        
        mid_txt=text(...
            'Position',[0.24 1.0 0 ],...
            'FontSize',ZmapGlobal.Data.fontsz.m ,...
            'FontWeight','bold',...
            'String','Depth limits for depth ratio calculation  ');
        
        top_txt=text(...
            'Position',[-0.10 .85 0 ],...
            'FontSize',ZmapGlobal.Data.fontsz.m ,...
            'FontWeight','bold',...
            'String','Top and bottom for TOP zone(km):');
        
        bot_txt=text(...
            'Position',[0.40 .85 0 ],...
            'FontSize',ZmapGlobal.Data.fontsz.m ,...
            'FontWeight','bold',...
            'String','Top and bottom for BOTTOM zone(km):');
        
        txt3 = text(...
            'Position',[0.30 0.64 0 ],...
            'FontSize',ZmapGlobal.Data.fontsz.m ,...
            'FontWeight','bold',...
            'String',' Grid Parameter');
        txt5 = text(...
            'Position',[-0.06 0.40 0 ],...
            'FontSize',ZmapGlobal.Data.fontsz.m ,...
            'FontWeight','bold',...
            'String','Spacing in x (dx) in deg:');
        
        txt6 = text(...
            'Position',[-0.06 0.29 0 ],...
            'FontSize',ZmapGlobal.Data.fontsz.m ,...
            'FontWeight','bold',...
            'String','Spacing in y (dy) in deg:');
        
        txt7 = text(...
            'Position',[-0.06 0.17 0 ],...
            'FontSize',ZmapGlobal.Data.fontsz.m ,...
            'FontWeight','bold',...
            'String','Min. No. of events > Mc:');
        
        
        
        set(gcf,'visible','on');
        watchoff
        
    
    
    % for plotting number of events used (ni) in view_bdepth
    ni_plot = ni;
    
    function my_calculate()
    % get the grid-size interactively and
    % calculate the b-value in the grid by sorting
    % thge seimicity and selectiong the ni neighbors
    % to each grid point
        
        [file1,path1] = uiputfile(fullfile(ZmapGlobal.Data.hodi, '*.mat'), 'Grid Datafile Name?') ;
        
        
        selgp
        itotal = length(newgri(:,1));
        if length(gx) < 4  ||  length(gy) < 4
            errordlg('Selection too small! (Dx and Dy are in degreees! ');
            return
        end
        
        
        ZmapMessageCenter.set_info(' ','Running bdepth_ratio... ');
        %  make grid, calculate start- endtime etc.  ...
        %
        [t0b, teb] = ZG.primeCatalog.DateRange() ;
        n = ZG.primeCatalog.Count;
        tdiff = round((teb-t0b)/ZG.bin_dur);
        loc = zeros(3, length(gx)*length(gy));
        
        % loop over  all points
        %
        i2 = 0.;
        i1 = 0.;
        bvg = [];
        allcount = 0.;
        nobv = 0;
        wai = waitbar(0,' Please Wait ...  ');
        set(wai,'NumberTitle','off','Name','b-value grid - percent done');;
        drawnow
        
        
        % sort by depth
        
        % [s,is] = sort(ZG.primeCatalog.Depth);
        % adepth = a(is(:,1),:);
        
        % find row index of ratio midpoint
        l = ZG.primeCatalog.Depth >= top_zonet & ZG.primeCatalog.Depth <  top_zoneb;
        top_zone = ZG.primeCatalog.subset(l);
        
        l = ZG.primeCatalog.Depth >= bot_zonet & ZG.primeCatalog.Depth <  bot_zoneb;
        bot_zone = ZG.primeCatalog.subset(l);
        
        
        
        %
        % overall b-value
        [bv magco stan av pr] =  bvalca3(top_zone,ZG.inb1);
        tbo1 = bv; tno1 = length(top_zone(:,1));
        
        [bv magco stan av pr] =  bvalca3(bot_zone,ZG.inb1);
        bbo1 = bv; bno1 = length(bot_zone(:,1));
        
        depth_ratio = tbo1/bbo1;
        
        disp(depth_ratio);
        
        % loop over all points
        for i= 1:length(newgri(:,1))
            x = newgri(i,1);y = newgri(i,2);
            allcount = allcount + 1.;
            i2 = i2+1;
            
            % calculate distance from center point and sort wrt distance
            l=ZG.primeCatalog.epicentralDistanceTo(x,y);
            [s,is] = sort(l);
            b = a(is(:,1),:) ;       % re-orders matrix to agree row-wise
            
            if tgl1 == 0   % take point within r
                l3 = l <= ra;
                b = ZG.primeCatalog.subset(l3);      % new data per grid point (b) is sorted in distanc  (from center point)
                rd = ra;
            else
                % take first ni points
                b = b(1:ni,:);      % new data per grid point (b) is sorted in distance
                l2 = sort(l); rd = l2(ni);
                
            end
            
            
            %estimate the completeness and b-value
            ZG.newt2 = b;
            
            % sort by depth
            
            l = b.Depth >= top_zonet & b.Depth <  top_zoneb;
            topb = b(l,:);
            per_in_top = (length(topb)/length(b))*100.0;
            l = b.Depth >= bot_zonet & b.Depth <  bot_zoneb;
            botb = b(l,:);
            per_in_bot = (length(botb)/length(b))*100.0;
            
            
            
            
            
            if length(topb) >= Nmin  && length(botb) >= Nmin
                
                if ZG.inb1 == 3
                    ZG.newt2 = topb;
                    [Mc, Mc90, Mc95, magco, prf]=mcperc_ca3();
                    l = topb(:,6) >= Mc90-0.05; magco = Mc90;
                    n1 = length(topb(l,:));
                    if length(topb(l,:)) >= Nmin
                        [topbv magco stan av pr] =  bvalca3(topb(l,:),2);
                        [topbv2 topstan2 topav2] =  bmemag(topb(l,:));
                    else  topbv = nan; topbv2 = nan, magco = nan; av = nan; topav2 = nan;
                        nobv = nobv + 1;
                    end
                    ZG.newt2 = botb;
                    [Mc, Mc90, Mc95, magco, prf]=mcperc_ca3();
                    l = botb(:,6) >= Mc90-0.05; magco = Mc90;
                    n2 = length(botb(l,:));
                    if length(botb(l,:)) >= Nmin
                        [botbv magco stan av pr] =  bvalca3(botb(l,:),2);
                        [botbv2 botstan2 botav2] =  bmemag(botb(l,:));
                        
                    else  botbv = nan; botbv2 = nan; magco = nan; av = nan; botav2 = nan;
                        nobv = nobv + 1;
                    end
                    
                elseif ZG.inb1 == 4
                    ZG.newt2 = topb;
                    [Mc, Mc90, Mc95, magco, prf]=mcperc_ca3();
                    l = topb(:,6) >= Mc95-0.05; magco = Mc95;
                    n1 = length(topb(l,:));
                    
                    if length(topb(l,:)) >= Nmin
                        [topbv magco topstan topav topme topmer topme2,  toppr] =  bvalca3(topb(l,:),2);
                        [topbv2 topstan2 topav2] =  bmemag(topb(l,:));
                    else
                        topbv = nan; topbv2 = nan, magco = nan; topav = nan; topav2 = nan;
                        nobv = nobv + 1;
                    end
                    ZG.newt2 = botb;
                    [Mc, Mc90, Mc95, magco, prf]=mcperc_ca3();
                    l = botb(:,6) >= Mc90-0.05; magco = Mc95;
                    n2 = length(botb(l,:));
                    
                    if length(botb(l,:)) >= Nmin
                        [botbv magco botstan botav botme botmer botme2,  botpr] =  bvalca3(botb(l,:),2);
                        [botbv2 botstan2 botav2] =  bmemag(botb(l,:));
                    else
                        botbv = nan; botbv2 = nan, magco = nan; botav = nan; botav2 = nan;
                        nobv = nobv + 1;
                    end
                    
                elseif ZG.inb1 == 5
                    ZG.newt2 = topb;
                    [Mc, Mc90, Mc95, magco, prf]=mcperc_ca3();
                    if isnan(Mc95) == 0
                        magco = Mc95;
                    elseif isnan(Mc90) == 0
                        magco = Mc90;
                    else
                        [bv magco stan av pr] =  bvalca3(b,1);
                    end
                    
                    l = topb(:,6) >= magco-0.05;
                    n1 = length(topb(l,:));
                    if length(topb(l,:)) >= Nmin
                        [topbv magco topstan topav topme topmer topme2,  toppr] =  bvalca3(topb(l,:),2);
                        [topbv2 topstan2 topav2] =  bmemag(topb(l,:));
                    else
                        topbv = nan; topbv2 = nan, magco = nan; topav = nan; topav2 = nan;
                        nobv = nobv + 1;
                    end
                    
                    ZG.newt2 = botb;
                    [Mc, Mc90, Mc95, magco, prf]=mcperc_ca3();
                    l = botb(:,6) >= magco-0.05;
                    n2 = length(botb(l,:));
                    
                    if length(botb(l,:)) >= Nmin
                        [botbv magco botstan botav botme botmer botme2,  botpr] =  bvalca3(botb(l,:),2);
                        [botbv2 botstan2 botav2] =  bmemag(botb(l,:));
                    else
                        botbv = nan; botbv2 = nan, magco = nan; botav = nan; bottopav2 = nan;
                        nobv = nobv + 1;
                    end
                    
                elseif ZG.inb1 == 1
                    % ZG.newt2 = topb;
                    % [Mc, Mc90, Mc95, magco, prf]=mcperc_ca3();
                    [topbv magco topstan topav topme topmer topme2,  toppr] =  bvalca3(topb,1);
                    l = topb(:,6) >= magco-0.05;
                    if length(topb(l,:)) >= Nmin
                        [topbv2 topstan2 topav2] =  bmemag(topb(l,:));
                        n1 = length(topb(l,:));
                    else
                        topbv = nan; topbv2 = nan; magco = nan; topav = nan; topav2 = nan;
                        n1 = nan;
                        
                        
                        nobv = nobv + 1;
                    end
                    %    ZG.newt2 = botb;
                    %    [Mc, Mc90, Mc95, magco, prf]=mcperc_ca3();
                    [botbv magco botstan botav botme botmer botme2,  botpr] =  bvalca3(botb,1);
                    l = botb(:,6) >= magco-0.05;
                    if length(botb(l,:)) >= Nmin
                        [botbv2 botstan2 botav2] =  bmemag(botb(l,:));
                        n2 = length(botb(l,:));
                        
                    else
                        botbv = nan; botbv2 = nan; magco = nan; botav = nan; botav2 = nan;
                        n2 = nan;
                        nobv = nobv + 1;
                    end
                    
                elseif ZG.inb1 == 2
                    [topbv magco topstan topav topme topmer topme2,  toppr] =  bvalca3(topb,2);
                    n1 = length(topb);
                    [topbv2 topstan2 topav2] =  bmemag(topb);
                    
                    [botbv magco botstan botav botme botmer botme2,  botpr] =  bvalca3(botb,2);
                    
                    n2 = length(botb);
                    [botbv2 botstan2 botav2] =  bmemag(botb);
                    
                end
                
            else
                topbv = nan; topbv2 = nan; magco = nan; topav = nan; topav2 = nan;
                botbv = nan; botbv2 = nan; magco = nan; botav = nan; botav2 = nan;
                nobv = nobv + 1;
                
            end
            
            bv = topbv/botbv; bv2 = topbv2/botbv2; stan2 = topstan2/botstan2; av = topav/botav;
            stan = topstan/botstan;
            n = n1+n2; 
            ZG.bo1 = topbv; 
            b2 = botbv;
            da = -2*n*log(n) + 2*n1*log(n1+n2*ZG.bo1/b2) + 2*n2*log(n1*b2/ZG.bo1+n2) - 2;
            pr = (1  -  exp(-da/2-2))*100;
            
            ltopb = length(topb);
            lbotb = length(botb);
            bvg = [bvg ; bv magco x y rd bv2 av pr topbv botbv per_in_top per_in_bot];
            waitbar(allcount/itotal)
            
        end
        
        mean_in_top = mean(per_in_top);
        mean_in_bot = mean(per_in_bot);
        snobv = num2str(nobv);
        spnobv = num2str((nobv/allcount)*100.0);
        disp(['Not enough EQs to calculate b values for ', snobv, ' gridnodes. This is ',spnobv,'% of the total'])
        
        % for newgr
        %save cnssgrid.mat
        %quit
        % save data
        %
        
        if file1 ~= 0
            catsave3('bdepth_ratio');
            %%%%%%        '[file1,path1] = uiputfile(fullfile(ZmapGlobal.Data.data_dir, ''*.mat''), ''Grid Datafile Name?'') ;',...
            close(wai)
            watchoff
        end
        
        % plot the results
        % old and valueMap (initially ) is the b-value matrix
        %
        normlap2=nan(length(tmpgri(:,1)),1)
        normlap2(ll)= bvg(:,1);
        valueMap=reshape(normlap2,length(yvect),length(xvect));
        
        normlap2(ll)= bvg(:,5);
        r=reshape(normlap2,length(yvect),length(xvect));
        
        normlap2(ll)= bvg(:,6);
        meg=reshape(normlap2,length(yvect),length(xvect));
        
        normlap2(ll)= bvg(:,2);
        old1=reshape(normlap2,length(yvect),length(xvect));
        
        
        normlap2(ll)= bvg(:,7);
        avm=reshape(normlap2,length(yvect),length(xvect));
        
        normlap2(ll)= bvg(:,8);
        Prmap=reshape(normlap2,length(yvect),length(xvect));
        
        
        normlap2(ll)= bvg(:,9);
        top_b=reshape(normlap2,length(yvect),length(xvect));
        
        normlap2(ll)= bvg(:,10);
        bottom_b=reshape(normlap2,length(yvect),length(xvect));
        
        normlap2(ll)= bvg(:,11);
        per_top=reshape(normlap2,length(yvect),length(xvect));
        
        normlap2(ll)= bvg(:,12);
        per_bot=reshape(normlap2,length(yvect),length(xvect));
        
        %  normlap2(ll)= bvg(:,13);
        %  ltopb=reshape(normlap2,length(yvect),length(xvect));
        
        % normlap2(ll)= bvg(:,14);
        % lbotb=reshape(normlap2,length(yvect),length(xvect));
        
        old = valueMap;
        
        % View the b-value map
        view_bdepth
        
    end
    
    function my_load()
    % Load exist b-grid
        [file1,path1] = uigetfile(['*.mat'],'b-value gridfile');
        if length(path1) > 1
            
            load([path1 file1])
            normlap2=nan(length(tmpgri(:,1)),1)
            
            
            normlap2(ll)= bvg(:,1);
            valueMap=reshape(normlap2,length(yvect),length(xvect));
            
            normlap2(ll)= bvg(:,5);
            r=reshape(normlap2,length(yvect),length(xvect));
            
            normlap2(ll)= bvg(:,6);
            meg=reshape(normlap2,length(yvect),length(xvect));
            
            normlap2(ll)= bvg(:,2);
            old1=reshape(normlap2,length(yvect),length(xvect));
            
            %  normlap2(ll)= bvg(:,7);
            %  pro=reshape(normlap2,length(yvect),length(xvect));
            
            normlap2(ll)= bvg(:,7);
            avm=reshape(normlap2,length(yvect),length(xvect));
            
            %  normlap2(ll)= bvg(:,9);
            % stanm=reshape(normlap2,length(yvect),length(xvect));
            
            normlap2(ll)= bvg(:,8);
            Prmap=reshape(normlap2,length(yvect),length(xvect));
            
            normlap2(ll)= bvg(:,9);
            top_b=reshape(normlap2,length(yvect),length(xvect));
            
            normlap2(ll)= bvg(:,10);
            bottom_b=reshape(normlap2,length(yvect),length(xvect));
            
            normlap2(ll)= bvg(:,11);
            per_top=reshape(normlap2,length(yvect),length(xvect));
            
            normlap2(ll)= bvg(:,12);
            per_bot=reshape(normlap2,length(yvect),length(xvect));
            
            %    normlap2(ll)= bvg(:,13);
            %    ltopb=reshape(normlap2,length(yvect),length(xvect));
            
            %   normlap2(ll)= bvg(:,14);
            %  lbotb=reshape(normlap2,length(yvect),length(xvect));
            
            old = valueMap;
            
            view_bdepth
        else
            return
        end
    end
    
    function callbackfun_001(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ZG.inb2=hndl2.Value;
        ;
    end
    
    function callbackfun_002(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        mid_point=str2double(mid_point_field.String);
        mid_point_field.String=num2str(mid_point);
    end
    
    function callbackfun_003(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        top_zonet=str2double(top_zonet_field.String);
        top_zonet_field.String=num2str(top_zonet);
    end
    
    function callbackfun_004(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        top_zoneb=str2double(top_zoneb_field.String);
        top_zoneb_field.String=num2str(top_zoneb);
    end
    
    function callbackfun_005(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        bot_zonet=str2double(bot_zonet_field.String);
        bot_zonet_field.String=num2str(bot_zonet);
    end
    
    function callbackfun_006(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        bot_zoneb=str2double(bot_zoneb_field.String);
        bot_zoneb_field.String=num2str(bot_zoneb);
    end
    
    function callbackfun_007(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ni=str2double(freq_field.String);
        freq_field.String=num2str(ni);
        tgl2.Value=0;
        tgl1.Value=1;
    end
    
    function callbackfun_008(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ra=str2double(freq_field0.String);
        freq_field0.String=num2str(ra);
        tgl2.Value=1;
        tgl1.Value=0;
    end
    
    function callbackfun_009(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        dx=str2double(freq_field2.String);
        freq_field2.String=num2str(dx);
    end
    
    function callbackfun_010(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        dy=str2double(freq_field3.String);
        freq_field3.String=num2str(dy);
    end
    
    function callbackfun_011(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        tgl2.Value=0;
    end
    
    function callbackfun_012(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        tgl1.Value=0;
    end
    
    function callbackfun_013(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        Nmin=str2double(freq_field4.String);
        % freq_field4.String=num2str(Nmin);
    end
    
    function callbackfun_014(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        close;
        
    end
    
    function callbackfun_015(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ZG.inb1=hndl2.Value;
        tgl1=tgl1.Value;
        tgl2=tgl2.Value;
        close;
        my_calculate();
    end
end
