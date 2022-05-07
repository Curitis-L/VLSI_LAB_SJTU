% =========================================================================
% Title       : Removing cyclic prefix of Simulation for OFDM IEEE 802.11a
% File        : removecp.m
% -------------------------------------------------------------------------
% Description :
%   This file removes the cyclic prefix for OFDM symbols
% -------------------------------------------------------------------------
% 
% =========================================================================

function data_out = removecp(data_in, len_of_gi)

    data_out = data_in(len_of_gi + 1 : end, :);

end
%******************** end of file ***************************
