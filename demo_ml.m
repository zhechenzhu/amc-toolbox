%%DEMO_ML   Demonstrates program to show examples simulated communication
%%signal and the classificaition of modulation classifiers using the
%%maximum likelihood classifier
%
%   Copyright (C) 2014 Zhechen Zhu
%   This file is part of Zhechen Zhu's AMC toolbox 0.4
%
%   Update (version no.): modification (editor)

% Specify demo script setting
textDisp = 1; % if display text status
graphic = 1; % if give visual illustrations

% Define signal generation specifications
modulation = '16qam';
sampleNumber = 1024;

% Generate transmitted signal
signalT = genmodsig(modulation,sampleNumber);

% Transpose transmitted signal with given channel
SNR = 5; % signal-to-noise ratio (dB)
signalR = amcawgn(signalT,SNR); % AWGN channel

% Plot contellation of transmitted and received signal
if graphic == 1
    subplot(2,2,1);
    scatter(real(signalT),imag(signalT));
    title('Transmitted clear signal');
    subplot(2,2,2);
    scatter(real(signalR),imag(signalR));
    title('Received noisy signal');
end

% Maximum likelihood classifier
modulationPool = {'2pam' '4pam' '8pam' '2psk' '4psk' '8psk' '4qam' '16qam' '64qam'};
if textDisp
    fprintf('Automatic modulation classification in progress...\n\n')
    fprintf(['Testing modulation:\t' modulation '\n']);
    fprintf('Communication channel:\tAWGN \n');
    fprintf(['Signal-to-noise ratio:\t' int2str(SNR) ' dB\n\n']);
    fprintf('Classifier:\t\tMaximum Likelihood Classifier.\n\n')
end

[class likelihood]= amcml(signalR,modulationPool,SNR);
    
% Display a summary of classification results
if textDisp
    fprintf('Automatic modulation classification in completed.\n\n')
    fprintf(['Classified modulation:\t' class '\n'])
    fprintf('\n')
    if strcmp(modulation,class)
        fprintf('Automatic modulation classificall is successful!\n\n')
    else
        fprintf('Automatic modulation classificall has failed.\n\n')
    end
end

% Plot normalized likelihood from different hypotheses
if graphic == 1
subplot(2,2,[3 4]);
bar(likelihood-mean(likelihood))
title('Normalized likelihood from different hypotheses')
set(gca,'XTickLabel',modulationPool)
set(gcf, 'Position', [50 50 700 600])
end