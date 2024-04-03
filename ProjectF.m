%Part F

% Load the data from 'css.mat'
load('css.mat');  % Assuming the variable name is 'CSS'
load('path.mat');
% Load the data from 'path.mat'
load('path.mat');  % Assuming the variable name is 'path'

% Compute the impulse response
impulse_response = path;

num_taps = 128;
step_size = 0.25;
leakage = 1e-6;

% Initialization
filter_coeffs_nlms = zeros(1, num_taps);
filter_coeffs_sslms = zeros(1, num_taps);
X = css;
Xcc = repmat(X, 1, 10); % Concatenate the speech signal 10 times
echoPath = path;
output_signal_nlms = zeros(size(Xcc));
output_signal_sslms = zeros(size(Xcc));
error_signal_nlms = zeros(size(Xcc));
error_signal_sslms = zeros(size(Xcc));
echoSignal = conv(Xcc, echoPath, 'same');

% NLMS algorithm
for n = num_taps:length(Xcc)
    x = Xcc(n:-1:n-num_taps+1);
    y_nlms = filter_coeffs_nlms * x.';
    e_nlms = echoSignal(n) - y_nlms;
    output_signal_nlms(n) = y_nlms;
    error_signal_nlms(n) = e_nlms;
    filter_coeffs_nlms = filter_coeffs_nlms + (step_size / (norm(x)^2 + leakage)) * e_nlms * x;
    
    % SSLMS algorithm
    y_sslms = filter_coeffs_sslms * sign(x).';
    e_sslms = echoSignal(n) - y_sslms;
    output_signal_sslms(n) = y_sslms;
    error_signal_sslms(n) = e_sslms;
 filter_coeffs_sslms = filter_coeffs_sslms + (step_size / (norm(x)^2 + leakage)) * sign(e_sslms) * x;
end

% Plot the far-end signal, the echo, and the error signal
figure;
subplot(2, 1, 1);
plot(Xcc);
xlabel('sample');
ylabel('Amplitude');
title('Far-End Signal');
grid on;

subplot(2, 1, 2);
plot(echoSignal);
xlabel('sample');
ylabel('Amplitude');
title('Echo');
grid on;
%plot of Echo Path vs Estimated Echo Path
sgtitle('Echo Cancellation Results (Dana, Amany, Shahd)');

figure;
plot(impulse_response, 'DisplayName', 'True Echo Path');
hold on;
plot(filter_coeffs_nlms, 'DisplayName', 'Estimated Echo Path (NLMS)');
plot(filter_coeffs_sslms, 'DisplayName', 'Estimated Echo Path (SSLMS)');
hold off;
xlabel('Tap');
ylabel('Amplitude');
title('Echo Path vs Estimated Echo Path  (Dana, Amany, Shahd)');
legend;
grid on;

% Plot the error signals
figure;
plot(error_signal_nlms, 'DisplayName', 'NLMS');
hold on;
plot(error_signal_sslms, 'DisplayName', 'SSLMS');
hold off;
title('Error Signal  (Dana, Amany, Shhd)');
xlabel('Sample Index (n)');
ylabel('Amplitude');
legend;