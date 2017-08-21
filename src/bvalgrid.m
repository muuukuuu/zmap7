function bvalgrid() % autogenerated function wrapper
    % This subroutine assigns creates a grid with
    % spacing dx,dy (in degreees). The size will
    % be selected interactively. The bvalue in each
    % volume around a grid point containing ni earthquakes
    % will be calculated as well as the magnitude
    % of completness
    %   Stefan Wiemer 1/95
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals

    %TODO: have this check for an already selected polygon, and use these points
    
    report_this_filefun(mfilename('fullpath'));
    
    % get the grid parameter
    % initial values
    %
    dx = 1.00;
    dy = 1.00 ;
    ni = 100;
    Nmin = 50;
    fMcFix=2.2;
    nBstSample=100;
    fMccorr = 0.2;
    fBinning = 0.1;
    stan2 = NaN;
    stan = NaN;
    prf = NaN;
    av = NaN;
    fStdDevB = NaN;
    fStdDevMc = NaN;
    bGridEntireArea = 0;
    
    % make the interface
    %
    figure_w_normalized_uicontrolunits(...
        'Name','Grid Input Parameter',...
        'NumberTitle','off',...
        'NextPlot','new', ...
        'units','points',...
        'Visible','off', ...
        'Position',[ ZG.wex+200 ZG.wey-200 700 275]);
    axis off
    
    % Get list of Mc computation possibilities
    [labelList2] = calc_Mc;
    
    %labelList2=[' MaxC (max curvature) | Fixed Mc | Automatic Mc (90% probability) | Automatic Mc (95% probability) | Best combination (Mc95 - Mc90 - max curvature) | EMR-method | MaxC (max curvature) + Mc correction'];
    labelPos = [0.2 0.8  0.6  0.08];
    hndl2=uicontrol(...
        'Style','popup',...
        'Position',labelPos,...
        'String',labelList2,...
        'callback',@callbackfun_001);
    
    % Set selection to 'Best combination'
    set(hndl2,'value',1);
    
    
    % Edit fields, radiobuttons, and checkbox
    oldfig_button = uicontrol('BackGroundColor',[.60 .92 .84], ...
        'Style','checkbox','string','Plot in Current Figure',...
        'Position',[.65 .20 .20 .08]);
    set(oldfig_button,'value',1);
    
    tgl1 = uicontrol('Style','radiobutton',...
        'string','Number of Events:',...
        'Position',[.05 .70 .2 .0800], 'callback',@callbackfun_002);
    
    % set to constant number of events
    set(tgl1,'value',1);
    
    % Checkbox and radiobuttons
    tgl2 =  uicontrol('Style','radiobutton',...
        'string','OR: Constant Radius',...
        'Position',[.05 .60 .2 .080], 'callback',@callbackfun_003);
    
    chKBst_button =  uicontrol('Style','checkbox',...
        'string','Mc bootstraps',...
        'Position',[.05 .20 .2 .080]);
    
    
    
    
    
    create_grid =  uicontrol('Style','radiobutton',...
        'string','Calculate a new grid', 'callback',@callbackfun_004,'Position',[.65 .65 .2 .080]);
    set(create_grid,'value',1);
    
    
    
    load_grid =  uicontrol('Style','radiobutton',...
        'string','Load a previously saved grid', 'callback',@callbackfun_005,'Position',[.65 .45 .2 .080]);
    
    save_grid =  uicontrol('Style','checkbox',...
        'string','Save selected grid to file',...
        'Position',[.65 .35 .2 .080]);
    
    prev_grid =  uicontrol('Style','radiobutton',...
        'string','Reuse the previous grid', 'callback',@callbackfun_006,'Position',[.65 .55 .2 .080]);
    
    
    
    % Editable fields
    freq_field=uicontrol('Style','edit',...
        'Position',[.35 .70 .12 .08],'String',num2str(ni),...
        'callback',@callbackfun_007);
    
    freq_field0=uicontrol('Style','edit',...
        'Position',[.35 .60 .12 .08],'String',num2str(ra),...
        'callback',@callbackfun_008);
    
    freq_field2=uicontrol('Style','edit',...
        'Position',[.35 .50 .06 .08],'String',num2str(dx),...
        'callback',@callbackfun_009);
    
    freq_field3=uicontrol('Style','edit',...
        'Position',[.41 .50 .06 .080],'String',num2str(dy),...
        'callback',@callbackfun_010);
    
    freq_field4 = uicontrol('Style','edit',...
        'Position',[.35 .40 .12 .080],'String',num2str(Nmin),...
        'callback',@callbackfun_011);
    
    freq_field5 = uicontrol('Style','edit',...
        'Position',[.35 .30 .12 .080],'String',num2str(fMcFix),...
        'callback',@callbackfun_012);
    
    freq_field6 =uicontrol('Style','edit',...
        'Position',[.35 .20 .12 .08],'String',num2str(nBstSample),...
        'callback',@callbackfun_013);
    
    freq_field7 =uicontrol('Style','edit',...
        'Position',[.35 .10 .12 .08],'String',num2str(fMccorr),...
        'callback',@callbackfun_014);
    
    
    % Cancel and OK Button's
    close_button=uicontrol('Style','Pushbutton',...
        'Position',[.50 .05 .15 .10 ],'callback',@callbackfun_015,'String','Cancel');
    
    go_button1=uicontrol('Style','Pushbutton',...
        'Position',[.70 .05 .15 .10 ],...
        'callback',@callbackfun_016,...
        'String','Go');
    
    %     go_button1=uicontrol('BackGroundColor', 'y', 'Style', 'pushbutton', ...
    %         'Units', 'normalized', 'Position', [.60 .05 .15 .12], ...
    %         'Callback', 'ZG.inb1=hndl2.Value;tgl1=tgl1.Value;tgl2=tgl2.Value; bBst_button = get(chKBst_button, ''Value'');close,sel =''ca'', bvalgrid',...
    %         'String', 'OK');
    %
    % Labels
    text(...
        'Position',[0.10 0.98 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.l ,...
        'FontWeight','bold',...
        'String','Please choose an Mc estimation option   ');
    %     txt3 = text(...
    %         'Color',[0 0 0 ],...
    %         'EraseMode','normal',...
    %         'Position',[0.30 0.75 0 ],...
    %         ...
    %         'FontSize',ZmapGlobal.Data.fontsz.l ,...
    %         'FontWeight','bold',...
    %         'String',' Grid Parameter');
    txt5 = text(...
        'Position',[-0.1 0.5 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'FontWeight','bold',...
        'String','Spacing in x (dx) / y (dy) in deg:');
    
    txt6 = text(...
        'Position',[-0.1 0.4 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'FontWeight','bold',...
        'String','Min. No. of events > Mc:');
    
    txt7 = text(...
        'Position',[-0.1 0.30 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'FontWeight','bold',...
        'String','Fixed Mc (affects only "Fixed Mc"):');
    
    txt8 = text(...
        'Position',[-0.1 0.05 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'FontWeight','bold',...
        'String','Mc correction for MaxC:');
    
    
    
    
    set(gcf,'visible','on');
    watchoff
    
    function my_calculate()
        % get the grid-size interactively and
        % calculate the b-value in the grid by sorting
        % thge seimicity and selectiong the ni neighbors
        % to each grid point
        
        map = findobj('Name','Seismicity Map');
        
        if create_grid == 1
            % Select and reate grid
            pause(0.5)
            [newgri, xvect, yvect, ll] = ex_selectgrid(map, dx, dy, bGridEntireArea);
            gx = xvect;
            gy = yvect;
        end
        
        
        if load_grid == 1
            %load file
            
            pause(0.5) %the pause is needed there, because sometimes load was ignored
            [file1,path1] = uigetfile(['*.mat'],'b-value gridfile');
            
            if length(path1) > 1
                think
                load([path1 file1])
            end
            
            
        end
        
        % Plot all grid points
        plot(newgri(:,1),newgri(:,2),'+k','era','back')
        
        zmap_message_center.set_info(' ','Running... ');think
        %  make grid, calculate start- endtime etc.  ...
        %
        t0b = min(ZG.a.Date)  ;
        n = ZG.a.Count;
        teb = max(ZG.a.Date) ;
        tdiff = round((teb-t0b)/ZG.bin_days);
        loc = zeros(3, length(gx)*length(gy));
        
        % loop over  all points
        %
        bvg = [];
        allcount = 0.;
        wai = waitbar(0,' Please Wait ...  ');
        set(wai,'NumberTitle','off','Name','b-value grid - percent done');;
        drawnow
        
        % Overall b-value
        [bv magco stan av me mer me2,  pr] =  bvalca3(a,ZG.inb1);
        
        itotal = length(newgri(:,1));
        bvg = nan(itotal,14);
        ZG.bo1 = bv; no1 = ZG.a.Count;
        
        % loop over all points
        for i= 1:length(newgri(:,1))
            x = newgri(i,1);y = newgri(i,2);
            allcount = allcount + 1.;
            
            % calculate distance from center point and sort wrt distance
            l=ZG.a.epicentralDistanceTo(x,y);
            [s,is] = sort(l);
            b = a(is(:,1),:) ;       % re-orders matrix to agree row-wise
            
            if tgl1 == 0   % take point within r
                l3 = l <= ra;
                b = ZG.a.subset(l3);      % new data per grid point (b) is sorted in distanc
                rd = ra;
            else
                % take first ni points
                b = b(1:ni,:);      % new data per grid point (b) is sorted in distance
                l2 = sort(l); rd = l2(ni);
            end
            
            % Number of earthquakes per node
            [nX,nY] = size(b);
            
            % Estimate the completeness and b-value
            ZG.newt2 = b;
            
            if length(b) >= Nmin  % enough events?
                % Added to obtain goodness-of-fit to powerlaw value
                mcperc_ca3;
                
                [fMc] = calc_Mc(b, ZG.inb1, fBinning, fMccorr);
                l = b.Magnitude >= fMc-(fBinning/2);
                if length(b(l,:)) >= Nmin
                    [fMeanMag, fBValue, fStd_B, fAValue] =  calc_bmemag(b(l,:), fBinning);
                else
                    %fMc = NaN;
                    fBValue = NaN; fStd_B = NaN; fAValue= NaN;
                end
                % Set standard deviation ofa-value to NaN;
                fStd_A= NaN; fStd_Mc = NaN;
                
                % Bootstrap uncertainties
                if bBst_button == 1
                    % Check Mc from original catalog
                    l = b.Magnitude >= fMc-(fBinning/2);
                    if length(b(l,:)) >= Nmin
                        [fMc, fStd_Mc, fBValue, fStd_B, fAValue, fStd_A, vMc, mBvalue] = calc_McBboot(b, fBinning, nBstSample, ZG.inb1);
                    else
                        fMc = NaN;
                        %fStd_Mc = NaN; fBValue = NaN; fStd_B = NaN; fAValue= NaN; fStd_A= NaN;
                    end
                else
                    % Set standard deviation ofa-value to NaN;
                    fStd_A= NaN; fStd_Mc = NaN;
                end
                
                
            else % of if length(b) >= Nmin
                fMc = NaN; fStd_Mc = NaN; fBValue = NaN; fStd_B = NaN; fAValue= NaN; fStd_A = NaN;
                %bv = NaN; bv2 = NaN; stan = NaN; stan2 = NaN; prf = NaN; magco = NaN; av = NaN; av2 = NaN;
                fStdDevB = NaN;
                fStdDevMc = NaN;
                prf = NaN;
                b = [NaN NaN NaN NaN NaN NaN NaN NaN NaN];
                nX = NaN;
            end
            mab = max(b.Magnitude) ; if isempty(mab); mab = NaN; end
            
            % Result matrix
            %bvg(allcount,:)  = [bv magco x y rd bv2 stan2 av stan prf  mab av2 fStdDevB fStdDevMc nX];
            bvg(allcount,:)  = [fMc fStd_Mc x y rd fBValue fStd_B fAValue fStd_A prf mab fStdDevB fStdDevMc nX];
            waitbar(allcount/itotal)
        end  % for  newgri
        
        
        catsave3('bvalgrid');
        
        %changed the none error with the positioning of the window
        close(wai)
        watchoff
        
        % plot the results
        % old and re3 (initially ) is the b-value matrix
        %
        
        % normlap2=nan(length(tmpgri(:,1)),1)
        normlap2=nan(length(ll),1)
        % Mc map
        normlap2(ll)= bvg(:,1);
        mMc =reshape(normlap2,length(yvect),length(xvect));
        % Standard deviation Mc
        normlap2(ll)= bvg(:,2);
        mStdMc=reshape(normlap2,length(yvect),length(xvect));
        % Radius resolution
        normlap2(ll)= bvg(:,5);
        r=reshape(normlap2,length(yvect),length(xvect));
        % b-value
        normlap2(ll)= bvg(:,6);
        mBvalue=reshape(normlap2,length(yvect),length(xvect));
        % Standard deviation b-value
        normlap2(ll)= bvg(:,7);
        mStdB=reshape(normlap2,length(yvect),length(xvect));
        %a-value M(0)
        normlap2(ll)= bvg(:,8);
        mAvalue=reshape(normlap2,length(yvect),length(xvect));
        % Standard deviationa-value
        normlap2(ll)= bvg(:,9);
        mStdA=reshape(normlap2,length(yvect),length(xvect));
        % Goodness of fit to power-law map
        normlap2(ll)= bvg(:,10);
        Prmap=reshape(normlap2,length(yvect),length(xvect));
        % Whatever this is
        normlap2(ll)= bvg(:,11);
        ro=reshape(normlap2,length(yvect),length(xvect));
        % Additional runs
        normlap2(ll)= bvg(:,12);
        mStdDevB = reshape(normlap2,length(yvect),length(xvect));
        %
        normlap2(ll)= bvg(:,13);
        mStdDevMc = reshape(normlap2,length(yvect),length(xvect));
        
        normlap2(ll)= bvg(:,14);
        mNumEq = reshape(normlap2,length(yvect),length(xvect));
        
        kll = ll;
        
        re3 = mBvalue;
        old = re3;
        
        % View the b-value map
        view_bva(lab1,re3)
        
    end
    
    function my_load()
        % Load exist b-grid
        [file1,path1] = uigetfile(['*.mat'],'b-value gridfile');
        if length(path1) > 1
            think
            load([path1 file1])
            % plot the results
            % old and re3 (initially ) is the b-value matrix
            %
            % Mc map
            normlap2(ll)= bvg(:,1);
            mMc =reshape(normlap2,length(yvect),length(xvect));
            % Standard deviation Mc
            normlap2(ll)= bvg(:,2);
            mStdMc=reshape(normlap2,length(yvect),length(xvect));
            % Radius resolution
            normlap2(ll)= bvg(:,5);
            r=reshape(normlap2,length(yvect),length(xvect));
            % b-value
            normlap2(ll)= bvg(:,6);
            mBvalue=reshape(normlap2,length(yvect),length(xvect));
            % Standard deviation b-value
            normlap2(ll)= bvg(:,7);
            mStdB=reshape(normlap2,length(yvect),length(xvect));
            %a-value M(0)
            normlap2(ll)= bvg(:,8);
            mAvalue=reshape(normlap2,length(yvect),length(xvect));
            % Standard deviationa-value
            normlap2(ll)= bvg(:,9);
            mStdA=reshape(normlap2,length(yvect),length(xvect));
            % Goodness of fit to power-law map
            normlap2(ll)= bvg(:,10);
            Prmap=reshape(normlap2,length(yvect),length(xvect));
            % Whatever this is
            normlap2(ll)= bvg(:,11);
            ro=reshape(normlap2,length(yvect),length(xvect));
            % Additional runs
            normlap2(ll)= bvg(:,12);
            mStdDevB = reshape(normlap2,length(yvect),length(xvect));
            %
            normlap2(ll)= bvg(:,13);
            mStdDevMc = reshape(normlap2,length(yvect),length(xvect));
            
            normlap2(ll)= bvg(:,14);
            mNumEq = reshape(normlap2,length(yvect),length(xvect));
            
            
            re3 = mBvalue;
            old = re3;
            
            view_bva(lab1,re3)
            
        else
            return
        end
    end
    
    function callbackfun_001(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ZG.inb2=hndl2.Value;
    end
    
    function callbackfun_002(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        tgl2.Value=0;
    end
    
    function callbackfun_003(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        tgl1.Value=0;
    end
    
    function callbackfun_004(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        load_grid.Value=0;
        prev_grid.Value=0;
    end
    
    function callbackfun_005(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        prev_grid.Value=0;
        create_grid.Value=0;
    end
    
    function callbackfun_006(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        load_grid.Value=0;
        create_grid.Value=0;
    end
    
    function callbackfun_007(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ni=str2double(freq_field.String);
        freq_field.String=num2str(ni);
        tgl2.Value=0;
        tgl1.Value=1;
    end
    
    function callbackfun_008(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ra=str2double(freq_field0.String);
        freq_field0.String=num2str(ra);
        tgl2.Value=1;
        tgl1.Value=0;
    end
    
    function callbackfun_009(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        dx=str2double(freq_field2.String);
        freq_field2.String=num2str(dx);
    end
    
    function callbackfun_010(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        dy=str2double(freq_field3.String);
        freq_field3.String=num2str(dy);
    end
    
    function callbackfun_011(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        Nmin=str2double(freq_field4.String);
        freq_field4.String=num2str(Nmin);
    end
    
    function callbackfun_012(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        fMcFix=str2double(freq_field5.String);
        freq_field5.String=num2str(fMcFix);
    end
    
    function callbackfun_013(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        nBstSample=str2double(freq_field6.String);
        freq_field6.String=num2str(nBstSample);
        chKBst_button.Value=1;
    end
    
    function callbackfun_014(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        fMccorr=str2double(freq_field7.String);
        freq_field7.String=num2str(fMccorr);
        hndl2.Value=1;
    end
    
    function callbackfun_015(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        close;
        done;
    end
    
    function callbackfun_016(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ZG.inb1=hndl2.Value;
        tgl1=tgl1.Value;
        tgl2=tgl2.Value;
        bBst_button = get(chKBst_button, 'Value');
        prev_grid=prev_grid.Value;
        create_grid=create_grid.Value;
        load_grid=load_grid.Value;
        save_grid=save_grid.Value;
        oldfig_button=oldfig_button.Value;
        close;
        my_calculate();
    end
    
end
