function newsta(sta) % autogenerated function wrapper
    %  A as(t) value is calculated for a given cumulative number curve and displayed in the plot.
    %  Operates on catalogue ZG.newcat
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    
    
    % start and end time
    
    think
    report_this_filefun(mfilename('fullpath'));
    b = ZG.newcat;
    
    %select big evenets
    l = ZG.newt2.Magnitude > ZG.big_eq_minmag;
    big = ZG.newt2.subset(l);
    
    [ZG.compare_window_yrs, ZG.bindays] = choose_parameters(ZG.compare_window_yrs, ZG.bindays); % window length, bin length
    
    
    t0b = min(ZG.newt2.Date); % changed from ZG.a.Date
    teb = max(ZG.newt2.Date); % changed from ZG.a.Date
    tdiff = round(days(teb - t0b)/ZG.bin_days); % in days/ZG.bin_days
    
    % for hist, xt & 2nd parameter were centers.  for histcounts, it is edges.
    [cumu, xt] = histcounts(ZG.newt2.Date, t0b: ZG.bin_days :teb);
    xt = xt + (xt(2)-xt(1))/2; xt(end)=[]; % convert from edges to centers!
    cumu2=cumsum(cumu);
    
    
    %  winlen_days is the cutoff at the beginning and end of the analyses to avoid spikes at the end
    % winlen_days = 10;
    
    
    % calculate mean and z value
    
    ncu = length(xt);
    as = nan(1,ncu);
    
    winlen_days = floor(ZG.compare_window_yrs/days(ZG.bin_days));
    probabilityButtonCallback=[];
    switch sta
        case 'rub'
            for i = winlen_days:1:tdiff-winlen_days
                mean1 = mean(cumu(1:i));
                mean2 = mean(cumu(i+1:i+winlen_days));
                var1 = cov(cumu(1:i));
                var2 = cov(cumu(i+1:i+winlen_days));
                as(i) = (mean1 - mean2)/(sqrt(var1/i+var2/winlen_days));
                titletext=['Rubberband Function; wl = ', num2str(ZG.compare_window_yrs)];
            end
        case 'ast'
            for i = floor(winlen_days):floor(tdiff-winlen_days)
                mean1 = mean(cumu(1:i));
                mean2 = mean(cumu(i+1:ncu));
                var1 = cov(cumu(1:i));
                var2 = cov(cumu(i+1:ncu));
                as(i) = (mean1 - mean2)/(sqrt(var1/i+var2/(tdiff-i)));
                titletext=['AS(t) Function; wl = ', num2str(ZG.compare_window_yrs)];
            end
        case 'lta'
            for i = 1:length(cumu)-winlen_days
                cu = [cumu(1:i-1) cumu(i+winlen_days+1:ncu)];
                mean1 = mean(cu);
                mean2 = mean(cumu(i:i+winlen_days));
                var1 = cov(cu);
                var2 = cov(cumu(i:i+winlen_days));
                as(i) = (mean1 - mean2)/(sqrt(var1/(ncu-winlen_days)+var2/winlen_days));
                titletext=['LTA(t) Function; wl = ', num2str(ZG.compare_window_yrs)];
                probabilityButtonCallback=@(~,~)translating('z');
            end
        case 'bet'
            Catalog=ZG.newcat;
            NumberBins = length(xt);
            BetaValues = zeros(1,NumberBins)*NaN;
            TimeBegin = min(Catalog.Date);
            NumberEQs = Catalog.Count;
            TimeEnd = max(Catalog.Date);
            
            if (ZG.compare_window_yrs >= TimeEnd-TimeBegin) || (ZG.compare_window_yrs <= 0)
                errordlg('winlen_days is either too long or too short.');
                return;
            end
            
            for i = 1:length(cumu)-winlen_days
                EQIntervalReal=sum(cumu(i:i+(winlen_days-1)));
                NormalizedIntervalLength=winlen_days/NumberBins;
                STDTheor=sqrt(NormalizedIntervalLength*NumberEQs*(1-NormalizedIntervalLength));
                BetaValues(i) = (EQIntervalReal-(NumberEQs*NormalizedIntervalLength))/STDTheor;
            end
            as = BetaValues;
            titletext=['LTA(t) Function; \beta-values; wl = ', num2str(ZG.compare_window_yrs)];
            probabilityButtonCallback=@(~,~)translating('beta');
    end
    
    %  Plot the as(t)
    cum=findobj('Type','Figure','-and','Name','Cumulative Number Statistic');
    
    % Set up the Cumulative Number window
    
    assert(~isempty(cum))
    figure(cum);
    delete(findobj(cum,'Type','axes'));
    tet1 = '';
    try delete(sinewsta); catch ME; error_handler(ME, ' '); end
    try delete(te2); catch ME; error_handler(ME, ' '); end
    try delete(ax1); catch ME; error_handler(ME, ' '); end
    %clf
    hold on
    set(gca,'visible','off','FontSize',ZmapGlobal.Data.fontsz.m,...
        'LineWidth',1.5,...
        'Box','on')
    
    % orient tall
    set(gcf,'PaperPosition',[2 1 5.5 7.5])
    rect = [0.2,  0.15, 0.65, 0.75];
    axes('position',rect)
    [pyy,ax1,ax2] = plotyy(xt,cumu2,xt,as);
    
    set(pyy(2),'YLim',[min(as)-2  max(as)+5],'XLim',[t0b teb],...
        'XTicklabel',[],'TickDir','out')
    xl = get(pyy(2),'XLim');
    set(pyy(1),'XLim',xl);
    
    set(ax1,'LineWidth',2.0,'Color','b')
    set(ax2,'LineWidth',1.0,'Color','r')
    xlabel('Time in years ','FontWeight','normal','FontSize',ZmapGlobal.Data.fontsz.m)
    ylabel('Cumulative Number ','FontWeight','normal','FontSize',ZmapGlobal.Data.fontsz.m)
    
    if ~isempty(probabilityButtonCallback)
        uicontrol('Style','Pushbutton','Units','normal',...
            'Position',[.35 .0 .3 .05],'String','Translate into probabilities',...
            'callback',probabilityButtonCallback);
    end
    
    title(titletext,'FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m,'Color','k');
    
    i = find(as == max(as));
    if length(i) > 1
        i = i(1);
    end
    
    tet1 =sprintf('Zmax: %3.1f at %s ',max(as),char(xt(i),'uuuu-MM-dd hh:mm:ss'));
    
    vx = xlim;
    vy = ylim;
    xlim([vx(1), dateshift(teb,'end','Year') ]);
    ylim([vy(1),  vy(2)+0.05*vy(2)]);
    te2 = text(vx(1)+0.5, vy(2)*0.9,tet1);
    set(te2,'FontSize',ZmapGlobal.Data.fontsz.m,'Color','k','FontWeight','normal')
    
    grid
    set(gca,'Color',color_bg)
    
    hold on;
    
    
    % plot big events on curve
    %
    if ~isempty(big)
        l = ZG.newt2.Magnitude > ZG.big_eq_minmag;
        f = find( l  == 1);
        bigplo = plot(big.Date,f,'hm');
        set(bigplo,'LineWidth',1.0,'MarkerSize',10,...
            'MarkerFaceColor','y','MarkerEdgeColor','k')
        stri4 = [];
        for i = 1:big.Count
            s = sprintf('  M=%3.1f',big.Magnitude(i));
            stri4 = [stri4 ; s];
        end
    end
    
    
    % repeat button
    
    uicontrol('Units','normal',...
        'Position',[.25 .0 .08 .05],'String','New',...
        'callback',@callbackfun_003)
    
    if exist('stri', 'var')
        vx=xlim;
        vy=ylim;
        %v = axis;
        
        tea = text(vx(1)+0.5,vy(2)*0.9,stri) ;
        set(tea,'FontSize',ZmapGlobal.Data.fontsz.m,'Color','k','FontWeight','normal')
    else
        strib = [file1];
    end
    
    strib = [name];
    
    set(cum,'Visible','on');
    figure(cum);
    watchoff
    watchoff(cum)
    done
    
    xl = get(pyy(2),'XLim');
    set(pyy(1),'XLim',xl);
    
    
    %%
    
    function [winLengthYears, binDays] = choose_parameters(winLengthYears, binDays) % window length, bin length
        def = {winLengthYears, binDays};
        tit ='beta computation input parameters';
        prompt={ 'Compare window length (years)',...
            'bin length (days)',...
            };
        ni2 = inputdlg(prompt,tit,1,def);
        
        winLengthYears = str2double(ni2{1});
        binDays = str2double(ni2{2});
    end
    
    %% callback functions
    function callbackfun_003(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        newsta(sta); % cannot e put directly into uicontrol's callback because 'sta' would be unchanging
    end
end
