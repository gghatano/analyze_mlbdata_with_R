# R のバージョンが > 3.0.1 だと動くと思います
# 最初はここのコメントアウトを消して, パッケージのインストール
# install.packages("twitteR)
# install.packages("ROAuth)
library("twitteR")
library("ROAuth")

# 各種keyの登録 アカウント名: 甲子園野球速報bot
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
 0アウト ランナー 無し 
八頭 0-0 角館
"
time = Sys.time()
updateStatus(message)
