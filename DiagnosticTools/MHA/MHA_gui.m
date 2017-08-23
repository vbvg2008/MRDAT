function varargout = MHA_gui(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MHA_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @MHA_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end


% --- Executes just before MHA_gui is made visible.
function MHA_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MHA_gui (see VARARGIN)

% Choose default command line output for MHA_gui
handles.output = hObject;
num_inputs = length(varargin);
handles.Frame_switch =0;
Frame_switch = 0;
handles.change = 0;
if isempty(varargin)==1
   error('case_data must be the input of MHA_gui') ;
elseif num_inputs==1
    case_data = varargin{1};
    MHA_case_idx = 1:length(case_data);
    well_list = fieldnames(case_data{1}.Tvar.Well);
elseif num_inputs==2
    case_data = varargin{1};
    MHA_case_idx = varargin{2};
    well_list = fieldnames(case_data{1}.Tvar.Well);
else
    if ischar(varargin{num_inputs})==1
        case_data = varargin{1};
        MHA_case_idx = 1:length(case_data);
        well_list = fieldnames(case_data{1}.Tvar.Well);
        Frame_data = varargin{2};
        Frame_switch =1;
        handles.Frame_data = Frame_data;
        handles.Frame_switch = Frame_switch;
    else
        case_data = varargin{1};
        MHA_case_idx = varargin{2};
        well_list = varargin{3};
    end
end
current_idx = 1;
case_idx = MHA_case_idx(1);
Well_name = well_list{1};
Case_name = case_data{case_idx}.name;
pic_name = [Case_name,'_',Well_name,'.png'];
axes(handles.axes1);
if Frame_switch==1
    imshow(Frame_data{current_idx}.cdata);
else
    imshow(pic_name);
end


depWIC = eval(['case_data{case_idx}.Diagnostics.MHA.',Well_name,'.DepWIC']);
Case_info = sprintf(['Case Name: ',Case_name,'\n\n','Well Name: ',Well_name,'\n\n','DepWIC: ',num2str(depWIC),'\n\n','Case Index: ',num2str(case_idx),'\n\n','MHA Index: ',num2str(current_idx)]);
set(handles.text2,'String',Case_info);


total_num_pic = length(well_list)*length(MHA_case_idx);
total_list_info = cell(total_num_pic,2);
k=1;
for i = 1:length(MHA_case_idx)
    for j = 1:length(well_list)
        total_list_info{k,1} = MHA_case_idx(i);
        total_list_info{k,2} = well_list{j};
        k=k+1;
    end
end


handles.total_list_info = total_list_info;
handles.current_idx = current_idx;
handles.total_idx = k-1;
handles.case_data = case_data;
handles.MHA_case_idx = MHA_case_idx;
handles.well_list = well_list;
% Update handles structure
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = MHA_gui_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Go.
function Go_Callback(hObject, eventdata, handles)
% hObject    handle to Go (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
case_idx = str2double(get(handles.edit1,'String'));
if mod(case_idx,1)==0
    case_data = handles.case_data;
    well_list = fieldnames(case_data{case_idx}.Tvar.Well);
    num_wells = length(well_list);
    Well_name = well_list{1};
    Case_name = case_data{case_idx}.name;
    current_idx = (case_idx-1)*num_wells+1;
    if handles.Frame_switch ==1
        Frame_data = handles.Frame_data;
        axes(handles.axes1);
        imshow(Frame_data{current_idx}.cdata);
    else
        pic_name = [Case_name,'_',Well_name,'.png'];
        axes(handles.axes1);
        imshow(pic_name);
    end
    depWIC = eval(['case_data{case_idx}.Diagnostics.MHA.',Well_name,'.DepWIC']);
    Case_info = sprintf(['Case Name: ',Case_name,'\n\n','Well Name: ',Well_name,'\n\n','DepWIC: ',num2str(depWIC),'\n\n','Case Index: ',num2str(case_idx),'\n\n','MHA Index: ',num2str(current_idx)]);
    set(handles.text2,'String',Case_info);
    handles.current_idx = current_idx;
end
guidata(hObject, handles);





% --- Executes on button press in Previous.
function Previous_Callback(hObject, eventdata, handles)
% hObject    handle to Previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
current_idx = handles.current_idx ;
handles.change = 0;
if current_idx >1
    current_idx = current_idx-1;
    total_list_info = handles.total_list_info;
    case_data = handles.case_data;
    case_idx = total_list_info{current_idx,1};
    Well_name = total_list_info{current_idx,2};
    Case_name = case_data{case_idx}.name;
    if handles.Frame_switch ==1
        Frame_data = handles.Frame_data;
        axes(handles.axes1);
        imshow(Frame_data{current_idx}.cdata);
    else

        pic_name = [Case_name,'_',Well_name,'.png'];
        axes(handles.axes1);
        imshow(pic_name);
    end
    depWIC = eval(['case_data{case_idx}.Diagnostics.MHA.',Well_name,'.DepWIC']);
    Case_info = sprintf(['Case Name: ',Case_name,'\n\n','Well Name: ',Well_name,'\n\n','DepWIC: ',num2str(depWIC),'\n\n','Case Index: ',num2str(case_idx),'\n\n','MHA Index: ',num2str(current_idx)]);
    set(handles.text2,'String',Case_info);
    handles.current_idx = current_idx;
end
guidata(hObject, handles);

% --- Executes on button press in Next.
function Next_Callback(hObject, eventdata, handles)
% hObject    handle to Next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
current_idx = handles.current_idx ;
handles.change = 0;
if current_idx < handles.total_idx
    current_idx = current_idx+1;
    total_list_info = handles.total_list_info;
    case_data = handles.case_data;
    case_idx = total_list_info{current_idx,1};
    Well_name = total_list_info{current_idx,2};
    Case_name = case_data{case_idx}.name;
    if handles.Frame_switch ==1
        Frame_data = handles.Frame_data;
        axes(handles.axes1);
        imshow(Frame_data{current_idx}.cdata);
    else
        pic_name = [Case_name,'_',Well_name,'.png'];
        axes(handles.axes1);
        imshow(pic_name);
    end
    depWIC = eval(['case_data{case_idx}.Diagnostics.MHA.',Well_name,'.DepWIC']);
    Case_info = sprintf(['Case Name: ',Case_name,'\n\n','Well Name: ',Well_name,'\n\n','DepWIC: ',num2str(depWIC),'\n\n','Case Index: ',num2str(case_idx),'\n\n','MHA Index: ',num2str(current_idx)]);
    set(handles.text2,'String',Case_info);
    
    handles.current_idx = current_idx;
end
guidata(hObject, handles);

% --- Executes on button press in Edit.
function Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

case_data = handles.case_data;
current_idx = handles.current_idx;
total_list_info = handles.total_list_info;
case_idx = total_list_info{current_idx,1};
Well_name = total_list_info{current_idx,2};
axes(handles.axes1);
HI = eval(['case_data{case_idx}.Diagnostics.MHA.',Well_name,'.HI;']);
DHI = eval(['case_data{case_idx}.Diagnostics.MHA.',Well_name,'.DHI;']);
WIC = eval(['case_data{case_idx}.Tvar.Well.',Well_name,'.WaterInjectionCumulative.data']); 
plot(WIC,HI,WIC,DHI);
axis([0 range(WIC)*7/6 0 range(HI)*7/6]);
[depWIC,y]=ginput(1);
hold on
scatter(depWIC,y,'filled');
hold off
handles.change = 1;
handles.newWIC = depWIC;
handles.newy = y;

guidata(hObject, handles);


% --- Executes on button press in Exit.
function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MHA_gui_OutputFcn(hObject, eventdata, handles);
case_data = handles.case_data;
%might need to change this dir later
save('case_data.mat','case_data');

delete(handles.figure1);


% --- Executes on button press in Save.
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.change ==1 
    case_data = handles.case_data;
    current_idx = handles.current_idx;
    total_list_info = handles.total_list_info;
    case_idx = total_list_info{current_idx,1};
    Well_name = total_list_info{current_idx,2};
    Case_name = case_data{case_idx}.name;
    depWIC = handles.newWIC;
    y =handles.newy;
    eval(['case_data{case_idx}.Diagnostics.MHA.',Well_name,'.DepWIC = depWIC;']);
    eval(['case_data{case_idx}.Diagnostics.MHA.',Well_name,'.DepHI = y;']);
    eval(['case_data{case_idx}.Diagnostics.MHA.',Well_name,'.DepDHI = y;']);
    
    HI = eval(['case_data{case_idx}.Diagnostics.MHA.',Well_name,'.HI;']);
    DHI = eval(['case_data{case_idx}.Diagnostics.MHA.',Well_name,'.DHI;']);
    WIC = eval(['case_data{case_idx}.Tvar.Well.',Well_name,'.WaterInjectionCumulative.data']); 
    pic_name = [Case_name,'_',Well_name,'.png'];
    h = figure('visible','off');
    plot(WIC,HI,WIC,DHI);
    axis([0 range(WIC)*7/6 0 range(HI)*7/6]);
    xlabel('Water Injection Cumulative');
    ylabel('HI/DHI');
    legend('HI','DHI');
    legend('boxoff')
    hold on
    scatter(depWIC,y,'filled');
    hold off
    if handles.Frame_switch ==1
        Frame_data = handles.Frame_data;
        Frame_data{current_idx} = getframe(h);
        handles.Frame_data = Frame_data;
    end
    saveas(h,pic_name);
    close(h);
    
    Case_info = sprintf(['Case Name: ',Case_name,'\n\n','Well Name: ',Well_name,'\n\n','DepWIC: ',num2str(depWIC),'\n\n','Case Index: ',num2str(case_idx),'\n\n','MHA Index: ',num2str(current_idx)]);
    set(handles.text2,'String',Case_info);
    
    handles.case_data = case_data;
    handles.change = 0;
end
guidata(hObject, handles);






