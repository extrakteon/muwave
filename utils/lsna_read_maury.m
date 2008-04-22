function data = lsna_read_maury(filename)

% init LSNA data structure
data.freq = [];
data.a1 = [];
data.b1 = [];
data.a2 = [];
data.b2 = [];

gamma.load = [];
gamma.source = [];

fid = fopen(filename,'r');



while not(feof(fid))

    str = fgetl(fid);

    if not(isempty(str))
        % parse fundamental frequency
        if strmatch('Frequency',str)
            token = strtok(str,'Frequency');
            token = regexprep(sscanf(upper(token),'%s'),{'THZ','GHZ','MHZ','KHZ','HZ'},{'e12','e9','e6','e3','e0'});
            tmp.fundamental = sscanf(token,'%f');
        end

        % ports, harminics, imods and tone_spacing
        if strmatch('LSNA data:',str)
            tokens = regexpi(str,'PORTS = (\d.*), HARMONICS = (\d.*), IMODS = (\d.*), TONE_SPACING_MHZ = (\d.*)','tokens');
            tmp.ports = sscanf(tokens{1}{1},'%d');
            tmp.harmonics = sscanf(tokens{1}{2},'%d');
            tmp.imods = sscanf(tokens{1}{3},'%d');
            tmp.tone_spacing = 1e6*sscanf(tokens{1}{4},'%f');
        end

        % source/load terminations
        if strmatch('Gamma_dut',str)
            tokens = regexpi(str,'(\w*) = \((\S* \S*)\)','tokens');
            for k = 1:length(tokens)
                gamma_tmp = tokens{k}{1};
                gamma_tokens = regexpi(gamma_tmp,'(\w*)_(\d*)[a-z][a-z]','tokens');
                if isempty(gamma_tokens)
                    gamma_name = gamma_tmp;
                    gamma_index = 1;
                else
                    gamma_name = gamma_tokens{1}{1};
                    gamma_index = sscanf(gamma_tokens{1}{2},'%d');
                end
                gamma_value = sscanf(tokens{k}{2},'%f');
                gamma_value = gamma_value(1)+gamma_value(2)*j;
                gamma_vector = gamma.(lower(gamma_name));
                gamma_vector(gamma_index) = gamma_value;
                gamma.(lower(gamma_name)) = gamma_vector;
            end
        end
        
        % power sweep and LSNA data
        if strmatch('numpower_meas',str)
            token = strtok(str,'numpower_meas = ');
            numpower_meas = sscanf(token,'%d');

            % read power sweep block
            header = fgetl(fid);
            header_tokens = regexpi(header,'(\w*)','tokens');
            tmp_data = [];
            for k = 1:numpower_meas
                str = fgetl(fid);
                tmp_data = [tmp_data; sscanf(str,'%f')'];
            end
            for k = 1:length(header_tokens)
                [unit_token, unit_end] = regexpi(header_tokens{k}{1},'_([vmA]*)$','tokens','start');
                if isempty(unit_token)
                    var_name = header_tokens{k}{1};
                    unit = 1;
                else
                    var_name = header_tokens{k}{1}(1:(unit_end-1));
                    switch unit_token{1}{1}
                        case 'v'
                            unit = 1;
                        case 'mA'
                            unit = 1e-3;
                    end
                end
                data.(var_name) = tmp_data(:,k)*unit;
            end
            
            % read LSNA data
            channels = {'a1','b1','a2','b2'};
            for k = 1:numpower_meas % POWER LEVELS
                tmp_data = zeros(1,1+tmp.harmonics);
                for n = 1:tmp.ports*2 % CHANNELS
                    header = fgetl(fid);
                    for m = 1:(1+tmp.harmonics)
                        str = fgetl(fid);
                        token = regexpi(str,'(\S* \S*)$','tokens');
                        x_val = sscanf(token{1}{1},'%f');
                        tmp_data(m) = x_val(1) + x_val(2)*j;
                    end
                    x_data = data.(channels{n});
                    x_data = [x_data; tmp_data];
                    data.(channels{n}) = x_data;
                end
            end
        end

        
        

    end

end

fclose(fid);

data.freq = repmat(tmp.fundamental*[0:1:tmp.harmonics],[numpower_meas 1]);

% Calculate Voltages and Currents
data.v1 = data.a1+data.b1;
data.i1 = (data.a1-data.b1)/50;
data.v2 = data.a2+data.b2;
data.i2 = (data.a2-data.b2)/50;

% Add DC-levels
data.v1(:,1) = data.Vin;
data.i1(:,1) = data.Iin;
data.v2(:,1) = data.Vout;
data.i2(:,1) = data.Iout;

data.a1(:,1) = 0.5*(data.v1(:,1)+50*data.i1(:,1));
data.b1(:,1) = 0.5*(data.v1(:,1)-50*data.i1(:,1));
data.a2(:,1) = 0.5*(data.v2(:,1)+50*data.i2(:,1));
data.b2(:,1) = 0.5*(data.v2(:,1)-50*data.i2(:,1));

