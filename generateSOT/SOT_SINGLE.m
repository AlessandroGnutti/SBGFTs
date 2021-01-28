% Copyright Osman G. Sezer and Onur G. Guleryuz 2015
%
% Routines that generate the transforms derived in: 
%
% Sezer, O.G.; Guleryuz, O.G.; Altunbasak, Y., "Approximation and Compression With Sparse Orthonormal Transforms," in Image Processing, 
% IEEE Transactions on , vol.24, no.8, pp.2328-2343, Aug. 2015
%
% http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7065257&isnumber=7086144
%
function [E,tcost] = SOT_SINGLE(Lambda,X,E)
% Train E for given X for single class


diff = 0;
ccurr = 1000000;
cprev = 0;
tcost = zeros(1000,1);

count = 1; 
while abs(cprev-ccurr) > diff     
    
    C = E'*X;
    C(abs(C)<sqrt(Lambda)) = 0;   
    Y = C*X';

    [U,~,V] = svd(Y);
    E = V*U';
    Dist = (X-E*C).^2;
    tcost(count) = sum(sum(Dist) + Lambda*sum((C~=0)));
    
%   cost of 10 prev iteration
    if count > 10
       cprev = tcost(count-10); 
    end
    
    ccurr = tcost(count);
    
    diff=abs(cprev)*1e-4;
    
    count = count + 1;        
end

[~,ind]=sort(-mean(C.^2,2));
E=E(:,ind);
tcost = tcost(1:count-1);





