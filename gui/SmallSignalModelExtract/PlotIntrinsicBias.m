function PlotIntrinsicBias(swp,Rj,Cgd,Ri,Cgs,Rds,Cds,gm,tau,size,type)
%% Bias
Vgsweep = unique(swp.V1_SET);
Vdsweep = unique(swp.V2_SET);
Vg = reshape(swp.V1_SET,length(Vdsweep),length(Vgsweep)); % Voltage bias
Vd = reshape(swp.V2_SET,length(Vdsweep),length(Vgsweep));
Ig = reshape(swp.I1,length(Vdsweep),length(Vgsweep)); % Current bias
Id = reshape(swp.I2,length(Vdsweep),length(Vgsweep));
%% Normalize
if size > 0
    Rj = normalize_transistorparam(size,Rj,'R');
    Ri = normalize_transistorparam(size,Ri,'R');
    Rds = normalize_transistorparam(size,Rds,'R');
    Cgd = normalize_transistorparam(size,Cgd,'C');
    Cgs = normalize_transistorparam(size,Cgs,'C');
    Cds = normalize_transistorparam(size,Cds,'C');
    gm = normalize_transistorparam(size,gm,'gm');
    Ig = Ig/size;
    Id = Id/size;
end

%% Reshape
Rj = reshape(Rj,length(Vdsweep),length(Vgsweep));
Cgd = reshape(Cgd,length(Vdsweep),length(Vgsweep));
Ri = reshape(Ri,length(Vdsweep),length(Vgsweep));
Cgs = reshape(Cgs,length(Vdsweep),length(Vgsweep));
Rds = reshape(Rds,length(Vdsweep),length(Vgsweep));
gm = reshape(gm,length(Vdsweep),length(Vgsweep));
Cds = reshape(Cds,length(Vdsweep),length(Vgsweep));
tau = reshape(tau,length(Vdsweep),length(Vgsweep));

%% PLOT
figure('Position',[1970 250 1250 830])

if type == 'Vg'
    %1
    subplot(16,3,1:3:12)
    plot(Vg',Cgs'*1e15)
    title('Cgs')
    if size > 0
        ylabel('Capacitance (fF/mm)')
    else
        ylabel('Capacitance (fF)')
    end
    %2
    subplot(16,3,2:3:12)
    plot(Vg',Cgd'*1e15)
    title('Cgd')
    %3
    subplot(16,3,3:3:12)
    plot(Vg',Cds'*1e15)
    title('Cds')
    %4
    subplot(16,3,16:3:27)
    plot(Vg',Rds')
    title('Rds')
    if size > 0
        ylabel('Resistance (\Omega\cdot mm)')
    else
        ylabel('Resistance (\Omega)')
    end
    %5
    subplot(16,3,17:3:27)
    plot(Vg',Rj')
    title('Rj')
    %6
    subplot(16,3,18:3:27)
    plot(Vg',Ri')
    title('Ri')
    h = legend(num2str(unique(swp.V2_SET)'));
    legendpos = get(h,'OuterPosition');
    legendpos(1:2) = [0.915 0.5-legendpos(4)/2];
    set(h,'OuterPosition',legendpos)
    %7
    subplot(16,3,31:3:42)
    plot(Vg',1./Rds'*1e3)
    title('Gds')
    xlabel('Gate Voltage (V)')
    if size > 0
        ylabel('Conductance (mS/mm)')
    else
        ylabel('Conductance (mS)')
    end
    %8
    subplot(16,3,32:3:42)
    plot(Vg',gm'*1e3)
    title('gm')
    xlabel('Gate Voltage (V)')
    %9
    subplot(16,3,33:3:42)
    plot(Vg',tau'*1e12)
    title('\tau')
    xlabel('Gate Voltage (V)')
    ylabel('time (ps)')
elseif type == 'Vd'
    %1
    subplot(16,3,1:3:12)
    plot(Vd,Cgs*1e15)
    title('Cgs')
    if size > 0
        ylabel('Capacitance (fF/mm)')
    else
        ylabel('Capacitance (fF)')
    end
    %2
    subplot(16,3,2:3:12)
    plot(Vd,Cgd*1e15)
    title('Cgd')
    %3
    subplot(16,3,3:3:12)
    plot(Vd,Cds*1e15)
    title('Cds')
    %4
    subplot(16,3,16:3:27)
    plot(Vd,Rds)
    title('Rds')
    if size > 0
        ylabel('Resistance (\Omega\cdot mm)')
    else
        ylabel('Resistance (\Omega)')
    end
    %5
    subplot(16,3,17:3:27)
    plot(Vd,Rj)
    title('Rj')
    %6
    subplot(16,3,18:3:27)
    plot(Vd,Ri)
    title('Ri')
    h = legend(num2str(unique(swp.V1_SET)'));
    legendpos = get(h,'OuterPosition');
    legendpos(1:2) = [0.915 0.5-legendpos(4)/2];
    set(h,'OuterPosition',legendpos)
    %7
    subplot(16,3,31:3:42)
    plot(Vd,1./Rds*1e3)
    title('Gds')
    xlabel('Drain Voltage (V)')
    if size > 0
        ylabel('Conductance (mS/mm)')
    else
        ylabel('Conductance (mS)')
    end
    %8
    subplot(16,3,32:3:42)
    plot(Vd,gm*1e3)
    title('gm')
    xlabel('Drain Voltage (V)')
    %9
    subplot(16,3,33:3:42)
    plot(Vd,tau*1e12)
    title('\tau')
    xlabel('Drain Voltage (V)')
    ylabel('time (ps)')
elseif type == 'Id'
    %1
    subplot(16,3,1:3:12)
    plot(Id'*1000,Cgs'*1e15)
    title('Cgs')
    if size > 0
        ylabel('Capacitance (fF/mm)')
    else
        ylabel('Capacitance (fF)')
    end
    %2
    subplot(16,3,2:3:12)
    plot(Id'*1000,Cgd'*1e15)
    title('Cgd')
    %3
    subplot(16,3,3:3:12)
    plot(Id'*1000,Cds'*1e15)
    title('Cds')
    %4
    subplot(16,3,16:3:27)
    plot(Id'*1000,Rds')
    title('Rds')
    if size > 0
        ylabel('Resistance (\Omega\cdot mm)')
    else
        ylabel('Resistance (\Omega)')
    end
    %5
    subplot(16,3,17:3:27)
    plot(Id'*1000,Rj')
    title('Rj')
    %6
    subplot(16,3,18:3:27)
    plot(Id'*1000,Ri')
    title('Ri')
    h = legend(num2str(unique(swp.V2_SET)'));
    legendpos = get(h,'OuterPosition');
    legendpos(1:2) = [0.915 0.5-legendpos(4)/2];
    set(h,'OuterPosition',legendpos)
    %7
    subplot(16,3,31:3:42)
    plot(Id'*1000,1./Rds'*1e3)
    title('Gds')
    if size > 0
        xlabel('Drain Current (mA/mm)')
        ylabel('Conductance (mS/mm)')
    else
        xlabel('Drain Current (mA)')
        ylabel('Conductance (mS)')
    end
    %8
    subplot(16,3,32:3:42)
    plot(Id'*1000,gm'*1e3)
    title('gm')
    if size > 0
        xlabel('Drain Current (mA/mm)')
    else
        xlabel('Drain Current (mA)')
    end
    %9
    subplot(16,3,33:3:42)
    plot(Id'*1000,tau'*1e12)
    title('\tau')
    if size > 0
        xlabel('Drain Current (mA/mm)')
    else
        xlabel('Drain Current (mA)')
    end
    ylabel('time (ps)')
elseif type == '3D'
    x = reshape(Vg,[numel(Vg), 1]);
    y = reshape(Vd,[numel(Vd), 1]);
    %1
    z = reshape(Cgs,[numel(Cgs), 1]);
    subplot(16,3,1:3:12)
    plot3(x,y,z*1e15,'.')
    title('Cgs')
    if size > 0
        zlabel('Capacitance (fF/mm)')
    else
        zlabel('Capacitance (fF)')
    end
    %2
    z = reshape(Cgd,[numel(Cgd), 1]);
    subplot(16,3,2:3:12)
    plot3(x,y,z*1e15,'.')
    title('Cgd')
    %3
    z = reshape(Cds,[numel(Cds), 1]);
    subplot(16,3,3:3:12)
    plot3(x,y,z*1e15,'.')
    title('Cds')
    %4
    z = reshape(Rds,[numel(Rds), 1]);
    subplot(16,3,16:3:27)
    plot3(x,y,z,'.')
    set(gca,'ZScale','log')
    title('Rds')
    if size > 0
        zlabel('Resistance (\Omega\cdot mm)')
    else
        zlabel('Resistance (\Omega)')
    end
    %5
    z = reshape(Rj,[numel(Rj), 1]);
    subplot(16,3,17:3:27)
    plot3(x,y,z,'.')
    title('Rj')
    %6
    z = reshape(Ri,[numel(Ri), 1]);
    subplot(16,3,18:3:27)
    plot3(x,y,z,'.')
    title('Ri')
    %h = legend(num2str(unique(swp.V2_SET)'));
    %legendpos = get(h,'OuterPosition');
    %legendpos(1:2) = [0.915 0.5-legendpos(4)/2];
    %set(h,'OuterPosition',legendpos)
    %7
    z = reshape(1./Rds,[numel(Rds), 1]);
    subplot(16,3,31:3:42)
    plot3(x,y,z*1e3,'.')
    set(gca,'ZScale','log')
    title('Gds')
    if size > 0
        zlabel('Conductance (mS/mm)')
    else
        zlabel('Conductance (mS)')
    end
    %8
    z = reshape(gm,[numel(gm), 1]);
    subplot(16,3,32:3:42)
    plot3(x,y,z*1e3,'.')
    title('gm')
    %9
    z = reshape(tau,[numel(tau), 1]);
    subplot(16,3,33:3:42)
    plot3(x,y,z*1e12,'.')
    title('\tau')
    zlabel('time (ps)')
end

if not(type == '3D')
    % Get colors of first and last line
    a = get(gca,'Children');
    Firstcolor = get(a(end),'Color');
    Firstcolor = whichcolor(Firstcolor);
    Lastcolor = get(a(1),'Color');
    Lastcolor = whichcolor(Lastcolor);
    
    subplot(16,3,[46:48])
    if strcmp(type,'Vg') || strcmp(type,'Id')
        text(0,0.8,['Vds swept between \color{' Firstcolor '} ' num2str(min(swp.V2_SET)) ' V \color{black}and \color{' Lastcolor '}' num2str(max(swp.V2_SET)) ' V' '\color{black} in all graphs.'],'Fontsize',14)
    else
        text(0,0.8,['Vgs swept between \color{' Firstcolor '} ' num2str(min(swp.V1_SET)) ' V \color{black}and \color{' Lastcolor '}' num2str(max(swp.V1_SET)) ' V' '\color{black} in all graphs.'],'Fontsize',14)
    end
    if size > 0
        text(0,0,['Parameters are normalized against gate width'],'Fontsize',14)
    end
    axis off
end

