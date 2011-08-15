function PlotExtrinsicParameters(Rs,Ls,Rd,Ld,Ri,Lg,dLg)
    figure('Position',[50 80 1250 450])
    subplot(2,4,1);
    plot(Rs);
    title('Rs');
    ylabel('Resistance (\Omega)')
    
    subplot(2,4,2);
    plot(Rd);
    title('Rd');
    
    subplot(2,4,3);
    plot(Ri);
    title('Ri');
    
    subplot(2,4,5);
    plot(Ls*1e12);
    title('Ls');
    xlabel('Iterations')
    ylabel('Inductance (pH)')
    
    subplot(2,4,6);
    plot(Ld*1e12);
    title('Ld');
    xlabel('Iterations')
    
    subplot(2,4,7);
    plot(Lg*1e12);
    title('Lg');
    xlabel('Iterations')
        
    subplot(2,4,8);
    semilogy(abs(dLg*1e12))
    title('\Delta Lg')
    xlabel('Iterations')
    
    subplot(2,4,4);
    text('String','From N. Rorsman et al. (1996):',...
        'Position',[-0.2 0.9],...
        'FontSize',10)
    text('Interpreter','latex',...
        'String','$$Z11 = R_g + R_i + \frac{R_{dy}}{1+j\omega C_gR_{dy}} \frac{R_c}{2} + Rs + \\ j\omega(L_s + \Delta L_g)$$',...
        'Position',[-0.2 0.65],...
        'FontSize',10)
    text('Interpreter','latex',...
        'String','$$Z12 = Z21 = R_s + \frac{R_c}{2} + j\omega L_s$$',...
        'Position',[-0.2 0.45],...
        'FontSize',10)
    text('Interpreter','latex',...
        'String','$$ \\Z22 = R_d + R_s + R_c + j\omega(L_s + \Delta L_d)$$',...
        'Position',[-0.2 0.25],...
        'FontSize',10)
axis off






