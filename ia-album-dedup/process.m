clear all

if ~isempty(getenv('GITHUB_ACTION'))
    system('sudo apt install -y libjpeg tesseract-ocr')
    system('sudo pip3 install internetarchive')
    system('./download.sh')
end

mkdir pairs

F = dir('*.txt');
T = {};

for f=1:numel(F)
    t = loadText(F(f).name);
    T{f} = t;
end

% Create a list of documents which matlab can work with
docs = tokenizedDocument(T);
docs = removeStopWords(docs);
docs = normalizeWords(docs, 'Style', 'lemma');
docs = erasePunctuation(docs);

% we can improve sensitivity by removing common n-grams
for l=6:-1:3
    ng = bagOfNgrams(docs, 'NGramLength', l);
    top_ng = topkngrams(ng, 20, 'IgnoreCase', true);
    top_ng = top_ng(top_ng.Count > 5,:);
    top_ng = top_ng.Ngram;

    repl_ng = top_ng;
    repl_ng(:) = "";

    docs = replaceNgrams(docs, top_ng, repl_ng);
end

% We can also remove short n-grams which appear very frequently,
% e.g. RCA Victor, Columbia, etc.
ng = bagOfNgrams(docs, 'NGramLength', 2);
top_ng = topkngrams(ng, 100, 'IgnoreCase', true);
top_ng = top_ng(top_ng.Count > 20,:);
top_ng = top_ng.Ngram;
repl_ng = top_ng;
repl_ng(:) = "";
docs = replaceNgrams(docs, top_ng, repl_ng);

similarity = bm25Similarity(docs);
similarity = similarity - diag(diag(similarity));

similarity2 = cosineSimilarity(docs);

[a,b,s] = find(triu(similarity) > 50 & triu(similarity2) > 0.50);

for i=1:numel(a)
    score = full(similarity(a(i),b(i)));
    score2 = full(similarity2(a(i),b(i)));

    disp('MATCH')
    disp([score score2])
    disp(T(a(i)))
    disp(T(b(i)))
    disp('')

    Ia = imread(F(a(i)).name(1:end-4));
    Ib = imread(F(b(i)).name(1:end-4));

    Ia = imresize(Ia, [768 768]);
    Ib = imresize(Ib, [768 768]);

    imwrite([Ia Ib], sprintf('pairs/%0.2f_%0.6f___%i_%i.jpg', score, score2, a(i), b(i)));
end


function t = loadText(fname)
    fid = fopen(fname, 'r');
    t = fread(fid, 'char');

    % Replace new lines with spaces to avoid these appearing as separate documents.
    t(t==10) = char(32);
    t = string(char(t)');

    fclose(fid);
end