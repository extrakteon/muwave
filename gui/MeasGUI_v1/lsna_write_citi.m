DIR = dir('data/Mitsu/8GHz/*.mat');
for Idx = 1:length(DIR)
    fname = DIR(Idx).name;
    fileload = sprintf('data/Mitsu/8GHz/%s',fname);
    load(fileload);
    
    foutname = sprintf('citi/8GHz/%s.citi',fname(1:end-4));

    [a b] = size(swp.A1);

    INDEX = (1:a).';
    FREQ = swp(1).freq.';

    NOUTER = length(INDEX);
    NINNER = length(FREQ);

    % Här behöver ändras så vektorerna blir rätt utifrån measwf klassen
    V1=reshape(swp.V1.',a*b,1);
    I1=reshape(swp.I1.',a*b,1);
    V2=reshape(swp.V2.',a*b,1);
    I2=reshape(swp.I2.',a*b,1);

    fid=fopen(foutname,'w');
    fprintf(fid,'CITIFILE A.01.01\n');
    fprintf(fid,'COMMENT Chalmers LSNA data\n');
    fprintf(fid,'COMMENT Date: %s\n',datestr(now));
    fprintf(fid,'NAME NoName\n');
    fprintf(fid,'VAR INDEX MAG %d\n',NOUTER);
    fprintf(fid,'VAR FREQ MAG %d\n',NINNER);
    fprintf(fid,'DATA V1 RI\n');
    fprintf(fid,'DATA I1 RI\n');
    fprintf(fid,'DATA V2 RI\n');
    fprintf(fid,'DATA I2 RI\n');
    fprintf(fid,'VAR_LIST_BEGIN\n');
    fprintf(fid,'%d\n',INDEX);
    fprintf(fid,'VAR_LIST_END\n');
    fprintf(fid,'VAR_LIST_BEGIN\n');
    fprintf(fid,'%e\n',FREQ);
    fprintf(fid,'VAR_LIST_END\n');

    % V1
    fprintf(fid,'BEGIN\n');
    fprintf(fid,'%e,%e\n',[real(V1),imag(V1)].');
    fprintf(fid,'END\n');

    % I1
    fprintf(fid,'BEGIN\n');
    fprintf(fid,'%e,%e\n',[real(I1),imag(I1)].');
    fprintf(fid,'END\n');

    % V2
    fprintf(fid,'BEGIN\n');
    fprintf(fid,'%e,%e\n',[real(V2),imag(V2)].');
    fprintf(fid,'END\n');

    % I2
    fprintf(fid,'BEGIN\n');
    fprintf(fid,'%e,%e\n',[real(I2),imag(I2)].');
    fprintf(fid,'END\n');

    fclose(fid);
end