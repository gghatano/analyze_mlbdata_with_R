library(xts)
## calculate the number of hit in each game

teamhit = function(file = "all2013.csv"){
  
  print(paste("now:" , year))
  year = substr(file, 4, 8)
  
  filename = paste("../../../../data/", file, sep="")
  dat = fread(filename)
  name = fread("../names.csv", header=FALSE) %>% unlist
  dat1 = dat %>% setnames(name) %>% 
    dplyr::select(GAME_ID, AWAY_TEAM_ID, BAT_HOME_ID, H_FL)
  
  dat_teamhit = dat1 %>% 
    setnames(c("id", "away", "h_a", "h_fl")) %>% 
    mutate(home= substr(id, 1,3)) %>% 
    mutate(hit = ifelse(h_fl > 0, 1, 0)) %>% 
    group_by(id, home, away, h_a) %>% 
    dplyr::summarise(hit = sum(hit)) %>% 
    mutate(team = ifelse(h_a==1, home, away)) %>% 
    group_by(add=FALSE) %>%
    dplyr::select(id, hit, team) 
  
  ## set the column "game" as the number of game 
  dat_teamhit_game = 
    dat_teamhit %>% 
    group_by(team) %>% 
    dplyr::summarise(id = id , hit = hit, game = row_number(id)) 
  dat_teamhit_game
  
  ## calculate the numebr of team-hit in 5-streak-games.
  dat_teamhit5 = 
    dat_teamhit_game %>% 
    group_by(team, add=FALSE) %>%
    dplyr::summarise(teamhit5game=rollapplyr(hit, 5, sum), 
                     game = head(game, length(game)-4)) 
  
  dat_teamhit_game
  dat_teamhit5_id = 
    dat_teamhit5 %>% 
    inner_join(dat_teamhit_game, by=c("team", "game")) %>% 
    select(id, team, game, teamhit5game) %>% 
    setnames(c("start_game_id", "team", "game", "teamhit_in_5games")) %>% 
    mutate(year = year)
  return(dat_teamhit5_id)
}

files = fread("../../../../data/files.txt", header=FALSE) %>% unlist
files
dat = data.table()
for(file in files){
  dat_tmp = teamhit(file)
  dat = rbind(dat, dat_tmp)
  print(paste("file: " , file))
}
dat %>% write.csv("teamhit.csv", quote = FALSE, row.names=FALSE)
