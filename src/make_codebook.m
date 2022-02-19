function make_codebook(fnames, codebook_name_str)
% MAKE_CODEBOOK コードブックを作成する関数
%   画像のパスが入ったセル配列を受け取り、
%   画像からSURF特徴量を用いてBoFベクトルを作り
%   コードブックを作成する

    Features=[];
    for i = 1:length(fnames)
        disp(fnames{i});
        I = imread(fnames{i});
        I = good_resize(I);
        I = rgb2gray(I);
        p = createRandomPoints(I, 1000);
        [f, ~] = extractFeatures(I,p);
        Features = [Features; f];
    end

    disp('kmeans clustering...')
    [~, codebook] = kmeans(Features, 1000);
    save(strcat(codebook_name_str, '.mat'), 'codebook');
end
