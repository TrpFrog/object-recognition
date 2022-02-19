disp('alexnet');
test(alexnet, 'fc7', 4096);
disp('resnet101');
test(resnet101, 'pool5', 2048);
disp('googlenet');
test(googlenet, 'pool5-7x7_s1', 1024);
disp('vgg19');
test(vgg19, 'fc6', 4096);

function test(net, layer, dcnn_size)
    trp  = dcnn_matrix(get_img_fnames('trumpet'), net, layer, dcnn_size);
    trb  = dcnn_matrix(get_img_fnames('trombone'), net, layer, dcnn_size);
    frog = dcnn_matrix(get_img_fnames('frog'), net, layer, dcnn_size);
    leek = dcnn_matrix(get_img_fnames('leek'), net, layer, dcnn_size);

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
        [plabel, ~] = predict(model, eval_data);
        correct = sum(abs(plabel + eval_label)) / 2;
        ac = correct / length(eval_label);
    end
end
