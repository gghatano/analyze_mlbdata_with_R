甲子園実況botの作成
===

## 内容

yahoo!の甲子園一球速報.htmlをなんやかんやして, 試合状況をツイートします. 


## 説明

### baseball_jikkyou_tweet.bash
これを実行すると, ツイートまでやってくれます. 

### baseball_jikkyou.bash
htmlをダウンロードして, 試合状況をout.txtに書き出します. 

### out.txt
今の試合状況が入っています

### tweet.txt
ツイートする文章が入っています

### kousien_jikkyou_template.R
RからツイートするのRスクリプトです. 
ここTwitterAPIkeyを入力して, $HOME/templateにおきます.

## 補足

twitter APIを取得して, 
各種keyをtweet.template.Rに入力してください.
できたtemplateファイルを$HOME/twitter_tamplate/にtemplateファイルを置きます. 
baseball_jikkyou_tweet.bashの中で, 
$HOME/template/kousien_jikkyou_template.Rからツイート用スクリプトを作ってくれます.
