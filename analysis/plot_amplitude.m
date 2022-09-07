%% Plot moulin amplitude in 2011, 2012, 2015, 2016

% Set figure fontsize
fs = 8;

% Add paths to necessary functions
addpath(genpath('../data/'));

% Set years to plot
myears = [2011, 2012, 2015, 2016];
alphabet = {'(a) 2011', '(b) 2012', '(c) 2015', '(d) 2015'};

% Default color order
cord = [   5.3125000e-01   7.9687500e-01   9.2968750e-01
   6.6406250e-02   4.6484375e-01   1.9921875e-01
   8.6328125e-01   7.9687500e-01   4.6484375e-01
   7.9687500e-01   3.9843750e-01   4.6484375e-01
   1.9921875e-01   1.3281250e-01   5.3125000e-01
   6.6406250e-01   2.6562500e-01   5.9765625e-01
   2.6562500e-01   6.6406250e-01   5.9765625e-01];

% Make equivalent semi-transparent colors
ctransp = cord;
ctransp(:, 4) = 0.67;

fig = figure('Units', 'centimeters', 'Position', [5, 5, 17, 11]);
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
    
    moulin_amp = zeros(size(outs.outputs.m_moulin));
    for kk=1:7
        % Compute the instantaneous moulin amplitude
        moulin_amp(kk, :) = smooth_da(tt*86400, full(outs.outputs.m_moulin(kk, :)));
        
        % Plot instantaneous amplitude
        plot(times, moulin_amp(kk, :), 'Color', ctransp(kk, :))
    end
    
    mean_amp = movmean(moulin_amp, 12*7, 2, 'omitnan');
    plot(times, mean_amp)
    set(ax, 'ColorOrder', cord);
    % Axes options
    ticklocs = [datetime(myears(ii), 6, 1), datetime(myears(ii), 7, 1), datetime(myears(ii), 8, 1), datetime(myears(ii), 9, 1)];
    xticks(ticklocs)
    
    % Set minor tick locations
    minticks = [datetime(myears(ii), 5, 15), datetime(myears(ii), 6, 1), datetime(myears(ii), 6, 15), datetime(myears(ii), 7, 1),...
            datetime(myears(ii), 7, 15), datetime(myears(ii), 8, 1), datetime(myears(ii), 8, 15), datetime(myears(ii), 9, 1)];
    ax.MinorGridLineStyle = '-';
    ax.XMinorGrid = 'on';
    ax.XAxis.MinorTickValues = minticks;
    
    ylim([0, 15])
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
ylabel('Amplitude (m^3 s^{-1})', 'FontSize', fs)
set(gca, 'XTickLabels', [])

nexttile(2)
set(gca, 'YTickLabels', [])
set(gca, 'XTickLabels', [])

nexttile(3)
ylabel('Amplitude (m^3 s^{-1})', 'FontSize', fs)

nexttile(4)
set(gca, 'YTickLabels', [])

% Fix tick labels - this removes the year from the xaxis tick labels
ax3 = nexttile(3);
ax3.XTickLabel = ax3.XTickLabel;

ax4 = nexttile(4);
ax4.XTickLabel = ax4.XTickLabel;

print('figures/moulin_amplitude', '-dpng', '-r600')
print('figures/moulin_amplitude', '-depsc')
