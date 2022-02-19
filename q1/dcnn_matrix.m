function mat = dcnn_matrix(paths, net, layer, dcnn_size)
%DCNN_MATRIX DCNN特徴量の行列を作る関数
%   画像のパスが含まれたセル配列を受け取り、各行がDCNN特徴量のベクトルになっている行列を返す

    f = waitbar(0,'Please wait...');

    mat = zeros(length(paths), dcnn_size);
    for i = 1:length(paths)
        waitbar(i/length(paths),f,strcat('Loading, ', paths{i}, '...'));
        I = imread(paths{i});
        I = good_resize(I);
        reimg = imresize(I, net.Layers(1).InputSize(1:2));
        dcnnf = activations(net,reimg,layer);
        dcnnf = squeeze(dcnnf);
        mat(i, :) = dcnnf/norm(dcnnf);
    end

    close(f)
end
