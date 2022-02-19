function mat = colorhis_matrix(paths)
%COLORHIS_MATRIX ファイルパスのセル配列から 64色カラーヒストグラムの行列を作る
    mat = zeros(size(paths, 2), 64);
    for i = 1:size(paths, 2)
        path = paths{i};
        I = good_resize(imread(path));
        mat(i, :) = color_hisgram(I);
    end
end
