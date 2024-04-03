% part B
% Load the data from 'css.mat'
load('css.mat');  % Assuming the variable name is 'CSS'

% Extract the CSS samples
CSS_samples = css;

% Compute the Power Spectrum Density (PSD)
fs = 8000;  % Sampling frequency (replace with the actual sampling frequency)
psd = pwelch(CSS_samples, [], [], [], fs);

% Plotting the CSS samples
subplot(2, 1, 1);
plot(CSS_samples);
title('CSS Data');
xlabel('Sample');
ylabel('Amplitude');

% Plotting the Power Spectrum Density (PSD)
subplot(2, 1, 2);
freq_axis = linspace(0, fs/2, numel(psd));
plot(freq_axis, 10*log10(psd)+40);
title('Power Spectrum Density (PSD)');
xlabel('Frequency (Hz)');
ylabel('Power (dB)');
grid on;

% Adjusting the plot layout
sgtitle('CSS Data and Power Spectrum Density  (Dana, Amany, Shahd)');
