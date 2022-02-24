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
  img/trombone/000034.jpg 1.042946
  img/trumpet/000035.jpg 1.006059
  img/trombone/000095.jpg 0.953104
  [Top incorrect images]
  img/trombone/000066.jpg 1.001773
  img/trombone/000013.jpg 0.973041
  img/trombone/000027.jpg 0.930085
accuracy: 0.800000

[Frogs and Leeks]
  [Top correct images]
  img/leek/000011.jpg 1.483670
  img/leek/000058.jpg 1.412738
  img/frog/000076.jpg 1.363731
  [Top incorrect images]
  img/frog/000029.jpg 1.229452
  img/frog/000071.jpg 0.991923
  img/frog/000099.jpg 0.965545
accuracy: 0.920000
```



### scr_dcnn.m

「alexnet, resnet101, googlenet, vgg19 によるDCNN特徴ベクトル + 線形SVM, 非線形SVM」 による画像分類を行う。

```
alexnet
[Trumpets and Trombones]
------------- Linear SVM -------------
  [Top correct images]
  img/trombone/000084.jpg 2.076298
  img/trombone/000036.jpg 1.654065
  img/trombone/000034.jpg 1.557592
  [Top incorrect images]
  img/trumpet/000015.jpg 1.699343
  img/trombone/000041.jpg 1.588419
  img/trumpet/000111.jpg 1.074477
accuracy: 0.900000
--------------------------------------
----------- Non-linear SVM -----------
  [Top correct images]
  img/trumpet/000052.jpg 1.475181
  img/trombone/000013.jpg 1.328322
  img/trombone/000003.jpg 1.322803
  [Top incorrect images]
  img/trombone/000041.jpg 1.315485
  img/trumpet/000015.jpg 1.173087
  img/trombone/000052.jpg 1.116194
accuracy: 0.910000
--------------------------------------

[Frogs and Leeks]
------------- Linear SVM -------------
  [Top correct images]
  img/leek/000028.jpg 2.074516
  img/leek/000051.jpg 1.849995
  img/leek/000001.jpg 1.849690
  [Top incorrect images]
accuracy: 1.000000
--------------------------------------
----------- Non-linear SVM -----------
  [Top correct images]
  img/leek/000028.jpg 1.746225
  img/leek/000013.jpg 1.608937
  img/frog/000060.jpg 1.608610
  [Top incorrect images]
accuracy: 1.000000
--------------------------------------

resnet101
[Trumpets and Trombones]
------------- Linear SVM -------------
  [Top correct images]
  img/trumpet/000065.jpg 1.987961
  img/trombone/000006.jpg 1.761446
  img/trombone/000106.jpg 1.730450
  [Top incorrect images]
  img/trombone/000041.jpg 1.808177
  img/trumpet/000032.jpg 1.223122
  img/trumpet/000083.jpg 0.218644
accuracy: 0.950000
--------------------------------------
----------- Non-linear SVM -----------
  [Top correct images]
  img/trombone/000006.jpg 1.472899
  img/trombone/000034.jpg 1.413686
  img/trumpet/000046.jpg 1.408369
  [Top incorrect images]
  img/trombone/000041.jpg 1.060746
  img/trumpet/000032.jpg 0.988919
  img/trumpet/000083.jpg 0.192947
accuracy: 0.965000
--------------------------------------

[Frogs and Leeks]
------------- Linear SVM -------------
  [Top correct images]
  img/frog/000076.jpg 1.687419
  img/frog/000044.jpg 1.662978
  img/frog/000004.jpg 1.614383
  [Top incorrect images]
accuracy: 1.000000
--------------------------------------
----------- Non-linear SVM -----------
  [Top correct images]
  img/frog/000044.jpg 1.467752
  img/frog/000076.jpg 1.457662
  img/frog/000004.jpg 1.444315
  [Top incorrect images]
accuracy: 1.000000
--------------------------------------

googlenet
[Trumpets and Trombones]
------------- Linear SVM -------------
  [Top correct images]
  img/trombone/000084.jpg 2.272048
  img/trombone/000034.jpg 2.238054
  img/trombone/000078.jpg 2.132393
  [Top incorrect images]
  img/trombone/000041.jpg 2.129383
  img/trumpet/000049.jpg 1.796975
  img/trombone/000052.jpg 1.110829
accuracy: 0.965000
--------------------------------------
----------- Non-linear SVM -----------
  [Top correct images]
  img/trombone/000013.jpg 1.612670
  img/trombone/000106.jpg 1.544221
  img/trumpet/000090.jpg 1.523797
  [Top incorrect images]
  img/trumpet/000049.jpg 1.581763
  img/trombone/000041.jpg 1.294058
  img/trumpet/000168.jpg 1.032150
accuracy: 0.960000
--------------------------------------

[Frogs and Leeks]
------------- Linear SVM -------------
  [Top correct images]
  img/frog/000063.jpg 1.775359
  img/frog/000032.jpg 1.668341
  img/frog/000076.jpg 1.637236
  [Top incorrect images]
accuracy: 1.000000
--------------------------------------
----------- Non-linear SVM -----------
  [Top correct images]
  img/frog/000063.jpg 1.545641
  img/frog/000076.jpg 1.501950
  img/frog/000032.jpg 1.452456
  [Top incorrect images]
accuracy: 1.000000
--------------------------------------

vgg19
[Trumpets and Trombones]
------------- Linear SVM -------------
  [Top correct images]
  img/trumpet/000015.jpg 2.073871
  img/trombone/000084.jpg 1.876587
  img/trumpet/000065.jpg 1.843254
  [Top incorrect images]
  img/trombone/000041.jpg 1.624534
  img/trombone/000022.jpg 0.995335
  img/trombone/000044.jpg 0.292523
accuracy: 0.970000
--------------------------------------
----------- Non-linear SVM -----------
  [Top correct images]
  img/trumpet/000075.jpg 1.672333
  img/trumpet/000046.jpg 1.564924
  img/trumpet/000103.jpg 1.564924
  [Top incorrect images]
  img/trombone/000041.jpg 0.941757
  img/trombone/000044.jpg 0.146779
  img/trombone/000056.jpg -1.008252
accuracy: 0.980000
--------------------------------------

[Frogs and Leeks]
------------- Linear SVM -------------
  [Top correct images]
  img/frog/000076.jpg 1.863508
  img/frog/000071.jpg 1.713079
  img/leek/000011.jpg 1.709077
  [Top incorrect images]
accuracy: 1.000000
--------------------------------------
----------- Non-linear SVM -----------
  [Top correct images]
  img/frog/000076.jpg 1.634277
  img/frog/000060.jpg 1.525262
  img/frog/000096.jpg 1.486887
  [Top incorrect images]
accuracy: 1.000000
--------------------------------------
```



### scr_collect_imgs.m

`traffic_lights.txt` に書かれたURLで指定された画像をダウンロードする

### scr_reranking.m

検索結果のリランキングを行う。

`img/traffic_lights`  には学習する検索ランキング、`img/traffic_lights_test`  にはリランキングする画像リストが含まれる。

