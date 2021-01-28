% Copyright Osman G. Sezer and Onur G. Guleryuz 2015
%
% Routines that generate the transforms derived in: 
%
% Sezer, O.G.; Guleryuz, O.G.; Altunbasak, Y., "Approximation and Compression With Sparse Orthonormal Transforms," in Image Processing, 
% IEEE Transactions on , vol.24, no.8, pp.2328-2343, Aug. 2015
%
% http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7065257&isnumber=7086144
%

% First load the training data
load('X.mat');
% Training data comes with a data structure (cell) 'X' which has 64x20000
% matrix at each cell. Each cell representation a direction given in 'directions' vector.
% Each 8x8 block is vectorized; and we have 20k samples for each direction.
% This labeling is done by choosing the dominant image gradient in each 8x8 block.


% Call the SOT_LOOP function
% E is the corresponding orthogonal representation for each X cell
% E{k}'s can be initialized as identity matrix since annealing step is
% enabled. Else DCT or KLT of each cell can be used to initialized the
% SOT_SINGLE algorithm.
%
% In this version of our software only 8x8 block size is used.

E=cell(40,1);

for i = 1:40
   E{i} = eye(64);
end

% for faster convergence
% modify diff=abs(cprev)*1e-6; to
% diff=abs(cprev)*1e-4; or lower
% in SOT_SINGLE.m
[E,X] = SOT_LOOP(E, X, 1:40, 8);
