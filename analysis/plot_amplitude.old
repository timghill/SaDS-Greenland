%% Plot moulin diurnal amplitude in 2011, 2012, 2015, 2016

fs = 8;

addpath(genpath('~/sglads/SaDS/SaDS/functions/'));
addpath(genpath('../'))

myears = [2011, 2012, 2015, 2016];
tmins = [datetime(2011, 1, 1)];
tmaxs = [datetime(2011, 1, 1)];

fig = figure('Units', 'centimeters', 'Position', [5, 5, 15, 10]);
left_color = [.5 .5 0];
right_color = [0 .5 .5];
% set(fig,'defaultAxesColorOrder',[left_color; right_color]);

cc = colororder;
ctrans = cc;
ctrans(:, 4) = 0.33;

alphabet = {'a (2011)', 'b (2012)', 'c (2015)', 'd (2016)'};

T = tiledlayout(2, 2, 'TileSpacing', 'tight', 'Padding', 'compact');

for ii=1:length(myears)
% for ii=1
    outs = load(sprintf('../outputs/greenland_%d_regrow.mat', myears(ii)));
    
    
    tt = outs.outputs.tt/86400;
    times = datetime(myears(ii), 1, 1) + days(tt);
%     ticklocs = [datetime(year, 6, 1), datetime(year, 6, 15), datetime(year, 7, 1),...
%             datetime(year, 7, 15), datetime(year, 8, 1), datetime(year, 8, 15), datetime(year, 9, 1)];
    ticklocs = [datetime(myears(ii), 6, 1), datetime(myears(ii), 7, 1), datetime(myears(ii), 8, 1), datetime(myears(ii), 9, 1)];
    
    tmins(ii) = datetime(2011, month(times(1)), day(times(1)));
    tmaxs(ii) = datetime(2011, month(times(end)), day(times(end)));

    ii_map = [1, 3, 2, 4];
%     subplot(2, 2, ii_map(ii))
    nexttile(ii_map(ii))
    hold on
    
    n_moulins = size(outs.outputs.m_moulin, 1);
    amp = zeros(n_moulins, length(outs.outputs.tt));
    for kk=1:n_moulins
        mm = smooth_da(outs.outputs.tt, outs.outputs.m_moulin(kk, :));
        amp(kk, :) = mm;
    end
    amp_mean = movmean(amp, 12*7, 2, 'omitnan');
    
    hold on
    for kk=1:7
        plot(times, amp(kk, :), 'Color', ctrans(kk, :))
    end
    
    plot(times, amp_mean)

%     ylim([0, 80])
    ylim([0, 15])
    text(0.025, 0.9, alphabet{ii}, 'Units', 'normalized', 'FontSize', fs)
    grid on
    
    
    if ii==3 || ii==4
        set(gca, 'YTickLabels', [])
    end
    
    if ii_map(ii)<3
        set(gca, 'XTickLabels', [])
    end
    
    set(gca, 'FontSize', fs);
    
    box off
    minticks = [datetime(myears(ii), 6, 1), datetime(myears(ii), 6, 15), datetime(myears(ii), 7, 1),...
            datetime(myears(ii), 7, 15), datetime(myears(ii), 8, 1), datetime(myears(ii), 8, 15), datetime(myears(ii), 9, 1)];
    hax = gca;
    hax.MinorGridLineStyle = '-';
    set(hax, 'XMinorGrid', 'on')
    hax.XAxis.MinorTickValues = minticks;
end

% linkaxes([nexttile(1), nexttile(2)], 'y')
% linkaxes([nexttile(3), nexttile(4)], 'y')
% 
% linkaxes([nexttile(1), nexttile(3)], 'x')
% linkaxes([nexttile(2), nexttile(4)], 'x')

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

nexttile(3)
% xlabel('Day of year')

nexttile(4)
% xlabel('Day of year')

nexttile(1)
ylabel('Amplitude (m^3/s)', 'FontSize', fs)

nexttile(3)
ylabel('Amplitude (m^3/s)', 'FontSize', fs)

% Fix tick labels
ax3 = nexttile(3);
ax3.XTickLabel = ax3.XTickLabel;

ax4 = nexttile(4);
ax4.XTickLabel = ax4.XTickLabel;


print('figures/moulin_amplitude', '-dpng', '-r600')
print('figures/moulin_amplitude', '-depsc')

