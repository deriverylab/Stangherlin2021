% tracking_ batch
% 09042015 ver1.1
% Modif by Manu change on lane 33 seqtrace by seqtrace2, which adds the width, intensity and ofset to the output
% 160831 bug on lane32
% 160908 new version using a tracking algorithm from the manley lab
% 07/11/2017 version 1.3 modif of the path to the param file for windows10
% 14082018 modif by Manu to read thunderstorm data
% this will track all in folder in parallel
% this tracks ALL the spots and keep their position and intensities

clc
clear
%parpool
TIME_UNITS = 's';
%open one of the timing file (should all be the same)
Time2=xlsread(cat(2,'1.tif','_timingms.xls')); 
dT=round(mean(diff(Time2)))/1000; %dT in seconds usefull for velocities estimation
T=(0:size(Time2,1)-1)';
Time=dT*T; % in seconds

xyspacings=0.11;
SPACE_UNITS = 'µm';  


%parameter tracking
Diffcoef=4; %estimate of the maximum distance that a particle would move in a single time interval
Gap=5; %number of time steps that a particle can be 'lost' and then recovered again
good=15; %filter tracks smaller than XYZ timeoints

%parameter MSD fits
thresholdlin=50; %this is the threshold for the linear fit 
thresholdconf=100; %tthreshold for the loglog fit
N_DIM=2;


cd raw;
fol=dir;
sfol=size(fol,1);
% 
for p=3:sfol
     cd(fol(p).name);
	 files=dir('*.tif');
     sfiles=size(files,1);
     Pool_tracks={}; 
	 Pool_tracksInt={};
     Pool_MSDfit={};
	 
     for q=1:sfiles
 clc
 display(cat(2,'processing file ',num2str(q),' of ',num2str(sfiles)));
        
         %------load position file -------
basename=files(q).name;
delimiter = ',';
startRow = 2;

formatSpec = '%f%f%f%f%f%f%f%f%f%[^\n\r]';
filename=(cat(2,basename,'.csv'));
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);
for i=1:9
Poolfoundspots(:,i)= dataArray{i};
end
%%the collumns are {'id','frame','xnm','ynm','sigmanm','intensityphoton','offsetphoton','bkgstdphoton','uncertainty_xynm'});
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%-----------------tracking---------

X=zeros(size(Poolfoundspots,1),4);
X(:,4)=Poolfoundspots(:,2);
X(:,1:2)=Poolfoundspots(:,3:4)./92;%nm to pixel conversion
X(:,5)=Poolfoundspots(:,6);%intensity
X(:,6)=Poolfoundspots(:,5);%offset
X(:,7)=Poolfoundspots(:,7);%sigma
X(:,8)=Poolfoundspots(:,9);%uncertainty

param = struct('mem',Gap,'dim',3,'good',good,'quiet',0);
tracks = track2(X,Diffcoef,param); %modified track to get (intensity, offset, sigma1, uncertainty)  

%make a cell array with the tracks compatible with MSD analyser 
%with the real timing in sec and the spacings ok

ntracks=tracks(size(tracks,1),9);

% put tracks into
%Cells of MSD analyzer. %also calculate a mean motion of each track t
Mean_motion=cell(ntracks,1);
tracksCell=cell(ntracks, 1);
tracksInt=cell(ntracks, 1);

parfor j=1:ntracks
Temp=tracks(find(tracks(:,9)==j),1:9); 
%get mean motion
T=diff(Temp)*xyspacings;
Mean_motion{j,1}=mean(abs(mean(T(:,2:3))));
%if Mean_motion(j,1)>motionthres
tracksCell{j,1}(:,1)=Time(Temp(:,4)); %put the real time 
tracksCell{j,1}(:,2:3)=Temp(:,1:2)*xyspacings; %this is for 2D
tracksInt{j,1}(:,1)=Time(Temp(:,4)); 
tracksInt{j,1}(:,2:3)=Temp(:,1:2)*xyspacings; %remark z spacings need if 3D 
tracksInt{j,1}(:,4)=zeros(size(Temp,1),1);
tracksInt{j,1}(:,5:8)=Temp(:,5:8)*xyspacings;
end

Pool_tracks=cat(1,Pool_tracks,tracksCell);
Pool_tracksInt=cat(1,Pool_tracksInt,tracksInt);

% run MSD analysis
%msdanalyze initiation
ma = msdanalyzer(N_DIM, SPACE_UNITS, TIME_UNITS);
%passtracks to msd analyzer
ma = ma.addAll(tracksCell);

%compute MSD
ma = ma.computeMSD;
ma.msd;

Y=ma.msd; %cell matrix with MSD of each track
MSDlinfit=zeros(length(Y),3); %gives Deff, conf int, r2
MSDconffit=zeros(length(Y),5); %gives Deff, conf int, alpha, conf int r2

MSDfit=cell(length(Y),1);
%1 D by linear fit
%2 D conf interval linear fit
%3 r2 linear fit
%4 D by loglog fit
%5 D conf interval loglog fit
%6 a loglog fit
%7 a conf interval loglog fit
%8 r2 loglog fit
%9 mean intensity of track

parfor j=1:length(Y)
    t = Y{j,1}(:,1);
    x = Y{j,1}(:,2);
    dx = Y{j,1}(:,3) ./ sqrt(Y{j,1}(:,4));  
    
    %have to handle nan
    b=isnan(x);
    b=~b;
    x=x(b);
    t=t(b);
    dx=dx(b);
          
    nancap=min(find(diff(isnan(dx))==1));%we have to cap in case there are less point than the threshold
    if isempty(nancap)==1
        nancap=length(dx);
    end
    
%     shadedErrorBar(t, x, dx, 'k');
%     hold on


    [fo, gof] = fit(t(1:min(nancap,thresholdlin)), x(1:min(nancap,thresholdlin)), fittype('a*x+b'), 'Weights', dx(1:min(nancap,thresholdlin)),'StartPoint', [0 0]);
    MSDfit{j,1}(1,1)=fo.a/(2*N_DIM);
    Daverageconf=confint(fo);
    Daverageconf=Daverageconf(:,1)./(2*N_DIM);%get 95 conf of first param
    MSDfit{j,1}(1,2)=max(abs(Daverageconf-MSDfit{j,1}(1,1)));
    MSDfit{j,1}(1,3)=gof.rsquare;  
    
    [fo, gof] = fit(log(t(2:min(length(x)-1,thresholdconf))), log(x(2:min(length(x)-1,thresholdconf))), fittype('a*x+b'),'StartPoint', [0 0]);
    MSDfit{j,1}(1,4)=exp(fo.b)/(2*N_DIM);
    Dconstrainedconf=confint(fo);
    Dconstrainedconf=exp(Dconstrainedconf(:,2))./(2*N_DIM);%get 95 conf of first param
    MSDfit{j,1}(1,5)=max(abs(Dconstrainedconf-MSDfit{j,1}(1,4)));
    MSDfit{j,1}(1,8)=gof.rsquare;
    MSDfit{j,1}(1,6)=fo.a;
    alphaconf=confint(fo);
    alphaconf=alphaconf(:,1);
    MSDfit{j,1}(1,7)=max(abs(alphaconf-MSDfit{j,1}(1,6)));
    MSDfit{j,1}(1,9)=mean(tracksInt{j,1}(:,5));
end

MSDfit=cell2mat(MSDfit);
Pool_MSDfit=cat(1,Pool_MSDfit,MSDfit);

save(cat(2,basename,'_tracksNMSD.mat'),'tracksCell','tracksInt','MSDfit');
clear X Poolfoundspots Temp trackCell i j tracks ma MSDfit 

end    
     save('Pool__tracksNMSD.mat','Pool_tracks','Pool_tracksInt','Pool_MSDfit');
cd ..
end