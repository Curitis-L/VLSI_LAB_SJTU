% =========================================================================
% Title       : Modulation of Simulation for OFDM IEEE 802.11a
% File        : ofdmmod.m
% -------------------------------------------------------------------------
% Description :
%   This file prepares constellation symbols with the (Gray) mapping, and
%   generate the transmitted symbols
% -------------------------------------------------------------------------
%
% =========================================================================

function ch = ofdmmod(paradata, OFDM)
   % initialize the tx signal
    ch = zeros(OFDM.para, OFDM.Nd);
    % -- construct IEEE 802.11a-compliant mapping/constellation points
    % -- Gray mapping verision
    switch (OFDM.mod_lev)
        case 1 % BPSK
            OFDM.Constellations = [-1, 1];
        case 2 % 4-QAM / QPSK
            OFDM.Constellations = [-1- 1i, -1+1i, ...
                                   +1-1i, +1+1i];
        case 4 % 16-QAM
            OFDM.Constellations = [-3-3i,-3-1i,-3+3i,-3+1i,-1-3i,-1-1i,
			  -1+3i,-1+1i,3-3i,3-1i,3+3i,3+1i,
			  1-3i,1-1i,1+3i,1+1i ]; % you should fix it;
        case 6 % 64-QAM
            OFDM.Constellations = [-7-7i,-7-5i,-7-1i,-7-3i,-7+7i,-7+5i,
			  -7+1i,-7+3i,-5-7i,-5-5i,-5-1i,-5-3i,
			  -5+7i,-5+5i,-5+1i,-5+3i,-1-7i,-1-5i,
			  -1-1i,-1-3i,-1+7i,-1+5i,-1+1i,-1+3i,
			  -3-7i,-3-5i,-3-1i,-3-3i,-3+7i,-3+5i,
			  -3+1i,-3+3i,7-7i,7-5i,7-1i,7-3i,7+7i,
			  7+5i,7+1i,7+3i,5-7i,5-5i,5-1i,5-3i,
			  5+7i,5+5i,5+1i,5+3i,1-7i,1-5i,1-1i,
			  1-3i,1+7i,1+5i,1+1i,1+3i,3-7i,3-5i,
			  3-1i,3-3i,3+7i,3+5i,3+1i,3+3i ]; % you should fix it;
        otherwise
            error('Modulation order for 11a mapping not supported.')
    end

    % modulation / bit mapping to the constellation symbol
    for i = 1 : OFDM.para
        bit_idx = reshape(paradata(i, :), OFDM.mod_lev, OFDM.Nd).';
        dec_idx = bi2de(fliplr(bit_idx)) + 1;
        ch(i, :) = OFDM.Constellations(dec_idx);
    end


    return
