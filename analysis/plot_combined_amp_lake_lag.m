%% Plot moulin diurnal amplitude, moulin lag time, and lake depth in 2012
% and 2016

% Set figure fontsize
fs = 8;

% Explicitly load 2012 and 2015 outputs
outs_2012 = load('../outputs/greenland_2012_regrow.mat');
outs_2015 = load('../outputs/greenland_2015_regrow.mat');
alphabet = {'(a)', '(b)', '(c)', '(d)', '(e)', '(f)'};


% Colors for lakes
lake_colors = [
0.3516    0.6250    0.5508
0.8906    0.5547    0.3438
0.7812    0.4375    0.4922
0.2969    0.5703    0.6914];

moulin_colors = [   5.3125000e-01   7.9687500e-01   9.2968750e-01
   6.6406250e-02   4.6484375e-01   1.9921875e-01
   8.6328125e-01   7.9687500e-01   4.6484375e-01
   7.9687500e-01   3.9843750e-01   4.6484375e-01
   1.9921875e-01   1.3281250e-01   5.3125000e-01
   6.6406250e-01   2.6562500e-01   5.9765625e-01
   2.6562500e-01   6.6406250e-01   5.9765625e-01];


% Define semi-transparent colors
ctransp = moulin_colors;
ctransp(:, 4) = 0.33;

% Explicitly compute datetime arrays from time in seconds
tt_2012 = outs_2012.outputs.tt/86400;
times_2012 = datetime(2012, 1, 1) + days(tt_2012);

tt_2015 = outs_2015.outputs.tt/86400;
times_2015 = datetime(2015, 1, 1) + days(tt_2015);
    
fig = figure('Units', 'centimeters', 'Position', [5, 5, 17, 11]);
T = tiledlayout(3, 2, 'Padding', 'compact', 'TileSpacing', 'none');

%% Compute moulin diurnal amplitude in 2012 and 2015
n_moulins = size(outs_2012.outputs.m_moulin, 1);
amp_2012 = zeros(n_moulins, length(outs_2012.outputs.tt));
for kk=1:n_moulins
    mm = smooth_da(outs_2012.outputs.tt, outs_2012.outputs.m_moulin(kk, :));
    amp_2012(kk, :) = mm;
end



amp_2015 = zeros(n_moulins, length(outs_2015.outputs.tt));
for kk=1:n_moulins
    mm = smooth_da(outs_2015.outputs.tt, outs_2015.outputs.m_moulin(kk, :));
    amp_2015(kk, :) = mm;
end

% 7-day moving average amplitudes
amp_2012_mean = movmean(amp_2012, 12*7, 2, 'omitnan');
amp_2015_mean = movmean(amp_2015, 12*7, 2, 'omitnan');

%% Lake water depths
lake_indices = [3233, 3387, 2274, 2317];

a1 = nexttile(1);
set(a1, 'ColorOrder', moulin_colors)
hold on
for ii=1:7
    plot(times_2012, amp_2012(ii, :), 'Color', ctransp(ii, :))
end
plot(times_2012, amp_2012_mean)
ylabel('Amplitude (m^3 s^{-1})', 'FontSize', fs)
ticklocs_2012 = [datetime(2012, 6, 1), datetime(2012, 7, 1), datetime(2012, 8, 1), datetime(2012, 9, 1)];
minticks_2012 = [datetime(2012, 6, 1), datetime(2012, 6, 15), datetime(2012, 7, 1),...
        datetime(2012, 7, 15), datetime(2012, 8, 1), datetime(2012, 8, 15), datetime(2012, 9, 1)];
ylim([0, 15])

addpath(genpath('../data/'));
[melt_fun, ~] = get_RACMO_melt(2012);
% yyaxis right
melt_2012 = mean(melt_fun(outs_2012.outputs.tt)*86400);
melt_2012 = movmean(melt_2012, 12);



a2 = nexttile(2);
set(a2, 'ColorOrder', moulin_colors)
hold on
for ii=1:7
    plot(times_2015, amp_2015(ii, :), 'Color', ctransp(ii, :))
end
plot(times_2015, amp_2015_mean)
set(a2, 'YTickLabels', []);
% grid on
xlim([times_2015(1), times_2015(end)])
ticklocs_2015 = [datetime(2015, 6, 1), datetime(2015, 7, 1), datetime(2015, 8, 1), datetime(2015, 9, 1)];
minticks_2015 = [datetime(2015, 6, 1), datetime(2015, 6, 15), datetime(2015, 7, 1),...
        datetime(2015, 7, 15), datetime(2015, 8, 1), datetime(2015, 8, 15), datetime(2015, 9, 1)];
ylim([0, 15])

% yyaxis right
[melt_fun, ~] = get_RACMO_melt(2015);
melt_2015 = mean(melt_fun(outs_2015.outputs.tt)*86400);
melt_2015 = movmean(melt_2015, 12);
% set(gca, 'YColor', 'k')
% set(gca, 'FontSize', fs)
% plot(times_2015, melt_2015, 'k')
% ylim(gca, [0, 0.08])
% hold on
% ylabel('Melt (m/d)')
% yticks([0, 0.02, 0.04, 0.06, 0.08])
% yticklabels({'0.0', '0.02', '0.04', '0.06', '0.08'})

% linkaxes([a1, a2], 'y');



%% Lake water depth
a3 = nexttile(5);
hold on
for jj=1:length(lake_indices)
    plot(times_2012, outs_2012.outputs.hs(lake_indices(jj), :), 'Color', lake_colors(jj, :))
end
% colororder(a3, lake_colors)
ylabel('Lake depth (m)')
ylim([0, 3.5])

a4 = nexttile(6);
hold on
for jj=1:length(lake_indices)
    plot(times_2015, outs_2015.outputs.hs(lake_indices(jj), :), 'Color', lake_colors(jj, :))
end
colororder(a4, lake_colors)
a4.YTickLabels = [];
% linkaxes([a3, a4], 'y')
ylim([0, 3.5])

%% Moulin lags
t1_2012 = tt_2012(1)*86400;
tend_2012 = tt_2012(end)*86400;
dt = 10*60;

t1_2015 = tt_2015(1)*86400;
tend_2015 = tt_2015(end)*86400;

tt_smooth_2012 = t1_2012:dt:tend_2012;
tt_smooth_2015 = t1_2015:dt:tend_2015;

moulin_2012 = full(outs_2012.outputs.m_moulin([5, 7], :))';
moulin_2015 = full(outs_2015.outputs.m_moulin([5, 7], :))';

moulin_smooth_2012 = interp1(tt_2012*86400, moulin_2012, tt_smooth_2012, 'spline')';
moulin_smooth_2015 = interp1(tt_2015*86400, moulin_2015, tt_smooth_2015, 'spline')';

[tt_lags_2012, lags_2012] = calc_lag(tt_smooth_2012, moulin_smooth_2012);
[tt_lags_2015, lags_2015] = calc_lag(tt_smooth_2015, moulin_smooth_2015);

times_lag_2012 = datetime(2012, 1, 1) + seconds(tt_lags_2012);
times_lag_2015 = datetime(2015, 1, 1) + seconds(tt_lags_2015);


lags_2012(lags_2012>=20) = nan;
lags_2012(lags_2012<=0) = nan;

lags_2015(lags_2015>=20) = nan;
lags_2015(lags_2015<=0) = nan;

lags_2012_mean = movmean(lags_2012, 7, 2, 'omitnan');
lags_2015_mean = movmean(lags_2015, 7, 2, 'omitnan');

mask_2012 = ~isnan(mean(lags_2012));
mask_2015 = ~isnan(mean(lags_2015));
tt_2012_masked = tt_lags_2012(mask_2012);
tt_2015_masked = tt_lags_2015(mask_2015);

% lags_2012_masked = lags_2012(repmat(mask_2012, 2, 1));
lags_2012_masked = zeros(2, length(tt_2012_masked));
lags_2012_masked(1, :) = lags_2012(1, mask_2012);
lags_2012_masked(2, :) = lags_2012(2, mask_2012);

lags_2015_masked = zeros(2, length(tt_2015_masked));
lags_2015_masked(1, :) = lags_2015(1, mask_2015);
lags_2015_masked(2, :) = lags_2015(2, mask_2015);

lag_ctrans = ctransp([5, 7], :);

a5 = nexttile(3);
hold on
for ii=1:2
    plot(times_lag_2012(mask_2012), lags_2012_masked(ii, :), 'Color', lag_ctrans(ii, :))
end

lakes = [5, 7];
for jj=1:size(lags_2012_mean, 1)
    plot(times_lag_2012, lags_2012_mean(jj, :), 'Color', moulin_colors(lakes(jj) , :))
end
% grid on
colororder(a5, moulin_colors([5, 7], :))
% xlim([times_2012(1), times_2012(end)])
ylim([0, 10])
ylabel('T_{lag} (hour)', 'FontSize', fs)
% xticks(ticklocs_2012)

a6 = nexttile(4);
hold on
for ii=1:2
    plot(times_lag_2015(mask_2015), lags_2015_masked(ii, :), 'Color', lag_ctrans(ii, :))
end
for jj=1:2
    plot(times_lag_2015, lags_2015_mean(jj, :), 'Color', moulin_colors(lakes(jj), :))
end

% grid on
colororder(a6, moulin_colors([5, 7], :))
ylim([0, 10])
% xticks(ticklocs_2015)

% xlim([times_2015(1), times_2015(end)])

% linkaxes([a5, a6], 'y')

%% Adjust axes
for ii=[1, 3, 5]
    aii = nexttile(ii);
    aii.MinorGridLineStyle = '-';
    set(aii, 'XMinorGrid', 'on')
    aii.XAxis.MinorTickValues = minticks_2012;
    xlim([times_2012(1), times_2012(end)])
    aii.XTick = ticklocs_2012;
    aii.FontSize = fs;
    
    grid on
    
    yyaxis right
    set(gca, 'YColor', 'k')
    set(gca, 'FontSize', fs)
    plot(times_2012, melt_2012, 'Color', 0.4*ones(4, 1))
    ylim(gca, [0, 0.08])
    set(gca, 'YTickLabels', {})
    hold on
end

for jj=[2, 4, 6]
    ajj = nexttile(jj);
    hold on
    
    yyaxis left
    ajj.MinorGridLineStyle = '-';
    ajj.XMinorGrid = 'on';
    ajj.XAxis.MinorTickValues = minticks_2015;
    xlim([times_2015(1), times_2015(end)])
    ajj.XTick = ticklocs_2015;
    ajj.FontSize = fs;
    
    grid on
    ajj.YTickLabels = [];
    
    
    yyaxis right
    set(gca, 'YColor', 'k')
    set(gca, 'FontSize', fs)
    plot(times_2015, melt_2015, 'Color', 0.4*ones(4, 1));
    ylim(gca, [0, 0.08])
    if jj==4
    ylabel('Melt rate (m day^{-1})')
    end
    hold on

    
end

for ii=1:6
    aii = nexttile(ii);
    text(aii, 0.025, 0.9, alphabet{ii}, 'Units', 'normalized', 'FontSize', fs)
    
    if ii<5
        aii.XTickLabels = [];
    end
    set(aii, 'Box', 'off')
end

print('figures/amp_lake_lag_max_melt', '-dpng', '-r600')
print('figures/amp_lake_lag_max_melt', '-depsc')

% correlations
% interpolate lag time onto the same tt grid as the lake level
% lag_2012_interp = interp1(times_lag_2012(~isnan(lags_2012(1, :))), lags_2012(1, ~isnan(times_lag_2012)), times_2012);
lag_2012_interp = interp1(times_lag_2012(mask_2012), lags_2012_mean(1, mask_2012), times_2012(1:end-72), 'linear', 'extrap');

M = [lag_2012_interp; outs_2012.outputs.hs(lake_indices(1), 1:end-72)];

corrcoef(M')