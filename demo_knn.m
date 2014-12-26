%%DEMO_KNN   Demonstrates program to show examples simulated communication
%%signal and the classificaition of modulation classifiers using the
%%l-nearest neighbour classifier
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

% Extracting high-order cumulant features
cumI = cumulant(real(signalR));
cumQ = cumulant(imag(signalR));

% Define modulation candidates
modulationPool = {'2pam' '4pam' '8pam' '2psk' '4psk' '8psk' '4qam' '16qam' '64qam'};

% Generate reference features for each modulation candidate
for iModulationCandidate = 1:numel(modulationPool)
    
    % Select modulation candidate
    modulationCandidate = modulationPool{iModulationCandidate};
    
    % Generate reference signals and features
    for iRef = 1:30
        refSignal = genmodsig(modulationCandidate,length(signalR));
        refSignal=amcawgn(refSignal,SNR);
        refCumI(iRef+(iModulationCandidate-1)*30,:) = cumulant(real(refSignal));
        refCumQ(iRef+(iModulationCandidate-1)*30,:) = cumulant(imag(refSignal));
    end
    
    % create label for the referenc feature sets
    label((iModulationCandidate-1)*30+1:(iModulationCandidate-1)*30+30,1)=iModulationCandidate;
end

% K-nearest neighbour classifier
if textDisp
    fprintf('Automatic modulation classification in progress...\n\n')
    fprintf(['Testing modulation:\t' modulation '\n']);
    fprintf('Communication channel:\tAWGN \n');
    fprintf(['Signal-to-noise ratio:\t' int2str(SNR) ' dB\n\n']);
    fprintf('Classifier:\t\tK-nearest Neighbour Classifier.\n\n')
end
[class, neighbours] = amcknn(modulationPool,[cumI cumQ],[refCumI refCumQ],label);

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
bar(neighbours)
title('Number of neghbour reference samples from different hypotheses')
set(gca,'XTickLabel',modulationPool)
set(gcf, 'Position', [50 50 700 600])
end