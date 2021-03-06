function grid_data = ImportGRDECL_perm(dir, fileName, nK, num_cases)
% Import permeability data from GRDECL file
%
% Last Update Date: 11/23/2017
%
%SYNOPSIS:
%   grid_data = ImportGRDECL_perm(dir, fileName, nK, num_cases)
%
%DESCRIPTION:
%  This function imports permeability data from GRDECL file and store them
%  in a structure with PERMX as a nK-row-matrix
%
%PARAMETERS:
%   grid_data - a structure containing PERM data in a nK-row-matrix 
%   dir - directory where the GRDECL file is stored
%   fileName - Name of the GRDECL file
%   nK - number of layers in the grid model
%   num_cases - number of PERMX cases in the GRDECL file
%

currentPath = userpath;
cd(dir);

if ~exist(fileName)
    msgbox(sprintf('%s file not found',fileName),'ImportGRDECL_perm.m','error');
    return
end

disp(['Loading permeability data from ', fileName, ' file.....']);

% Open file
fid=fopen(fileName,'r');
for case_idx=1:num_cases
    tline=fgetl(fid);
    % Look for PERMX keyword
    while ~contains(tline,'PERMX')
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
                Zeros = split(A{i}, '*');
                num_of_zeros = str2num(Zeros{1});
                j = num_of_zeros + (k - 1);
                perm(k:j) = zeros([num_of_zeros,1]);
                k = j+1;
            elseif contains(A{i}, '/')
                break;
            else
                perm(k) = str2double(A{i});
                k = k+1;
            end
        end
    end
    % Store data in grid_data structure (PERMX as a nK-row-matrix)
    num_IJK = length(perm);
    num_IJ = num_IJK / nK;
    perm_idx=1;
    for layer_idx=1:nK
        for ij=1:num_IJ
            grid_data{case_idx,1}.PERMX(layer_idx,ij) = perm(perm_idx);
            perm_idx = perm_idx + 1;
        end
    end
    disp(['Case ', num2str(case_idx), '/', num2str(num_cases), '....']);    
end
% Close file
fclose(fid);

disp('Loading completed!');
cd(currentPath);

end