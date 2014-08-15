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
  consumerKey = "SuNRx2EXhdl3lKAp3lbR7Bzpw",
  consumerSecret = "nBzoy0cVqcv6wLml1IF8CA2QbQt6niijg0R8vaKSg78CzuQXQ8",
  oauthKey = "2706364794-e4L37xblSs9welYm8s0HgPDqAZNz2OXKL16r4pC",
  oauthSecret = "0CEihGR27tPVhpR3vSt2k4Gu53bxH6KkHlwv2BMznLh95"
)

## 出力したい文字

registerTwitterOAuth(twit.oauth)
message = "
3回裏 0アウト ランナー 1塁 
大桐蔭 3-4 開星
"
time = Sys.time()
updateStatus(message)
