output = [];

num = strsplit(num2str(9:-1:0));
op = {'+', '-', '*', '/'};

numop = { num{:} op{:} };
numopeq = { numop{:} '=' };
numeq = { '=' num{:} };

valid = { num, numop, numop, numop, numopeq, numopeq, numeq, num }

D = cellfun(@numel, valid);
for i=1:prod(D)
    [a,b,c,d,e,f,g,h] = ind2sub(D, i);

    s = [valid{1}{a} valid{2}{b} valid{3}{c} valid{4}{d} ...
         valid{5}{e} valid{6}{f} valid{7}{g} valid{8}{h} ];

    if sum(s == '=') != 1, continue, end

    d = ismember(s, [op{:} '=']);
    if sum(d) == 0 || any(d & circshift(d,1)), continue, end

    if eval(strrep(s, '=', '=='))
        disp(s)
        output = [ output ; s ];
        disp(i/prod(D) * 100)
    end
end


save('nerdle_output.mat', 'output')