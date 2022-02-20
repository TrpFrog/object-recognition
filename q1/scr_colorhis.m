trp_paths  = get_img_fnames('trumpet');
trb_paths  = get_img_fnames('trombone');
frog_paths = get_img_fnames('frog');
leek_paths = get_img_fnames('leek');

trp_mat = colorhis_matrix(trp_paths);
trb_mat = colorhis_matrix(trb_paths);
frog_mat = colorhis_matrix(frog_paths);
leek_mat = colorhis_matrix(leek_paths);

label = [zeros(100, 1); ones(100, 1)];

disp('[Trumpets and Trombones]');
five_fold_cross_validation([trp_mat; trb_mat], label, [trp_paths, trb_paths], @f_learn, @f_test);

disp('[Frogs and Leeks]')
five_fold_cross_validation([frog_mat; leek_mat], label, [frog_paths, leek_paths], @f_learn, @f_test);

% モデル学習用関数
function model = f_learn(train_data, train_label)
    % 最近傍分類では学習データとラベルをそのままモデルとして返している
    % これらは判定用関数 f_test でそのまま用いられる
    model = {train_data, train_label};
end

% テスト用関数
function [ac, scores, is_correct] = f_test(model, eval_data, eval_label)
    train_data = model{1};
    train_label = model{2};

    scores = zeros(length(eval_label), 1);
    is_correct = false(length(eval_label), 1);

    n = size(eval_data, 1);
    ac = 0;
    for i = 1:n
        % 学習データの中でも最も近いベクトルのindexをもらう
        [scores(i), idx] = nearest_vec(train_data, eval_data(i, :));
        
        % ラベルが同じならば正解
        if train_label(idx) == eval_label(i)
            ac = ac + 1;
            is_correct(i) = true;
        end
    end

    % テストデータ数で割る
    ac = ac / n;
end
