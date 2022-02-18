function five_fold_cross_validation(data, label, f_learn, f_test) 
%FIVE_FOLD_CROSS_VALIDATION 5-fold cross validation をする関数
%   data:    使うデータ
%   label:   データに対応するラベル
%   f_learn: 学習用関数ハンドラ   (学習用データ、ラベル を受け取りモデルを返す)
%   f_test:  テスト用関数ハンドラ (テスト用データ、ラベル、モデル を受け取り分類率を返す)
%   戻り値はなし、分類率を出力する

    cv = 5;
    n = length(imgs);
    idx = [1:n];
    accuracy = [];
    for i = 1 : cv
        train_label = label(mod(idx, cv) ~= (i - 1), :);
        train_data = data(mod(idx, cv) ~= (i - 1), :);
        eval_label = label(mod(idx, cv) == (i - 1), :);
        eval_data = data(mod(idx, cv) == (i - 1), :);
        model = f_learn(train_label, train_data);
        ac = f_test(model, eval_label, eval_data);
        accuracy = [accuracy ac];
    end

    fprintf('accuracy: %f\n',mean(accuracy))
end
