# R のバージョンが > 3.0.1 だと動くと思います
# 最初はここのコメントアウトを消して, パッケージのインストール
# install.packages("twitteR)
# install.packages("ROAuth)
library("twitteR")
library("ROAuth")

# 各種keyの登録 アカウント名: suuri3lab
twit.oauth <- OAuthFactory$new(
  handshakeComplete = TRUE,
  signMethod="HMAC",
  consumerKey = "CONSUMER_KEY",
  consumerSecret = "CONSUMER_SECRET",
  oauthKey = "OAUTH_KEY",
  oauthSecret = "OAUTH_SECRET"
)

## 出力したい文字

registerTwitterOAuth(twit.oauth)
message = "
LABEL
"
time = Sys.time()
updateStatus(message)

