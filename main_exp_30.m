clear
close all
clc

files = dir(fullfile('Database/database/', '*.jpg'));
N = 8;
num_coef = 1:10;
load('In/U8.mat') % Load U
% load('In/K8.mat') % Load K
% load('In/S8.mat') % Load S
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('Indici.mat','indici')
quante = 30;
% U = U(:,:,indici(1:quante));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

psnr_sbgft = zeros(length(files), length(num_coef));
% psnr_klt = zeros(length(files), length(num_coef));
% psnr_sot = zeros(length(files), length(num_coef));
for i = 1:length(files)
    strg = files(i).name;
    disp(strg)
    img = imread(strcat('Database/database/', strg));
    if length(size(img))==3
        img = rgb2gray(img);
    end
    img = double(img);
    
    X_gsp = zeros(size(img,1), size(img,2),size(U,3));
%     X_klt = zeros(size(img,1), size(img,2),40);
%     X_sot = zeros(size(img,1), size(img,2),40);
    for k = 1:size(U,3)
        % Transform
        fun = @(block_struct) T(block_struct.data, U(:,:,k)');
        X_gsp(:,:,k) = blockproc(img, [N, N], fun);
%         fun = @(block_struct) T(block_struct.data, K(:,:,k)');
%         X_klt(:,:,k) = blockproc(img, [N, N], fun);
%         fun = @(block_struct) T(block_struct.data, S(:,:,k)');
%         X_sot(:,:,k) = blockproc(img, [N, N], fun);
    end
    
    for j = 1:length(num_coef)
        disp(j)
        
        true_ind = indici(:,j);
        
        X_gsp_app = zeros(size(img,1), size(img,2),quante);
%         X_klt_app = zeros(size(img,1), size(img,2),40);
%         X_sot_app = zeros(size(img,1), size(img,2),40);
        mse_gsp = zeros(size(img,1)/N, size(img,2)/N,quante);
%         mse_klt = zeros(size(img,1)/N, size(img,2)/N,40);
%         mse_sot = zeros(size(img,1)/N, size(img,2)/N,40);
        for k = 1:quante
            % Non-linear approximation
            fun = @(block_struct) nonLinApp(block_struct.data, num_coef(j));
            X_gsp_app(:,:,k) = blockproc(X_gsp(:,:,true_ind(k)), [N, N], fun);
%             X_klt_app(:,:,k) = blockproc(X_klt(:,:,k), [N, N], fun);
%             X_sot_app(:,:,k) = blockproc(X_sot(:,:,k), [N, N], fun);
%             % Anti-Transform
%             fun = @(block_struct) inv_T(block_struct.data, U(:,:,k)');
%             X_gsp(:,:,k) = blockproc(img, [N, N], fun);
%             fun = @(block_struct) inv_T(block_struct.data, K(:,:,k)');
%             X_klt(:,:,k) = blockproc(img, [N, N], fun);
%             fun = @(block_struct) inv_T(block_struct.data, S(:,:,k)');
%             X_sot(:,:,k) = blockproc(img, [N, N], fun);
            % MSE
            fun = @(bs) immse(bs.data,...
                X_gsp_app(bs.location(1):bs.location(1)+N-1, bs.location(2):bs.location(2)+N-1,k));
            mse_gsp(:,:,k) = blockproc(X_gsp(:,:,true_ind(k)), [N, N], fun);
%             fun = @(bs) immse(bs.data,...
%                 X_klt_app(bs.location(1):bs.location(1)+N-1, bs.location(2):bs.location(2)+N-1,k));
%             mse_klt(:,:,k) = blockproc(X_klt(:,:,k), [N, N], fun);
%             fun = @(bs) immse(bs.data,...
%                 X_sot_app(bs.location(1):bs.location(1)+N-1, bs.location(2):bs.location(2)+N-1,k));
%             mse_sot(:,:,k) = blockproc(X_sot(:,:,k), [N, N], fun);
        end
        best_mse = min(mse_gsp,[],3);
        my_mse = sum(best_mse(:))/numel(best_mse);
        psnr_sbgft(i,j) = 20*log10(255/sqrt(my_mse));
        
%         best_mse = min(mse_klt,[],3);
%         my_mse = sum(best_mse(:))/numel(best_mse);
%         psnr_klt(i,j) = 20*log10(255/sqrt(my_mse));
%         
%         best_mse = min(mse_sot,[],3);
%         my_mse = sum(best_mse(:))/numel(best_mse);
%         psnr_sot(i,j) = 20*log10(255/sqrt(my_mse));
    end
    
end

save(strcat('psnr_natural_images_', num2str(quante),'.mat'), 'psnr_sbgft')

%%%%%%%%%%%%%%%%%%%%%%%%% FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%
% function y = T(x, D)
%     N = size(x,1);
%     % D^(-1)*x
%     y = reshape(D*x(:), [N, N]); 
% %     y = D\x(:);
% end
% 
% function y = nonLinApp(x, num_coef)
%     [~, iM] = sort(abs(x(:)), 'descend');
%     y = zeros(size(x));
%     y(iM(1:num_coef)) = x(iM(1:num_coef));
% end

% function y = inv_T(x, D)
%     N = 8;
%     y = reshape(D\x(:), [N, N]);
% end