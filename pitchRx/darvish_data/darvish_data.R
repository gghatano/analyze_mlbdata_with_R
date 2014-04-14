library(pitchRx)
library(rgl)

dat = fread("/Users/taku/analyze_mlbdata_with_R/pitchRx/darvish_data/darvish_data.csv") 

# 公式記録のあるデータを使う
dat = dat %>% filter(sv_id != "NA")

# make the pitching ball trajectry by using rgl
dat %>% filter(sv_id != "NA") %>%
  filter(pitch_type %in% c("FF","SL")) %>% 
  head(50) %>% interactiveFX
writeWebGL(width=500, height=550)

# make animation of the pitching
# animation::saveHTML({
# dat %>% filter(sv_id != "NA") %>%
#   filter(pitch_type %in% c("SL", "FF")) %>% head(30) %>% 
#   animateFX(interval = 0.01, point.alpha = 0.9, layer=facet_grid(pitcher_name~pitch_type))
# }, htmlfile = "pitching_animation.html", outdir = getwd())

# density plot

pdf("strikeFX.pdf")
strikeFX(dat, geom="tile", 
         density1=list(des="Called Strike"), 
         density2=list(des="Ball"), layer=facet_grid(.~stand))
dev.off()

