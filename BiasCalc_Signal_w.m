clearvars;

%% file paths %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rawdir = 'D:\文档\CCLA\experiment\Data\IF20201127wxy__2020-11-27T12_06_18-Measurement 1\Images\';
savedir = 'D:\文档\CCLA\experiment\Data\IF20201127wxy__2020-11-27T12_06_18-Measurement 1\Results\cmos_bias\';

%% Export the images
fileList = dir(fullfile(rawdir,'*.tiff'));
fileList = {fileList.name};
for iFile = 1:length(fileList) 
    file = fullfile(rawdir,fileList{1,iFile});
        if contains(file,"ch1")==1
           file_ch1 = file;
           BiasCalc_singlewell_w(savedir,file_ch1);
        end 
end

%% 
fileList2     = dir(fullfile(savedir,'*.mat'));
fileList2     = {fileList2.name};
biasstack_all = [];

for iFile = 1:numel(fileList2)
    file2 = fullfile(savedir,fileList2{iFile});
    load(file2);
    biasstack_all = cat(3,biasstack_all,biasstack);
end

height=2160;
width =2160;
blockbias_all = nanmedian(biasstack_all,3);  
bias          = imresize(blockbias_all,[height width],'bicubic');
   
save([savedir,'High_content_microscopy_dapi_bias.mat'],'bias');
