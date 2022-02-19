function idx = nearest_vec(mat, vec)
%NEAREST_VEC 行列 mat の行ベクトルの中で vec と最も近いもののindexを返す
    n = size(mat, 1);
    mat = mat - repmat(vec, n, 1);
    [~, idx] = min(sum(mat.^2, 2)); % a^2 <= b^2 ならば |a| <= |b|
end
