% =========================================================================
% Title       : Subcarrier mapping for OFDM IEEE 802.11a
% File        : ofdmmap.m
% -------------------------------------------------------------------------
% Description :
%   This file maps the subcarriers for OFDM symbols
% -------------------------------------------------------------------------
%
% =========================================================================
function  data_out = ofdmmap(data_in, OFDM)

%****************** variables *************************
% data_in    : Input ch data
% data_out : Output ch data
% fftlen    : Length of FFT (points)
% nd        : Number of OFDM symbols
% *****************************************************
% fftlen = 64;
% nd = 6;

data_out = zeros(OFDM.fftlen, OFDM.Nd);
data_out(OFDM.ToneMap, :) = data_in(OFDM.subcarrier_order, :);

end

%******************** end of file ***************************
