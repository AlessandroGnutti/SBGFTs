% Copyright Osman G. Sezer and Onur G. Guleryuz 2015
%
% Routines that generate the transforms derived in:
%
% Sezer, O.G.; Guleryuz, O.G.; Altunbasak, Y., "Approximation and Compression With Sparse Orthonormal Transforms," in Image Processing,
% IEEE Transactions on , vol.24, no.8, pp.2328-2343, Aug. 2015
%
% http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7065257&isnumber=7086144
%
function [E,X] = SOT_LOOP(E,X,direction,block_width)

num_directions = length(direction);
%Lambda = delta^2;

Lambdas = [800 500 200 100 50 30 20 5];
Lambdas = Lambdas.*Lambdas;

for Lcount = 1:10 % Perform relabeling 10 times
    disp(Lcount)
    
    for count=1:length(Lambdas)
        disp(count)
        
        Lambda = Lambdas(count);
        
        % Find optimum bases using cost minimization algorithm
        % [E,Cost_Dir{count}] = SOT_SINGLE(Lambda,X,E);
        
        for i = 1:num_directions
            
            [E{i},~] = SOT_SINGLE(Lambda,X{i},E{i});
        end
        
    end
    
    for i = 1:num_directions
        
%         visual(E{i},3,block_width)
%         title(['Angle is:' num2str(direction(i))])
    end
    
    disp(['Iteration number:' num2str(Lcount-1)]);
    
    locs=cell(num_directions,num_directions);
    % Relabel each block in the database by the orientation of the
    % optimum basis that minimize the cost function.
    for i = 1:num_directions
        Cost =[];
        for j = 1:num_directions
            C = E{j}'*X{i};
            C(abs(C)<sqrt(Lambda)) = 0;
            Dum = (X{i}-E{j}*C).^2;
            Dummy = sum(Dum) + Lambda*sum((C~=0));
            Cost = [Cost; Dummy];
        end
        
        min_Vector = min(Cost);
        
        row = zeros(1,size(Cost,2));
        col = zeros(1,size(Cost,2));
        
        for m = 1:size(Cost,2)
            row_dum=find(Cost(:,m)==min_Vector(m));
            if length(row_dum)>1
                dum = abs(row_dum-i); % Choose the one closest to the original class i
                row(m) = row_dum(dum==min(dum));
            else
                row(m) = row_dum;
            end
            col(m) = m;
        end
        
        % data in the i'th direction goes to j direction
        for j = 1:num_directions
            locs{i}{j} = col(row==j);
        end
        clear row col;
    end
    
    clear C;
    
    Y=cell(num_directions,1);
    % Initialize matrices to hold new data arrangement
    for i = 1:num_directions
        Y{i} = [];
    end
    
    for i = 1:num_directions
        for j = 1:num_directions
            Y{j} = [Y{j}, X{i}(:,locs{i}{j})];
        end
    end
    
    clear X;
    X = Y;
    clear Y locs;
    
    
    % Garbage collection
    %     cwd = pwd;
    %     cd(tempdir);
    %     pack
    %     cd(cwd)
end

% Final iteration
for count=1:length(Lambdas)
    
    Lambda = Lambdas(count);
    % Find optimum bases using cost minimization algorithm
    %[E,Cost_Dir{count}] = SOT_SINGLE(Lambda,X,E);
    %close all;
    for i = 1:num_directions
        
        [E{i},~] = SOT_SINGLE(Lambda,X{i},E{i});
%         visual(E{i},3,block_width,i)
%         title(['Angle is:' num2str(direction(i))])
    end
end




