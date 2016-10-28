%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Purpose: Rotation matrix about second axis 
%   b = dcm*a
%
%   Inputs: 
%       - beta - rotation angle (rad)
%
%   Outpus: 
%       - rot2 - rotation matrix (3x3)
%
%   Dependencies: 
%       - none
%
%   Author: Shankar Kulumani 23 September 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function rot2 = ROT2(beta)


cos_beta = cos(beta);
sin_beta = sin(beta);

rot2 = [cos_beta  0  sin_beta;   ...
           0      1      0    ;   ...
        -sin_beta  0  cos_beta ];
end
