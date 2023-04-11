 
function varargout = MainUI(varargin)
tic;
% MAINUI MATLAB code for MainUI.fig
%      MAINUI, by itself, creates a new MAINUI or raises the existing
%      singleton*.
%
%      H = MAINUI returns the handle to a new MAINUI or the handle to
%      the existing singleton*.
%
%      MAINUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINUI.M with the given input arguments.
%
%      MAINUI('Property','Value',...) creates a new MAINUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainUI

% Last Modified by GUIDE v2.5 06-Apr-2015 00:18:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MainUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MainUI_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before MainUI is made visible.
function MainUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainUI (see VARARGIN)

% Choose default command line output for MainUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MainUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MainUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Browse.
function Browse_Callback(hObject, eventdata, handles)
global ExPath FileName;

% hObject    handle to Browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,FilePath ]= uigetfile({'*.mp4';'*.avi'},'File Selector');
ExPath = fullfile(FilePath, FileName);
len=length(FileName);
FileName=FileName(1:len-4);


% --- Executes on button press in Process.
function Process_Callback(hObject, eventdata, handles)
global d;
global method;
% hObject    handle to Process (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(method,'Select Method')==1
    msgbox('Select Method');
else
d = com.mathworks.mlwidgets.dialog.ProgressBarDialog.createProgressBar('Process started', []);
d.setValue(0);                        % default = 0
d.setProgressStatusLabel('Processing...');  % default = 'Please Wait'
d.setSpinnerVisible(true);               % default = true
d.setCancelButtonVisible(false);
d.setCircularProgressBar(false);         % default = false  (true means an indeterminate (looping) progress bar)
d.setVisible(true);                      % default = false
end
if strcmp(method,'Kmeans')==1
    VideoMainKmeans;
elseif strcmp(method,'KFCG')==1
    VideoMainKFCG;
elseif strcmp(method,'FCM')==1
    VideoMainFCM;
end

% --- Executes on button press in Download.
function Download_Callback(hObject, eventdata, handles)
global FileName;
% hObject    handle to Download (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
winopen(FileName);


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global method;
contents = cellstr(get(hObject,'String'));% returns popupmenu1 contents as cell array
method=contents{get(hObject,'Value')};% returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global ExPath d l k framerate1 numFrames1 numFramesWritten11;

%Extracting & Saving of frames from a Video file through Matlab Code%
d.setValue(0.1);
l=6;

% assigning the name of sample avi file to a variable
filename1 = ExPath;

%reading a video file
mov = VideoReader(filename1);
framerate1=mov.FrameRate;
k1=round(mov.duration/60);
k=k1*2;

% Defining Output folder as 'snaps'
opFolder = 'C:\VideoSumm\snaps';

%if  not existing 
if ~exist(opFolder, 'dir')
%make directory & execute as indicated in opfolder variable
mkdir(opFolder);
end

%getting no of frames
numFrames1= mov.NumberOfFrames;

%setting current status of number of frames written to zero
numFramesWritten11 = 0;
t=1;

%for loop to traverse & process from frame '1' to 'last' frames 
for m = 1 :k*framerate1 :numFrames1
    numFramesWritten11 = numFramesWritten11 + 1;
    currFrame = read(mov, m);    %reading individual frames
    opBaseFileName = sprintf('%d.png', t);
    opFullFileName = fullfile(opFolder, opBaseFileName);
    imwrite(currFrame, opFullFileName, 'png');   %saving as 'png' file
    t=t+1;
end     

d.setValue(0.3);
VideoSum;
global ExPath d l k framerate1 numFrames1 numFramesWritten11;

%Extracting & Saving of frames from a Video file through Matlab Code%
d.setValue(0.1);
l=8;
disp(ExPath);
% assigning the name of sample avi file to a variable
filename1 = ExPath;

%reading a video file
mov = VideoReader(filename1);
framerate1=mov.FrameRate;
k1=round(mov.duration/60);
k=k1*2;

% Defining Output folder as 'snaps'
opFolder = 'C:\VideoSumm\snaps';

%if  not existing 
if ~exist(opFolder, 'dir')
%make directory & execute as indicated in opfolder variable
mkdir(opFolder);
end

%getting no of frames
numFrames1= mov.NumberOfFrames;

%setting current status of number of frames written to zero
numFramesWritten11 = 0;
t=1;

%for loop to traverse & process from frame '1' to 'last' frames 
for m = 1 :k*framerate1 :numFrames1
    numFramesWritten11 = numFramesWritten11 + 1;
    currFrame = read(mov, m);    %reading individual frames
    opBaseFileName = sprintf('%d.png', t);
    opFullFileName = fullfile(opFolder, opBaseFileName);
    imwrite(currFrame, opFullFileName, 'png');   %saving as 'png' file
    t=t+1;
end     

d.setValue(0.3);
VideoSumKmeans;
global d numFramesWritten11 FileName framerate1;

n=numFramesWritten11-1;
fd=FrameDef.empty;
dataset=zeros(n,1);
for i=1:n
    %accessing first frames of each segment
    name=strcat(num2str(i),'.png');
    name=strcat('C:\VideoSumm\snaps\',name);
    im1=imread(name);
    
    %histograms
    im1=rgb2gray(im1);
    h=imhist(im1);
    
    value=0;
    for t=1:256
        value=value+t*h(t);
    end;
    dataset(i)=value;
    fd(i)=FrameDef(name,value,0);
    
end;

d.setValue(0.4);
[idx,C] = kmeans(dataset,k);
clust=zeros(n,k);
final=zeros(l,1);

for j=1:k
    for o=1:n
        if idx(o)==j
    clust(o,j)=dataset(o,1);
        end
    end
end

d.setValue(0.5);
rr=1;
ss=1;
temp=1;
clust=sort(clust,'descend');
while true
    if(ss>l)
        break;
    end
    if (clust(temp,rr)~=0)
       pos=checkValue(clust(temp,rr),n,fd); %find the value in object array
       if(fd(pos).flag==0)                  %flag to avoid repeatability of frames
        final(ss)=clust(temp,rr); 
        fd(pos).flag=1;
        rr=mod(rr,k)+1;
        ss=ss+1;
        temp=1;
       else
        temp=temp+1;
       end
    else
        temp=temp+1;
       continue; 
    end
end

finalpos=zeros(1,l);
for i=1:l
    finalpos(i)=checkValue(final(i),n,fd);
end
sortedpos=sort(finalpos);

d.setValue(0.6);
opFolder = 'C:\VideoSumm\snaps2';
    %if  not existing 
    if ~exist(opFolder, 'dir')
    %make directory & execute as indicated in opfolder variable
    mkdir(opFolder);
    end
    
ttt=1;
for i=1:l
    count=((sortedpos(i)-1)*k*framerate1)+1;
    count2=(count+k*framerate1);
    for m = count:count2
        %numFramesWritten11 = numFramesWritten11 + 1;
        currFrame = read(mov, m);    %reading individual frames
   
        opBaseFileName = sprintf('%d.png', ttt);
        opFullFileName = fullfile(opFolder, opBaseFileName);
        imwrite(currFrame, opFullFileName, 'png');   %saving as 'png' file
        ttt=ttt+1;
    end     
end
d.setValue(0.9);

%storing snaps2 folder images in imagesNames to create a video
workingDir = 'C:\VideoSumm';
imageNames = dir(fullfile(workingDir,'snaps2','*.png'));
imageNames = {imageNames.name};

%sorting the imagesNames according to numeric names of images
for i = 1:length(imageNames)
out(i) = cellfun(@(x)str2double(regexp(x,'\d*\.\d*','match')),imageNames(i));
end
out=sort(out);
for i = 1:length(imageNames)
    imageNames(i)=cellstr(strcat(num2str(out(i)),'.png'));
end

%assign name to output file
FileName=strcat(FileName,'_summarize.avi')
outputVideo = VideoWriter(fullfile(workingDir,FileName));
outputVideo.FrameRate = framerate1;
open(outputVideo)

for ii = 1:length(imageNames)
   img = imread(fullfile(workingDir,'snaps2',imageNames{ii}));
   writeVideo(outputVideo,img)
end

d.setValue(1);
close(outputVideo)
d.dispose();
msgbox('Processing Finished');

%remove directories
rmdir('C:\VideoSumm\snaps','s');
rmdir('C:\VideoSumm\snaps2','s');
analysisOfProcess;