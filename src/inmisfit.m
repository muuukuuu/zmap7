function inmisfit() % autogenerated function wrapper
    %
    % make dialog interface for misfit calculation
    %
    % S. Wiemer/Zhong Lu/Alex Allmann
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    
    %
    report_this_filefun(mfilename('fullpath'));
    
    %if isunix ~= 1
    %  errordlg('Misfit laculation only implemented for UNIX version, sorry');
    %  return
    %end
    
    ZG.newcat = ZG.a;
    
    
    if size(a(1,:)) < 12
        errordlg('You need 12 columns of Input Data to calculate misfit!');
        return
    end
    
    sig = 1;
    az = 180.;
    plu = 35.;
    R = 0.5;
    phi = 16;
    
    
    %initial values
    figure
    clf
    set(gca,'visible','off')
    set(gcf,'Units','pixel','NumberTitle','off','Name','Input Parameters for Misfit Calculation');
    
    set(gcf,'pos',[ ZG.welcome_pos ZG.welx+100 ZG.wely+50])
    
    bev=find(ZG.newcat.Magnitude==max(ZG.newcat.Magnitude)); %biggest events in catalog
    
    
    %default values of input parameters
    %ldx=100; %for seislap
    %tlap=100; %for seislap
    latt=ZG.newcat(bev(1),2);
    longt=ZG.newcat(bev(1),1);
    binlength=1;
    Mmin=3;
    ldepth=ZG.newcat(bev(1),7);
    
    % creates a dialog box to input some parameters
    %
    txt1 = text(...
        'Position',[0. 0.96 0 ],...
        'FontWeight','bold',...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'String','Sigma 1 or 3? : ');
    
    
    txt2 = text(...
        'Position',[0. 0.81 0 ],...
        'FontWeight','bold',...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'String','Please input Plunge ');
    
    
    txt3 = text(...
        'Position',[0. 0.66 0 ],...
        'FontWeight','bold',...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'String','Please input Azimuth :');
    
    txt4 = text(...
        'Position',[0. 0.51 0 ],...
        'FontWeight','bold',...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'String','R value:');
    txt5 = text(...
        'Position',[0. 0.36 0 ],...
        'FontWeight','bold',...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'String','Phi :');
    %
    
    inp1_field  = uicontrol('Style','edit',...
        'Position',[.85 .87 .13 .08],...
        'Units','normalized','String',num2str(sig),...
        'callback',@callbackfun_001);
    
    
    
    inp2_field  = uicontrol('Style','edit',...
        'Position',[.85 .75 .13 .08],...
        'Units','normalized','String',num2str(plu),...
        'callback',@callbackfun_002);
    
    
    inp3_field=uicontrol('Style','edit',...
        'Position',[.85 .63 .13 .08],...
        'Units','normalized','String',num2str(az),...
        'callback',@callbackfun_003);
    
    inp4_field=uicontrol('Style','edit',...
        'Position',[.85 .51 .13 .08],...
        'Units','normalized','String',num2str(R),...
        'callback',@callbackfun_004);
    
    
    inp5_field=uicontrol('Style','edit',...
        'Position',[.85 .39 .13 .08],...
        'Units','normalized','String',num2str(phi),...
        'callback',@callbackfun_005);
    %
    close_button=uicontrol('Style','Pushbutton',...
        'Position', [.72 .05 .15 .12 ],...
        'Units','normalized','callback',@callbackfun_006,'String','Cancel');
    
    inflap_button=uicontrol('Style','Pushbutton',...
        'Position', [.49 .05 .15 .12 ],...
        'Units','normalized','callback',@callbackfun_007,'String','Info');
    
    compare_button=uicontrol('Style','Pushbutton',...
        'Position', [.27 .05 .15 .12 ],...
        'Units','normalized','callback',@callbackfun_008,'String','CompMod');
    
    go_button=uicontrol('Style','Pushbutton',...
        'Position',[.05 .05 .15 .12 ],...
        'Units','normalized',...
        'callback',@callbackfun_009,...
        'String','Go');
    
    set(gcf,'visible','on');watchoff
    
    
    function callbackfun_001(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        sig=str2double(inp1_field.String);
        inp1_field.String=num2str(sig);
    end
    
    function callbackfun_002(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        plu=str2double(inp2_field.String);
        inp2_field.String=num2str(plu);
    end
    
    function callbackfun_003(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        az=str2double(inp3_field.String);
        inp3_field.String=num2str(az);
    end
    
    function callbackfun_004(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        R=str2double(inp4_field.String);
        inp4_field.String=num2str(R);
    end
    
    function callbackfun_005(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        phi=str2double(inp5_field.String);
        inp5_field.String=num2str(phi);
    end
    
    function callbackfun_006(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        close;
        zmap_message_center();
    end
    
    function callbackfun_007(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        infoz(1);
    end
    
    function callbackfun_008(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        compMisfit;
    end
    
    function callbackfun_009(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        close;
        zmap_message_center();
        domisfit;
    end
    
end
