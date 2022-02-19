disp('Generating BoF matrix of trumpets and trombones...');
load('codebook_tptb.mat');
trp  = bof_matrix(get_img_fnames('trumpet'), codebook);
trb  = bof_matrix(get_img_fnames('trombone'),codebook);

disp('Generating BoF matrix of frogs and leeks...');
load('codebook_frle.mat');
frog = bof_matrix(get_img_fnames('frog'), codebook);
leek = bof_matrix(get_img_fnames('leek'), codebook);

label = [-ones(100, 1); ones(100, 1)];

disp('[Trumpets and Trombones]');
five_fold_cross_validation([trp; trb], label, @f_learn, @f_test);

disp('[Frogs and Leeks]')
five_fold_cross_validation([frog; leek], label, @f_learn, @f_test);

% モデル学習用関数
function model = f_learn(train_data, train_label)
    model = fitcsvm(train_data, train_label, 'KernelFunction', 'rbf', 'KernelScale', 'auto');
end

% テスト用関数
function ac = f_test(model, eval_data, eval_label)
    n = size(eval_data, 1);
    [plabel, ~] = predict(model, eval_data);

    % label は 1 か -1 かのどちらかである。
    % もし分類が正しければ plabel と eval_label はそれぞれ 1 と 1, または -1 と -1 になるはずであり、
    % 誤りならば 1 と -1 となるはずである。
    % すなわち2つのベクトルの和の各要素は、正解ならば 2 か -2、不正解ならば 0 となる。
    % よって「(plabel + eval_label) / 2 の絶対値の和」が「正しく分類された数」となる。
    ac = sum(abs(plabel + eval_label)) / 2;
    ac = ac / n;
end
