%% Plot moulin discharge in 2011, 2012, 2015, 2016

% colorord = [166, 118, 29,
%     230, 171, 2,
%     102, 166, 30,
%     231, 41, 138,
%     117, 112, 179;
%     219, 95, 2;
%     27, 158, 119]/256;

% colorord = [1, 102, 94;
%     53, 151, 142;
%     128, 205, 193;
%     199, 234, 229;
%     223, 194, 125;
%     191, 129, 45;
%     140, 81, 10]/256;

% CC-vivid
% colorord = [   8.9453125e-01   5.2343750e-01   2.3437500e-02
%    3.6328125e-01   4.1015625e-01   6.9140625e-01
%    3.2031250e-01   7.3437500e-01   6.3671875e-01
%    5.9765625e-01   7.8515625e-01   2.6953125e-01
%    7.9687500e-01   3.7890625e-01   6.8750000e-01
%    1.4062500e-01   4.7265625e-01   4.2187500e-01
%    8.5156250e-01   6.4453125e-01   1.0546875e-01
%    1.8359375e-01   5.3906250e-01   7.6562500e-01
%    4.6093750e-01   3.0468750e-01   6.2109375e-01
%    9.2578125e-01   3.9062500e-01   3.5156250e-01
%    7.9687500e-01   2.2656250e-01   5.5468750e-01
%    6.4453125e-01   6.6406250e-01   5.9765625e-01];

% CC Safe
% colorord = [   5.3125000e-01   7.9687500e-01   9.2968750e-01
%    7.9687500e-01   3.9843750e-01   4.6484375e-01
%    8.6328125e-01   7.9687500e-01   4.6484375e-01
%    6.6406250e-02   4.6484375e-01   1.9921875e-01
%    1.9921875e-01   1.3281250e-01   5.3125000e-01
%    6.6406250e-01   2.6562500e-01   5.9765625e-01
%    2.6562500e-01   6.6406250e-01   5.9765625e-01
%    5.9765625e-01   5.9765625e-01   1.9921875e-01
%    5.3125000e-01   1.3281250e-01   3.3203125e-01
%    3.9843750e-01   6.6406250e-02   0.0000000e+00
%    3.9843750e-01   5.9765625e-01   7.9687500e-01
%    5.3125000e-01   5.3125000e-01   5.3125000e-01];


moulin_colors = [   5.3125000e-01   7.9687500e-01   9.2968750e-01
   6.6406250e-02   4.6484375e-01   1.9921875e-01
   8.6328125e-01   7.9687500e-01   4.6484375e-01
   7.9687500e-01   3.9843750e-01   4.6484375e-01
   1.9921875e-01   1.3281250e-01   5.3125000e-01
   6.6406250e-01   2.6562500e-01   5.9765625e-01
   2.6562500e-01   6.6406250e-01   5.9765625e-01];
% figure
% x = 1:10;
% y = 1:10;
% [xx, yy] = meshgrid(x, y);
% 
% pcolor(xx.*yy)
% shading flat
% colormap(colorord)
% colorbar;

% % CC bold
% colorord = [   4.9609375e-01   2.3437500e-01   5.5078125e-01
%    6.6406250e-02   6.4453125e-01   4.7265625e-01
%    2.2265625e-01   4.1015625e-01   6.7187500e-01
%    9.4531250e-01   7.1484375e-01   3.9062500e-03
%    9.0234375e-01   2.4609375e-01   4.5312500e-01
%    5.0000000e-01   7.2656250e-01   3.5156250e-01
%    8.9843750e-01   5.1171875e-01   6.2500000e-02
%    0.0000000e+00   5.2343750e-01   5.8203125e-01
%    8.0859375e-01   1.0937500e-01   5.6250000e-01
%    9.7265625e-01   4.8046875e-01   4.4531250e-01
%    2.9296875e-01   2.9296875e-01   5.5859375e-01
%    6.4453125e-01   6.6406250e-01   5.9765625e-01];

% % CC prism
% colorord = [   3.7109375e-01   2.7343750e-01   5.6250000e-01
%    1.1328125e-01   4.1015625e-01   5.8593750e-01
%    2.1875000e-01   6.4843750e-01   6.4453125e-01
%    5.8593750e-02   5.1953125e-01   3.2812500e-01
%    4.4921875e-01   6.8359375e-01   2.8125000e-01
%    9.2578125e-01   6.7578125e-01   3.1250000e-02
%    8.7890625e-01   4.8437500e-01   1.9531250e-02
%    7.9687500e-01   3.1250000e-01   2.4218750e-01
%    5.7812500e-01   2.0312500e-01   4.2968750e-01
%    4.3359375e-01   2.5000000e-01   4.3750000e-01
%    5.9765625e-01   3.0468750e-01   5.8203125e-01
%    3.9843750e-01   3.9843750e-01   3.9843750e-01];

% Set figure fontsize
fs = 8;

% Add paths to necessary functions
addpath(genpath('../data/'));
addpath(genpath('/home/tghill/projects/def-c3dow/tghill/SaDS/MMATH/cases/greenland/data/RACMO'))

% Set years to plot
myears = [2011, 2012, 2015, 2016];
alphabet = {'(a) 2011', '(b) 2012', '(c) 2015', '(d) 2015'};

fig = figure('Units', 'centimeters', 'Position', [5, 5, 17, 11]);
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
    set(ax, 'ColorOrder', moulin_colors)
    hold on
    for kk=1:7
        plot(times, outs.outputs.m_moulin(kk, :), 'Color', moulin_colors(kk, :))  % Plot moulin discharge
    end

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
ylabel('Discharge (m^3 s^{-1})', 'FontSize', fs)
set(gca, 'XTickLabels', [])
yyaxis right
set(gca, 'YTickLabels', [])

nexttile(2)
yyaxis left
set(gca, 'YTickLabels', [])
set(gca, 'XTickLabels', [])
yyaxis right
ylabel('Melt (m w.e. day^{-1})', 'FontSize', fs)

nexttile(3)
yyaxis left
ylabel('Discharge (m^3 s^{-1})', 'FontSize', fs)
yyaxis right
set(gca, 'YTickLabels', [])

nexttile(4)
yyaxis left
set(gca, 'YTickLabels', [])
yyaxis right
ylabel('Melt (m w.e. day^{-1})', 'FontSize', fs)

% Fix tick labels - this removes the year from the xaxis tick labels
ax3 = nexttile(3);
ax3.XTickLabel = ax3.XTickLabel;

ax4 = nexttile(4);
ax4.XTickLabel = ax4.XTickLabel;
