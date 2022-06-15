% =========================================================================
% Title       : Wrapper for CC Decoders
% File        : CC_decoder.m
% -------------------------------------------------------------------------
% Description :
%   This file performs (de-)puncturing and calls the chosen CC
%   decoders for the decision the information bits.
%   LLR_D is a priori LLR calculated by demodulator, info_bits_hat 
%   is the decision of info. bits
% -------------------------------------------------------------------------
% Revisions   :
%   Date                  Author  
%   02-Apr-2022     Jiaxin Lyu
% -------------------------------------------------------------------------
%   Author: Jiaxin Lyu (e-mail: ljx981120@sjtu.edu.cn)       
% =========================================================================

function info_bits_hat = CC_decoder(TxRx, rx_bits, LLR_D, N0)
    %% -- channel decoding
    switch (TxRx.Decoder.Type)
        case 'BCJR' % -- log-MAP BCJR algorithm for CC decoding (fast Matlab/mex C-implementation)
            LLR_A = zeros(4320, 1);
            LLR_A(TxRx.Code.Puncturing.Index) = LLR_D;
            [~, info_bits_hat] = BCJR(LLR_A, TxRx.Code.trellis.numInputSymbols,TxRx.Code.trellis.numOutputSymbols, ...
                TxRx.Code.trellis.numStates,TxRx.Code.trellis.nextStates,TxRx.Code.trellis.outputs);
        case 'Hard-Viterbi'
            if (TxRx.Code.Rate == 1/2) % no puncturing
                info_bits_hat = vitdec(rx_bits, TxRx.Code.trellis, TxRx.Code.tblen, 'term', 'hard');
            else % punturing is required
                info_bits_hat = vitdec(rx_bits, TxRx.Code.trellis, TxRx.Code.tblen, 'term', 'hard', TxRx.Code.Puncturing.Pattern);
            end
            info_bits_hat = logical(info_bits_hat);
        case 'Soft-Viterbi'
            rx_data = (0.5 * N0) .* LLR_D;
            if (TxRx.Code.Rate == 1/2) % no puncturing
                info_bits_hat = vitdec(-rx_data, TxRx.Code.trellis, TxRx.Code.tblen, 'term', 'unquant');
            else % punturing is required
                info_bits_hat = vitdec(-rx_data, TxRx.Code.trellis, TxRx.Code.tblen, 'term', 'unquant', TxRx.Code.Puncturing.Pattern);
            end
            info_bits_hat = logical(info_bits_hat);
        case 'myViterbi'
            %% -- Please implement the Viterbi decoder by yourself-- %%
            length = size(rx_bits,1)*TxRx.Code.Rate;
            info_bits_hat = zeros(length,1);
            start_PM = zeros(1,64);
            start_PM(2:64) = 10000;
            end_PM = zeros(1,64);
            end_PM(:) = 10000;
            paths_start = zeros(length,64);
            paths_end = zeros(length,64);
            count_bit = 1;
            %%Start viterbi decoding
            for path = 1:length
                cover = zeros(1,64);
                %%For each state, calculate path weight & pruning &save surviving path
                for state = 1:64
                    if (start_PM(state)~=1000)
                        next_point1 = floor(state/2-1/2) + 1;
                        next_point2 = floor(state/2-1/2) + 33;
                        [c1,c2] = bit_coding(state,0);
                        [c3,c4] = bit_coding(state,1);
                        if TxRx.Code.Rate == 1/2 
                            %consider no puncture
                            path_wight1 = xor(c1,rx_bits(count_bit))+xor(c2,rx_bits(count_bit+1));
                            path_wight2 = xor(c3,rx_bits(count_bit))+xor(c4,rx_bits(count_bit+1));
                        elseif TxRx.Code.Rate == 2/3
                            if mod(path,2) == 1
                            %consider puncture case 1
                                path_wight1 = xor(c1,rx_bits(count_bit))+xor(c2,rx_bits(count_bit+1));
                                path_wight2 = xor(c3,rx_bits(count_bit))+xor(c4,rx_bits(count_bit+1));
                            else
                                path_wight1 = xor(c1,rx_bits(count_bit));
                                path_wight2 = xor(c3,rx_bits(count_bit));
                            end
                            %consider puncture case 2
                        elseif TxRx.Code.Rate == 3/4
                            if mod(path,3) == 1
                                path_wight1 = xor(c1,rx_bits(count_bit))+xor(c2,rx_bits(count_bit+1));
                                path_wight2 = xor(c3,rx_bits(count_bit))+xor(c4,rx_bits(count_bit+1));
                            elseif mod(path,3) == 2
                                path_wight1 = xor(c1,rx_bits(count_bit));
                                path_wight2 = xor(c3,rx_bits(count_bit));
                            else
                                path_wight1 = xor(c2,rx_bits(count_bit));
                                path_wight2 = xor(c4,rx_bits(count_bit));
                            end              
                        end 
                        %%End path_wight calculation
                        %%Do pruning to choose 64 survival paths
                        if cover(next_point1) && (start_PM(state) + path_wight1 < end_PM(next_point1))
                            end_PM(next_point1) = start_PM(state) + path_wight1;
                            paths_end(1:path-1,next_point1) = paths_start(1:path-1,state);
                            paths_end(path,next_point1) = 0;
                        elseif cover(next_point1)==0
                            end_PM(next_point1) = start_PM(state) + path_wight1;
                            paths_end(1:path-1,next_point1) = paths_start(1:path-1,state);
                            paths_end(path,next_point1) = 0;
                            cover(next_point1) = 1;
                        end
                        %%If this point never be on the path, save directly
                        %%If not, perform comparison
                        if cover(next_point2) && start_PM(state) + path_wight2 < end_PM(next_point2)
                            end_PM(next_point2) = start_PM(state) + path_wight2;
                            paths_end(1:path-1,next_point2) = paths_start(1:path-1,state);
                            paths_end(path,next_point2) = 1;
                        elseif cover(next_point2)==0
                            end_PM(next_point2) = start_PM(state) + path_wight2;
                            paths_end(1:path-1,next_point2) = paths_start(1:path-1,state);
                            paths_end(path,next_point2) = 1; 
                            cover(next_point2) = 1;
                        end
                    end
                end
                %%End purning
                start_PM= end_PM;
                end_PM(:) = 10000;
                paths_start = paths_end;
                %%Start next state decoding preparation
                if TxRx.Code.Rate == 1/2
                    count_bit = count_bit + 2;
                elseif TxRx.Code.Rate == 2/3
                    if mod(path,2) == 1
                        count_bit = count_bit + 2;
                    else
                        count_bit = count_bit + 1;
                    end
                elseif TxRx.Code.Rate == 3/4
                    if mod(path,3) == 1
                        count_bit = count_bit + 2;
                    else
                        count_bit = count_bit + 1;
                    end
                end         
            end
                [~,pos] = min(start_PM);
                info_bits_hat(:) = paths_start(:,pos);
                %%hard viterbi decoding
                info_bits_hat = logical(info_bits_hat);  

                   
        otherwise
            error('No valid TxRx.Decoder.Type in CC_decoder.m')
    end
return

function [c1,c2] = bit_coding(state,inputnum)
    tmp = state-1;
    reg1 = mod(tmp,2);
    reg2 = mod(floor(tmp/2),2);
    reg3 = mod(floor(tmp/4),2);
    reg4 = mod(floor(tmp/8),2);
    reg5 = mod(floor(tmp/16),2);
    reg6 = mod(floor(tmp/32),2);
    c1 = mod(reg1 + reg2 + reg4 + reg5 + 0*reg3+inputnum, 2);
    c2 = mod(reg1 + reg4 + reg5 + reg6 + 0*reg3+inputnum, 2);
return
