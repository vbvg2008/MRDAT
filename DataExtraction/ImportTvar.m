function [data,case_list] = ImportTvar(Dir,FileName,data)
%Import time-dependent variables from spreadsheets exported from Petrel
%
% Last Update : 04/13/2017 
%
% SYNOPSIS: 
%   data  = ImportTvar(Dir)
%   data  = ImportTvar(Dir,FileName)
%   data  = ImportTvar(Dir,FileName,data)
%   [data,case_list]  = ImportTvar(Dir,FileName)
%   [data,case_list]  = ImportTvar(Dir,FileName,data)
%
% DESCRIPTION:
%   This function will extract the information from excel to matlab and
%   store them in a N * 1 cell format where N is the number of cases.
%   
% PARAMETERS:
%   Dir       - A Character array that contains the path to the spreadsheet
%
%   FileName  - A string that contains the name of the spreadsheet with
%              extensions
%
%   data      - The output data from function ImportCasePara (optional)
%
% RETURNS:
%   data      - A N *1 cell, each cell is a structured data for a case
%
%   case_list - A N * 1 cell, each cell contains the matching case name
%
%--Initialization-----------------------------

multiple_files_switch = 0;
if nargin == 1
    multiple_files_switch = 1;
    file_list = dir(Dir);
    file_list([1 2])=[];
    num_files = length(file_list);
    if num_files ==0
       error('Input directory has no files'); 
    end
else
    num_files = 1;
end


for current_file_idx = 1:num_files
    %--Import-Files----------------------------
    disp(['Loading Tvar data(',num2str(current_file_idx),'/',num2str(num_files),')......']);
    
    if multiple_files_switch ==1
        [num_data,~,raw_data] = xlsread([Dir,'\',file_list(current_file_idx).name]);   %Read the entire spreedsheet
    else
        [num_data,~,raw_data] = xlsread([Dir,'\',FileName]);   %Read the entire spreedsheet
    end
    
    [count_row_raw,count_col_raw] = size(raw_data);  %Get data size
    [count_row_num,count_col_num] = size(num_data); 

    %--Read-Unit-Headers--
    Punit_start_row = count_row_raw-count_row_num;
    Punit_start_col = count_col_raw-count_col_num+2;
    [PUnits,~] = Read_Unit_Headers(Punit_start_row,Punit_start_col,count_col_raw,raw_data);

    %--Get-CaseName--Parameter--FieldName--
    [CHeader,PHeader,f] = Read_Case_Header(Punit_start_row,Punit_start_col,count_col_raw,raw_data);

    %-----Corret-Format-in the Header------------------
    CHeader = Correct_Format(CHeader,0);
    PHeader = Correct_Format(PHeader,1);
    f = Correct_Format(f,0);

    %--Allocate-Data-Structure--
    UniqueCHeader = unique(CHeader);
    Case_count = length(UniqueCHeader);
    case_list = cell(Case_count,1);
    if nargin < 3 
        if current_file_idx ==1
            data = cell(Case_count,1);
        end
        data_exist = 0;
        Tvar_data_exist = 0;
        if current_file_idx >1
            Tvar_data_exist = 1;
        end
        for  idx = 1:Case_count
            case_list{idx} = UniqueCHeader{idx};
        end
    else 
        data_exist = 1;
        data_field_names = fieldnames(data{1});
        if ismember({'Tvar'},data_field_names)==1
            Tvar_data_exist = 1;
        end

        for  idx = 1:Case_count
            case_list{idx} = data{idx}.name;
        end
    end


    %--Read-Time------------------------------------------
    if Tvar_data_exist ==0
        [date,del_time,cum_time] = ReadTime(count_row_raw,count_row_num,raw_data);
    end
    %-------------------------------------------------------------
    %Allocate Data Structure
    prev_location_idx = 0;
    for idx = 1:count_col_num-1
        Case_string = CHeader{idx};
        location_idx = find(ismember(case_list,Case_string));
        if data_exist == 0 %if data does not exist
            if location_idx~=prev_location_idx
                data{location_idx,1}.name = Case_string;
                data{location_idx,1}.Tvar.Time.date = date;
                data{location_idx,1}.Tvar.Time.delt = del_time;
                 data{location_idx,1}.Tvar.Time.cumt = cum_time;
                prev_location_idx = location_idx;
            end
        else
            if isempty(location_idx) ==1    %If the case does not exist in original data
                disp(Case_string);
                error('cannot find matching case in original data');
            end
            if Tvar_data_exist ==0
                if location_idx~=prev_location_idx
                    data{location_idx,1}.Tvar.Time.date = date;
                    data{location_idx,1}.Tvar.Time.delt = del_time;
                    data{location_idx,1}.Tvar.Time.cumt = cum_time;
                end 
            end
        end


        field_identifier = f{idx};  %f could be R#, G#,WI#,WP#,Field
        letter_id = field_identifier(1);
        switch letter_id
            case 'F'
                eval(['data{location_idx}.Tvar.Field.',PHeader{idx},'.data = num_data(:,idx+1);']);
                eval(['data{location_idx}.Tvar.Field.',PHeader{idx},'.unit = PUnits{idx};']);
            case 'R'
                eval(['data{location_idx}.Tvar.Region.',field_identifier,'.',PHeader{idx},'.data = num_data(:,idx+1);']);
                eval(['data{location_idx}.Tvar.Region.',field_identifier,'.',PHeader{idx},'.unit = PUnits{idx};']);
            case 'G'
                eval(['data{location_idx}.Tvar.Group.',field_identifier,'.',PHeader{idx},'.data = num_data(:,idx+1);']);
                eval(['data{location_idx}.Tvar.Group.',field_identifier,'.',PHeader{idx},'.unit = PUnits{idx};']);           
            case {'W','I','P'}
                eval(['data{location_idx}.Tvar.Well.',field_identifier,'.',PHeader{idx},'.data = num_data(:,idx+1);']);
                eval(['data{location_idx}.Tvar.Well.',field_identifier,'.',PHeader{idx},'.unit = PUnits{idx};']);
            otherwise %treat it as region
                eval(['data{location_idx}.Tvar.Region.R',field_identifier,'.',PHeader{idx},'.data = num_data(:,idx+1);']);
                eval(['data{location_idx}.Tvar.Region.R',field_identifier,'.',PHeader{idx},'.unit = PUnits{idx};']);
        end

    end

end
    disp('Loading Tvar data completed!');
end
%%
function [CHeader,PHeader,f] = Read_Case_Header(Punit_start_row,Punit_start_col,count_col_raw,raw_data)

%--Read-Case-Headers-and Parameter-Headers--
CHeader_start_row = Punit_start_row-1;
CHeader_start_col = Punit_start_col;
CTotalHeader = raw_data(CHeader_start_row,CHeader_start_col:count_col_raw);

CHeader_Count = length(CTotalHeader);

CHeader = cell(1,CHeader_Count);
PHeader = cell(1,CHeader_Count);
f = cell(1,CHeader_Count);

File_identifier_string = raw_data{1,1};
Sample_CHeader = CTotalHeader{1};

[comma_s]= regexpi(Sample_CHeader,',');

if length(comma_s)==2
     File_identifier_string= [];
else
    [FIPNUM_s,FIPNUM_e]= regexpi(File_identifier_string,'FIPNUM');
    if isempty(FIPNUM_s)~=1
        File_identifier_string(FIPNUM_s:FIPNUM_e) = [];
        [comma_s2]= regexpi(File_identifier_string,',');
        File_identifier_string(comma_s2)=[];
    end
end


for idx = 1:CHeader_Count

    tem_string = CTotalHeader{idx};   %temporary string storing each case header
    start_idx = regexpi(tem_string,',');    %find the start index of ','
    if isempty(File_identifier_string)==0   %if file identifier is non-empty
        if isempty(start_idx)==1   %case header has no ","
            tem_string = [tem_string,',',File_identifier_string];  %add tem_string with file_identifier string
        else
            tem_string = [tem_string(1:start_idx(1)-1),',',File_identifier_string,tem_string(start_idx(1):end)];
        end
    end
    comma_idx = regexpi(tem_string,',');
    num_comma = length(comma_idx);
    if num_comma == 2
        CHeader{idx} = tem_string(1:comma_idx(1)-1); %before first "," is Case Header
        f{idx} = tem_string(comma_idx(1)+1:comma_idx(2)-1);%between two "," is field identifier
        PHeader{idx} = tem_string(comma_idx(2)+1:end); %after second "," is Parameter Name
    else
        error('unsupported case header format...');
    end
end

end
%%
function [PUnits,VarHeader] = Read_Unit_Headers(Punit_start_row,Punit_start_col,count_col_raw,raw_data)
    ParameterUnits = raw_data(Punit_start_row,Punit_start_col:count_col_raw);
    Punit_Count = length(ParameterUnits);
    PUnits = cell(1,Punit_Count);
    VarHeader = cell(1,Punit_Count);
    for idx = 1:Punit_Count
        tem_string = ParameterUnits{idx};   %temporary string storing each header
        start_idx = regexpi(tem_string,'[');    %find the start index of '['
        end_idx = regexpi(tem_string,']');      %find the start index of ']'
        PUnits{idx}= tem_string(start_idx+1:end_idx-1); %extract header units
        VarHeader{idx} = tem_string(1:start_idx-1);
    end
end
%%
function OutputHeader = Correct_Format(InputHeader,option)

%option 0 ----- delete blank space
%option 1 ----- delete blank space & Capitalize the first word's letter

num_cell = length(InputHeader);
OutputHeader = cell(1,num_cell);
for idx = 1:num_cell
    tem_string = InputHeader{idx};
    char_length = length(tem_string);
    blank_idx = regexpi(tem_string,' ');
    blank_idx_length = length(blank_idx);
    dash_idx = regexpi(tem_string,'-');
    and_idx = regexpi(tem_string,'&');
    switch option
        case 0 
            tem_string([blank_idx,dash_idx,and_idx])=[];
        case 1
            if blank_idx(blank_idx_length) == char_length %if the blank space is at end
                tem_string(blank_idx(1:end-1)+1)=upper(tem_string(blank_idx(1:end-1)+1));
            else  %the blank space is not at end
                tem_string(blank_idx(1:end)+1)=upper(tem_string(blank_idx(1:end)+1));
            end
            tem_string([blank_idx,dash_idx,and_idx])=[];
        otherwise
            error('Unidentified option number when correcting header format');
    end
    OutputHeader{idx} =tem_string;
end

end
%%
function [date,del_time,cum_time] = ReadTime(count_row_raw,count_row_num,raw_data)
Time_start_row = count_row_raw-count_row_num;
Time_col = 1;
del_time = zeros(count_row_num,1);
for idx = 1:count_row_num
    time_general = raw_data{Time_start_row+idx,Time_col};
    date(idx,1) = datetime(time_general,'ConvertFrom','excel');
    if idx ==1 
        del_time(idx) = 0;
    else
        del_time(idx) = datenum(date(idx)-date(idx-1));
    end
end
cum_time = cumsum(del_time);


end
