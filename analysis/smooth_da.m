function da = smooth_da(tt, mm)

tt_days = [];
tt_maxs = [];
tt_mins = [];
maxs = [];
mins = [];

dt = tt(2) - tt(1);
bin_len = floor(86400/dt);
n_days = (length(tt)-1)/bin_len;

for i=1:n_days
    imin = (i-1)*bin_len + 1;
    imax = i*bin_len;
    discharge_day = mm(imin:imax);
    tt_days(i) = tt(imin);
    tt_day = tt(imin:imax);
    
    [m_max, i_max] = max(discharge_day);
    [m_min, i_min] = min(discharge_day);
    tt_maxs(i) = tt_day(i_max);
    tt_mins(i) = tt_day(i_min);
    
    maxs(i) = m_max;
    mins(i) = m_min;
end

% tt_maxs = full([tt(1), tt_maxs]);
% maxs = full([mm(1), maxs]);
min_interp = interp1(tt_mins, mins, tt, 'linear');
max_interp = interp1(tt_maxs, maxs, tt, 'linear');

min_interp = movmean(min_interp, 12);
max_interp = movmean(max_interp, 12);

da = max_interp - min_interp;
da(da<0) = 0;
end