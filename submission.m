%% Group 28 - MATLAB Script for Transfer Function Analysis
% Inputs: Transfer functions, given as 1D arrays of numerator and denominator coefficients
% Outputs: 
% - Time-domain step response plot
% - s-domain pole-zero plot
% - Print transient response parameters (PO, td, tr, ts, ess)
% - Print s-domain parameters (wn, zeta) for each complex conjugate pole pair

%s^5 + 20*s^4 + 623*s^3 + 5886*s^2 + 48210*s + 278800
% 5th order transfer function
%                            106470
% T(s) = -----------------------------------------------
%        s^5 + 21s^4 + 304s^3 + 2456s^2 + 14703s + 53235
numerator1 = 106470;
denominator1 = [1 21 304 2456 14703 53235];

% Simplified transfer function
numerator2 = 130;
denominator2 = [1 2 65];

% Control System Toolbox allows us to model LTI system by transfer function
sys1 = tf(numerator1, denominator1);
sys2 = tf(numerator2, denominator2);

stepplot(sys1, sys2)