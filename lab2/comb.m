% =========================================================================
% Title       : Combine the signal with the Gaussian noise
% File        : comb.m
% -------------------------------------------------------------------------
% Description :
%   This file generate the AWGN channel output

% =========================================================================
function data_out = comb(data_in, N0)

    N0 = 0.5 * N0; % get the noise variance/power of the in-phase part and quadratic part
    sigma = sqrt(N0);
    noise = sigma .* (randn(1, length(data_in)) + 1i .* randn(1, length(data_in)));
    
    % AWGN channel output
    data_out = data_in + noise;
end
% ************************end of file***********************************
