coutput = num2cell(output, 2);

% zero prefixed
zp = @(a) numel(a) > 1 && a(1) == '0';

% contains zero prefixed
czp = @(a) any(cellfun(zp, strsplit(a, {op{:} '='})));

oczp = cellfun(czp, coutput);

output(oczp,:) = [];

size(output)

save('filter_output.mat', 'output')