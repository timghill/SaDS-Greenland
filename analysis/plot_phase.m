%% plot 'phase' of sheet/channel water mass and lake/moulin discharge

% Set plot fontsize
fs = 8;

% Analysis for 2012
outs = load('../outputs/greenland_2012_regrow.mat');
dmesh = outs.params.dmesh;

% Extract water level in lake L1 and its corresponding moulin
lake = outs.outputs.hs(3233, :);
moulin = full(outs.outputs.m_moulin(7, :));
tt = outs.outputs.tt(:);

figure('Units', 'centimeters', 'Position', [10, 10, 17, 7.2])
T = tiledlayout(1, 2, 'Padding', 'compact', 'TileSpacing', 'compact');

%% Second tile is lake/moulin relationship
nexttile(2)
scatter(lake, moulin, 20, tt/86400, 'filled', 'o', 'MarkerFaceAlpha', 0.8)
colormap(cmocean('matter'))
xlabel('Lake depth (m)')
ylabel('Moulin discharge (m^3 s^{-1})')
grid on
hold on

% Compute a linear fit through data where moulin discharge > 30 m3/s
% xfit = lake(moulin>30);
% yfit = moulin(moulin>30);
xfit = lake(lake>=1.75);
yfit = moulin(lake>=1.75);
P = polyfit(xfit, yfit, 1);

% Plot the linear fit
xmin = 1.75;
xmax = max(lake);
xx = linspace(xmin, xmax, 10);
f = polyval(P, xx);
plot(xx, f, 'k', 'LineWidth', 1.5)

text(0.025 , 0.95, '(b)', 'Units', 'normalized', 'FontSize', fs)
set(gca, 'FontSize', fs)

%% Plot sheet/channel water mass
nexttile(1)

% Compute mass in both systems
sheet = 1e3*sum(outs.outputs.hs.*dmesh.tri.area);
channel = 1e3*sum(outs.outputs.hc.*dmesh.tri.edge_length.*outs.params.r.*outs.outputs.Hc);

% Color-coded scatter plot
scatter(sheet, channel, 20, tt/86400, 'filled', 'o', 'MarkerFaceAlpha', 0.8)
colormap(cmocean('matter'))
xlabel('Sheet mass (kg)', 'FontSize', fs)
ylabel('Channel mass (kg)', 'FontSize', fs)
set(gca, 'FontSize', fs)

% Add a colorbar to the TiledLayout to represent both panels
cbar = colorbar;
cbar.Layout.Tile = 'east';
cbar.Label.String = 'Day of 2012';
cbar.Label.FontSize = fs;
grid on
text(0.025 , 0.95, '(a)', 'Units', 'normalized', 'FontSize', fs)

% Adjust plot position
T.InnerPosition = [0.067, 0.12, 0.8, 0.8];

print('figures/lake_moulin_phase', '-dpng', '-r600')
print('figures/lake_moulin_phase', '-depsc')

% Correlation
M_low = [xfit; yfit]';
corrcoef(M_low).^2

M = [xfit(xfit>2.5); yfit(xfit>2.5)]';
corrcoef(M).^2
