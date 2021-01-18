function [tformList] = channel_bias(fixed,moving)
% CHANNEL_BIAS aligns images from different channels to one reference
% channel.
%
%   Input
%       fixed: the reference channel
%       moving: the channels that wants to align with reference channel
%   Ouput:
%       tform: The geometric transformation object, that maps pixels in
%       moving to pixels in fixed
%
channelFolder = 'D:\CCLA\Mengdan_images\20210113 well2-1__2021-01-13T14_53_26-Measurement 3\Images\';
savedir = 'C:\Users\Jiasui\Documents\MATLAB\Jiasui\MCF10A_scatter plot\';
fixed = double(imread([channelFolder,'r08c04f01p01-ch2sk1fk1fl1.tiff']));

%%% add all of your moving channel and it's relative number to NumtoChannel array
NumtoChannel = {};
NumtoChannel(1,:) = {3, 'Alexa488'};
NumtoChannel(2,:) = {4, 'Alexa568'};
NumtoChannel(3,:) = {5, 'Alexa647'};
%%%%

for i = 1:length(NumtoChannel)
    num = cell2mat(NumtoChannel(i,1));
    channel = cell2mat(NumtoChannel(i,2));
    moving = double(imread([channelFolder,'r08c04f01p01-ch',sprintf('%d',num),'sk1fk1fl1.tiff']));
    tform = imregcorr(moving,fixed,'similarity');
    save([savedir,'High_content_microscopy_channel_',channel,'_bias.mat'],'tform');
    end
end 

