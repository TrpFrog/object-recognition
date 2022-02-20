trp_paths  = get_img_fnames('trumpet');
trb_paths  = get_img_fnames('trombone');
frog_paths = get_img_fnames('frog');
leek_paths = get_img_fnames('leek');

disp('Generating BoF matrix of trumpets and trombones...');
load('codebook_tptb.mat');
trp_mat = bof_matrix(trp_paths, codebook);
trb_mat = bof_matrix(trb_paths, codebook);

disp('Generating BoF matrix of frogs and leeks...');
load('codebook_frle.mat');
frog_mat = bof_matrix(frog_paths, codebook);
leek_mat = bof_matrix(leek_paths, codebook);

label = [-ones(100, 1); ones(100, 1)];

disp('[Trumpets and Trombones]');
five_fold_cross_validation([trp_mat; trb_mat], label, [trp_paths, trb_paths], @f_learn, @f_test);

disp('[Frogs and Leeks]')
five_fold_cross_validation([frog_mat; leek_mat], label, [frog_paths, leek_paths], @f_learn, @f_test);

% モデル学習用関数
function model = f_learn(train_data, train_label)
    model = fitcsvm(train_data, train_label, 'KernelFunction', 'rbf', 'KernelScale', 'auto');
end

% テスト用関数
function [ac, scores, is_correct] = f_test(model, eval_data, eval_label)
    n = size(eval_data, 1);
    [plabel, scores] = predict(model, eval_data);

    % label は 1 か -1 かのどちらかである。
    % もし分類が正しければ plabel と eval_label はそれぞれ 1 と 1, または -1 と -1 になるはずであり、
    % 誤りならば 1 と -1 となるはずである。
    % すなわち2つのベクトルの和の各要素は、正解ならば 2 か -2、不正解ならば 0 となる。
    % よって「(plabel + eval_label) / 2 の絶対値の和」が「正しく分類された数」となる。
    is_correct = abs(plabel + eval_label) / 2;
    ac = sum(is_correct) / n;
end
