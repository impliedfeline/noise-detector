% markbadsegment() 
%
% Adapted from eeglab function trial2eegplot()
% 
% Usage:
%   >> eegplotarray = trial2eegplot(rej, rejE, points, color);
%
% Inputs:
%   rej   - rejection vector (0 and 1) with one value per trial
%   rejE  - electrode rejection array (size nb_elec x trials) also
%           made of 0 and 1.
%   points - number of points per trials
%   color  - color of the windows for eegplot()
%
% Outputs:
%   eegplotarray - array defining windows which is compatible with 
%                  the function eegplot()
%
% 
% ---------------------------------------------------------- 
function rejeegplot = markbadsegment( rej, rejE, pnts, color)
%  rej = rejeseg;
%  rejE = rejesegE;
% color = [.95, .95,.95];

n_seg = 1:length(rej);
rej  = find(rej>0);
	rejE = rejE';
   	rejeegplot = ones(length(n_seg), size(rejE,2)+5);
   	rejeegplot(:, 6:end) = rejE;
    rejeegplot(:, 1) = (n_seg(:)-1)*pnts;
    rejeegplot(:, 2) = n_seg(:)*pnts-1;
   	rejeegplot(rej, 3:5) = ones(size(rej,2),1)*color;
return
