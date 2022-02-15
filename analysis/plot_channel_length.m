%% Plot total length of incised large and small channels in 2012, 2015

years = [2012, 2015];
fs = 8;

figure('Units', 'centimeters', 'Position', [10, 10, 19, 8])
T = tiledlayout(1, 2, 'Padding', 'compact', 'TileSpacing', 'compact');

alphabet = {'a', 'b'};

for ii=1:length(years)
    year = years(ii);
%     outs = load('greenland_2011_regrow.mat');
    outs = load(sprintf('../outputs/greenland_%d_regrow.mat', year));
    dmesh = outs.params.dmesh;

    tt = outs.outputs.tt/86400;

    sheet = 1e3*sum(outs.outputs.hs.*dmesh.tri.area);

    channel = 1e3*sum(outs.outputs.hc.*dmesh.tri.edge_length.*outs.params.r.*outs.outputs.Hc);

    sheet = sheet/max(sheet);
    channel = channel/max(channel);

    Hc_small = outs.outputs.Hc;
    Hc_small(Hc_small>0.3) = 0;
    Hc_small(Hc_small<=1.05*outs.params.Hmin) = 0;
    % small_area = sum(outs.params.r*Hc_small.^2);

    small_channels = ones(size(outs.outputs.Hc));
    small_channels = small_channels.*dmesh.tri.edge_length;
    small_channels(outs.outputs.Hc>=0.3) = 0;
    small_channels(outs.outputs.Hc<=1.1*outs.params.Hmin) = 0;
    small_length = sum(small_channels);

    big_channels = ones(size(outs.outputs.Hc)).*dmesh.tri.edge_length;
    big_channels(outs.outputs.Hc<0.3) = 0;
    big_length = sum(big_channels);

    tot_channels = small_length + big_length;

    Y = [big_length; big_length + small_length]';

    times = datetime(year, 1, 1) + days(tt);

    nexttile;
    area_plot = area(times, Y);
    area_plot(1).FaceColor = [0.3320, 0.6133, 0.6992];
    area_plot(1).FaceAlpha = 0.8;
    area_plot(2).FaceColor = [0.5586, 0.7461, 0.4648];
    area_plot(2).FaceAlpha = 0.8;
    grid on
    xlim([times(1), times(end)])
    ylim([0, 2e5])
    
    if ii==1
        legend('H_c>0.3 m', 'H_c\leq 0.3 m', 'Box', 'off')
        ylabel('Channel length (m)')
    end
    
    if ii==2
        set(gca, 'YTickLabels', [])
    end
    
    set(gca, 'FontSize', fs, 'Box', 'off')
    text(0.025 , 0.95, alphabet{ii}, 'Units', 'normalized', 'FontSize', fs)
    
    minticks = [datetime(year, 6, 1), datetime(year, 6, 15), datetime(year, 7, 1),...
            datetime(year, 7, 15), datetime(year, 8, 1), datetime(year, 8, 15), datetime(year, 9, 1)];
    hax = gca;
    hax.MinorGridLineStyle = '-';
    set(hax, 'XMinorGrid', 'on')
    hax.XAxis.MinorTickValues = minticks;
    
end

print('figures/channel_length', '-dpng', '-r600')
print('figures/channel_length', '-depsc')
