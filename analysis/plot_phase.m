outs = load('../outputs/greenland_2012_regrow.mat');
dmesh = outs.params.dmesh;
fs = 8;

lake = outs.outputs.hs(3233, :);
moulin = full(outs.outputs.m_moulin(7, :));
tt = outs.outputs.tt(:);

figure('Units', 'centimeters', 'Position', [10, 10, 19, 8])

T = tiledlayout(1, 2, 'Padding', 'compact', 'TileSpacing', 'compact');

nexttile(2)
scatter(lake, moulin, 20, tt/86400, 'filled', 'o', 'MarkerFaceAlpha', 0.8)
colormap(cmocean('matter'))
xlabel('Lake depth (m)')
ylabel('Moulin discharge (m^3/s)')
% cbar = colorbar;
grid on
hold on

xfit = lake(moulin>30);
yfit = moulin(moulin>30);
P = polyfit(xfit, yfit, 1);

xmin = -P(2)/P(1);
xmax = max(lake);
xx = linspace(xmin, xmax, 10);
f = polyval(P, xx);

plot(xx, f, 'k', 'LineWidth', 1.5)
text(0.025 , 0.95, 'b', 'Units', 'normalized', 'FontSize', fs)

set(gca, 'FontSize', fs)

nexttile(1)

sheet = 1e3*sum(outs.outputs.hs.*dmesh.tri.area);

channel = 1e3*sum(outs.outputs.hc.*dmesh.tri.edge_length.*outs.params.r.*outs.outputs.Hc);

scatter(sheet, channel, 20, tt/86400, 'filled', 'o', 'MarkerFaceAlpha', 0.8)
colormap(cmocean('matter'))
xlabel('Sheet mass (kg)')
ylabel('Channel mass (kg)')
cbar = colorbar;
cbar.Layout.Tile = 'east';
cbar.Label.String = 'Day of 2012';
cbar.Label.FontSize = fs;
grid on
set(gca, 'FontSize', fs)
text(0.025 , 0.95, 'a', 'Units', 'normalized', 'FontSize', fs)



T.InnerPosition = [0.067, 0.1, 0.8, 0.85];

print('figures/lake_moulin_phase', '-dpng', '-r600')
print('figures/lake_moulin_phase', '-depsc')
