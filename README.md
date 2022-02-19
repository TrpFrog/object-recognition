# Object Recognition Final Assignment



## これは何

物体認識論の最終課題に使用したリポジトリです。



## 動かし方

- `.dl_images.sh` を叩く
- img フォルダの中身から人力で不適切なものを取り除く
    - 画像が壊れてるのか MATLAB が読んでくれないやつもあった (つらい)



## 関数

### 共通

- `get_img_fnames`
    - 引数で `X` を指定すると `img/X`  内の画像のファイルパスのセル配列が返ってくる
- `good_resize`
    - 画像を渡すと `320 * 240` 画素に近くなるようにアスペクト比を崩さずリサイズしてくれる
- `nearest_vec`
    - 行列 M と行ベクトル v を渡すと、M 中で最も v にユークリッド距離が近い行ベクトル M_i の index を返す
- `five_fold_cross_validation`
    - データ、ラベル、学習用関数ハンドラ、テスト用関数ハンドラを渡すと 5-fold cross-validation をしてくれる



### カラーヒストグラム関係

- `color_hisgram`
    - 与えられた画像から 64 色カラーヒストグラムを作る
- `colorhis_matrix`
    - 与えられたファイルパス入りのセル配列から、各行が 64 色カラーヒストグラムになっている行列を返す



### BoF ベクトル + SVM 関係

- `make_codebook`
    - ランダムな点からコードブックを作成する
    - 戻り値なし、指定した名前のコードブックがファイルとして出力される
    - `make_codebook({trp{:}; trb{:}}, 'codebook_tptb');` のように呼び出す
    - コードブックサイズ: 1000
- `bof_matrix`
    - `colorhis_matrix` の BoF版
    - 与えられたファイルパス入りのセル配列から、各行が BoFベクトルになっている行列を返す
    - ただし codebook も引数として渡す必要がある
- `createRandomPoints`
    - dense sampling をする





## スクリプト

### scr_colorhis.m

カラーヒストグラムによる分類を行う。

```
[Trumpets and Trombones]
accuracy: 0.790000
[Frogs and Leeks]
accuracy: 0.730000
```



### scr_codebook.m

`make_codebook` を叩いてコードブックを作る。



### scr_bof.m

BoFベクトル + 非線形SVM による分類を行う。

```
[Trumpets and Trombones]
accuracy: 0.770000
[Frogs and Leeks]
accuracy: 0.920000
```

