% This script evaluates the percentage of space time coevered by
%alarms
%

global abo iala
re = [];

% Stefan Wiemer    4/95

report_this_filefun(mfilename('fullpath'));

abo = abo2;

titStr ='Warning!                                        ';

messtext= ...
    ['                                                '
    ' This rountine sometimes takes a long time!     '
    '  and may run out of memory. You can interupt   '
    ' the calculation with a ^C. The results         '
    ' calculated so far are stored in the variable re'];

zmap_message_center.set_message(titStr,messtext);
figure_w_normalized_uicontrolunits(mess)

def = {'5','0.1'};
tit ='Alarm Group Calculation';
prompt={'Minimum Zalarm to be used ?', 'Step width used ?'};

ni2 = inputdlg(prompt,tit,1,def);
l = ni2{1};
zm = str2double(l);
l = ni2{2};
is = str2double(l);

for tre2 = max(abo(:,4))-0.1:-is:zm
    tre2;
    abo = abo2;
    abo(:,5) = abo(:,5)* par1/365 + a(1,3);
    l = abo(:,4) >= tre2;
    abo = abo(l,:);
    l = abo(:,3) < tresh;
    abo = abo(l,:);
    disp([' Current Alarm threshold:  ' num2str(tre2) ])
    disp(['Number of alarms:  ' num2str(length(abo(:,1))) ])
    hold on

    j = 0;
    tmp = abo;

    while length(abo) > 1;
        j = j+1;
        [k,m] = findneic(1);
        po = [k];
        for i = 1:length(k)
            [k2,m2]  = findneic(k(i));
            po = [po ; k2];
        end
        po = sort(po);
        po2 = [0;  po(1:length(po)-1)] ;
        l = find(po-po2 > 0) ;
        po3 = po(l) ;
        do = ['an' num2str(j) ' = abo(po3,:);'];
        disp([num2str(j) '  Anomalie groups  found'])
        eval(do)
        abo(po3,:) =[];
    end   % while j


    re = [re ; tre2 j ];
end   % for tre2


figure

matdraw
axis off

uicontrol('Units','normal',...
    'Position',[.0 .65 .08 .06],'String','Save ',...
     'Callback',{@calSave9, re(:,1), re(:,2)})

rect = [0.20,  0.10, 0.70, 0.60];
axes('position',rect)
hold on
pl = plot(re(:,1),re(:,2),'r');
set(pl,'LineWidth',1.5)
pl = plot(re(:,1),re(:,2),'ob');
set(pl,'LineWidth',1.5,'MarkerSize',10)

set(gca,'visible','on','FontSize',ZmapGlobal.Data.fontsz.m,'FontWeight','bold',...
    'FontWeight','bold','LineWidth',1.5,...
    'Box','on')
grid

ylabel('Number of Alarm Groups')
xlabel('Zalarm ')
watchoff

