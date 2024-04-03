%PART c
% Load the data from 'css.mat'
load('css.mat');  % Assuming the variable name is 'CSS'
load('path.mat');

X = css;
Xc = [X X X X X] ; 
%Xc = repmat(X, 1, 5);
echoPath = path ; 
echoSignal = conv(Xc,echoPath,'same');
plot(echoSignal);
title('echo signal  (Dana, Amany, Shahd)');
xlabel('Time');
ylabel('Amplitude');


% Calculate the length of the input signal sequence
N = length(Xc);

% Calculate the power of the input signal Xc
power_Xc = 10 * log10((1 / N) * sum(Xc.^2));

% Display the result
disp(['power of input signal Xc: ' num2str(power_Xc)]);


% Calculate the length of the output signal sequence
S = length(echoSignal);

% Calculate the power of the output echo signal 
power_echo = 10 * log10((1 / S) * sum(echoSignal.^2));

% Display the result
disp(['power of output echo signal: ' num2str(power_echo)]);

ERL =  power_Xc - power_echo;
disp(['echo-return-loss (ERL):  ' num2str(ERL) ]);

 

