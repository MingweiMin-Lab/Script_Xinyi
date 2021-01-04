function IF_tiff_w(currFile, datadirIF)

%% Resolve the well column and row from the raw filename
currFolder = 'D:\文档\CCLA\experiment\Data\IF20201127wxy__2020-11-27T12_06_18-Measurement 1\Images\'; 
datadirIF = 'D:\文档\CCLA\experiment\Data\IF20201127wxy__2020-11-27T12_06_18-Measurement 1\Results\IF_intensity\IF_name_mat\';

%% basic parameters
nucr=12;
debrisarea=100;
boulderarea=1500; %MCF-10A: H2B:20 NLS:10
blobthreshold=-0.03; 
se = strel('disk',nucr*4);

timetotal=tic;
%% load CMOS
load('D:\文档\CCLA\experiment\Data\IF20201127wxy__2020-11-27T12_06_18-Measurement 1\Results\cmos_bias\High_content_microscopy_dapi_bias.mat');
biasall = bias;
load('D:\文档\CCLA\experiment\Data\IF20201127wxy__2020-11-27T12_06_18-Measurement 1\Results\cmos_bias\High_content_microscopy_Alexa_bias.mat');
biasall(:,:,2) = bias;
cmos = load('D:\文档\CCLA\experiment\Data\IF20201127wxy__2020-11-27T12_06_18-Measurement 1\Results\cmos_noise\high-content cmos noise.mat');
cmos = getfield(cmos,'cmos_camera');

%% load raw images   
for wellF = 1:5
    for wellRow = 1:2
        for wellCol = 1:11
      dapi = double(imread([currFolder, ['r',sprintf('%02d',wellRow),'c',sprintf('%02d',wellCol),'f',sprintf('%02d',wellF),'p01-ch1sk1fk1fl1.tiff']]));
      Alexa= double(imread([currFolder, ['r',sprintf('%02d',wellRow),'c',sprintf('%02d',wellCol),'f',sprintf('%02d',wellF),'p01-ch2sk1fk1fl1.tiff']]));
      
%% segment nuclei    
    segmethod='single';
    switch segmethod
        case 'log'
            nuc_mask=blobdetector_4(log(dapi),nucr,blobthreshold,debrisarea);
        case 'single'
            blurradius=3;
            nuc_mask=threshmask(dapi,blurradius);
            nuc_mask=markershed(nuc_mask,round(nucr*2/3));
        case 'double'
            blurradius=3;
            nuc_mask=threshmask(dapi,blurradius);
            nuc_mask=markershed(nuc_mask,round(nucr*2/3));
            nuc_mask=secondthresh(dapi,blurradius,nuc_mask,boulderarea*2);
    end
% remove small objects
    nuc_mask=bwareaopen(nuc_mask,debrisarea);

% Deflection-Bridging  
    nuc_mask=segmentdeflections_bwboundaries(nuc_mask,nucr,debrisarea);

%
    nuc_mask=excludelargeandwarped_3(nuc_mask,boulderarea,0.85);
    
%% calculate background: local 
    corrected1 = (dapi-cmos)./biasall(:,:,1);
    blur1 = imfilter(corrected1,fspecial('disk',3),'symmetric');
    real_1 = imtophat(blur1,se); % 
    real_1(real_1<1) = 1;
    real_IF(:,:,1)= real_1;
    
    corrected2 = (Alexa-cmos)./biasall(:,:,2);
    blur2 = imfilter(corrected2,fspecial('disk',3),'symmetric');
    real_2 = imtophat(blur2,se); % 
    real_2(real_2<1) = 1;
    real_IF(:,:,2)= real_2;
    
%% extract features 
    nuc_label=bwlabel(nuc_mask);
    nuc_info=struct2cell(regionprops(nuc_mask,real_IF(:,:,1),'Area','Centroid','MeanIntensity')');
    nuc_area=squeeze(cell2mat(nuc_info(1,1,:)));
    nuc_center=squeeze(cell2mat(nuc_info(2,1,:)))';
 
%% matching 
    numcells=numel(nuc_area);
    nuc_info=regionprops(nuc_label,'PixelIdxList');

    real1 = real_IF(:,:,1);
    real2 = real_IF(:,:,2);
    
    cells = struct([]);
    ring_label=getcytoring_3(nuc_label,4,real1);
    ring_info=regionprops(ring_label,'PixelIdxList');
    
    for cc=1:numcells
        raw2 = Alexa;
             if max(raw2(nuc_info(cc).PixelIdxList))<65000
                cells(cc).xy_coordinates    = nuc_center(cc,:);
                cells(cc).nuc_area          = nuc_area(cc);
                cells(cc).dapi_sum          = sum(real1(nuc_info(cc).PixelIdxList));
                cells(cc).dapi_mean         = mean(real1(nuc_info(cc).PixelIdxList));
                
                cells(cc).Alexa_nuc_median   = median(real2(nuc_info(cc).PixelIdxList));
                cells(cc).Alexa_ring_median  = median(real2(ring_info(cc).PixelIdxList));
                cells(cc).Alexa_nuc_mean     = mean(real2(nuc_info(cc).PixelIdxList));
                cells(cc).Alexa_ring_mean     = mean(real2(ring_info(cc).PixelIdxList));
                cells(cc).Alexa_nuc_sum      = sum(real2(nuc_info(cc).PixelIdxList));    
                cells(cc).Alexa_ring_sum      = sum(real2(ring_info(cc).PixelIdxList));  
             end        
    end
 
%% store data 
    if ~isempty(nuc_area)
        save([datadirIF,'r',num2str(wellRow), '_c', num2str(wellCol), '_f', num2str(wellF),'_IF.mat'],'cells');
    end
        end
    end
end
end
% toc(timetotal);
