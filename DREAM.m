function varargout = DREAM(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DREAM_OpeningFcn, ...
                   'gui_OutputFcn',  @DREAM_OutputFcn, ...
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

function DREAM_OpeningFcn(hObject, eventdata, handles, varargin)
axes(handles.bkg);
backgroundImage =importdata('DREAM-screen.jpg');
image(backgroundImage);
axis off

qmark = imread('qmark.jpg')
set(handles.tohelp,'CData',qmark)
clc
handles.output = hObject;
guidata(hObject, handles);

function varargout = DREAM_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function tohelp_Callback(hObject, eventdata, handles)
DPath=fileparts(which('DREAM.m'));
cd(DPath)
open([DPath '/Manual/Manual.html']) 

function tocalc_Callback(hObject, eventdata, handles)
AFD_FreqCalc_GUI

function todiv_Callback(hObject, eventdata, handles)
AFD_FreqDiv_GUI
