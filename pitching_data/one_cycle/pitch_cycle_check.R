library(data.table)
library(dplyr)
library(magrittr)

dat = fread("pitch_cycle.csv")
# 被打率
dat_average = 
  dat %>% 
  select(name, onecycle, hit, hit_all, atbat, atbat_all) %>%
  mutate(average = round(hit/ atbat, 3)) %>% 
  select(name, onecycle, average) 

# 被打率(全体)
dat_average_all = 
  dat %>% 
  select(name, onecycle, hit, hit_all, atbat, atbat_all) %>%
  group_by(onecycle) %>% 
  dplyr::summarise(hit = sum(hit), atbat = sum(atbat)) %>% 
  mutate(average = round(hit / atbat, 4))
dat_average_all %>% 
  arrange(desc(onecycle)) %>% 
  xtable %>% 
  print(type="html")

# 被打率diff
dat_average_diff = 
  dat_average %>% dcast(name ~ onecycle) %>% 
  setnames(c("name", "not_first", "first")) %>% 
  mutate(diff = first - not_first)
# diffのランキング
dat_average_diff %>% 
  mutate(diff = abs(diff)) %>%
  arrange(diff) %>% 
  head(10) %>% 
  xtable %>% 
  print(type="html")

# 被打率比較プロット
ggplot(dat_average_diff) + 
  geom_point(aes(x=first, y = not_first), size = 3) +
  stat_function(fun = function(x) x, linetype="dashed") + 
  ggtitle("Average (first cycle)") +
  xlim(0.15, 0.35) + ylim(0.15,0.35) + 
  ggsave("average.png")

# 奪三振率
dat_ko = 
  dat %>% 
  select(name, onecycle, ko, outs) %>% 
  mutate(ko_rate = ko / outs * 27)
# 奪三振率(ある程度投げた先発投手全体)
dat_ko_all = 
  dat_ko %>% 
  group_by(onecycle) %>%
  dplyr::summarise(ko = sum(ko), outs = sum(outs))%>% 
  mutate(name = "mean", ko_rate = ko / outs * 27) %>% 
  select(name, onecycle, ko, outs, ko_rate)

# 奪三振率のdiff
dat_ko_diff = 
  dat_ko %>% 
  select(name, onecycle, ko_rate) %>% 
  dcast.data.table(name ~ onecycle, value.var = "ko_rate") %>% 
  setnames(c("name", "not_first", "first")) %>% 
  mutate(KO_rate_diff = first - not_first) 
# 奪三振率diffランキング
dat_ko_diff %>% 
  arrange(KO_rate_diff) %>% 
  head(5) %>% 
  xtable %>% 
  print(type="html")

# 奪三振率比較プロット
gp_kbb = 
  ggplot(dat_ko_diff) + 
  geom_point(aes(x=first, y = not_first, col = name), size = 6) +
  xlim(2.5, 12) + ylim(2.5,12) + 
  stat_function(fun = function(x) x, linetype="dashed") + 
  ggtitle("KO_RATE (first cycle)") + 
  theme(legend.position="none")
  #ggsave("ko_rate.png")

library(plotly)
p = plotly("gghatano", "su64cdad4h")
p$ggplotly(gp_kbb)


# K_BB比較
dat_kbb = 
  dat %>% 
  select(name, onecycle, walk, ko) %>% 
  mutate(K_BB = ko / walk) %>% 
  select(name, onecycle, K_BB) %>% 
  dcast.data.table(name ~ onecycle) %>% 
  setnames(c("name", "not_first", "first")) %>%
  mutate(diff = first / not_first)
  
dat_kbb %>% 
  ggplot() +
  geom_point(aes(x=first, y=not_first), size=2) + 
  stat_function(fun = function(x) x, linetype="dashed") + 
  xlim(1.0, 10.0) + ylim(1.0,10.0) + 
  ggtitle("K/BB (first cycle)") + 
  ggsave("k_bb.png")

dat_kbb %>% 
  arrange(desc(diff)) %>% 
  head(5) %>% 
  xtable%>% 
  print(type="html")
