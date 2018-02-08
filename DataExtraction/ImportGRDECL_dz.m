function grid_data = ImportGRDECL_dz(dir, fileName, nK, num_cases, grid_data)
% Import cell height data from GRDECL file
%
% Last Update Date: 11/28/2017
%
%SYNOPSIS:
%   grid_data = ImportGRDECL_dz(dir, fileName, nK, num_cases, grid_data)
%
%DESCRIPTION:
%  This function imports cell height data from GRDECL file and store them
%  in a structure with DZ as a nK-row-matrix
%
%PARAMETERS:
%   grid_data - a structure containing DZ data in a nK-row-matrix 
%   dir - directory where the GRDECL file is stored
%   fileName - Name of the GRDECL file
%   nK - number of layers in the grid model
%   num_cases - number of DZ cases in the GRDECL file
%

currentPath = userpath;
cd(dir);

if ~exist(fileName)
    msgbox(sprintf('%s file not found',fileName),'ImportGRDECL_dz.m','error');
    return
end

disp(['Loading cell height data from ', fileName, ' file.....']);

% Open file
fid=fopen(fileName,'r');
for case_idx=1:num_cases
    tline=fgetl(fid);
    % Look for DZ keyword
    while ~contains(tline,'DZ')
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
                dZ(k:j) = ones([num_of_rep,1]).*str2double(Rep{2});
                k = j+1;
            elseif contains(A{i}, '/')
                break;
            else
                dZ(k) = str2double(A{i});
                k = k+1;
            end
        end
    end
    % Store data in grid_data structure (DZ as a nK-row-matrix) 
    num_IJK = length(dZ);
    num_IJ = num_IJK / nK;
    dZ_idx=1;
    for layer_idx=1:nK
        for ij=1:num_IJ
            grid_data{case_idx,1}.DZ(layer_idx,ij) = dZ(dZ_idx);
            dZ_idx = dZ_idx + 1;
        end
    end
    disp(['Case ', num2str(case_idx), '/', num2str(num_cases), '....']);    
end
% Close file
fclose(fid);

disp('Loading completed!');
cd(currentPath);

end