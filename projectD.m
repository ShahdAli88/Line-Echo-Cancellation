%Part D

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

% Plot the far-end signal, the echo, and the error signal
figure;
subplot(2, 1, 1);
plot(Xcc);
xlabel('sample');
ylabel('Amplitude');
title('Far-End Signal');
grid on;

subplot(2, 1, 2);
plot(output_signal);
xlabel('sample');
ylabel('Amplitude');
title('Echo after NLMS ');
grid on;

%subplot(3, 1, 3);
%plot(error_signal);
%xlabel('Sample');
%ylabel('Amplitude');
%title('Error Signal');
%grid on;


%plot of Echo Path vs Estimated Echo Path
sgtitle('Echo Cancellation Results (Dana, Amany, Shahd)');

figure;
plot(impulse_response, 'DisplayName', 'True Echo Path');
hold on;
plot(filter_coeffs, 'DisplayName', 'Estimated Echo Path');
hold off;
xlabel('Tap');
ylabel('Amplitude');
title('Echo Path vs Estimated Echo Path (Dana,Amany,Shahd)');
legend;
grid on;