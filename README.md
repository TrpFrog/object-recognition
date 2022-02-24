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
- `print_top3_imgs`
    - 5-fold cross validation の結果を受け取り、スコアでソート、正解の中のスコアトップ3 と 不正解の中のスコアトップ3 を出力する
    



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



### DCNN特徴量 + SVM 関係

- `dcnn_matrix`
    - `colorhis_matrix` の DCNN 特徴量版
    - 画像のパスのセル配列、ネットワーク、レイヤ、サイズを渡す



## スクリプト

### scr_colorhis.m

カラーヒストグラムによる分類を行う。

```
[Trumpets and Trombones]
  [Top correct images]
  img/trumpet/000005.jpg -0.000000
  img/trumpet/000010.jpg -0.000000
  img/trumpet/000033.jpg -0.000000
  [Top incorrect images]
  img/trombone/000010.jpg -1707.011131
  img/trumpet/000050.jpg -1707.011131
  img/trumpet/000041.jpg -1929.702568
accuracy: 0.750000

[Frogs and Leeks]
  [Top correct images]
  img/leek/000002.jpg -120.024997
  img/leek/000059.jpg -120.024997
  img/leek/000073.jpg -3245.846885
  [Top incorrect images]
  img/frog/000071.jpg -7799.208934
  img/frog/000034.jpg -8544.003979
  img/leek/000087.jpg -8762.108650
accuracy: 0.730000
```



### scr_codebook.m

`make_codebook` を叩いてコードブックを作る。



### scr_bof.m

BoFベクトル + 非線形SVM による分類を行う。

```
[Trumpets and Trombones]
  [Top correct images]
  img/trumpet/000109.jpg 1.045216
  img/trombone/000109.jpg 0.991987
  img/trumpet/000058.jpg 0.979795
  [Top incorrect images]
  img/trombone/000024.jpg 0.785272
  img/trombone/000013.jpg 0.769484
  img/trumpet/000051.jpg 0.723784
accuracy: 0.810000

[Frogs and Leeks]
  [Top correct images]
  img/leek/000004.jpg 1.582948
  img/leek/000017.jpg 1.539405
  img/leek/000026.jpg 1.451947
  [Top incorrect images]
  img/leek/000067.jpg 0.791777
  img/frog/000010.jpg 0.761106
  img/frog/000099.jpg 0.703192
accuracy: 0.915000
```



### scr_dcnn.m

「alexnet, resnet101, googlenet, vgg19 によるDCNN特徴ベクトル + 線形SVM, 非線形SVM」 による画像分類を行う。

```
alexnet
[Trumpets and Trombones]
------------- Linear SVM -------------
  [Top correct images]
  img/trombone/000082.jpg 2.076298
  img/trombone/000004.jpg 1.854511
  img/trumpet/000013.jpg 1.699343
  [Top incorrect images]
  img/trombone/000041.jpg 1.049238
  img/trombone/000027.jpg 0.934369
  img/trombone/000047.jpg 0.914957
accuracy: 0.900000
--------------------------------------
----------- Non-linear SVM -----------
  [Top correct images]
  img/trumpet/000052.jpg 1.475181
  img/trombone/000004.jpg 1.432469
  img/trumpet/000046.jpg 1.429362
  [Top incorrect images]
  img/trombone/000041.jpg 0.712832
  img/trumpet/000126.jpg 0.602192
  img/trombone/000047.jpg 0.452466
accuracy: 0.910000
--------------------------------------

[Frogs and Leeks]
------------- Linear SVM -------------
  [Top correct images]
  img/leek/000026.jpg 2.074516
  img/leek/000004.jpg 2.007032
  img/leek/000033.jpg 1.982283
  [Top incorrect images]
accuracy: 1.000000
--------------------------------------
----------- Non-linear SVM -----------
  [Top correct images]
  img/leek/000026.jpg 1.746225
  img/leek/000004.jpg 1.689339
  img/leek/000033.jpg 1.672888
  [Top incorrect images]
accuracy: 1.000000
--------------------------------------

resnet101
[Trumpets and Trombones]
------------- Linear SVM -------------
  [Top correct images]
  img/trumpet/000064.jpg 1.987961
  img/trombone/000084.jpg 1.847380
  img/trombone/000039.jpg 1.808177
  [Top incorrect images]
  img/trombone/000041.jpg 1.274331
  img/trumpet/000123.jpg 0.570181
  img/trumpet/000032.jpg 0.429116
accuracy: 0.950000
--------------------------------------
----------- Non-linear SVM -----------
  [Top correct images]
  img/trombone/000066.jpg 1.686773
  img/trombone/000004.jpg 1.512264
  img/trombone/000053.jpg 1.481053
  [Top incorrect images]
  img/trombone/000041.jpg 0.876075
  img/trombone/000056.jpg 0.277250
  img/trumpet/000083.jpg 0.237917
accuracy: 0.965000
--------------------------------------

[Frogs and Leeks]
------------- Linear SVM -------------
  [Top correct images]
  img/frog/000074.jpg 1.687419
  img/frog/000042.jpg 1.662978
  img/frog/000002.jpg 1.614383
  [Top incorrect images]
accuracy: 1.000000
--------------------------------------
----------- Non-linear SVM -----------
  [Top correct images]
  img/frog/000042.jpg 1.467752
  img/frog/000074.jpg 1.457662
  img/frog/000002.jpg 1.444315
  [Top incorrect images]
accuracy: 1.000000
--------------------------------------

googlenet
[Trumpets and Trombones]
------------- Linear SVM -------------
  [Top correct images]
  img/trombone/000084.jpg 2.416699
  img/trombone/000037.jpg 2.381108
  img/trombone/000065.jpg 2.317755
  [Top incorrect images]
  img/trombone/000041.jpg 0.860713
  img/trombone/000056.jpg 0.651318
  img/trumpet/000123.jpg 0.605277
accuracy: 0.965000
--------------------------------------
----------- Non-linear SVM -----------
  [Top correct images]
  img/trumpet/000046.jpg 1.917373
  img/trombone/000112.jpg 1.671854
  img/trumpet/000117.jpg 1.619313
  [Top incorrect images]
  img/trombone/000041.jpg 0.733353
  img/trombone/000056.jpg 0.583285
  img/trumpet/000123.jpg 0.450082
accuracy: 0.960000
--------------------------------------

[Frogs and Leeks]
------------- Linear SVM -------------
  [Top correct images]
  img/frog/000062.jpg 1.775359
  img/frog/000031.jpg 1.668341
  img/frog/000074.jpg 1.637236
  [Top incorrect images]
accuracy: 1.000000
--------------------------------------
----------- Non-linear SVM -----------
  [Top correct images]
  img/frog/000062.jpg 1.545641
  img/leek/000033.jpg 1.506754
  img/frog/000074.jpg 1.501950
  [Top incorrect images]
accuracy: 1.000000
--------------------------------------

vgg19
[Trumpets and Trombones]
------------- Linear SVM -------------
  [Top correct images]
  img/trumpet/000013.jpg 2.073871
  img/trumpet/000046.jpg 1.897645
  img/trombone/000082.jpg 1.876587
  [Top incorrect images]
  img/trumpet/000123.jpg 0.843630
  img/trombone/000041.jpg 0.578862
  img/trombone/000056.jpg 0.292750
accuracy: 0.970000
--------------------------------------
----------- Non-linear SVM -----------
  [Top correct images]
  img/trumpet/000075.jpg 1.672333
  img/trumpet/000041.jpg 1.564924
  img/trumpet/000099.jpg 1.564924
  [Top incorrect images]
  img/trumpet/000123.jpg 0.528126
  img/trombone/000041.jpg 0.488657
  img/trombone/000044.jpg 0.146779
accuracy: 0.980000
--------------------------------------

[Frogs and Leeks]
------------- Linear SVM -------------
  [Top correct images]
  img/frog/000074.jpg 1.863508
  img/frog/000069.jpg 1.713079
  img/leek/000015.jpg 1.709077
  [Top incorrect images]
accuracy: 1.000000
--------------------------------------
----------- Non-linear SVM -----------
  [Top correct images]
  img/frog/000074.jpg 1.634277
  img/frog/000058.jpg 1.525262
  img/frog/000014.jpg 1.489810
  [Top incorrect images]
accuracy: 1.000000
--------------------------------------
```



### scr_collect_imgs.m

`traffic_lights.txt` に書かれたURLで指定された画像をダウンロードする

### scr_reranking.m

検索結果のリランキングを行う。

`img/traffic_lights`  には学習する検索ランキング、`img/traffic_lights_test`  にはリランキングする画像リストが含まれる。

