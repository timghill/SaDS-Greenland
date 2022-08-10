fs = 8;
mlw = 1.5;

moulin_colors = [   5.3125000e-01   7.9687500e-01   9.2968750e-01
   6.6406250e-02   4.6484375e-01   1.9921875e-01
   8.6328125e-01   7.9687500e-01   4.6484375e-01
   7.9687500e-01   3.9843750e-01   4.6484375e-01
   1.9921875e-01   1.3281250e-01   5.3125000e-01
   6.6406250e-01   2.6562500e-01   5.9765625e-01
   2.6562500e-01   6.6406250e-01   5.9765625e-01];

% addpath(genpath('~/sglads/SaDS/SaDS/functions/'))
addpath(genpath('/media/tghill/Seagate Backup Plus Drive/tim/MMATH/SaDS/SaDS/functions/'))
dem = load('../data/greenland_refined_elevation.mat');
dmesh = load('../data/meshes/greenland_refined_mesh.mat');
dmesh.tri.elements = dmesh.tri.elements/1e3;
dmesh.tri.nodes = dmesh.tri.nodes/1e3;
outs = load('../outputs/greenland_2012_regrow.mat');

tindex = 562;

figure('Units', 'centimeters', 'Position', [2,2, 17, 6.71]);

% T = tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

% nexttile(1);
[A, R] = readgeoraster('../data/LC08_L2SP_007013_20210708_20210713_02_T1_SR_rendered_cropped.tif');

RGB = A(:, :, 1:3);

x = R.XWorldLimits(1):R.CellExtentInWorldX:R.XWorldLimits(end);
y = R.YWorldLimits(1):R.CellExtentInWorldY:R.YWorldLimits(end);
x = x(1:end-1);
y = y(1:end-1);

[xx, yy] = meshgrid(x, y);

r = A(:, :, end);
g = A(:, :, 2);
b = A(:, :, 1);

rmin = min(r(:));
rmax = max(r(:));

normalize = @(x) (x - min(x(:)))./(max(x(:)) - min(x(:)));

r = normalize(r);
g = normalize(g);
b = normalize(b);

% RGB = zeros(size(A));
% RGB(:, :, 1) = r;
% RGB(:, :, 2) = g;
% RGB(:, :, 3) = b;
% 
% % Adjust white balance
% RGB(:, :, 1) = RGB(:, :, 1)*0.98;
% RGB(:, :, 2) = RGB(:, :, 2)*0.99;

% RGB = RGB/max(RGB(:));
parent_ax = axes(gcf, 'Position', [0.02, 0.02, 0.96, 0.96]);
hold on
% imshow(xx/1e3, yy/1e3, RGB)
% RI = imref2d(size(r));
RI.XWorldLimits = R.XWorldLimits/1e3;
RI.YWorldLimits = R.YWorldLimits/1e3;
image('CData', flipud(RGB), 'XData', R.XWorldLimits/1e3, 'YData', R.YWorldLimits/1e3)
axis image

moulins = find(outs.params.moulins==1);
lake_indices = [3233, 3387, 2274, 2317];


cc = moulin_colors;
nonlake_moulins = [2, 3, 6];
for ii=1:length(moulins)
    if ~ismember(ii, nonlake_moulins)
        mec = [0, 0, 0];
    else
        mec = cc(ii, :);
    end
    plot(dmesh.tri.nodes(moulins(ii), 1), dmesh.tri.nodes(moulins(ii), 2),...
        'o', 'MarkerEdgeColor', mec, 'MarkerFaceColor', cc(ii, :), 'LineWidth', mlw)
    
%     text(dmesh.tri.nodes(moulins(ii), 1), dmesh.tri.nodes(moulins(ii), 2), num2str(ii),...
%     'FontSize', 14);
end

colors = [
    0.3516    0.6250    0.5508
    0.8906    0.5547    0.3438
    0.7812    0.4375    0.4922
    0.2969    0.5703    0.6914];

for jj=1:4
    plot(dmesh.tri.elements(lake_indices(jj), 1), dmesh.tri.elements(lake_indices(jj), 2), ...
        '^', 'MarkerEdgeColor', colors(jj, :), 'MarkerFaceColor', colors(jj, :))
    tcol = [0, 0, 0];
    text(dmesh.tri.elements(lake_indices(jj), 1)+0.1, dmesh.tri.elements(lake_indices(jj), 2)+0.1,...
        sprintf('L%d', jj), 'FontSize', fs, 'VerticalAlignment', 'bottom', 'Color', tcol, 'FontWeight', 'bold');
end

domain_shp = shaperead('../data/shapefiles/gr_subdomain.shp');
for ii=1:length(domain_shp)
    catchmnt = domain_shp(ii);
    pgon = polyshape(catchmnt.X(1:end-5)/1e3, catchmnt.Y(1:end-5)/1e3);
    plot(pgon, 'FaceColor', 'none', 'EdgeColor', 'k', 'FaceAlpha', 1);
end

axis image
xlabel('Easting (km)', 'FontSize', fs)
ylabel('Northing (km)', 'FontSize', fs)
box off
set(gca, 'FontSize', fs)
set(gca, 'Visible', 'off')

% xlim(R.XWorldLimits/1e3)
xlim([577, 645])
% ylim(R.YWorldLimits/1e3)
ylims = [7.43e3, 7.455e3];
% ylims = R.YWorldLimits/1e3;
% ylims(1) = 7431270/1e3;
ylim(ylims);
text(0.025, 0.95, '(a)', 'Units', 'normalized', 'FontSize', fs)

% text(-0.15, 1.025, 'b', 'Units', 'normalized', 'FontSize', fs)

% ax = Discharge;
% ax.Position = [0.275, 0.145, 0.713, 0.79];

% nexttile(2);
inset = axes(gcf, 'Position', [0.42, 0.15, 0.55, 0.75]);
hold on
set(gca, 'FontSize', fs)
set(inset, 'Color', 'none')
element_plot(dmesh, dem.z_element, 'EdgeColor', 'none')
caxis([1150, 1450])

hthresh = 0.5;
for ii=1:dmesh.tri.n_edges
% for ii=[500]
   hii = outs.outputs.hc(ii, tindex);
   if hii>hthresh
       n1 = dmesh.tri.connect_edge(ii, 1);
       n2 = dmesh.tri.connect_edge(ii, 2);
       plot(dmesh.tri.nodes([n1, n2], 1), dmesh.tri.nodes([n1, n2], 2), 'k', 'LineWidth', 0.5)
   end
end


% colormap(cmocean('balance'))
% colormap('gray')
% cmap = cmocean('topo');
% cmap = cmap(129+16:end, :);
% colormap(cmap);

% cmap = colormap('bone');
% cmap = cmap(64:end, :);

cmap = palettes('-blue-8');

colormap(cmap);
cbar = colorbar;
cbar.Label.String = 'Elevation (m)';
cbar.Label.FontSize = fs;


moulins = find(outs.params.moulins==1);
lake_indices = [3233, 3387, 2274, 2317];


% cc = colororder;
for ii=1:length(moulins)
    if ~ismember(ii, nonlake_moulins)
        mec = [0, 0, 0];
    else
        mec = cc(ii, :);
    end
    plot(dmesh.tri.nodes(moulins(ii), 1), dmesh.tri.nodes(moulins(ii), 2),...
        'o', 'MarkerEdgeColor', mec, 'MarkerFaceColor', cc(ii, :), 'LineWidth', mlw)
    
end

colors = [
    0.3516    0.6250    0.5508
    0.8906    0.5547    0.3438
    0.7812    0.4375    0.4922
    0.2969    0.5703    0.6914];

for jj=1:4
    plot(dmesh.tri.elements(lake_indices(jj), 1), dmesh.tri.elements(lake_indices(jj), 2), ...
        '^', 'MarkerEdgeColor', colors(jj, :), 'MarkerFaceColor', colors(jj, :))
    if jj<3
%         tcol = [1, 1, 1];
        tcol = [0, 0, 0];
    else
        tcol = [0, 0, 0];
    end
end


axis image
xlabel('Easting (km)', 'FontSize', fs)
ylabel('Northing (km)', 'FontSize', fs)
box off

set(inset, 'Position', [0.42, 0.15, 0.55, 0.75]);


xlim([577.5, 607.5])
ylim([7430, 7455])


text(0.025, 0.95, '(b)', 'Units', 'normalized', 'FontSize', fs)

% T.InnerPosition = [0.075, 0.075, 0.8, 0.85];


ax_inset = axes(gcf, 'Position', [0.325, 0.55, 0.15, 0.4]);
hold on

outline = shaperead('../data/shapefiles/gr_simple_multi.shp');
for ii=1:length(outline)
    oline = outline(ii);
    if length(oline.X)>10000
        pgon = polyshape(oline.X(1:10:end-5), oline.Y(1:10:end-5));
        plot(pgon, 'FaceColor', [1, 1, 1], 'EdgeColor', [0, 0, 0], 'FaceAlpha', 1);
    end
end

pgon = polyshape(domain_shp.X(1:end-5), domain_shp.Y(1:end-5));
plot(pgon, 'FaceColor', 'r', 'EdgeColor', 'r', 'FaceAlpha', 1);

mx = nanmean(domain_shp.X);
my = nanmean(domain_shp.Y);
plot(mx, my, 'ks', 'MarkerSize', 5, 'MarkerFaceColor', 'k')

axis image


set(ax_inset, 'Visible', 'off')

% T.InnerPosition = [0.025, 0.1, 0.87, 0.8];
% % 
print('figures/domain', '-dpng', '-r600')
print('figures/domain', '-depsc')
