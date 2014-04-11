library(pitchRx)

dat = fread("darvish_data.csv") 

# 公式記録のあるデータを使う
dat = dat %>% filter(sv_id != "NA")

# make the pitching ball trajectry by using rgl
dat %>% filter(sv_id != "NA") %>%
  filter(pitch_type %in% c("SL", "FF")) %>% 
  head(20) %>% interactiveFX

# make animation of the pitching
animation::saveHTML({
dat %>% filter(sv_id != "NA") %>%
  filter(pitch_type %in% c("SL", "FF")) %>% head(30) %>% 
  animateFX(interval = 0.01, point.alpha = 0.9, layer=facet_grid(pitcher_name~stand))
}, htmlfile = "pitching_animation.html", outdir = getwd())

# density plot

pdf("strikeFX.pdf")
strikeFX(dat, geom="tile", 
         density1=list(des="Called Strike"), 
         density2=list(des="Ball"), layer=facet_grid(.~stand))
dev.off()

