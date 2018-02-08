function PERMX = ImportGRDECL(dir, fileName, nK)
% Import permeability data from GRDECL file
%
% Last Update Date: 11/21/2017
%
%SYNOPSIS:
%   PERMX = ImportGRDECL(dir, fileName, nK)
%
%DESCRIPTION:
%  This function imports permeability data from GRDECL file and store them
%  in a nK-row-matrix
%
%PARAMETERS:
%   PERMX - a nK-row-matrix containing permeability values for each grid block
%   dir = directory where the GRDECL file is stored
%   fileName = Name of the GRDECL file
%   nK = number of layers in the grid model
%

currentPath = userpath;
cd(dir);

if ~exist(fileName)
    msgbox(sprintf('%s file not found',fileName),'ImportGRDECL.m','error');
    return
end

delimiter = ' ';
formatSpec = '%s';
endOfLine = '\r\n';    %endOfLine = '/';
disp(['Loading permeability data from ', fileName, ' file.....']);

% Open file
fid=fopen(fileName,'r');
tline=fgetl(fid);

% Look for PERMX keyword
while ~contains(tline,'PERMX')
    tline=fgetl(fid);
end
tline=fgetl(fid);

% Import permeability data and store them in a 1x1 cell array
C = textscan(fid, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'ReturnOnError', false, 'EndOfLine', endOfLine);
tline=fgetl(fid);

% Close the file
fclose(fid); 

% Convert cell array into a string array
A = string(C{1,1});

% Amount of data in PERMX keyword
num_of_str = length(A);

% Counter for grid blocks
k=1;

% Note: When there are more than 5 continuos grid blocks with a
% permeability value of zero, data in GRDECL file is written in the
% following format: NumberOfBlock*0.0000. Example: 7*0.0000 indicates there
% are 7 continuos blocks with zero permeability

for i=1:(num_of_str-1)
        if ~isempty(A{i})
            % Look for multiple zeros format (Ex: 7*0.0000)  
            temp_value = split(A{i}, '*');
            temp_size = length(temp_value);            
            if temp_size==1
                % Asign single value to a single grid block
                perm(k)=str2double(temp_value{1});
                k = k+1;
            elseif temp_size==2
                % Assign multiple zeros to multiple grid blocks
                num_of_zeros = str2double(temp_value{1});
                j = num_of_zeros + (k - 1);
                perm(1,k:j) = zeros([num_of_zeros,1]);
                k = j+1;
            end
        end
end

% Store data in PERMX (a nK-row-matrix)
perm_idx=1;
num_IJK = length(perm);
num_IJ = num_IJK / nK;
for layer_idx=1:nK
    for ij=1:num_IJ
        PERMX(layer_idx,ij) = perm(perm_idx);
        perm_idx = perm_idx + 1;
    end
end

disp('Loading completed!');
cd(currentPath);

end