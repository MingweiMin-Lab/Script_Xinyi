function H2B_count_w(currFile, datadirIF)

%% Resolve the H2B-mTurquoise fluorescent images filename
currFile='D:\文档\CCLA\实验\Minlab\20200917\Sep$17-001-A01_2020091700001_5_01\x000000y000000-10x-FL\Ch1\000000_000000_10_200917_1030_001_f1.jpg'; 
[filepath,name,exp] = fileparts(currFile);

%% basic parameters
nucr=12;
debrisarea=100;
boulderarea=1500; %MCF-10A: H2B:20 NLS:10
blobthreshold=-0.03; 
se = strel('disk',nucr*4); 

bfReaderJian = imread(currFile);

%% segment nuclei 
    raw_IF = double(rgb2gray(bfReaderJian));
    segmethod ='log';
    switch segmethod
        case 'log'
            nuc_mask=blobdetector_4(log(raw_IF),nucr,blobthreshold,debrisarea);
        case 'single'
            blurradius=3;
            nuc_mask=threshmask(raw_IF,blurradius);
            nuc_mask=markershed(nuc_mask,round(nucr*2/3));
        case 'double'
            blurradius=3;
            nuc_mask=threshmask(raw_IF,blurradius);
            nuc_mask=markershed(nuc_mask,round(nucr*2/3));
            nuc_mask=secondthresh(raw_IF,blurradius,nuc_mask,boulderarea*2);
    end
    
    nuc_mask=bwareaopen(nuc_mask,debrisarea);
    
% Deflection-Bridging 
    nuc_mask=segmentdeflections_bwboundaries(nuc_mask,nucr,debrisarea);
    
%% counting
   nuc_label=bwlabel(nuc_mask);   
   nuc_info=regionprops(nuc_label,'centroid');
   centroids = cat(1,nuc_info.Centroid);
   numcell= size(centroids);
   n= numcell(1,1);
   imshow(nuc_mask);
   hold on;
    for i=1:n
      text(centroids(i,1),centroids(i,2),num2str(i),'horiz','center','color','r');                               
    end        
end
    
    