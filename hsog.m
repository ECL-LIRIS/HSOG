% Prelimianry code for HSOG; and the toolbox of Daisy is required (http://cvlab.epfl.ch/software/daisy, 'mdaisy-v1.0') 

function desc = hsog(imagename, frm)

% Input:
%     imagename  -- The name of the image where the HSOG (Interest Points) descriptors are extracted
%     frm             -- The center (X,Y) of the keypoint frames
% Output:
%     desc           -- The final HSOG (Interest Points) descriptors

addpath('./tools/mdaisy-v1.0');

% Set daisy parameters
R  = 25;
RQ = 3;
TQ = 4;
HQ = 8;
SI = 1;
LI = 1;
NT = 1;

% Read image data
im = imread(imagename);
M = size(im,1);
N = size(im,2);

% Compute daisy descriptors for each pixel of the image
dzy1 = compute_daisy(im,R,RQ,TQ,HQ,SI,LI,NT);
daisy1 = dzy1.descs;

daisy_all = [];

% Compute 2nd-order descriptors (HSOG) based on 1st-order daisy image for required dimensions
for i = 1:HQ
    
    temp = daisy1(:,i);
    temp = reshape(temp,N,M);
    temp = temp';
    
    dzy2 = compute_daisy(temp,R,RQ,TQ,HQ,SI,LI,NT);
    daisy2 = dzy2.descs;
    daisy_all = [daisy_all,daisy2];
    
end

% Transfer keypoint locations to linear index
loc = (frm(2,:)-1)*dzy2.w+frm(1,:);

% Get final HSOG descriptors
desc = daisy_all(loc,:);

end
