function BiasCalc_singlewell_w(savedir,currFile)
%%
timetotal=tic;
%%
nucradius=12;
tilenum=31; %number of tiles (e.g. 10 --> 10x10) for calculating background within each tile
prctilethresh=50; %the intensity percentile to take within each tile
dilationscale=2.5; %nuclear:*1 cytoplasmic:*2
maskdilation=round(nucradius*dilationscale);

%% Resolve the well column and row from the raw filename

%currFile = 'D:\文档\CCLA\experiment\Data\IF20201127wxy__2020-11-27T12_06_18-Measurement 1\Images\r01c01f01p01-ch1sk1fk1fl1.tiff';
currFolder = 'D:\文档\CCLA\experiment\Data\IF20201127wxy__2020-11-27T12_06_18-Measurement 1\Images\'; 
%savedir =  'D:\文档\CCLA\experiment\Data\IF20201127wxy__2020-11-27T12_06_18-Measurement 1\Results\';
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

cmos = load('D:\文档\CCLA\experiment\Data\IF20201127wxy__2020-11-27T12_06_18-Measurement 1\Results\cmos_noise\high-content cmos noise.mat');
cmos = getfield(cmos,'cmos_camera');
%%
% for wellF = 1:5      %XY_Loc
    biasstack=[];  
    shot = [num2str(wellRow),'_',num2str(wellCol),'_',num2str(wellF)];
     
    dapi = double(imread([currFolder, ['r',sprintf('%02d',wellRow),'c',sprintf('%02d',wellCol),'f',sprintf('%02d',wellF),'p01-ch1sk1fk1fl1.tiff']]));
    Alexa= double(imread([currFolder, ['r',sprintf('%02d',wellRow),'c',sprintf('%02d',wellCol),'f',sprintf('%02d',wellF),'p01-ch2sk1fk1fl1.tiff']]));
    
    %%% remove noise 
    sigblur=imfilter(Alexa,fspecial('gaussian',5),'symmetric');            
    nucblur=imfilter(dapi,fspecial('disk',3),'symmetric');
    
    %%% remove background 
    nucraw=bgsub_local(nucblur,60);
                
    %%% generate dilated foreground mask to block out cells %%%
    nucmask=threshmask(nucraw,3);             %segmentation
    nanmask=imdilate(nucmask,strel('disk',maskdilation,0));
    
    %%% 
%      sigbackground=sigblur-cmos;
%      sigbackground(nanmask)=NaN;       
    %%% 
      nucbackground=nucblur-cmos;
      nucbackground(nanmask)=NaN;   
                
    %%% calculate background in each tile %%%%%%%%%%%%%%%%%%%%%
%      bgblock=blockpercentile_blockimage(sigbackground,tilenum,prctilethresh);
      bgblock=blockpercentile_blockimage(nucbackground,tilenum,prctilethresh);
                
    %%% normalize each tile against the center tile %%%%%%%%%%%
    midrc=ceil(tilenum/2);
    refval=bgblock(midrc,midrc);
                
          if ~isnan(refval)
              bgblocknorm=bgblock/refval;
              biasstack=cat(3,biasstack,bgblocknorm);
          end
% end

    save([savedir,shot,'.mat'],'biasstack');
    toc(timetotal);
