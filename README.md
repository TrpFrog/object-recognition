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
  ../img/trombone/000082.jpg 1206181548.000000
  ../img/trombone/000048.jpg 998511552.000000
  ../img/trumpet/000075.jpg 786339519.000000
  [Top incorrect images]
  ../img/trumpet/000073.jpg 781380682.000000
  ../img/trombone/000063.jpg 455219324.000000
  ../img/trumpet/000126.jpg 390800264.000000
accuracy: 0.790000

[Frogs and Leeks]
  [Top correct images]
  ../img/frog/000063.jpg 757850968.000000
  ../img/frog/000069.jpg 634802669.000000
  ../img/frog/000095.jpg 605016648.000000
  [Top incorrect images]
  ../img/frog/000062.jpg 732262368.000000
  ../img/frog/000074.jpg 678455895.000000
  ../img/frog/000055.jpg 658725738.000000
accuracy: 0.730000
```



### scr_codebook.m

`make_codebook` を叩いてコードブックを作る。



### scr_bof.m

BoFベクトル + 非線形SVM による分類を行う。

```
[Trumpets and Trombones]
  [Top correct images]
  ../img/trumpet/000065.jpg 1.115044
  ../img/trombone/000034.jpg 1.040363
  ../img/trumpet/000113.jpg 1.000760
  [Top incorrect images]
  ../img/trombone/000066.jpg 1.012964
  ../img/trombone/000013.jpg 0.966756
  ../img/trombone/000027.jpg 0.945968
accuracy: 0.765000

[Frogs and Leeks]
  [Top correct images]
  ../img/leek/000011.jpg 1.502183
  ../img/frog/000076.jpg 1.477229
  ../img/leek/000008.jpg 1.433985
  [Top incorrect images]
  ../img/frog/000029.jpg 1.047417
  ../img/frog/000071.jpg 0.993963
  ../img/frog/000099.jpg 0.991841
accuracy: 0.910000
```



### scr_dcnn.m

「alexnet, resnet101, googlenet, vgg19 によるDCNN特徴ベクトル + 線形SVM, 非線形SVM」 による画像分類を行う。

```
alexnet
[Trumpets and Trombones]
------------- Linear SVM -------------
  [Top correct images]
  ../img/trombone/000084.jpg 2.044618
  ../img/trombone/000036.jpg 1.750707
  ../img/trumpet/000015.jpg 1.664335
  [Top incorrect images]
  ../img/trombone/000041.jpg 1.638329
  ../img/trumpet/000122.jpg 1.135896
  ../img/trombone/000027.jpg 1.003171
accuracy: 0.890000
--------------------------------------
----------- Non-linear SVM -----------
  [Top correct images]
  ../img/trombone/000013.jpg 1.440209
  ../img/trombone/000003.jpg 1.437032
  ../img/trombone/000091.jpg 1.437032
  [Top incorrect images]
  ../img/trombone/000041.jpg 1.352291
  ../img/trombone/000052.jpg 1.047100
  ../img/trombone/000027.jpg 1.000081
accuracy: 0.910000
--------------------------------------

[Frogs and Leeks]
------------- Linear SVM -------------
  [Top correct images]
  ../img/leek/000028.jpg 2.074516
  ../img/leek/000051.jpg 1.849995
  ../img/leek/000001.jpg 1.849690
  [Top incorrect images]
accuracy: 1.000000
--------------------------------------
----------- Non-linear SVM -----------
  [Top correct images]
  ../img/leek/000028.jpg 1.746225
  ../img/leek/000013.jpg 1.608937
  ../img/frog/000060.jpg 1.608610
  [Top incorrect images]
accuracy: 1.000000
--------------------------------------

resnet101
[Trumpets and Trombones]
------------- Linear SVM -------------
  [Top correct images]
  ../img/trumpet/000065.jpg 2.060001
  ../img/trumpet/000071.jpg 1.742554
  ../img/trombone/000006.jpg 1.658716
  [Top incorrect images]
  ../img/trombone/000041.jpg 1.741964
  ../img/trumpet/000032.jpg 1.250480
  ../img/trombone/000047.jpg 0.233325
accuracy: 0.950000
--------------------------------------
----------- Non-linear SVM -----------
  [Top correct images]
  ../img/trombone/000006.jpg 1.473978
  ../img/trombone/000016.jpg 1.430212
  ../img/trombone/000034.jpg 1.399037
  [Top incorrect images]
  ../img/trombone/000041.jpg 1.051594
  ../img/trumpet/000032.jpg 1.029585
  ../img/trumpet/000123.jpg -0.099975
accuracy: 0.970000
--------------------------------------

[Frogs and Leeks]
------------- Linear SVM -------------
  [Top correct images]
  ../img/frog/000076.jpg 1.687419
  ../img/frog/000044.jpg 1.662978
  ../img/frog/000004.jpg 1.614383
  [Top incorrect images]
accuracy: 1.000000
--------------------------------------
----------- Non-linear SVM -----------
  [Top correct images]
  ../img/frog/000044.jpg 1.467752
  ../img/frog/000076.jpg 1.457662
  ../img/frog/000004.jpg 1.444315
  [Top incorrect images]
accuracy: 1.000000
--------------------------------------

googlenet
[Trumpets and Trombones]
------------- Linear SVM -------------
  [Top correct images]
  ../img/trombone/000034.jpg 2.252679
  ../img/trombone/000084.jpg 2.169622
  ../img/trombone/000078.jpg 2.162387
  [Top incorrect images]
  ../img/trombone/000041.jpg 2.051777
  ../img/trumpet/000049.jpg 1.932893
  ../img/trumpet/000032.jpg 1.499542
accuracy: 0.970000
--------------------------------------
----------- Non-linear SVM -----------
  [Top correct images]
  ../img/trombone/000013.jpg 1.621510
  ../img/trumpet/000077.jpg 1.612431
  ../img/trumpet/000103.jpg 1.603947
  [Top incorrect images]
  ../img/trumpet/000049.jpg 1.745717
  ../img/trombone/000041.jpg 1.301680
  ../img/trumpet/000119.jpg 0.507995
accuracy: 0.970000
--------------------------------------

[Frogs and Leeks]
------------- Linear SVM -------------
  [Top correct images]
  ../img/frog/000063.jpg 1.775359
  ../img/frog/000032.jpg 1.668341
  ../img/frog/000076.jpg 1.637236
  [Top incorrect images]
accuracy: 1.000000
--------------------------------------
----------- Non-linear SVM -----------
  [Top correct images]
  ../img/frog/000063.jpg 1.545641
  ../img/frog/000076.jpg 1.501950
  ../img/frog/000032.jpg 1.452456
  [Top incorrect images]
accuracy: 1.000000
--------------------------------------

vgg19
[Trumpets and Trombones]
------------- Linear SVM -------------
  [Top correct images]
  ../img/trumpet/000015.jpg 2.041238
  ../img/trumpet/000065.jpg 1.817716
  ../img/trumpet/000071.jpg 1.770318
  [Top incorrect images]
  ../img/trombone/000041.jpg 1.823780
  ../img/trombone/000108.jpg 1.138833
  ../img/trumpet/000125.jpg 1.015703
accuracy: 0.935000
--------------------------------------
----------- Non-linear SVM -----------
  [Top correct images]
  ../img/trumpet/000046.jpg 1.580939
  ../img/trumpet/000077.jpg 1.579347
  ../img/trumpet/000015.jpg 1.448637
  [Top incorrect images]
  ../img/trumpet/000125.jpg 1.000235
  ../img/trombone/000041.jpg 0.985881
  ../img/trombone/000044.jpg 0.038762
accuracy: 0.970000
--------------------------------------

[Frogs and Leeks]
------------- Linear SVM -------------
  [Top correct images]
  ../img/frog/000076.jpg 1.863508
  ../img/frog/000071.jpg 1.713079
  ../img/leek/000011.jpg 1.709077
  [Top incorrect images]
accuracy: 1.000000
--------------------------------------
----------- Non-linear SVM -----------
  [Top correct images]
  ../img/frog/000076.jpg 1.634277
  ../img/frog/000060.jpg 1.525262
  ../img/frog/000096.jpg 1.486887
  [Top incorrect images]
accuracy: 1.000000
--------------------------------------
```



### scr_collect_imgs.m

`traffic_lights.txt` に書かれたURLで指定された画像をダウンロードする

### scr_reranking.m

検索結果のリランキングを行う。

`img/traffic_lights`  には学習する検索ランキング、`img/traffic_lights_test`  にはリランキングする画像リストが含まれる。

