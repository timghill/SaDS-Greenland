%% Plot moulin lag time in 2011, 2012, 2015, 2016

fs = 8;

addpath(genpath('~/sglads/SaDS/SaDS/functions/'))

fig = figure('Units', 'centimeters', 'Position', [5, 5, 15, 10]);
T = tiledlayout(2, 2, 'TileSpacing', 'tight', 'Padding', 'compact');

myears = [2011, 2012, 2015, 2016];
tmins = [datetime(2011, 1, 1)];
tmaxs = [datetime(2011, 1, 1)];

alphabet = {'a (2011)', 'b (2012)', 'c (2015)', 'd (2016)'};
ii_map = [1, 3, 2, 4];

% lake_indices = [3233, 2317, 3387, 2274];
lake_indices = [3233, 3387, 2274, 2317];
dem = load('../data/greenland_refined_elevation.mat');
lake_elevations = dem.z_element(lake_indices);

cc = colororder;

colororder(cc([5, 7], :));

cdef = colororder;
ctrans = cdef;
ctrans(:, 4) = 0.33;

for ii=1:length(myears)
% for ii=1
    outs = load(sprintf('../outputs/greenland_%d_regrow_highfreq.mat', myears(ii)));
%     outs = load(sprintf('../outputs/greenland_%d_regrow.mat', myears(ii)));
    dmesh = outs.params.dmesh;
    year = myears(ii);
    
    tt_orig = outs.outputs.tt;
    m_moulin_orig = full(outs.outputs.m_moulin([5, 7], :)');
    
    t1 = tt_orig(1);
    tend = tt_orig(end);
    dt = 10*60;
    
    tt_smooth = t1:dt:tend;
    m_moulin_smooth = interp1(tt_orig, m_moulin_orig, tt_smooth, 'spline')';
    
    [tt_lags, lags] = calc_lag(tt_smooth, m_moulin_smooth);
    lags(lags>=23) = nan;
    lags(lags<=0) = nan;
    
    lags_mean = movmean(lags, 7, 2, 'omitnan');


    tt = tt_lags/86400;
    times = datetime(year, 1, 1) + days(tt);
    
    tmins(ii) = datetime(2011, month(times(1)), day(times(1)));
    tmaxs(ii) = datetime(2011, month(times(end)), day(times(end)));
    
    nexttile(ii_map(ii));
    hold on
    for kk=1:2
        plot(times, lags(kk, :), 'linewidth', 1, 'Color', ctrans(kk, :))
    end
    plot(times, lags_mean)
%     xlim([times(1), times(end)])
    ticklocs = [datetime(year, 6, 1), datetime(year, 7, 1), datetime(year, 8, 1), datetime(year, 9, 1)];

    xticks(ticklocs)
    
    text(0.025, 0.9, alphabet{ii}, 'Units', 'normalized', 'FontSize', fs)
    grid on
    
    set(gca, 'FontSize', fs)
    
    
    if ii==3 || ii==4
        set(gca, 'YTickLabels', [])
    end
    
    if ii_map(ii)<3
        set(gca, 'XTickLabels', [])
    end
    
    box off
    
    minticks = [datetime(year, 6, 1), datetime(year, 6, 15), datetime(year, 7, 1),...
            datetime(year, 7, 15), datetime(year, 8, 1), datetime(year, 8, 15), datetime(year, 9, 1)];
    hax = gca;
    hax.MinorGridLineStyle = '-';
    set(hax, 'XMinorGrid', 'on')
    hax.XAxis.MinorTickValues = minticks;
    
    ylim([0, 24])
end

tt_min_left = min(tmins([1, 2]));
tt_min_left = datetime(2012, month(tt_min_left), day(tt_min_left));
tt_max_left = max(tmaxs([1, 2]));
tt_max_left = datetime(2012, month(tt_max_left), day(tt_max_left));

tt_min_right = min(tmins([3, 4]));
tt_max_right = max(tmaxs([3, 4]));

tt_min_right = datetime(2016, month(tt_min_right), day(tt_min_right));
tt_max_right = datetime(2016, month(tt_max_right), day(tt_max_right));

xlim(nexttile(1), [tt_min_left - years(1), tt_max_left - years(1)])
xlim(nexttile(3), [tt_min_left, tt_max_left])

xlim(nexttile(2), [tt_min_right - years(1), tt_max_right - years(1)])
xlim(nexttile(4), [tt_min_right, tt_max_right])

nexttile(1)
ylabel('T_{min} (hours)', 'FontSize', fs)

nexttile(3)
ylabel('T_{min} (hours)', 'FontSize', fs)


% Fix tick labels
ax3 = nexttile(3);
ax3.XTickLabel = ax3.XTickLabel;

ax4 = nexttile(4);
ax4.XTickLabel = ax4.XTickLabel;

print('figures/lag_time', '-dpng', '-r600')
print('figures/lag_time', '-depsc')

