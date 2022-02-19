function bof = bof_matrix(paths, codebook)
%BOF_MATRIX 画像のパスが含まれたセル配列を受け取り、各行がBoFベクトルになっている行列を返す
    n = length(paths);
    bof = zeros(n, 1000);
    for i = 1:n
        disp(strcat(string(i), '/', string(n), ': ', paths{i}));
        I = imread(paths{i});
        I = good_resize(I);
        I = rgb2gray(I);
        p = createRandomPoints(I,3000);
        [f,p2] = extractFeatures(I,p);
        for j = 1:size(p2, 1)
            res = nearest_vec(codebook, f(j, :));
            bof(i, res) = bof(i, res) + 1; 
        end
    end
    bof = bof ./ sum(bof,2); 
end
