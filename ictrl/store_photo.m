function rc = store_photo(h_dde,filename)
% Take a photo

% Get a temporary file name
temp_file_name = tempname;

% Snap photo
ddeexec(h_dde,sprintf(':capt:vid "%s"',temp_file_name));

% Import bitmap and save as jpeg
im_data = imread(temp_file_name);
imwrite(im_data, filename, 'jpeg');
