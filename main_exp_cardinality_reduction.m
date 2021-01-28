clear
close all
clc

files = dir(fullfile('Database/database/', '*.jpg'));
N = 8;
num_coef = 1:10;
load('In/U8.mat') % Load U

mappa_mse = zeros(size(U,3),length(num_coef));
for i = 1:length(files)
    strg = files(i).name;
    disp(strg)
    img = imread(strcat('Database/database/', strg));
    if length(size(img))==3
        img = rgb2gray(img);
    end
    img = double(img);
    
    X_gsp = zeros(size(img,1), size(img,2),40);
    for k = 1:40
        % Transform
        fun = @(block_struct) T(block_struct.data, U(:,:,k)');
        X_gsp(:,:,k) = blockproc(img, [N, N], fun);
    end
    
    for j = 1:length(num_coef)
        disp(j)
        X_gsp_app = zeros(size(img,1), size(img,2),40);
        mse_gsp = zeros(size(img,1)/N, size(img,2)/N,40);
        for k = 1:40
            % Non-linear approximation
            fun = @(block_struct) nonLinApp(block_struct.data, num_coef(j));
            X_gsp_app(:,:,k) = blockproc(X_gsp(:,:,k), [N, N], fun);
            % MSE
            fun = @(bs) immse(bs.data,...
                X_gsp_app(bs.location(1):bs.location(1)+N-1, bs.location(2):bs.location(2)+N-1,k));
            mse_gsp(:,:,k) = blockproc(X_gsp(:,:,k), [N, N], fun);
        end
        [best_mse, ind_mse] = min(mse_gsp,[],3);
        for qq = 1:size(U,3)
            mappa_mse(qq,j) = mappa_mse(qq,j) + length(find(ind_mse==qq));
        end
    end
    
end

save('mappa_mse.mat.mat', 'mappa_mse')

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
