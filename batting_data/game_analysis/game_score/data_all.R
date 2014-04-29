require(lattice)
require(latticeExtra)

## create 3d bar plot 

res = fread("gamedata.csv")
res_game = 
  res %>% 
  group_by(home, away) %>%
  dplyr::summarise(game = sum(game)) %>% 
  filter(home < 10 & away < 10)

## create closs table: home \times away \to game
res_game_tabs = xtabs(game ~ home + away, data = res_game)

## make 3dbarplot
cloud(res_game_tabs, panel.3d.cloud = panel.3dbars,
      xbase = 0.4, ybase = 0.4, zlim = c(0, max(res_game_tabs)),
      scales = list(arrows = FALSE, just = "right"), xlab = NULL, ylab = NULL,
      col.facet = level.colors(res_game_tabs, at = do.breaks(range(res_game_tabs), 20),
                               col.regions = cm.colors,
                               colors = TRUE),
      colorkey = list(col = cm.colors, at = do.breaks(range(res_game_tabs), 20)),
      screen = list(z = 40, x = -30))

## create tile plot
res_game %>% mutate(home = as.factor(home), away = as.factor(away)) %>% 
  ggplot() + 
  geom_tile(aes(x=home, y=away, fill = game)) + 
  scale_fill_gradient(low="white", high="black") + 
  ggtitle("Score heat map (1922 ~ 2013)") + 
  theme(plot.title = element_text(size=24, face="bold"))
  ggsave("Score_heatmap.png")
