function fnlist = get_img_fnames(target)
%GET_IMGS_FNAMES 指定したフォルダの画像を取得
%   例えば get_img_fnames('trumpet') ならば
%   トランペットの画像フォルダ内に含まれる画像のパスのセル配列を返す
    fnlist = {};
    DIR = strcat('img/',target,'/');
    W = dir(DIR);

    for j=1:size(W)
        if (strfind(W(j).name,'.jpg'))
            fn=strcat(DIR,W(j).name);
            fnlist = [fnlist(:)' {fn}];
        end
    end
end
