clear 
close 
clc

files = dir(fullfile('CovMatHD/', '*.mat'));
K = zeros(64,64,40);
for i = 1:length(files)
    strg = files(i).name;
    load(strcat('CovMatHD/', strg));
    C = eval(strg(1:end-4));
    [V,D] = eig(C);
    subplot(8,5,i), imagesc(uint8(reshape(255/0.8*(V(:,end)+0.4), [8,8]))), yticks([]), xticks([]),...
        caxis([0 255]), colormap(gray)
    K(:,:,i) = V;
end

%% Plot centroids
% files = dir(fullfile('Centroids/', '*.mat'));
% figure
% for i = 1:length(files)
%     strg = files(i).name;
%     load(strcat('Centroids/', strg));
%     C = eval(strg(1:end-4));
%     subplot(8,5,i), imagesc(reshape(uint8(C),[8 8])), yticks([]), xticks([]),...
%         caxis([0 255]), colormap(gray)
% end