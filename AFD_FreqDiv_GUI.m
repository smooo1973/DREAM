function varargout = AFD_FreqDiv_GUI(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @AFD_FreqDiv_GUI_OpeningFcn, ...
    'gui_OutputFcn',  @AFD_FreqDiv_GUI_OutputFcn, ...
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

function AFD_FreqDiv_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

function varargout = AFD_FreqDiv_GUI_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

function chodatatype_Callback(hObject, eventdata, handles)
val = get(handles.chodatatype,'Value');
str = get(handles.chodatatype,'String');
handles.AFD.datatype =char(str{val});
if (strfind(handles.AFD.datatype,'---'))
    set(handles.datamsg,'String','Please choose right data type!')
    set(handles.csvpanel,'Visible','Off')
else
    set(handles.datamsg,'String',' ')
    set(handles.csvpanel,'Visible','On')
end


function chodatatype_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function chocsv_Callback(hObject, eventdata, handles)
[filename,filepath] = uigetfile('*.csv','select a file');
csv = fullfile(filepath,filename);
data=importdata(csv);
set(handles.showcsv,'Data',data);
handles.AFD.workdir=filepath;
guidata(hObject,handles);


function chofreqn_Callback(hObject, eventdata, handles)
handles.AFD.freqn = get(handles.chofreqn,'String');
guidata(hObject,handles);

function chofreqn_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%run
function run_Callback(hObject, eventdata, handles)
val = get(handles.chodatatype,'Value');
str = get(handles.chodatatype,'String');
handles.AFD.datatype =char(str{val});
handles.AFD.freqn = str2double(get(handles.chofreqn,'String'));
if (strfind(handles.AFD.datatype,'NIFTI'))
    AFD_FreqDiv_IMG(handles.AFD.workdir,handles.AFD.freqn)
else
    AFD_FreqDiv_FD(handles.AFD.workdir,handles.AFD.freqn)
end

function back_Callback(hObject, eventdata, handles)
AFD(handles.AFD)
