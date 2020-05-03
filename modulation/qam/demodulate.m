function [a,b,rx_a,rx_b] = demodulate(rx, symRate, F, fs, phaseShift)
% rx is a signal which has been modulated with QAM256 with a symbol
% rate of symRate on a carry of F at a sample rate of fs.
%
% rx_a and rx_b are also returned, which are I and Q after a lowpass
% filter has been applied. These can be plotted against eachother to
% produce a constellation diagram.
%
% You can adjust the phase of the local oscilator with phaseShift.

time = numel(rx) / fs;
time = 2*pi*F*(0:(1/fs):time+(1/fs));
time = time(1:numel(rx));
time = time + phaseShift;

I = 2 * sin(time) .* rx;
Q = 2 * cos(time) .* rx;

rx_a = lowpass(I, symRate, fs);
rx_b = lowpass(Q, symRate, fs);

lower = fs/symRate/2;
inc = fs/symRate;
upper = numel(time)-lower;

query = round(lower:inc:upper);

a = rx_a(query);
b = rx_b(query);
