function img = good_resize(img)
%GOOD_RESIZE いい感じにリサイズする関数
%   画素数がなるべく 320 * 240 に近くなるようにリサイズする

    [H, W, ~] = size(img);

    goal = 320 * 240;
    h = round(sqrt(H / W * goal));
    w = round(sqrt(W / H * goal));
    
    img = imresize(img, [h, w]);
end
