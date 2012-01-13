function SetIQRec(x, y, dio, ModNum)

% convert from x and y to a decimal number between 0 and 4095
Ivar = round(2048 - x.*2047);
Qvar = round(2048 - y.*2047);

% generate words to write
Qbin = dec2bin(Qvar,12);
Ibin = dec2bin(Ivar,12);
Word1b=Ibin(5:12);
Word2b=[Qbin(9:12) Ibin(1:4)];
Word3b=Qbin(1:8);

% convert binary to dec words
Word1 = bin2dec(Word1b);
Word2 = bin2dec(Word2b);
Word3 = bin2dec(Word3b);

% write words using NI DAQ toolbox
Port = (0:1:2) + (ModNum - 1)*3; % get bord indexes
P0 = sprintf('dev1/port%d',Port(1)); % port 1
P1 = sprintf('dev1/port%d',Port(2)); % port 2
P2 = sprintf('dev1/port%d',Port(3)); % port 3
WriteDigitalPort_nonUI(P0, Word1); % write word 1
WriteDigitalPort_nonUI(P1, Word2); % write word 2
WriteDigitalPort_nonUI(P2, Word3); % write word 3

% % compute line indexes depending on modulator number
% Ports = (0:1:2) + (ModNum - 1)*3;
% L1 = (Ports(1)*7+1):(8+Ports(1)*7);
% L2 = (Ports(2)*8+1):(8+Ports(2)*8);
% L3 = (Ports(3)*8+1):(8+Ports(3)*8);
% 
% % write digital ports
% putvalue(dio.Line(L1),dec2binvec(Word1,8));
% putvalue(dio.Line(L2),dec2binvec(Word2,8));
% putvalue(dio.Line(L3),dec2binvec(Word3,8));



% WriteDigitalPort(P0,dec2hex(Word1));
% WriteDigitalPort(P1,dec2hex(Word2));
% WriteDigitalPort(P2,dec2hex(Word3));