%% Plot moulin discharge in 2011, 2012, 2015, 2016

fs = 8;

addpath(genpath('~/sglads/SaDS/SaDS/functions/'));
addpath(genpath('../'))

myears = [2011, 2012, 2015, 2016];
tmins = [datetime(2011, 1, 1)];
tmaxs = [datetime(2011, 1, 1)];

fig = figure('Units', 'centimeters', 'Position', [5, 5, 15, 10]);
left_color = [.5 .5 0];
right_color = [0 .5 .5];

cc = colororder;

alphabet = {'a (2011)', 'b (2012)', 'c (2015)', 'd (2016)'};

T = tiledlayout(2, 2, 'TileSpacing', 'tight', 'Padding', 'compact');

for ii=1:length(myears)
% for ii=1
    outs = load(sprintf('../outputs/greenland_%d_regrow.mat', myears(ii)));
    
    melt_fun = get_RACMO_melt(myears(ii));


    ii_map = [1, 3, 2, 4];
%     subplot(2, 2, ii_map(ii))
    nexttile(ii_map(ii))
    
    tt = outs.outputs.tt/86400;
    times = datetime(myears(ii), 1, 1) + days(tt);
%     ticklocs = [datetime(year, 6, 1), datetime(year, 6, 15), datetime(year, 7, 1),...
%             datetime(year, 7, 15), datetime(year, 8, 1), datetime(year, 8, 15), datetime(year, 9, 1)];
    ticklocs = [datetime(myears(ii), 6, 1), datetime(myears(ii), 7, 1), datetime(myears(ii), 8, 1), datetime(myears(ii), 9, 1)];
    
    tmins(ii) = datetime(2011, month(times(1)), day(times(1)));
    tmaxs(ii) = datetime(2011, month(times(end)), day(times(end)));
    
    melt = mean(melt_fun(outs.outputs.tt)*86400);
    melt = movmean(melt, 12);
    plot(times, melt*80/0.08, 'Color', 'k')
    xticks(ticklocs)
    hold on
    
    set(gca,'ColorOrderIndex',1, 'FontSize', fs)
    plot(times, outs.outputs.m_moulin)

    xlim([times(1), times(end)])
    ylim([0, 80])
    text(0.025, 0.9, alphabet{ii}, 'Units', 'normalized', 'FontSize', fs)
    grid on
    
    
    if ii==3 || ii==4
        set(gca, 'YTickLabels', [])
    end
    
    if ii_map(ii)<3
        set(gca, 'XTickLabels', [])
    end
    
    
    yyaxis right
    set(gca, 'YColor', 'k')
%     plot(outs.outputs.tt/86400, melt, 'Color', 'k', 'LineWidth', 1)
    if ii==1 || ii==2
        set(gca, 'YTickLabels', [])
    else
        ylabel('Melt (m/day)', 'FontSize', fs)
    end
    ylim([0, 0.08])
    
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
yyaxis left
ylabel('Discharge (m^3/s)', 'FontSize', fs)

nexttile(3)
yyaxis left
ylabel('Discharge (m^3/s)', 'FontSize', fs)

% Fix tick labels
ax3 = nexttile(3);
ax3.XTickLabel = ax3.XTickLabel;

ax4 = nexttile(4);
ax4.XTickLabel = ax4.XTickLabel;

% fig.text(0.5, 0.1, 'Day of year', 'Units', 'no

print('figures/discharge', '-dpng', '-r600')
print('figures/discharge', '-depsc')
