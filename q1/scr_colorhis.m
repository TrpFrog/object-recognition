trp  = colorhis_matrix(get_img_fnames('trumpet'));
trb  = colorhis_matrix(get_img_fnames('trombone'));
frog = colorhis_matrix(get_img_fnames('frog'));
leek = colorhis_matrix(get_img_fnames('leek'));

label = [zeros(100, 1); ones(100, 1)];

disp('[Trumpets and Trombones]');
five_fold_cross_validation([trp; trb], label, @f_learn, @f_test);

disp('[Frogs and Leeks]')
five_fold_cross_validation([frog; leek], label, @f_learn, @f_test);

% モデル学習用関数
function model = f_learn(train_data, train_label)
    % 最近傍分類では学習データとラベルをそのままモデルとして返している
    % これらは判定用関数 f_test でそのまま用いられる
    model = {train_data, train_label};
end

% テスト用関数
function ac = f_test(model, eval_data, eval_label)
    train_data = model{1};
    train_label = model{2};

    n = size(eval_data, 1);
    ac = 0;
    for i = 1:n
        % 学習データの中でも最も近いベクトルのindexをもらう
        idx = nearest_vec(train_data, eval_data(i, :));

        % ラベルが同じならば正解
        if train_label(idx) == eval_label(i)
            ac = ac + 1;
        end
    end

    % テストデータ数で割る
    ac = ac / n;
end
