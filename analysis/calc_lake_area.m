addpath(genpath('~/sglads/SaDS/SaDS/functions/'))

outs = load('../outputs/greenland_2012_regrow.mat');
dmesh = outs.params.dmesh;

hmin = 0.75;
dmax = 3e3;

lake_indices = [3233, 3387, 2274, 2317];

[~, tindex] = max(sum(outs.outputs.hs));

hs = outs.outputs.hs(:, tindex);

depth_mask = hs>hmin;
length(find(depth_mask))

lake_elements = {};

for ii=1:length(lake_indices)
    lakeii = lake_indices(ii);
    dist = vecnorm( (dmesh.tri.elements - dmesh.tri.elements(lakeii, :))')';
    
    lake_neighs = find(dist<=dmax & hs>=hmin);
    lake_elements{ii} = lake_neighs;
end

hs_plot = zeros(size(hs));
for ii=1:4
    hs_plot(lake_elements{ii}) = 1;
end

figure
element_plot(dmesh, hs_plot, 'EdgeColor', 'None')
colormap(cmocean('dense'))
colorbar
hold on
% plot(dmesh.tri.elements(lake_indices, 1), dmesh.tri.elements(lake_indices, 2), 'rx')

figure
element_plot(dmesh, hs, 'EdgeColor', 'none')
colormap(cmocean('dense'))
colorbar

L1 = lake_elements{1};
L2 = lake_elements{2};
L3 = lake_elements{3};
L4 = lake_elements{4};

disp('Lake areas:')
sum(dmesh.tri.area(L1))
sum(dmesh.tri.area(L2))
sum(dmesh.tri.area(L3))
sum(dmesh.tri.area(L4))

save('lake_elements.mat', 'L1', 'L2', 'L3', 'L4')
