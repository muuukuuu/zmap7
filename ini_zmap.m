%    This is the  ZMAP default file used for the SUN Version.
%    Customize setting if desired
%
report_this_filefun(mfilename('fullpath'));
%global ty ty1 ty2 ty3
%global rad xa0 ic ya0 step ni
%global strib stri2 infstri maix maiy
global ZG

ZG=ZmapGlobal.Data;
% Marker sizes
ZG.ms6 = 3;
%ms10 = 10;
%ms12 = 12;

% Marker type
%ty ='.';
%ty1 ='+';
%ty2 = 'o';
%ty3 ='x';
ZG.mainmap_plotby='depth';
sel  = 'in';

% set up Window size

% Various setups
%
%rad = 50.;
%ic = 0;
%ya0 = 0.;
%xa0 = 0.;
%ZG.compare_window_yrs_v3 = 1.;
%ZG.compare_window_yrs = 1.5;
%step = 3;
%ni = 100;

strib = ' ';
stri2 = [];
ZG.hold_state=false;
ZG.hold_state2=false;
infstri = ' Please enter information about the | current dataset here';
maix = [];
maiy = [];


% Initial Time setting

% Tresh is the radius in km below which blocks
% in the zmap's will be plotted
%
ZG.tresh_km = 50; %radius below which blocks in the zmap's will be plotted
ZG.xsec_width_km = 10 ;   % initial width of crossections
ZG.xsec_rotation_deg = 10; % initial rotation angle in cross-section window
ZG.freeze_colorbar = false;

% Set the Background color for the plot
% default \: light yellow 1 1 0.6
ZG.color_bg = [1.0 1.0 1.0];
in = 'initf';

% seislap default parameters
%ldx = 100;
%tlap = 100;

ZG.shading_style ='flat';
ZG.inb1=1;
ZG.inb2=1;
% inda = 1;
ZG.ra = 5;

ZG.someColor = 'w';
ZG.bin_days = days(14); % bin length, days
ZG.big_eq_minmag = 8; % minimum cutoff for "large" earthquakes

%set the recursion slightly, to avoid error (specialy with ploop functions)
set(0,'RecursionLimit',750)

