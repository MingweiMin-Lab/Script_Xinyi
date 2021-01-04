%%
load('spectrax_emCopy.mat');
load('spectrax_exCopy.mat');
load('FPs_w.mat');

figure(1)
allFPs={'DAPI','CFP','GFP','FITC','YFP','CY3','mCherry','CY5','mIFP'};

%%
for i=1:length(allFPs)
    subplot(length(allFPs)+3,1,i)
    name_ex=eval([allFPs{i},'_ex']);
    name_em=eval([allFPs{i} '_em']);
    plot(name_ex(:,1),name_ex(:,2),'LineWidth',2);
    hold on
    plot(name_em(:,1),name_em(:,2),'LineWidth',2);
    grid minor
    ylabel(allFPs(i));
    xlim([300 800])
end
%%
subplot(length(allFPs)+6,1,length(allFPs)+1)
plot(spectrax_exCopy1(:,1),spectrax_exCopy1(:,2),'LineWidth',2);
grid minor
xlim([300 800]);
ylabel('ex filters');
%%
subplot(length(allFPs)+6,1,length(allFPs)+2)
plot(spectrax_exCopy2(:,1),spectrax_exCopy2(:,2),'LineWidth',2);
grid minor
xlim([300 800]);
ylabel('ex filters');
%%
subplot(length(allFPs)+6,1,length(allFPs)+3)
plot(spectrax_emCopy1(:,1),spectrax_emCopy1(:,2),'LineWidth',2);
hold on
plot(spectrax_emCopy1(:,1),spectrax_emCopy1(:,2),'LineWidth',2);
grid minor
xlim([300 800]);
ylabel('em filters ');
%%
subplot(length(allFPs)+6,1,length(allFPs)+4)
plot(spectrax_emCopy2(:,1),spectrax_emCopy2(:,2),'LineWidth',2);
hold on
plot(spectrax_emCopy2(:,1),spectrax_emCopy2(:,2),'LineWidth',2);
grid minor
xlim([300 800]);
ylabel('em filters ');
%%
subplot(length(allFPs)+6,1,length(allFPs)+5)
plot(spectrax_emCopy3(:,1),spectrax_emCopy3(:,2),'LineWidth',2);
hold on
plot(spectrax_emCopy3(:,1),spectrax_emCopy3(:,2),'LineWidth',2);
grid minor
xlim([300 800]);
ylabel('em filters ');