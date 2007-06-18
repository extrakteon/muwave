function [TUN] = read_tuner(filename)

% determine long path name
[pathstr,name,ext] = fileparts(filename);
if isempty(pathstr) || strcmp(pathstr,'.')
    pathstr = pwd;
end
long_filename = fullfile(pathstr,strcat(name,ext));

% Create the cache file in the temp-directory as given in the apropriate registry entry.
cachefile = fullfile(tempdir,strcat('cache',adler32(long_filename),'.mat'));

try
    % does a cachefile exist?
    tmp = load(cachefile);
    TUN = tmp.TUN;
catch
    % otherwise read tuner-file and create a cahce-copy!
    TUN = read_tunerfile(long_filename);
    save(cachefile,'TUN');
end


function TUN = read_tunerfile(filename)

read_sparam = false;
fidx = 0;
fid = fopen(filename,'r');
str = fgetl(fid);
while feof(fid)==0
    % find tokens
    [s,f,t]=regexp(str,'([.\w]+)');
    if not(read_sparam) && (length(t) > 1)
        key = str(t{1}(1):t{1}(2));
        switch lower(key)
            case 'freq'
                fidx = fidx + 1;
                freq{fidx} = str2num(str(t{2}(1):t{2}(2)));
                %unit_str = str(t{3}(1):t{3}(2));
                freq{fidx} = freq{fidx}*1e9; % convert to Hz
                positions{fidx} = str2num(str(t{4}(1):t{4}(2)));
                % reset counters and structures
                idx = 0;
                data(fidx).xp = meassweep;
            case 'range'
                %disp(str);
            case 'position'
                idx = idx + 1;
                L{fidx}(idx) = str2num(str(t{2}(1):t{2}(2)));
                P1{fidx}(idx) = str2num(str(t{3}(1):t{3}(2)));
                P2{fidx}(idx) = str2num(str(t{4}(1):t{4}(2)));
                read_sparam = true;
                sp = []; % reset counters and data structures
                ctr = 0;
            otherwise
        end
    end
    if read_sparam
        ctr = ctr + 1;
        
        str = fgetl(fid); % read S-params
        vect = sscanf(str,'%g')';
        if isempty(vect)
            freq_list = freq{fidx}*(1:size(sp,3)); % harmonic frequency list
            % construct meassp-object
            xp = meassp;
            xp = set(xp,'data', xparam(sp,'S',50,freq_list)); % construct xparam-object
            measstate_tmp = get(xp,'measstate');
            measstate_tmp = addprop(measstate_tmp,'L',L{fidx}(idx));
            measstate_tmp = addprop(measstate_tmp,'P1',P1{fidx}(idx));
            measstate_tmp = addprop(measstate_tmp,'P2',P2{fidx}(idx));
            xp = set(xp,'measstate', measstate_tmp);
            % add to meassweep-object
            data(fidx).xp = add(data(fidx).xp, xp);
            read_sparam = false;
        else
            sp(1,1,ctr) = vect(1) + j*vect(2);
            sp(2,1,ctr) = vect(3) + j*vect(4);
            sp(1,2,ctr) = vect(5) + j*vect(6);
            sp(2,2,ctr) = vect(7) + j*vect(8); 
        end
        
    else
        str = fgetl(fid);
    end

end
fclose(fid);

% rearrange output data
for k = 1:length(data)
     TUN.fundamental(k) = freq{k};
     TUN.harmonics(k) = length(data(k).xp.freq);
     TUN.sp{k} = data(k).xp;
end

