%Part A
% Load the data from 'path.mat'
load('path.mat');  % Assuming the variable name is 'path'

% Compute the impulse response
impulse_response = path;

% Compute the frequency response using freqz
fs = 8000;  % Sampling frequency (replace with your actual sampling frequency)
frequency_response = freqz(impulse_response, 1, [], fs);

% Compute the corresponding frequency axis
frequency_axis = linspace(0, fs/2, numel(frequency_response));
%The linspace function is then used to generate the frequency axis from 0 Hz to the Nyquist frequency (fs/2)
% numel(frequency_response) to determine the length of the frequency axis

% Convert magnitude to dB
magnitude_dB = 20*log10(abs(frequency_response));

% Plotting the impulse response
subplot(2, 1, 1);
plot(impulse_response);
title('Impulse Response');
xlabel('Sample');
ylabel('Amplitude');

% Plotting the frequency response in dB
subplot(2, 1, 2);
plot(frequency_axis, magnitude_dB);
title('Magnitude Frequency Response');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
grid on;

% Adjusting the plot layout
sgtitle('Echo Path Response (Dana, Amany, Shahd)');