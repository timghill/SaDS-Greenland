outs = load('../outputs/greenland_2011_regrow.mat');

figure;

moulins = full(outs.outputs.m_moulin);
tt = outs.outputs.tt;
n_moulins = size(moulins, 1);

moulin_mean = movmean(moulins, 12*7, 2);

moulin_da = zeros(size(moulins));
for ii=1:n_moulins
    moulin_da(ii, :) = smooth_da(tt, moulins(ii, :));
end

% moulin_max = max(moulins, [], 2);
median(moulins, 2);
moulin_da_rel = moulin_da./moulin_max;

da_mean = movmean(moulin_da, 12*7, 2, 'omitnan');

plot(tt, moulin_mean, 'LineWidth', 2)
grid on

figure
plot(tt, da_mean, 'LineWidth', 2)
grid on

figure
plot(tt, da_mean./moulin_mean, 'Linewidth', 2)
ylim([0, 1])
grid on
print('figures/relative_diurnal_amp', '-dpng', '-r600')