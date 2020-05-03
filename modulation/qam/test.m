clear all
close all

freq = 1e3;
sample_rate = 16e3;
symbol_rate = 100;

phrase = 'Hello from Matlab.';

phrase_bin = dec2bin(phrase, 8);
a = bin2dec(phrase_bin(:,1:4))-8;
b = bin2dec(phrase_bin(:,5:8))-8;

tx = modulate(a, b, symbol_rate, freq, sample_rate);

rx = awgn(tx, 6);

[a,b,I,Q] = demodulate(rx, symbol_rate, freq, sample_rate, 0);

a = round(a + 8); b = round(b + 8);
a = min(max(0, a), 15); b = min(max(0, b), 15);

rx_phrase = [dec2bin(a) dec2bin(b)];
disp(char(bin2dec(rx_phrase))')

% Constellation diagram of QAM256.
figure
plot(I, Q)
set(gca, 'Position', [0 0 1 1])
axis([-9 9 -9 9])
axis square

