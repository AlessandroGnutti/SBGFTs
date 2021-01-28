clear
close all
clc

strg_database = 'Database/database/';
files = dir(fullfile(strg_database, '*.jpg'));
N = 8;
num_coef = 1:10;
load('In/U8.mat') % Load U
load('In/K8.mat') % Load K
load('In/S8.mat') % Load S

psnr_sbgft = zeros(length(files), length(num_coef));
psnr_klt = zeros(length(files), length(num_coef));
psnr_sot = zeros(length(files), length(num_coef));
for i = 1:length(files)
    strg = files(i).name;
    disp(strg)
    img = imread(strcat(strg_database, strg));
    if length(size(img))==3
        img = rgb2gray(img);
    end
    img = double(img);
    
    X_gsp = zeros(size(img,1), size(img,2),40);
    X_klt = zeros(size(img,1), size(img,2),40);
    X_sot = zeros(size(img,1), size(img,2),40);
    for k = 1:40
        % Transform
        fun = @(block_struct) T(block_struct.data, U(:,:,k)');
        X_gsp(:,:,k) = blockproc(img, [N, N], fun);
        fun = @(block_struct) T(block_struct.data, K(:,:,k)');
        X_klt(:,:,k) = blockproc(img, [N, N], fun);
        fun = @(block_struct) T(block_struct.data, S(:,:,k)');
        X_sot(:,:,k) = blockproc(img, [N, N], fun);
    end
    
    for j = 1:length(num_coef)
        X_gsp_app = zeros(size(img,1), size(img,2),40);
        X_klt_app = zeros(size(img,1), size(img,2),40);
        X_sot_app = zeros(size(img,1), size(img,2),40);
        mse_gsp = zeros(size(img,1)/N, size(img,2)/N,40);
        mse_klt = zeros(size(img,1)/N, size(img,2)/N,40);
        mse_sot = zeros(size(img,1)/N, size(img,2)/N,40);
        for k = 1:40
            % Non-linear approximation
            fun = @(block_struct) nonLinApp(block_struct.data, num_coef(j));
            X_gsp_app(:,:,k) = blockproc(X_gsp(:,:,k), [N, N], fun);
            X_klt_app(:,:,k) = blockproc(X_klt(:,:,k), [N, N], fun);
            X_sot_app(:,:,k) = blockproc(X_sot(:,:,k), [N, N], fun);
            % MSE
            fun = @(bs) immse(bs.data,...
                X_gsp_app(bs.location(1):bs.location(1)+N-1, bs.location(2):bs.location(2)+N-1,k));
            mse_gsp(:,:,k) = blockproc(X_gsp(:,:,k), [N, N], fun);
            fun = @(bs) immse(bs.data,...
                X_klt_app(bs.location(1):bs.location(1)+N-1, bs.location(2):bs.location(2)+N-1,k));
            mse_klt(:,:,k) = blockproc(X_klt(:,:,k), [N, N], fun);
            fun = @(bs) immse(bs.data,...
                X_sot_app(bs.location(1):bs.location(1)+N-1, bs.location(2):bs.location(2)+N-1,k));
            mse_sot(:,:,k) = blockproc(X_sot(:,:,k), [N, N], fun);
        end
        best_mse = min(mse_gsp,[],3);
        my_mse = sum(best_mse(:))/numel(best_mse);
        psnr_sbgft(i,j) = 20*log10(255/sqrt(my_mse));
        
        best_mse = min(mse_klt,[],3);
        my_mse = sum(best_mse(:))/numel(best_mse);
        psnr_klt(i,j) = 20*log10(255/sqrt(my_mse));
        
        best_mse = min(mse_sot,[],3);
        my_mse = sum(best_mse(:))/numel(best_mse);
        psnr_sot(i,j) = 20*log10(255/sqrt(my_mse));
    end
    
end

save('psnr_natural_images.mat', 'psnr_sbgft', 'psnr_klt', 'psnr_sot')

%%%%%%%%%%%%%%%%%%%%%%%%% FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%
function y = T(x, D)
    N = size(x,1);
    % D^(-1)*x
    y = reshape(D*x(:), [N, N]); 
%     y = D\x(:);
end

function y = nonLinApp(x, num_coef)
    [~, iM] = sort(abs(x(:)), 'descend');
    y = zeros(size(x));
    y(iM(1:num_coef)) = x(iM(1:num_coef));
end
