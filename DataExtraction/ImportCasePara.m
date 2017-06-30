function [data,case_list] = ImportCasePara(Dir,FileName,data)
%Import case parameter from spreadsheets exported from Petrel
%
% SYNOPSIS: 
%   data  = ImportCasePara(Dir,FileName)
%   data  = ImportCasePara(Dir,FileName,data)
%   [data,case_list]  = ImportCasePara(Dir,FileName)
%   [data,case_list]  = ImportCasePara(Dir,FileName,data)
%
% DESCRIPTION:
%   This function will extract the information from excel to matlab and
%   store them in a N * 1 cell format where N is the number of cases.
%   
% PARAMETERS:
%   Dir       - A string that contains the path to the spreadsheet
%
%   FileName  - A string that contains the name of the spreadsheet with
%              extensions
%
%   data      - The output data from function ImportTvar (optional)
%
% RETURNS:
%   data      - A N *1 cell, each cell is a structured data for a case
%
%   case_list - A N * 1 cell, each cell contains the matching case name
%
%----------------------------------------------------------------------------
%--Import-Files--
[num_data,~,raw_data] = xlsread([Dir,'\',FileName]);   %Read the entire spreedsheet
[count_row_raw,count_col_raw] = size(raw_data);  %Get data size
[count_row_num,count_col_num] = size(num_data); 

%--Read-Case-Parameters--
CParameter_start_row = count_row_raw - count_row_num;
CParameter_start_col = 2;
CHeader_total = raw_data(CParameter_start_row,CParameter_start_col:count_col_raw);
CHeader_Count = length(CHeader_total);
ParaName = cell(1,CHeader_Count);
ObjFun_array = zeros(1,CHeader_Count);
for idx = 1:CHeader_Count
    tem_string = char(unicode2native(CHeader_total{idx}));
    start_idx_unicode = regexpi(tem_string,'?');
    start_idx_square = regexpi(tem_string,'');
    tem_string(start_idx_square) = [];
    tem_string(start_idx_unicode) = [];  %remove the unicode character
    start_idx_obj = regexpi(tem_string,'OBJFUN');
    start_idx_b = regexpi(tem_string,'(');
    if isempty(start_idx_obj)~=1
        ObjFun_array(1,idx) = 1;
    end
    if isempty(start_idx_b) %if the data is numerical
        ParaName{idx} = tem_string(2:end);  %remove the "$" sign
    else %the data is string
        ParaName{idx} = tem_string(2:start_idx_b-1); %remove the bracket"()"
    end
end

%--Allocate--Data--
if nargin < 3 
    data = cell(count_row_num,1);
    case_match = 0;
else 
    case_match = 1;
    case_list = cell(count_row_num,1);
    for  idx = 1:count_row_num
        case_list{idx} = data{idx}.name;
    end
end
for idx = 1:count_row_num
    Case_string = raw_data{idx+1,1};
    if case_match == 0 
        location_idx = idx;
        data{location_idx,1}.name = Case_string;
    else
        location_idx = find(ismember(case_list,Case_string));
        if isempty(location_idx) ==1    %If the case does not exist in original data
            error('cannot find matching case in original data');
        end
    end
    for idx_para = 1:CHeader_Count  %Begin filing the data
        if ObjFun_array(idx_para) ==1  % if it is a response variable
            eval(['data{location_idx}.RPVar.',ParaName{idx_para},'= raw_data{idx+1,idx_para+1};']); %fill in .RPVar.varname
        else
            eval(['data{location_idx}.',ParaName{idx_para},'= raw_data{idx+1,idx_para+1};']); %fill in data.varname
        end
    end
end

%--Create-Case-List--
if case_match ==0
    case_list = cell(count_row_num,1);
    for  idx = 1:count_row_num
        case_list{idx} = data{idx}.name;
    end   
end

end