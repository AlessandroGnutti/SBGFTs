% Copyright Osman G. Sezer and Onur G. Guleryuz 2015
%
% Routines that generate the transforms derived in: 
%
% Sezer, O.G.; Guleryuz, O.G.; Altunbasak, Y., "Approximation and Compression With Sparse Orthonormal Transforms," in Image Processing, 
% IEEE Transactions on , vol.24, no.8, pp.2328-2343, Aug. 2015
%
% http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7065257&isnumber=7086144
%
function visual( A, mag, cols, fig_no )
% visual - display a basis for image patches
%
% A        the basis, with patches as column vectors
% mag      magnification factor
% cols     number of columns (x-dimension of map)
%

% Get maximum absolute value (it represents white or black; zero is gray)
maxi=max(max(abs(A)));
mini=-maxi;

% This is the side of the window
dim = sqrt(size(A,1));

% Helpful quantities
dimm = dim-1;
dimp = dim+1;
rows = size(A,2)/cols;
if rows-floor(rows)~=0, error('Fractional number of rows!'); end

% Initialization of the image
I = maxi*ones(dim*rows+rows-1,dim*cols+cols-1); 

for i=0:rows-1
  for j=0:cols-1
    
    % This sets the patch
    I(i*dimp+1:i*dimp+dim,j*dimp+1:j*dimp+dim) = ...
			reshape(A(:,i*cols+j+1),[dim dim]);
  end
end

I = imresize(I,mag,'nearest');

if(nargin==4)
    change_current_figure(fig_no);
else
    figure;
end


colormap(gray(256));
iptsetpref('ImshowBorder','tight'); 
subplot('position',[0,0,1,1]);
warning('off','all');
imshow(I,[mini maxi]);
truesize;  
warning('on','all');

function change_current_figure(h)
set(0,'CurrentFigure',h)

