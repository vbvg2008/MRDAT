function data = ImportPRT(directoryOfFolder)
%Extract some specific parameters from a all the 'prt' files in one folder
%
%SYNOPSIS:
%	data = extract_variables_from_folder(directoryOfFolder)
%
%DESCRIPTION:
%	this program is used to find out the correspondingPAV,PORV and total in place(including oil and water)
%	with the units of STB. The PRT file earned from Eclipse need to be changed to prt file at first.
%
%PARAMETERS:
%	directoryOfFolder - the folder used to place all the prt file waiting to be analyzed, which is in the string formate
%
%RETURNS:
%	data - all the required data all stored in this cell array
%-----------------------------------------------------------------------------

cd(directoryOfFolder);
fileList = dir();
fileList(1:2) = [];
fileAmount = size(fileList , 1);

%creat a cell array(data) of all files in the specified dirctory folder
data = cell(fileAmount , 1);

%Read through all the files
for fileNumber = 1 : 1 : fileAmount
    
    %create a structer in each cell within the cell array(data)
    data{fileNumber,1} = struct;
    %create a field named as 'fileName' in the structure
    data{fileNumber,1}.fileName = fileList(fileNumber,1).name;
    %create two structures in the cell array used for storing the data of
    %field and different regions
    data{fileNumber,1}.fieldData = struct;
    data{fileNumber,1}.regionData = struct;
    
    %open the file, and assign the file representative number into fid
    fid=fopen(data{fileNumber,1}.fileName);
    
    while 1
        tline = fgetl(fid);
        %find out the day 0.0
        appear = strfind(tline, 'BALANCE  AT      0.00  DAYS');
        if size(appear,2) ~= 0
            while 1
                tline = fgetl(fid);
                appear2 = strfind(tline, 'FIELD TOTALS');
                if size(appear2,2) ~= 0
                    tline = fgetl(fid);
                    %read the number of this line, and store it in to a array
                    A = regexp(tline,'\d*\.?\d*','match');
                    data{fileNumber,1}.fieldData.PAV = str2double(A{1,1});
                    tline = fgetl(fid);
                    %read the number of this line, and store it in to a array
                    A = regexp(tline,'\d*\.?\d*','match');
                    data{fileNumber,1}.fieldData.PORV = str2double(A{1,1});
                end
                appear3 = strfind(tline, 'CURRENTLY IN PLACE');
                if size(appear3,2) ~= 0
                    k = regexp(tline,'\d*','match');
                    a1 = str2double(k{1,1});
                    a2 = str2double(k{1,2});
                    a3 = str2double(k{1,3});
                    a4 = str2double(k{1,4});
                    if a1 == a2
                        data{fileNumber,1}.fieldData.oilTotalInPlace = a2;
                        data{fileNumber,1}.fieldData.waterTotalInPlace = a3;
                    elseif a3 == a1 + a2
                        data{fileNumber,1}.fieldData.oilTotalInPlace = a3;
                        data{fileNumber,1}.fieldData.waterTotalInPlace = a4;
                    end
                    break
                end
            end
            break
        end
    end
    
    lineNumber = 0;
    while 1
        tline = fgetl(fid);
        appear = strfind(tline, 'FIPNUM  REPORT REGION');
        theNumberOfRegion = 0;
        lineNumber = lineNumber + 1;
        if size(appear,2) ~= 0
            theNumberOfRegion = theNumberOfRegion + 1;
            A = regexp(tline,'\d*\.?\d*','match');   
            regionNumber = A{1,1};
            regionName = ['Region',regionNumber];
            data{fileNumber,1}.regionData.(regionName) = struct;
            tline = fgetl(fid);
         	%read the number of this line, and store it in to a array
            A = regexp(tline,'\d*\.?\d*','match');
            data{fileNumber,1}.regionData.(regionName).PAV = str2double(A{1,1});
            tline = fgetl(fid);
            %read the number of this line, and store it in to a array
            A = regexp(tline,'\d*\.?\d*','match');
            data{fileNumber,1}.regionData.(regionName).PORV = str2double(A{1,1}); 
        end
        appear3 = strfind(tline, 'CURRENTLY IN PLACE');
        if size(appear3,2) ~= 0
            k = regexp(tline,'\d*','match');
            a1 = str2double(k{1,1});
            a2 = str2double(k{1,2});
            a3 = str2double(k{1,3});
            a4 = str2double(k{1,4});
            if a1 == a2
                data{fileNumber,1}.regionData.(regionName).oilTotalInPlace = a2;
                data{fileNumber,1}.regionData.(regionName).waterTotalInPlace = a3;
            elseif a3 == a1 + a2
                data{fileNumber,1}.regionData.(regionName).oilTotalInPlace = a3;
                data{fileNumber,1}.regionData.(regionName).waterTotalInPlace = a4;
            end
            lineNumber = 0;
        end  
        
        if lineNumber >15
            break
        end
    end
end

end
    
    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    

