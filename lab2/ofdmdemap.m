% =========================================================================
% Title       : Subcarrier mapping for OFDM IEEE 802.11a
% File        : ofdmdemap.m
% -------------------------------------------------------------------------
% Description :
%   This file demaps the subcarriers for OFDM symbols
% -------------------------------------------------------------------------
%
% =========================================================================
function  data_out = ofdmdemap(data_in, OFDM)

%****************** variables *************************
% data_in    : Input ch data
% data_out : Output ch data
% fftlen    : Length of FFT (points)
% nd        : Number of OFDM symbols
% *****************************************************
% fftlen = 64;
% nd = 6;

data_out = zeros(OFDM.para, OFDM.Nd);
data_out(OFDM.subcarrier_order, :) = data_in(OFDM.ToneMap, :);

end

%******************** end of file ***************************
