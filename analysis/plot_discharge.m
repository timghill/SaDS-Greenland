%% Plot moulin discharge in 2011, 2012, 2015, 2016

% Set figure fontsize
fs = 8;

% Add paths to necessary functions
addpath(genpath('../data/'));
addpath(genpath('/home/tghill/projects/def-c3dow/tghill/SaDS/MMATH/cases/greenland/data/RACMO'))

% Set years to plot
myears = [2011, 2012, 2015, 2016];
alphabet = {'a (2011)', 'b (2012)', 'c (2015)', 'd (2016)'};

fig = figure('Units', 'centimeters', 'Position', [5, 5, 15, 10]);
T = tiledlayout(2, 2, 'TileSpacing', 'tight', 'Padding', 'compact');
for ii=1:length(myears)
    outs = load(sprintf('../outputs/greenland_%d_regrow.mat', myears(ii)));
    
    % Get handle to RACMO melt data
    melt_fun = get_RACMO_melt(myears(ii));

    % Find correct subplot index since panels are ordered 2011, 2015, 2012,
    % 2016
    ii_map = [1, 3, 2, 4];
    ax = nexttile(ii_map(ii));
    
    % Convert time in seconds to a datetime array
    tt = outs.outputs.tt/86400;
    times = datetime(myears(ii), 1, 1) + days(tt);
    
    % Compute domain-averaged and 24-hour moving average melt
    melt = mean(melt_fun(outs.outputs.tt)*86400);
    melt = movmean(melt, 12);
    
    % Resert color index so moulins correpond to colors in overview figure
    set(ax,'ColorOrderIndex',1, 'FontSize', fs)
    plot(times, outs.outputs.m_moulin)  % Plot moulin discharge

    % Axes options
    ticklocs = [datetime(myears(ii), 6, 1), datetime(myears(ii), 7, 1), datetime(myears(ii), 8, 1), datetime(myears(ii), 9, 1)];
    xticks(ticklocs)
    
    % Set minor tick locations
    minticks = [datetime(myears(ii), 5, 15), datetime(myears(ii), 6, 1), datetime(myears(ii), 6, 15), datetime(myears(ii), 7, 1),...
            datetime(myears(ii), 7, 15), datetime(myears(ii), 8, 1), datetime(myears(ii), 8, 15), datetime(myears(ii), 9, 1)];
    ax.MinorGridLineStyle = '-';
    ax.XMinorGrid = 'on';
    ax.XAxis.MinorTickValues = minticks;
    
    ylim([0, 80])
    text(0.025, 0.9, alphabet{ii}, 'Units', 'normalized', 'FontSize', fs)
    grid on
    box off
    
    yyaxis right
    set(ax, 'YColor', 'k')
    set(gca, 'FontSize', fs)
    plot(times, melt, 'k')
    ylim([0, 0.08])
end

% Manually set xlims to the appropriately matched dates
xlim(nexttile(1), [datetime(2011, 5, 26), datetime(2011, 9, 4)])
xlim(nexttile(3), [datetime(2012, 5, 26), datetime(2012, 9, 4)])

xlim(nexttile(2), [datetime(2015, 5, 9), datetime(2015, 9, 14)])
xlim(nexttile(4), [datetime(2016, 5, 9), datetime(2016, 9, 14)])

nexttile(1)
yyaxis left
ylabel('Discharge (m^3/s)', 'FontSize', fs)
set(gca, 'XTickLabels', [])
yyaxis right
set(gca, 'YTickLabels', [])

nexttile(2)
yyaxis left
set(gca, 'YTickLabels', [])
set(gca, 'XTickLabels', [])
yyaxis right
ylabel('Melt (m w.e./day)', 'FontSize', fs)

nexttile(3)
yyaxis left
ylabel('Discharge (m^3/s)', 'FontSize', fs)
yyaxis right
set(gca, 'YTickLabels', [])

nexttile(4)
yyaxis left
set(gca, 'YTickLabels', [])
yyaxis right
ylabel('Melt (m w.e./day)', 'FontSize', fs)

% Fix tick labels - this removes the year from the xaxis tick labels
ax3 = nexttile(3);
ax3.XTickLabel = ax3.XTickLabel;

ax4 = nexttile(4);
ax4.XTickLabel = ax4.XTickLabel;

print('figures/discharge', '-dpng', '-r600')
print('figures/discharge', '-depsc')
