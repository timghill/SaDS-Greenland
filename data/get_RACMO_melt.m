function [ms_handle, msc_handle] = get_RACMO_melt(year)
% get_RACMO_melt. Return function handle to evaluate RACMO melt.
%
% Interpolates linearly in time to calculate RACMO melt at any arbitrary
% time
% 
% [ms_handle, msc_handle] = get_RACMO_melt(year)
%
% Function handles have call signature
% melt = ms_handle(t);
% melt_edge = msc_handle(t);

if year>0
    racmofile = sprintf('RACMO/RACMO_snowmelt_%d.mat', year);
    edgefile = sprintf('RACMO/RACMO_edge_snowmelt_%d.mat', year);
else
    racmofile = 'RACMO/RACMO_snowmelt_median.mat';
    edgefile = 'RACMO/RACMO_edge_snowmelt_median.mat';
end
% Read in the processed data
racmo_melt = load(racmofile);

edge_melt_file = load(edgefile);
edge_melt = edge_melt_file.snowmelt;

melt = racmo_melt.snowmelt;
tt = racmo_melt.tt;

if year>0
    tt_seconds = seconds(tt - datetime(year, 1, 1));
else
    tt_seconds = seconds(tt - datetime(2020, 1, 1));
end

ms_handle = @(t) max(interp1(tt_seconds, melt', t, 'linear')', 0);
msc_handle = @(t) max(interp1(tt_seconds, edge_melt', t, 'linear')', 0);

end