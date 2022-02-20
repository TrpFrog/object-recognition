function print_top3_imgs(paths, score, is_correct)
%GET_TOP_IMGS 正解、不正解のそれぞれ上位3つの画像のパスを出力する
%   引数は画像パスのセル配列、スコアの行列、正解か不正解かの配列
    correct_score   = score(is_correct == true);
    incorrect_score = score(is_correct == false);

    correct_paths   = paths(is_correct == true);
    incorrect_paths = paths(is_correct == false);

    [correct_score,   correct_sorted_idx]   = sort(correct_score, 'descend');
    [incorrect_score, incorrect_sorted_idx] = sort(incorrect_score, 'descend');

    disp('  [Top correct images]');
    n = min(3, length(correct_paths));
    for i = 1:n
        fprintf('  %s %f\n', correct_paths{correct_sorted_idx(i)}, correct_score(i));
    end

    disp('  [Top incorrect images]');
    n = min(3, length(incorrect_paths));
    for i = 1:n
        fprintf('  %s %f\n', incorrect_paths{incorrect_sorted_idx(i)}, incorrect_score(i));
    end
end