net = alexnet;
layer = 'fc7';
dcnn_size = 4096;

% Learn
tlights = dcnn_matrix(get_img_fnames('traffic_lights'), net, layer, dcnn_size);
bgimg   = dcnn_matrix(get_img_fnames('bgimg'), net, layer, dcnn_size);


for n = [25 50]
    fprintf('\n[n = %d]\n', n);

    label = [ones(n, 1); -ones(1000, 1)];
    dcnn_mat = [tlights(1:n, :); bgimg];
    
    model = fitcsvm(dcnn_mat, label, 'KernelFunction', 'linear');
    
    % Test
    test_fnames = get_img_fnames('traffic_lights_test');
    test_mat = dcnn_matrix(test_fnames, net, layer, dcnn_size);
    
    [plabel, pscore] = predict(model, test_mat);
    [sorted_score, sorted_idx] = sort(pscore(:,2),'descend');

    FID = fopen(strcat('result', string(n), '.txt'), 'w');
    for i=1:numel(sorted_idx)
        fprintf('%s %f\n', test_fnames{sorted_idx(i)}, sorted_score(i));
        fprintf(FID,'%s %.5f\n', test_fnames{sorted_idx(i)}, sorted_score(i));
    end
    fclose(FID);
end
