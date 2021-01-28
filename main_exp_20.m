clear
close all
clc

files = dir(fullfile('Database/database/', '*.jpg'));
N = 8;
num_coef = 1:10;
load('In/U8.mat') % Load U
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('Indices.mat','indici')
quante = 20;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

psnr_sbgft = zeros(length(files), length(num_coef));
for i = 1:length(files)
    strg = files(i).name;
    disp(strg)
    img = imread(strcat('Database/database/', strg));
    if length(size(img))==3
        img = rgb2gray(img);
    end
    img = double(img);
    
    X_gsp = zeros(size(img,1), size(img,2),size(U,3));
    for k = 1:size(U,3)
        % Transform
        fun = @(block_struct) T(block_struct.data, U(:,:,k)');
        X_gsp(:,:,k) = blockproc(img, [N, N], fun);
    end
    
    for j = 1:length(num_coef)
        disp(j)
        
        true_ind = indici(:,j);
        
        X_gsp_app = zeros(size(img,1), size(img,2),quante);
        mse_gsp = zeros(size(img,1)/N, size(img,2)/N,quante);
        for k = 1:quante
            % Non-linear approximation
            fun = @(block_struct) nonLinApp(block_struct.data, num_coef(j));
            X_gsp_app(:,:,k) = blockproc(X_gsp(:,:,true_ind(k)), [N, N], fun);
            % MSE
            fun = @(bs) immse(bs.data,...
                X_gsp_app(bs.location(1):bs.location(1)+N-1, bs.location(2):bs.location(2)+N-1,k));
            mse_gsp(:,:,k) = blockproc(X_gsp(:,:,true_ind(k)), [N, N], fun);
        end
        best_mse = min(mse_gsp,[],3);
        my_mse = sum(best_mse(:))/numel(best_mse);
        psnr_sbgft(i,j) = 20*log10(255/sqrt(my_mse));
    end    
end

save(strcat('psnr_natural_images_', num2str(quante),'.mat'), 'psnr_sbgft')

%%%%%%%%%%%%%%%%%%%%%%%%% FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%
function y = T(x, D)
    N = size(x,1);
    % D^(-1)*x
    y = reshape(D*x(:), [N, N]); 
end
 
function y = nonLinApp(x, num_coef)
    [~, iM] = sort(abs(x(:)), 'descend');
    y = zeros(size(x));
    y(iM(1:num_coef)) = x(iM(1:num_coef));
end
