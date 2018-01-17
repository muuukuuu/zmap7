function add_menu_catalog(mycatalog, myview, force, figureHandle)
    % add_menu_catalog was create_catalog_menu adds a menu designed to handle catalog modifications
    % add_menu_catalog(mycatalog, force, handle)
    % mycatalog is a name of the ZmapGlobal.Data field containing a ZmapCatalog
    % myview is a name of the ZmapGlobal.Data.View field containing a ZmapCatalogView
    %
    % Menu Options:
    %   Crop catalog to window -
    %   Edit Ranges -
    %   Rename - 
    %   - - -
    %   Memorize/Recall Catalog -
    %   Clear Memorized Catalog -
    %   - - -
    %   Combine Catalogs -
    %   Compare Catalogs -
    %   Save Current Catalog - save as a ZmapCatdalog (.mat) or a v6 or v7+ ASCII table (.dat)
    %   - - -
    %   Stats -
    %   Get/Load Catalog - 
    %   Reload Last Catalog -
    
    
    %TODO clear up mess between ZG.catalogs and ZG.Views.view
    
    % to find this menu, use findobj(figurehandle, 'Tag', mytag);
    mytag = 'menu_catalog';
    
    %
    %mycatalog = 'primeCatalog';
    
    ZG = ZmapGlobal.Data; % for use in all subroutines
    h = findobj(figureHandle,'Tag','menu_catalog');
    if ~isempty(h) && exist('force','var') && force
        delete(h); h=[];
    end
    if ~isempty(h)
        return
    end
    
    submenu = uimenu('Label','Catalog','Tag','menu_catalog');
    
    switch figureHandle.Name
        case 'Seismicity Map'
            uimenu(submenu,'Label','Crop main catalog to window axes','Callback',@cb_crop);
            uimenu(submenu,'Label','Crop main catalog to shape','Callback',@cb_shapecrop);
            
        case 'Cumulative Number'
            uimenu(submenu,'Label','Replace main catalog','Callback',@cb_replace_main);
            uimenu(submenu,'Label','Crop main catalog to shape','Callback',@cb_shapecrop);
    end
        
    
    uimenu(submenu,'Label','Edit Ranges...','Callback',@cb_editrange);
    
    % choose a time range by clicking on the axes. only available if x-axis is a datetime axis.
    uimenu(submenu,'Label','Cut in Time (cursor) ','Callback',@cursor_timecut_callback);
            
    uimenu(submenu,'Label','Rename...','Callback',@cb_rename);
    
    uimenu(submenu,'Label','Memorize/Recall Catalog','Callback',@(~,~) memorize_recall_catalog,...
        'Separator','on');
    
    uimenu(submenu,'Label','Clear Memorized Catalog','Callback',@cb_clearmemorized);
    
    uimenu(submenu,'Label','Combine catalogs','Callback',@cb_combinecatalogs,...
        'Separator','on');
    
    uimenu(submenu,'Label','Compare catalogs - find identical events','Callback',@(~,~)comp2cat);
    
    uimenu(submenu,'Label','Save current catalog','Callback',@(~,~)save_zmapcatalog(ZG.(mycatalog)));
    catexport = uimenu(submenu,'Label','Export current catalog...');
    uimenu(catexport,'Label','to workspace (ZmapCatalog)','Callback',@(~,~)exportToWorkspace(ZG.(mycatalog)),...
        'Enable','off');
    uimenu(catexport,'Label','to workspace (Table)','Callback',@(~,~)exportToTable(ZG.(mycatalog)),...
        'Enable','off');
    
    uimenu(submenu,'Label','Info (Summary)','Callback',@(~,~)info_summary_callback(mycatalog),...
        'Separator','on');
    
    catmenu = uimenu(submenu,'Label','Get/Load Catalog',...
        'Separator','on');
    
    uimenu(submenu,'Label','Reload last catalog','Callback',@cb_reloadlast,...
        'Enable','off');
    
    uimenu(catmenu,'Label','from *.mat file','Callback', {@(s,e) load_zmapfile() });
    uimenu(catmenu,'Label','from other formatted file','Callback', @(~,~)zdataimport());
    uimenu(catmenu,'Label','from FDSN webservice','Callback', @get_fdsn_data_from_web_callback);
    
    
    uimenu(catmenu,'Separator','on','Label','Set as main catalog',...
        'callback',@cb_keep); % Replaces the primary catalog, and replots this subset in the map window
    uimenu(catmenu,'Separator','on','Label','Reset',...
        'callback',@cb_resetcat); % Resets the catalog to the original selection
    
    uimenu (catmenu,'Label','Decluster the catalog',...
        'callback',@(~,~)inpudenew())
    
    function cb_crop(~,~)
        ZG.(mycatalog).setFilterToAxesLimits(findobj(figureHandle, 'Type','Axes'))
        ZG.(mycatalog).cropToFilter();
        zmap_update_displays();
    end
    
    function cb_replace_main(~,~)
        ZG.primeCatalog=ZG.(mycatalog);
        zmap_update_displays();
    end
    
    function cb_shapecrop(~,~)
        if isempty(ZG.selection_shape) || isnan(ZG.selection_shape.Points(1))
            errordlg('No shape exists. Create one from the selection menu first','Cannot crop to shape');
            return
        end
        events_in_shape = ZG.selection_shape.isInside(ZG.(mycatalog).Longitude, ZG.(mycatalog).Latitude);
        ZG.(mycatalog)=ZG.(mycatalog).subset(events_in_shape);
        zmap_update_displays();
    end
    
    function cb_editrange(~,~)
        [tmpcat,ZG.maepi,ZG.big_eq_minmag] = catalog_overview(ZmapCatalogView(mycatalog), ZG.big_eq_minmag);
        ZG.Views.(myview)=tmpcat;
        ZG.(mycatalog)=tmpcat.Catalog();
        zmap_update_displays();
    end
    
    function cb_rename(~,~)
        oldname=ZG.(mycatalog).Name;
        [~,~,newname]=smart_inputdlg('Rename',...
            struct('prompt','Catalog Name:','value',oldname));
        ZG.(mycatalog).Name=newname;
        %ZmapMessageCenter.update_catalog();
        %zmap_update_displays();
    end
    
    function cb_clearmemorized(~,~)
        if isempty(ZG.memorized_catalogs)
            msg='No catalogs are currently memorized';
        else
            msg='The memorized catalog has been cleared.';
        end
        ZG.memorized_catalogs=[];
        msgbox(msg,'Clear Memorized');
    end
    
    function cb_reloadlast(~,~)
        error('Unimplemented create this function from scratch!');
    end
    
    function cb_combinecatalogs(~,~)
        ZG.newcat=comcat(ZG.Views.(myview));
        timeplot('newcat');
    end
    
    function cursor_timecut_callback(src,~)
        % will change ZG.newt2
        
        ax = findobj(figureHandle,'Type','axes');
        showTimeCut = any(arrayfun(@(x)isa(get(x,'Xaxis'),'matlab.graphics.axis.decorator.DatetimeRuler'),ax));
        if ~showTimeCut
            src.Visible='off';
            msgbox('The X axis is not a datetime axis, so this menu item will not work.','Inactive Menu Item');
        end
        
        [tt1,tt2]=timesel('cum');
        %ZG.Views.(myview).DateRange=[tt1, tt2];
        ZG.(mycatalog)=ZG.(mycatalog).subset(ZG.(mycatalog).Date>=tt1 & ZG.(mycatalog).Date<=tt2);
        pl=CumTimePlot.getInstance()
        pl.reset()
    end

end

function exportToWorkspace(catalog)
    safername=catalog.Name;
    safername(~ismember(safername,['a':'z','A':'Z','0':'9']))='_';
    fn=inputdlg('Variable Name for export:','Export to workspace',1,safername);
    if ~isempty(fn)
        assignin('base',fn{1},catalog)
    end
end

function exportToTable(catalog)
    safername=catalog.Name;
    safername(~ismember(safername,['a':'z','A':'Z','0':'9']))='_';
    fn=inputdlg('Variable Name for export:','Export to workspace',1,safername);
    if ~isempty(fn)
        assignin('base',fn{1},catalog.table())
    end
end
    

function info_summary_callback(mycatalog)
    ZG=ZmapGlobal.Data;
    summarytext=ZG.(mycatalog).summary('stats');
    f=msgbox(summarytext,'Catalog Details');
    f.Visible='off';
    f.Children(2).Children.FontName='FixedWidth';
    p=f.Position;
    p(3)=p(3)+95;
    p(4)=p(4)+10;
    f.Position=p;
    f.Visible='on';
end
