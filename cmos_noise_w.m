%% Resolve the well column and row from the raw filename

currFile    = 'D:\文档\CCLA\experiment\Data\IF20201127wxy__2020-11-27T12_06_18-Measurement 1\CAMERA 647 NOISE__2020-12-02T15_11_44-Measurement 1\Images\r01c05f01p01-ch1sk1fk1fl1.tiff';
dapiFolder  = 'D:\文档\CCLA\experiment\Data\IF20201127wxy__2020-11-27T12_06_18-Measurement 1\CAMERA DAPI NOISE__2020-12-02T15_09_36-Measurement 1\Images\'; 
AlexaFolder = 'D:\文档\CCLA\experiment\Data\IF20201127wxy__2020-11-27T12_06_18-Measurement 1\CAMERA 647 NOISE__2020-12-02T15_11_44-Measurement 1\Images\';
savedir =  'D:\文档\CCLA\experiment\Data\IF20201127wxy__2020-11-27T12_06_18-Measurement 1\Results\cmos_noise\';
[~,fn] = fileparts(currFile);

%Find a capital letter, followed by two digits
startIdx1 = regexp(fn,'r[0-9][0-9]');
startIdx2 = regexp(fn,'c[0-9][0-9]');
startIdx3 = regexp(fn,'f[0-9][0-9]');

%Convert the first letter into a number
wellRow = str2double(fn(startIdx1+2));

%Convert the next two digits into the column number
% wellCol = str2double(fn(startIdx2+2));
wellCol = str2double(fn(startIdx2+1:startIdx2+2));

%Convert the next two digits into the frame-XY-loc number
wellF   = str2double(fn(startIdx3+2));

%% calculate the cmos noise
cmos_Alexa = double(imread(currFile));
[m,n]=size(cmos_Alexa);
a=zeros(m,n);
b=zeros(m,n);
for wellP=1:10  
    Ia=double(imread([dapiFolder, ['r',sprintf('%02d',wellRow),'c',sprintf('%02d',wellCol),'f',sprintf('%02d',wellF),'p',sprintf('%02d',wellP),'-ch1sk1fk1fl1.tiff']]));
    a=a+Ia;   

    Ib=double(imread([AlexaFolder, ['r',sprintf('%02d',wellRow),'c',sprintf('%02d',wellCol),'f',sprintf('%02d',wellF),'p',sprintf('%02d',wellP),'-ch1sk1fk1fl1.tiff']]));
    b=b+Ib;
end
a=a/10;
b=b/10;
cmos_camera = (a+b)./2;


save([savedir, 'high-content cmos noise'], 'cmos_camera');



    
    
    
    
    