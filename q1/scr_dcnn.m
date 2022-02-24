disp('alexnet');
test(alexnet, 'fc7', 4096);
disp('resnet101');
test(resnet101, 'pool5', 2048);
disp('googlenet');
test(googlenet, 'pool5-7x7_s1', 1024);
disp('vgg19');
test(vgg19, 'fc6', 4096);

function test(net, layer, dcnn_size)
    trp_paths  = get_img_fnames('trumpet');
    trb_paths  = get_img_fnames('trombone');
    frog_paths = get_img_fnames('frog');
    leek_paths = get_img_fnames('leek');
    
    trp_mat = dcnn_matrix(trp_paths, net, layer, dcnn_size);
    trb_mat = dcnn_matrix(trb_paths, net, layer, dcnn_size);
    frog_mat = dcnn_matrix(frog_paths, net, layer, dcnn_size);
    leek_mat = dcnn_matrix(leek_paths, net, layer, dcnn_size);

    label = [-ones(100, 1); ones(100, 1)];

    disp('[Trumpets and Trombones]');
    matrix = [trp_mat; trb_mat];
    paths = [trp_paths, trb_paths];
    disp('------------- Linear SVM -------------');
    five_fold_cross_validation(matrix, label, paths, @f_learn_linear, @f_test);
    disp('--------------------------------------');
    disp('----------- Non-linear SVM -----------');
    five_fold_cross_validation(matrix, label, paths, @f_learn_rbf, @f_test);
    disp('--------------------------------------');
    fprintf('\n');
    
    disp('[Frogs and Leeks]')
    matrix = [frog_mat; leek_mat];
    paths = [frog_paths, leek_paths];
    disp('------------- Linear SVM -------------');
    five_fold_cross_validation(matrix, label, paths, @f_learn_linear, @f_test);
    disp('--------------------------------------');
    disp('----------- Non-linear SVM -----------');
    five_fold_cross_validation(matrix, label, paths, @f_learn_rbf, @f_test);
    disp('--------------------------------------');
    fprintf('\n');

    % モデル学習用関数 (線形SVM)
    function model = f_learn_linear(train_data, train_label)
        model = fitcsvm(train_data, train_label,'KernelFunction','linear');
    end

    % モデル学習用関数 (非線形SVM)
    function model = f_learn_rbf(train_data, train_label)
        model = fitcsvm(train_data, train_label, 'KernelFunction', 'rbf', 'KernelScale', 'auto');
    end
    
    % テスト用関数
    function [ac, scores, is_correct] = f_test(model, eval_data, eval_label) 
        [plabel, scores] = predict(model, eval_data);
        is_correct = abs(plabel + eval_label) / 2;

        scores = abs(scores(:,2));
        ac = sum(is_correct) / length(eval_label);
    end
end
