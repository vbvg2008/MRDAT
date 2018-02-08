function grid_data = ImportGRDECL_Region(dir, fileName, nK, keywordName, grid_data)
% Import region numbering from GRDECL file
%
% Last Update Date: 12/20/2017
%
%SYNOPSIS:
%   grid_data = ImportGRDECL_Region(dir, fileName, nK, keywordName, grid_data)
%
%DESCRIPTION:
%  This function imports region numbering from GRDECL file and store them
%  in a structure with Region as a nK-row-matrix
%
%PARAMETERS:
%   grid_data - a structure containing region numbering in a nK-row-matrix
%   dir - directory where the GRDECL file is stored
%   fileName - Name of the GRDECL file
%   nK - number of layers in the grid model
%   keywordName - Keyword name for the region numbering
%

currentPath = userpath;
cd(dir);

if ~exist(fileName)
    msgbox(sprintf('%s file not found',fileName),'ImportGRDECL_Region.m','error');
    return
end

disp(['Loading Region data from ', fileName, ' file.....']);

% Open file
fid=fopen(fileName,'r');
tline=fgetl(fid);
% Look for Region keyword
while ~contains(tline, keywordName)
    tline=fgetl(fid);
end
tline=fgetl(fid);
k =1;
while ~contains(tline,'/')
    tline=fgetl(fid);
    A = split(tline, ' ');
    for i=1:length(A)
        if isempty(cell2mat(A(i)))
            continue;
        elseif contains(A{i}, '*')
            Rep = split(A{i}, '*');
            num_of_rep = str2double(Rep{1});
            j = num_of_rep + (k - 1);
            Wregion(k:j) = ones([num_of_rep,1]).*str2double(Rep{2});
            k = j+1;
        elseif contains(A{i}, '/')
            break;
        else
            Wregion(k) = str2double(A{i});
            k = k+1;
        end
    end
end
% Store data in grid_data structure (WellRegion as a nK-row-matrix)
num_IJK = length(Wregion);
num_IJ = num_IJK / nK;
Wregion_idx=1;
for layer_idx=1:nK
    for ij=1:num_IJ
        grid_data{1,1}.WellRegion(layer_idx,ij) = Wregion(Wregion_idx);
        Wregion_idx = Wregion_idx + 1;
    end
end
% Close file
fclose(fid);

disp('Loading completed!');
cd(currentPath);

end