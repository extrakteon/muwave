 function [Cpg Cpd]= ParasiticCapacitor(swp,LF1,LF2,plotMode)
f = swp.freq;
Omega = 2*pi*f;
%%  EXTRACT
Y11=swp.Y11;
Y12=swp.Y12;
Y21=swp.Y21;
Y22=swp.Y22;

Cb_extr = -imag(Y12)./Omega;
Cb = MeanValue(Cb_extr, LF1, LF2);

Cpg_extr = (imag(Y11)+2*imag(Y12))./Omega;
Cpg = MeanValue(Cpg_extr, LF1, LF2);
Cpd = Cpg;

Cpd_Cds_extr = (imag(Y22)+imag(Y12))./Omega; 
Cds_extr = Cpd_Cds_extr - Cpg_extr;
Cds = MeanValue(Cds_extr, LF1, LF2);

%% PLOT
if plotMode ==1
figure('Position',[30 450 1650 660])
% S11,S22
subplot(4,4,[1 5])
[h1 hchart] = smithchart(swp.S11);
hold on
h2 = smithchart(swp.S22);
set(h1,'Linewidth',1)
set(h2,'Color','r','Linewidth',1)
set(hchart,'LabelVisible','off')
legend('S11','S22','Location','Best')

% S21, S12
subplot(4,4,[2 6])
plot(f/1e9,10*log10(abs(swp.S12)),'b')
hold on
plot(f/1e9,10*log10(abs(swp.S21)),'r')
title('S21, S12')
ylabel('dB')
legend('S12','S21','Location','Best')

% Y11, Y22, -Y12
subplot(4,4,[9 13])
plot(f(2:end)/1e9,imag(Y11(2:end)),'r')
hold on
plot(f(2:end)/1e9,imag(Y22(2:end)),'b')
hold on
plot(f(2:end)/1e9,-imag(Y12(2:end)),'g')
set(gca,'Xlim',[f(1) f(end)]/1e9)
ylabel('Imaginary Parts (mS)')
xlabel('Frequency [GHz]')
legend('Y11','Y22','-Y12','location','Best')

% Imag(Y)...
subplot(4,4,[10 14])
plot(f(2:end)/1e9,(imag(Y11(2:end))+imag(Y12(2:end))),'r')
hold on
plot(f(2:end)/1e9,(imag(Y22(2:end))+imag(Y12(2:end))),'b')
hold on
plot(f(2:end)/1e9,-imag(Y12(2:end)),'g')
set(gca,'Xlim',[f(1) f(end)]/1e9)
xlabel('Frequency [GHz]')
ylabel('Imaginary Parts (mS)')
legend('Im(Y11+Y12)','Im(Y22+Y12)','-Im(Y12)','location','Best')

% Cb
subplot(4,4,[3 7])
plot(f(2:end)/1e9,Cb_extr(2:end)/1e-15,'LineWidth',2)
hold on
plot(f(LF1:LF2)/1e9,Cb_extr(LF1:LF2)/1e-15,'r','LineWidth',2.5)
set(gca,'Xlim',[f(1) f(end)]/1e9)
ax = get(gca,'YLim');
set(gca,'Ylim',[max(-3*max(abs(Cb_extr(LF1:LF2)/1e-15)),ax(1)) ...
    min(3*max(abs(Cb_extr(LF1:LF2)/1e-15)),ax(2))])
ylabel('Capacitance [fF]','Fontweight','bold')
title('Cb','Fontweight','bold')
set(gca,'Linewidth',2)
set(gca,'Fontweight','bold')

% Cpg, Cpd
subplot(4,4,[11 15])
plot(f(2:end)/1e9,Cpg_extr(2:end)/1e-15,'b','LineWidth',1)
hold on
plot(f(LF1:LF2)/1e9,Cpg_extr(LF1:LF2)/1e-15,'r','LineWidth',2)
set(gca,'Xlim',[f(1) f(end)]/1e9)
ax = get(gca,'YLim');
set(gca,'Ylim',[max(-3*max(abs(Cpg_extr(LF1:LF2)/1e-15)),ax(1)) ...
    min(3*max(abs(Cpg_extr(LF1:LF2)/1e-15)),ax(2))])
xlabel('Frequency [GHz]','Fontweight','bold')
ylabel('Capacitance [fF]','Fontweight','bold')
title('Cpg,Cpd','Fontweight','bold')
set(gca,'Linewidth',2)
set(gca,'Fontweight','bold')

% Cds
subplot(4,4,[12 16])
plot(f(2:end)/1e9,Cds_extr(2:end)/1e-15,'b','LineWidth',1)
hold on
plot(f(LF1:LF2)/1e9,Cds_extr(LF1:LF2)/1e-15,'r','LineWidth',2)
set(gca,'Xlim',[f(1) f(end)]/1e9)
ax = get(gca,'YLim');
set(gca,'Ylim',[max(-3*max(abs(Cds_extr(LF1:LF2)/1e-15)),ax(1)) ...
    min(3*max(abs(Cds_extr(LF1:LF2)/1e-15)),ax(2))])
xlabel('Frequency [GHz]','Fontweight','bold')
ylabel('Capacitance [fF]','Fontweight','bold')
title('Cds','Fontweight','bold')
set(gca,'Linewidth',2)
set(gca,'Fontweight','bold')

subplot(4,4,4)
model = imread('Extraction_pinchoff.PNG');
image(model)
axis off

subplot(4,4,8)
text('Interpreter','latex',...
 'String','$$Y = \left[ \begin{array}{cc} j\omega(Cpg + 2Cb) & -j\omega Cb \\ -j\omega Cb & j\omega(Cds + Cb + Cpd) \end{array} \right]$$',...
 'Position',[0 1.1],...
 'FontSize',10)
text('Interpreter','latex',...
 'String','$$Cb = -Im(Y12)/\omega$$',...
 'Position',[0 0.7],...
 'FontSize',10)
text('Interpreter','latex',...
 'String','$$Cpg = Cpd = (Im(Y11) + 2\cdot Im(Y12))/\omega$$',...
 'Position',[0 0.4],...
 'FontSize',10)
text('Interpreter','latex',...
 'String','$$Cds = (Im(Y22) + Im(Y12))/\omega - Cpg$$',...
 'Position',[0 0.1],...
 'FontSize',10)
axis off


end


