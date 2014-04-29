## data2013_score.R 

## check by 2013 data
## data2013 = fread("all2013.csv)
## names = fread("names.csv")
## setnames(data2013, names)
## スコア別試合数を集計. 
## まずは試合でgroup_byして, 別に最終的な試合
## ホームチーム, アウェイチームの得点でgroup_byして数を数えればいい. 
data2013_gamescore_home_away = 
  data2013 %>% group_by(GAME_ID) %>% 
  dplyr::summarise(away = max(AWAY_SCORE_CT, na.rm=TRUE), 
                   home = max(HOME_SCORE_CT, na.rm=TRUE)) %>% 
  group_by(away, home, add=FALSE) %>% 
  dplyr::summarise(game = n())

head(data2013_gamescore_home_away)

## tile plot
data2013_gamescore_home_away %>% 
  ggplot() + geom_tile(aes(x=home, y=away, fill = game)) + 
  scale_fill_gradient(low="white", high="steelblue") + theme_bw() + 
  ggtitle("Score heat map") + 
  ggsave("Score_heatmap.png")

## balloon plot
data2013_gamescore_home_away %>% 
  ggplot(aes(x=home, y=away, size = game)) + 
  geom_point(shape = 21, color = "black", fill = "cornsilk") + 
  scale_size_area(max_size=15) + 
  ggsave("Score_balloonplot.png")


## ホーム/アウェイの区別をなくした場合
data2013_gamescore_high_low = 
  data2013_gamescore_home_away %>% 
  mutate(H_L = ifelse(home > away, 
                      paste(home, "-", away, sep=""), 
                      paste(away, "-", home, sep=""))) %>% 
  group_by(H_L, add=FALSE) %>% 
  dplyr::summarise(game = sum(game)) %>% 
  arrange(desc(game))

data2013_gamescore_high_low %>% head(20) %>% 
  ggplot(aes(x=reorder(H_L, game), y=game)) + 
  geom_bar(stat="identity", fill = "lightblue", colour = "black") + 
  xlab("Score") + ylab("Number") + ggtitle("Score-game barplot in 2013-season (2431 games)")
  ggsave("GameScore.png")


data2013_dim = 
  data2013 %>% 
  group_by(GAME_ID, add=FALSE) %>% 
  dplyr::summarise(fullgame = n()) %>% dim
