% Part E

% Load the data from 'css.mat'
load('css.mat');  % Assuming the variable name is 'CSS'
% Load the data from 'path.mat'
load('path.mat');  % Assuming the variable name is 'path'

% Compute the impulse response
impulse_response = path;

num_taps = 128;
step_size = 0.25;
leakage = 1e-6;

% Initialization
filter_coeffs = zeros(1, num_taps);
X = css;
Xcc = [X X X X X X X X X X] ; 
echoPath = path ; 
output_signal = zeros(size(Xcc));
error_signal = zeros(size(Xcc));
echoSignal = conv(Xcc,echoPath,'same');

% NLMS algorithm
for n = num_taps:length(Xcc)
    x = Xcc(n:-1:n-num_taps+1);
    y = filter_coeffs * x.';
    e = echoSignal(n) - y;
    output_signal(n) = y;
    error_signal(n) = e; 
    filter_coeffs = filter_coeffs + (step_size / (norm(x)^2 + leakage)) * e * x;
    
end

% Calculate the sampling frequency
fs = 16000;  % Assuming a sampling frequency of 8000 Hz

% Calculate the frequency response of the estimated FIR channel
[h, w] = freqz(filter_coeffs, 1024);

% Calculate the frequency response of the given FIR system (Path)
[h_true, w_true] = freqz(impulse_response, 1024);

% Convert normalized frequency to normal frequency
f = w * (fs / (2*pi));
f_true = w_true * (fs / (2*pi));
magnitude_dB = 20*log10(abs(h_true));
dB2 = 20*log10(abs(h));

% Plot the amplitude response
figure('Position', [0, 0, 800, 400])
plot(f, dB2, 'LineWidth', 2, 'DisplayName', 'Estimated FIR Channel');
hold on;
plot(f_true,magnitude_dB , 'LineWidth', 2, 'DisplayName', 'True FIR Channel (Path)');
hold off;
xlabel('Frequency (Hz)');
ylabel('Amplitude (dB)');
title('Amplitude Response  (Dana, Amany, Shahd)');
legend;
grid on;

% Plot the phase response
figure('Position', [0, 0, 800, 400])
plot(f, angle(h), 'LineWidth', 2, 'DisplayName', 'Estimated FIR Channel');
hold on;
plot(f_true, angle(h_true), 'LineWidth', 2, 'DisplayName', 'True FIR Channel (Path)');
hold off;
xlabel('Frequency (Hz)');
ylabel('Phase (radians)');
title('Phase Response  (Dana, Amany, Shahd)');
legend;
grid on;
