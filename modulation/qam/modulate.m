function [tx] = modulate (a, b, symRate, F, fs)
% This function returns a QAM256 signal with an I from a and Q from b,
% at a symbol rate of symRate, at frequency F sampled at fs.

assert(numel(a) == numel(b), 'a and b must be of equal length')

time = numel(a) / symRate;
time = 2*pi*F*(0:(1/fs):time+(1/fs));

sigA = imresize(a, [numel(time), 1]', 'nearest')';
sigB = imresize(b, [numel(time), 1]', 'nearest')';

I = sin(time) .* sigA;
Q = cos(time) .* sigB;

tx = I + Q;

