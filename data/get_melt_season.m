function [onset, freeze] = get_melt_season(year)
% get_melt_season returns the start and end days of the melt season.
%
% [onset, freeze] = get_melt_season(year) returns the melt onset and freeze
% up days for the specified year. If year==0, returns the median melt
% season. The days are given as integer day numbers. The dates provide the
% minimum covering extent. You may want to pad the end of the melt season
% with a few extra days to let the system drain.
%
% This function does not do any validation on the inputs. year must be an
% integer that corresponds to a year in the input csv file, or 0 to return
% the median melt season.

% Read the melt season CSV file. You can inspect the file manually since
% it's small.
F = readtable('melt_season.csv');

rowindex = find(F.Year == year);
if isempty(rowindex)
    error('Year %s not found', year);
else
    onset = F.StartDayNum(rowindex);
    freeze = F.EndDayNum(rowindex);
end
