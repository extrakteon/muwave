function PlotModelvsMeasurements(swp,model,k)
try
    pos = get(gcf,'Position');
    if pos(2)>320 % Move down if positioned to high
        pos(2) = 320;
    end
    pos = pos.*[1 1 0 0] + [0 0 1150 800];
    set(gcf,'Position',pos)
catch
    figure('Position',[475 275 1150 800])
end
smithplot(swp,model)

%% Error
max_s11 = max(max(abs(swp.S11).^2));
max_s12 = max(max(abs(swp.S12).^2));
max_s21 = max(max(abs(swp.S21).^2));
max_s22 = max(max(abs(swp.S22).^2));
norm_factor = 4*length(swp.freq);

Error = ((sum(abs(model.S11 - swp.S11).^2)/max_s11 + ...
    sum(abs(model.S12 - swp.S12).^2)/max_s12 + ...
    sum(abs(model.S21 - swp.S21).^2)/max_s21 + ...
    sum(abs(model.S22 - swp.S22).^2)/max_s22)/norm_factor)*100; % In percentage


%% Text
txtstr = sprintf(' Vgs=%g V \n Vds=%g V \n Nr.=%g \n Measidx=%g \n Modelidx=%g \n Error=%0.2f %%', ...
    swp.V1_SET,swp.V2_SET,k,swp.Index,model.Index,Error);
text(-2.35, 3.5, txtstr,'FontSize', 14, 'FontUnits', 'normalized');

