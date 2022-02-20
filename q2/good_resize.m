function img = good_resize(img)
%GOOD_RESIZE いい感じにリサイズする関数
%   画素数がなるべく 320 * 240 に近くなるようにリサイズする

    [H, W, ~] = size(img);

    goal = 320 * 240;
    h = sqrt(H / W * goal);
    w = sqrt(W / H * goal);

    hs = [floor(h) floor(h) ceil(h) ceil(h)];
    ws = [floor(w) ceil(w) floor(w) ceil(w)];

    h = 0;
    w = 0;
    for i = 1:4
        if abs(h * w - goal) > abs(hs(i) * ws(i) - goal)
            h = hs(i);
            w = ws(i);
        end
    end
    
    img = imresize(img, [h, w]);
end
