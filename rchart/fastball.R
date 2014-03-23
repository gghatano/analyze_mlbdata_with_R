library(rCharts)

# dat = fread(paste(getwd(), "/pitch_fx/2013.csv", sep=""))

data = dat %>% 
  dplyr::select(pitch_type, type, count, pitcher_name, sv_id) %>% 
  filter(pitch_type!="NA") 
dat %>% select(pitch_type) %>% table
fastball = c("FF", "FT", "FC", "FS")
data_fast = data %>% 
  mutate(FAST_FL = ifelse(pitch_type %in% fastball, "T", "F")) %>% 
  mutate(month = substr(sv_id, 4,4)) %>% 
  filter(month >= 4)

pitcher = "Hiroki Kuroda"
fast_rate = function(pitcher = "Hiroki Kuroda"){
  data_count = data_fast %>% 
    filter(pitcher_name == pitcher) %>% 
    group_by(count) %>% 
    dplyr::summarise(fast = sum(FAST_FL == "T"), non_fast = sum(FAST_FL == "F")) %>% 
    mutate(fast_rate = fast / (fast+non_fast), non_fast_rate = non_fast / (fast+non_fast)) %>% 
    dplyr::select(count, fast_rate, non_fast_rate) %>% 
    melt(id.var = "count") %>% setnames(c("count", "pitch", "freq"))
  rp = rPlot(data = data_count, freq ~ count, color = "pitch", type = "bar")
  return(rp)
}
  
fast_rate()
fast_rate("Yu Darvish")
