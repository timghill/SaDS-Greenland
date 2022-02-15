fs = 8;

addpath(genpath('~/sglads/SaDS/SaDS/functions/'))

fig = figure('Units', 'centimeters', 'Position', [5, 5, 15, 10]);
T = tiledlayout(2, 2, 'TileSpacing', 'tight', 'Padding', 'compact');

myears = [2011, 2012, 2015, 2016];
tmins = [datetime(2011, 1, 1)];
tmaxs = [datetime(2011, 1, 1)];

alphabet = {'(a) 2011', '(b) 2012', '(c) 2015', '(d) 2016'};
ii_map = [1, 3, 2, 4];

% lake_indices = [3233, 2317, 3387, 2274];
lake_indices = [3233, 3387, 2274, 2317];
dem = load('../data/greenland_refined_elevation.mat');
lake_elevations = dem.z_element(lake_indices);

for ii=1:length(myears)
% for ii=1
    outs = load(sprintf('../outputs/greenland_%d_regrow.mat', myears(ii)));
    dmesh = outs.params.dmesh;
    year = myears(ii);

    %% Plot lake levels
    colors = [
    0.3516    0.6250    0.5508
    0.8906    0.5547    0.3438
    0.7812    0.4375    0.4922
    0.2969    0.5703    0.6914];

    colororder(colors)

    tt = outs.outputs.tt/86400;
    times = datetime(year, 1, 1) + days(tt);
    
    tmins(ii) = datetime(2011, month(times(1)), day(times(1)));
    tmaxs(ii) = datetime(2011, month(times(end)), day(times(end)));
    
    
    nexttile(ii_map(ii));
    plot(times, outs.outputs.hs(lake_indices, :), 'linewidth', 1)
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
    
    ylim([0, 3.5])
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
ylabel('Lake depth (m)', 'FontSize', fs)

nexttile(3)
ylabel('Lake depth (m)', 'FontSize', fs)


% Fix tick labels
ax3 = nexttile(3);
ax3.XTickLabel = ax3.XTickLabel;

ax4 = nexttile(4);
ax4.XTickLabel = ax4.XTickLabel;

print('figures/lake_depth', '-dpng', '-r600')
print('figures/lake_depth', '-depsc')

%% CODE TO FIND LAKES
% figure
% element_plot(dmesh, outs.outputs.hs(:, tindex), 'EdgeColor', 'none')
% colormap(cmocean('dense'));
% hold on
% 
% XX = [585142, 7446240,
%       602204, 7438570,
%       586209, 7438030,
%       590996, 7442950];
% 
% lake_indices = [];
% for i=1:4
%     xs = XX(i, :);
%     dists = sqrt( sum((dmesh.tri.elements - xs).^2, 2));
%     near_neighs = find(dists<250);
%     [maxdepth, index] = max(outs.outputs.hs(near_neighs, tindex));
%     lake_indices = [lake_indices, near_neighs(index)];
% end
% 
% lake_indices;
% 
% plot(dmesh.tri.elements(lake_indices, 1), dmesh.tri.elements(lake_indices, 2), 'kx')
