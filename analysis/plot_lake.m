%% Plot moulin amplitude in 2011, 2012, 2015, 2016

% Set figure fontsize
fs = 8;

% Add paths to necessary functions
addpath(genpath('../data/'));

% Set years to plot
myears = [2011, 2012, 2015, 2016];
alphabet = {'(a) 2011', '(b) 2012', '(c) 2015', '(d) 2015'};

% Default color order
lake_indices = [3233, 3387, 2274, 2317];
lake_colors = [0.3516    0.6250    0.5508
    0.8906    0.5547    0.3438
    0.7812    0.4375    0.4922
    0.2969    0.5703    0.6914];


fig = figure('Units', 'centimeters', 'Position', [5, 5, 17, 11]);
colororder(lake_colors)
T = tiledlayout(2, 2, 'TileSpacing', 'tight', 'Padding', 'compact');
for ii=1:length(myears)
    outs = load(sprintf('../outputs/greenland_%d_regrow.mat', myears(ii)));

    % Find correct subplot index since panels are ordered 2011, 2015, 2012,
    % 2016
    ii_map = [1, 3, 2, 4];
    ax = nexttile(ii_map(ii));
    hold on
    
    % Convert time in seconds to a datetime array
    tt = outs.outputs.tt/86400;
    times = datetime(myears(ii), 1, 1) + days(tt);
    
    plot(times, outs.outputs.hs(lake_indices, :), 'linewidth', 1)

    % Axes options
    ticklocs = [datetime(myears(ii), 6, 1), datetime(myears(ii), 7, 1), datetime(myears(ii), 8, 1), datetime(myears(ii), 9, 1)];
    xticks(ticklocs)
    
    % Set minor tick locations
    minticks = [datetime(myears(ii), 5, 15), datetime(myears(ii), 6, 1), datetime(myears(ii), 6, 15), datetime(myears(ii), 7, 1),...
            datetime(myears(ii), 7, 15), datetime(myears(ii), 8, 1), datetime(myears(ii), 8, 15), datetime(myears(ii), 9, 1)];
    ax.MinorGridLineStyle = '-';
    ax.XMinorGrid = 'on';
    ax.XAxis.MinorTickValues = minticks;
    
    ylim([0, 3.5])
    text(0.025, 0.9, alphabet{ii}, 'Units', 'normalized', 'FontSize', fs)
    grid on
    box off
    
    set(ax, 'FontSize', fs)
end

% Manually set xlims to the appropriately matched dates
xlim(nexttile(1), [datetime(2011, 5, 26), datetime(2011, 9, 4)])
xlim(nexttile(3), [datetime(2012, 5, 26), datetime(2012, 9, 4)])

xlim(nexttile(2), [datetime(2015, 5, 9), datetime(2015, 9, 14)])
xlim(nexttile(4), [datetime(2016, 5, 9), datetime(2016, 9, 14)])

nexttile(1)
ylabel('Lake depth (m)', 'FontSize', fs)
set(gca, 'XTickLabels', [])

nexttile(2)
set(gca, 'YTickLabels', [])
set(gca, 'XTickLabels', [])

nexttile(3)
ylabel('Lake depth (m)', 'FontSize', fs)

nexttile(4)
set(gca, 'YTickLabels', [])

% Fix tick labels - this removes the year from the xaxis tick labels
ax3 = nexttile(3);
ax3.XTickLabel = ax3.XTickLabel;

ax4 = nexttile(4);
ax4.XTickLabel = ax4.XTickLabel;

print('figures/lake_depth', '-dpng', '-r600')
print('figures/lake_depth', '-depsc')
