function meritplot(varargin)
%MERITPLOT plots the various gain curves versus frequency

% $Header$
% $Author: koffe $
% $Date: 2009-01-13 11:05:46 +0100 (ti, 13 jan 2009) $
% $Revision: 96 $ 
% $Log$
% Revision 1.3  2005/04/27 21:37:12  fager
% * Changed from measSP to meassp.
%
% Revision 1.2  2004/05/28 06:59:45  koffer
% *** empty log message ***
%
% Revision 1.1  2004/05/12 08:01:55  koffer
% Added routine for plotting h21 and MSG/MAG versus log-frequency
%
%

% At the moment only one input is supported
sp = varargin{1};
x = freq(sp); 
idx_stable = find(stable(sp));
idx_unstable = find(~stable(sp)); % stupid solution...
% for some reason subsref doesn't work from within the class
S.type = '()';S.subs={idx_stable};
sp_stable = subsref(sp,S);
S.type = '()';S.subs={idx_unstable};
sp_unstable = subsref(sp,S);
x_stable = x(idx_stable);
x_unstable = x(idx_unstable);

figure(1);
subplot(2,1,1);
semilogx(x,20*log10(abs(h21(sp))),'.');
%saxis=axis;
%axis(saxis.*[1 1 0 1]);
ylabel('|h21| [dB]');
xlabel('Frequency [Hz]');

subplot(2,1,2)
semilogx(x_unstable,10*log10(gmsg(sp_unstable)),'.',x_stable,10*log10(ga(sp_stable)),'.');
%saxis=axis;
%axis(saxis.*[1 1 0 1]);
ylabel('MSG/MAG [dB]');
xlabel('Frequency [Hz]');
