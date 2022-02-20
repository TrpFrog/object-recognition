function five_fold_cross_validation(data, label, paths, f_learn, f_test) 
%FIVE_FOLD_CROSS_VALIDATION 5-fold cross validation をする関数
%   data:    使うデータ
%   label:   データに対応するラベル
%   paths:   元画像のファイルパス
%   f_learn: 学習用関数ハンドラ   (学習用データ、ラベル を受け取りモデルを返す)
%   f_test:  テスト用関数ハンドラ (テスト用データ、ラベル、モデル を受け取り分類率を返す)
%   戻り値はなし、分類率を出力する

    cv = 5;
    n = size(data, 1);
    idx = [1:n];
    accuracy = [];

    pti_paths = {};
    pti_scores = [];
    pti_is_correct = [];

    for i = 1 : cv
        train_label = label(mod(idx, cv) ~= (i - 1), :);
        train_data  =  data(mod(idx, cv) ~= (i - 1), :);
        eval_label  = label(mod(idx, cv) == (i - 1), :);
        eval_data   =  data(mod(idx, cv) == (i - 1), :);
        eval_paths  = paths(mod(idx, cv) == (i - 1));

        model = f_learn(train_data, train_label);
        [ac, scores, is_correct] = f_test(model, eval_data, eval_label);

        pti_paths = [pti_paths eval_paths];
        pti_is_correct = [pti_is_correct is_correct];
        pti_scores = [pti_scores scores];

        accuracy = [accuracy ac];
    end

    print_top3_imgs(pti_paths, pti_scores, pti_is_correct);

    fprintf('accuracy: %f\n',mean(accuracy))
end
