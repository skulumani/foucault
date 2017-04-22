%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Purpose: Rotation matrix about thrid axis
%   b = dcm*a
%
%   Inputs: 
%       - gamma - rotation angle (rad)
%
%   Outpus: 
%       - rot3 - rotation matrix (3x3)
%
%   Dependencies: 
%       - none
%
%   Author: Shankar Kulumani 23 September 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function rot3 = ROT3(gamma)

cos_gamma = cos(gamma);
sin_gamma = sin(gamma);

rot3 = [ cos_gamma -sin_gamma  0 ;   ...
        sin_gamma cos_gamma  0 ;   ...
            0         0       1 ];
        
end