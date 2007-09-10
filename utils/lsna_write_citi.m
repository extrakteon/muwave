function lsna_write_citi(data,foutname)

pin =  10*log10(data.a1(:,2).*conj(data.a1(:,2))/50)+30;
freq = data.freq(1,:)';

NOUTER = length(pin);
NINNER = length(freq);
NITEM = 4;

data_chunk = [];
for k = 1:NOUTER
    for n = 1:NINNER
        item = [data.v1(k,n);data.i1(k,n);data.v2(k,n);data.i2(k,n)];
        data_chunk = [data_chunk; item];
    end
end

tmp = [real(data_chunk) imag(data_chunk)];
data_chunk = reshape(tmp',[numel(tmp) 1]);

fid=fopen(foutname,'w');
fprintf(fid,'CITIFILE A.01.01\n');
fprintf(fid,'COMMENT Chalmers LSNA data\n');
fprintf(fid,'COMMENT Date: %s\n',datestr(now));
fprintf(fid,'NAME NoName\n');
fprintf(fid,'VAR power MAG %d\n',length(pin));
fprintf(fid,'VAR vgate MAG 1\n');
fprintf(fid,'VAR vdrain MAG 1\n');
fprintf(fid,'VAR FREQ MAG %d\n',length(freq));
fprintf(fid,'DATA v1 RI\n');
fprintf(fid,'DATA i1 RI\n');
fprintf(fid,'DATA v2 RI\n');
fprintf(fid,'DATA i2 RI\n');
fprintf(fid,'VAR_LIST_BEGIN\n');
fprintf(fid,'%g\n',pin);
fprintf(fid,'VAR_LIST_END\n');
fprintf(fid,'VAR_LIST_BEGIN\n');
fprintf(fid,'%g\n',data.v1(1,1));
fprintf(fid,'VAR_LIST_END\n');
fprintf(fid,'VAR_LIST_BEGIN\n');
fprintf(fid,'%g\n',data.v2(1,1));
fprintf(fid,'VAR_LIST_END\n');
fprintf(fid,'VAR_LIST_BEGIN\n');
fprintf(fid,'%g\n',freq);
fprintf(fid,'VAR_LIST_END\n');
fprintf(fid,'BEGIN\n');
fprintf(fid,'%g,%g\n',real(data_chunk),imag(data_chunk));
fprintf(fid,'END\n');
fclose(fid);