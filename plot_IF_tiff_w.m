%%
% currFolder = 'D:\文档\CCLA\experiment\Data\IF20201127wxy__2020-11-27T12_06_18-Measurement 1\Results\IF_intensity\IF_name_mat\1\'; 
currFolder = 'C:\Users\Jiasui\Documents\MATLAB\Jiasui\MCF10A_scatter plot\Result\'; 
fileList = dir(fullfile(currFolder,'*.mat'));
fileList = {fileList.name};

savedir =  'C:\Users\Jiasui\Documents\MATLAB\Jiasui\MCF10A_scatter plot\Scatter plot\';

%%
dapiResult=[];
AlexaResult=[];
for iFile=1:length(fileList)
    fn=fileList{1,iFile};
    startIdx1 = regexp(fn,'r[0-9]');
    startIdx2 = regexp(fn,'c[0-9]');
    startIdx3 = regexp(fn,'f[0-9]');
    wellRow =  str2double(fn(startIdx1+1));
% wellCol =  str2double(fn(startIdx2+1));
    wellCol =  str2double(fn(startIdx2+1:startIdx2+2)); 
    wellF =  str2double(fn(startIdx3+1));
    if wellCol ==11
        if wellRow ==2
        load(fn);
          for i=1:length(cells)
              dapi=getfield(cells,{i},'dapi_sum');
%               Alexa=getfield(cells,{i},'Alexa_nuc_sum');
               Alexa=getfield(cells,{i},'Alexa_nuc_sum');
%                Alexa=getfield(cells,{i},'Alexa_ring_sum');
              dapiResult=[dapiResult;dapi];
              AlexaResult=[AlexaResult;Alexa];
          end
        end  
    end
end
figure,dscatter_new(dapiResult,log10(AlexaResult));

       
       
        
        
























