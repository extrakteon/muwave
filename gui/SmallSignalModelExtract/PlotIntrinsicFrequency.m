function PlotIntrinsicFrequency(swp,Rj,Cgd,Ri,Cgs,Rds,Cds,gm,tau,idxLF1,idxLF2,idxHF1,idxHF2)
    figure('Position',[1940 280 1250 830])
    f = swp.freq/1e9;
    
    subplot(16,3,1:3:12);
    plot(f,Cgs/1e-15);
    hold on
    plot(f(idxLF1:idxLF2),Cgs(idxLF1:idxLF2)/1e-15,'r','Linewidth',2);
    title('Cgs');
    ylabel('Capacitance (fF)')
    axis([0 max(f) 0 2*mean(Cgs(idxLF1:idxLF2)/1e-15)])
    
    subplot(16,3,2:3:12);
    plot(f,Cgd/1e-15);
    hold on
    plot(f(idxLF1:idxLF2),Cgd(idxLF1:idxLF2)/1e-15,'r','Linewidth',2);
    title('Cgd');
    axis([0 max(f) 0 2*mean(Cgd(idxLF1:idxLF2)/1e-15)])
    
    subplot(16,3,3:3:12);
    plot(f,Cds/1e-15);
    hold on
    plot(f(idxLF2:floor(idxHF1/2)),Cds(idxLF2:floor(idxHF1/2))/1e-15,'r','Linewidth',2);
    title('Cds');
    axis([0 max(f) 0 2*mean(Cds(idxLF1:idxLF2)/1e-15)])
    
    subplot(16,3,16:3:27);
    plot(f,Rds);
    hold on
    plot(f(idxLF1:idxLF2),Rds(idxLF1:idxLF2),'r','Linewidth',2);
    title('Rds');
    axis([0 max(f) 0 2*mean(Rds(idxLF1:idxLF2))])
    ylabel('Resistance (\Omega)')
    
    subplot(16,3,17:3:27);
    plot(f,Rj);
    hold on
    plot(f(idxHF1:idxHF2),Rj(idxHF1:idxHF2),'r','Linewidth',2);
    title('Rj');
    axis([0 max(f) -mean(abs(Rj(idxHF1:idxHF2))) 2*mean(abs(Rj(idxHF1:idxHF2)))])
    
    subplot(16,3,18:3:27);
    plot(f,Ri);
    hold on
    plot(f(idxHF1:idxHF2),Ri(idxHF1:idxHF2),'r','Linewidth',2);
    title('Ri');
    axis([0 max(f) 0 5*mean(Ri(idxHF1:idxHF2))])
    
    subplot(16,3,31:3:42);
    gds = 1./Rds;
    plot(f,gds/1e-3);
    hold on
    plot(f(idxLF1:idxLF2),gds(idxLF1:idxLF2)/1e-3,'r','Linewidth',2);
    title('gds');
    ylabel('Conductance (mS)')
    xlabel('Frequency (GHz)')
    axis([0 max(f) 0 2*mean(gds(idxLF1:idxLF2)/1e-3)])
    
    subplot(16,3,32:3:42);
    plot(f,gm/1e-3);
    hold on
    plot(f(idxLF1:idxLF2),gm(idxLF1:idxLF2)/1e-3,'r','Linewidth',2);
    title('gm');
    xlabel('Frequency (GHz)')
    axis([0 max(f) 0 2*mean(gm(idxLF1:idxLF2)/1e-3)])
    
    subplot(16,3,33:3:42);
    plot(f,tau/1e-12);
    hold on
    plot(f(idxHF1:idxHF2),tau(idxHF1:idxHF2)/1e-12,'r','Linewidth',2);
    title('\tau');
    ylabel('time (ps)')
    xlabel('Frequency (GHz)')
    axis([0 max(f) -5*mean(abs(tau(idxHF1:idxHF2)/1e-12)) 5*mean(abs(tau(idxHF1:idxHF2)/1e-12))])
    
    subplot(16,3,[46:48]);
    text(0,0.8,['Vgs:  ' num2str(swp.V1_SET) ' V'],'Fontsize',14)
    text(0,0.0,['Vds:  ' num2str(swp.V2_SET) ' V'],'Fontsize',14)
    text(0,-0.8,['Ids:  ' num2str(round(swp.I2*1e3*100)/100) ' mA'],'Fontsize',14)
    axis off
    
    
    
    