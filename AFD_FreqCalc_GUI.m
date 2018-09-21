function varargout = AFD_FreqCalc_GUI(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AFD_FreqCalc_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @AFD_FreqCalc_GUI_OutputFcn, ...
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

function AFD_FreqCalc_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

function varargout = AFD_FreqCalc_GUI_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function gettr_Callback(hObject, eventdata, handles)
handles.AFD.tr = get(handles.gettr,'String');
guidata(hObject,handles);

function gettr_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function getsublist_Callback(hObject, eventdata, handles)
[filename,filepath] = uigetfile('*.list','select a sublist');
sub_list = fullfile(filepath,filename);
handles.AFD.sub_list = sub_list;
sublist_all = importdata(sub_list)
sub = char(sublist_all(1,1));
func = get(handles.getfunc,'String');
rest = get(handles.getrest,'String');
val = get(handles.chodatatype,'Value');
str = get(handles.chodatatype,'String');
handles.AFD.datatype =char(str{val});
if (strfind(handles.AFD.datatype,'NIFTI'))
    sublist_all = importdata(handles.AFD.sub_list )
    sub = char(sublist_all(1,1));
    files = dir([handles.AFD.workdir ,'/' sub ,'/' func ,'/',rest ,'*.nii.gz']);
else if(strfind(handles.AFD.datatype,'1D'))
    files = dir([handles.AFD.workdir ,'/' sub ,'/' func ,'/',rest ,'*.1D']);
    end
end
handles.AFD.files = {files.name}
set(handles.showfile,'String',handles.AFD.files)

guidata(hObject,handles);

function getwd_Callback(hObject, eventdata, handles)
if get(hObject,'value')
    [pathname] = uigetdir;
    if pathname
        handles.AFD.workdir=pathname;
        set(handles.showwd,'String',pathname)
        guidata(hObject,handles);
    end
end

function getwd_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function getfunc_Callback(hObject, eventdata, handles)
func = get(handles.getfunc,'String');
rest = get(handles.getrest,'String');
handles.AFD.func = func;
 sublist_all = importdata(handles.AFD.sub_list )
    sub = char(sublist_all(1,1));
val = get(handles.chodatatype,'Value');
str = get(handles.chodatatype,'String');
handles.AFD.datatype =char(str{val});
if (strfind(handles.AFD.datatype,'NIFTI'))
    sublist_all = importdata(handles.AFD.sub_list )
    sub = char(sublist_all(1,1));
    files = dir([handles.AFD.workdir ,'/' sub ,'/' func ,'/',rest ,'*.nii.gz']);
else if(strfind(handles.AFD.datatype,'1D'))
    files = dir([handles.AFD.workdir ,'/' sub ,'/' func ,'/',rest ,'*.1D']);
    end
end
handles.AFD.files = {files.name}
set(handles.showfile,'String',handles.AFD.files)
guidata(hObject,handles);

function getfunc_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function getrest_Callback(hObject, eventdata, handles)
rest = get(handles.getrest,'String');
func = get(handles.getfunc,'String');
handles.AFD.rest = rest;
 sublist_all = importdata(handles.AFD.sub_list )
    sub = char(sublist_all(1,1));
val = get(handles.chodatatype,'Value');
str = get(handles.chodatatype,'String');
handles.AFD.datatype =char(str{val});
if (strfind(handles.AFD.datatype,'NIFTI'))
    sublist_all = importdata(handles.AFD.sub_list)
    sub = char(sublist_all(1,1));
    files = dir([handles.AFD.workdir ,'/' sub ,'/' func ,'/',rest ,'*.nii.gz']);
else if(strfind(handles.AFD.datatype,'1D'))
    files = dir([handles.AFD.workdir ,'/' sub ,'/' func ,'/',rest ,'*.1D']);
    end
end
handles.AFD.files = {files.name}
set(handles.showfile,'value',1);
set(handles.showfile,'String',handles.AFD.files)
guidata(hObject,handles);

function getrest_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function showfile_Callback(hObject, eventdata, handles)
rest = get(handles.getrest,'String');
func = get(handles.getfunc,'String');
 sublist_all = importdata(handles.AFD.sub_list )
    sub = char(sublist_all(1,1));
val = get(handles.chodatatype,'Value');
str = get(handles.chodatatype,'String');
handles.AFD.datatype =char(str{val});
if (strfind(handles.AFD.datatype,'NIFTI'))
    sublist_all = importdata(handles.AFD.sub_list)
    sub = char(sublist_all(1,1));
    files = dir([handles.AFD.workdir ,'/' sub ,'/' func ,'/',rest ,'*.nii.gz']);
else if(strfind(handles.AFD.datatype,'1D'))
    files = dir([handles.AFD.workdir ,'/' sub ,'/' func ,'/',rest ,'*.1D']);
    end
end
if strcmp(get(gcf,'selectiontype'),'open')
str=get(handles.showfile,'string');
v=get(handles.showfile,'value');
str(v)=[];
set(handles.showfile,'value',1);
set(handles.showfile,'string',str);
end
guidata(hObject,handles);

function showfile_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function txt_Callback(hObject, eventdata, handles)
guidata(hObject,handles);

function chodatatype_Callback(hObject, eventdata, handles)
val = get(handles.chodatatype,'Value');
str = get(handles.chodatatype,'String');
handles.AFD.datatype =char(str{val});
if (strfind(handles.AFD.datatype,'---'))
    set(handles.datamsg,'String','Please choose right data type!')
    set(handles.calpanel,'Visible','Off')
else 
    set(handles.datamsg,'String',' ')
    set(handles.calpanel,'Visible','On')
end

function chodatatype_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%run
function run_Callback(hObject, eventdata, handles)
handles.AFD.func= get(handles.getfunc,'String');
handles.AFD.tr = str2double(get(handles.gettr,'String'));
handles.AFD.files = get(handles.showfile,'String')
val = get(handles.chodatatype,'Value');
str = get(handles.chodatatype,'String');
handles.AFD.datatype =char(str{val});
if (strfind(handles.AFD.datatype,'NIFTI'))
AFD_FreqCalc_IMG(handles.AFD.tr, handles.AFD.workdir,handles.AFD.sub_list,handles.AFD.func,handles.AFD.files)
else
AFD_FreqCalc_FD(handles.AFD.tr, handles.AFD.workdir,handles.AFD.sub_list,handles.AFD.func,handles.AFD.files)
end

function back_Callback(hObject, eventdata, handles)
AFD(handles.AFD)
