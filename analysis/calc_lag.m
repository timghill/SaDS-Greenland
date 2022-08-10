function [ttnew, lags] = calc_lag(tt, m_moulin)
% calc_lag: Calculate time of peak moulin input in hours
%
% ttnew: Time of midnight each day (seconds)
% lags: (n_moulins x n days) time (hours) of peak moulin input
dt = tt(2) - tt(1);
Nday = 86400/dt;

ttnew = [];
lags = [];

kk=0;
for ii=1:Nday:(length(tt)+1-Nday)
    kk = kk+1;
    tt_day = tt(ii:ii+Nday - 1);
    for jj=1:size(m_moulin, 1)
        daily_discharge = m_moulin(jj, ii:ii+Nday-1);
        [~, jj_peak] = max(daily_discharge);
        
        tt_peak = tt_day(jj_peak);
        lag = tt_peak - tt_day(1);
        
%         % Lag based on max
        lag = lag - 3600*15 - 60*22;
        
%       % Lag based on min
%         lag = lag - 3600*3 - 60*22;
        lags(jj, kk) = lag/3600;
    end
    ttnew(kk) = tt_day(1);
end

% lags(lags==-12) = 0;
