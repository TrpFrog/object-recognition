function res = color_hisgram(fig)
%COLOR_HISGRAM 64色カラーヒストグラムを作る関数
%   詳細説明をここに記述

    % 64色に減色
    RED = fig(:,:,1); GREEN = fig(:,:,2); BLUE = fig(:,:,3);
    reduced = uint8(floor(double(RED)/64) * 4 * 4 ...
        + floor(double(GREEN)/64) * 4 + floor(double(BLUE)/64));

    % ヒストグラムを作成
    res = zeros(1, 64);
    n = size(reduced, 1) * size(reduced, 2);
    for i = 1 : n
        color = reduced(i) + 1; % 1-indexed
        res(color) = res(color) + 1;
    end
end

