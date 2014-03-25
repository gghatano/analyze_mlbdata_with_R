MLB Scouting Report: Fastball-Count (2013)
========================================================



Fastball-count is the pitching-count such that the fastball is often thrown.

Now, visualize the fastball-count of some pitchers by using R and pitch-f/x data.

The code and data can be obtained from github (fastball.Rmd)

https://github.com/gghatano/analyze_mlbdata_with_R/tree/master/rchart


```r
library(dplyr)
library(data.table)
library(magrittr)
library(rCharts)
library(xtable)


# select the column used for this document
col_used = c("pitch_type", "type", "count", "pitcher_name", "sv_id")
# dat = fread(paste(getwd(), '/pitch_fx/2013.csv', sep=''), select =
# col_used, showProgress=FALSE)
dat = fread("pitchfx_data_for_plot.csv")

# remove the row includes 'NA remove the row of Pre-Season Game
data = dat %>% filter(pitch_type != "NA") %>% mutate(month = substr(sv_id, 4, 
    4)) %>% filter(month >= 4)

fastball = c("FF", "FT", "FC", "FS")

# check the fastball-ratio on each Ball/Strike count
data_fast = data %>% mutate(FAST_FL = ifelse(pitch_type %in% fastball, "T", 
    "F"))

# check the data-table data_fast %>% head %>% xtable %>% print(type='html')
data_fast %>% head %>% xtable %>% print(type = "html")
```

<!-- html table generated in R 3.0.2 by xtable 1.7-3 package -->
<!-- Tue Mar 25 10:03:52 2014 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH> pitch_type </TH> <TH> sv_id </TH> <TH> type </TH> <TH> count </TH> <TH> pitcher_name </TH> <TH> month </TH> <TH> FAST_FL </TH>  </TR>
  <TR> <TD align="right"> 1 </TD> <TD> FF </TD> <TD> 130401_131510 </TD> <TD> S </TD> <TD> 0-0 </TD> <TD> Clayton Kershaw </TD> <TD> 4 </TD> <TD> T </TD> </TR>
  <TR> <TD align="right"> 2 </TD> <TD> CU </TD> <TD> 130401_131526 </TD> <TD> X </TD> <TD> 0-1 </TD> <TD> Clayton Kershaw </TD> <TD> 4 </TD> <TD> F </TD> </TR>
  <TR> <TD align="right"> 3 </TD> <TD> FF </TD> <TD> 130401_131606 </TD> <TD> B </TD> <TD> 0-0 </TD> <TD> Clayton Kershaw </TD> <TD> 4 </TD> <TD> T </TD> </TR>
  <TR> <TD align="right"> 4 </TD> <TD> FF </TD> <TD> 130401_131619 </TD> <TD> S </TD> <TD> 1-0 </TD> <TD> Clayton Kershaw </TD> <TD> 4 </TD> <TD> T </TD> </TR>
  <TR> <TD align="right"> 5 </TD> <TD> CU </TD> <TD> 130401_131652 </TD> <TD> B </TD> <TD> 1-1 </TD> <TD> Clayton Kershaw </TD> <TD> 4 </TD> <TD> F </TD> </TR>
  <TR> <TD align="right"> 6 </TD> <TD> FF </TD> <TD> 130401_131712 </TD> <TD> B </TD> <TD> 2-1 </TD> <TD> Clayton Kershaw </TD> <TD> 4 </TD> <TD> T </TD> </TR>
   </TABLE>



### ------------------------------------------------------------------
Function "fast_rate" calculates the pitcher's fastball-ratio of each Ball/Strike count and visualizes them

```r
# output the fastball-ratio barplot of 'pitcher' default : 'Hiroki Kuroda'
fast_rate = function(pitcher = "Hiroki Kuroda") {
    # calculate fastball/non-fastball ratio
    data_count = data_fast %>% filter(pitcher_name == pitcher) %>% group_by(count) %>% 
        dplyr::summarise(fast = sum(FAST_FL == "T"), non_fast = sum(FAST_FL == 
            "F")) %>% mutate(FAST = fast/(fast + non_fast), non_FAST = non_fast/(fast + 
        non_fast)) %>% dplyr::select(count, FAST, non_FAST) %>% melt(id.var = "count") %>% 
        setnames(c("count", "pitch", "freq"))
    return(data_count)
}
```



```r
dat_kuroda = fast_rate("Hiroki Kuroda")

up = uPlot(x = "freq", y = "count", group = "pitch", data = dat_kuroda, type = "StackedBar")
up
```

<iframe src='
figure/unnamed-chunk-3.html
' scrolling='no' seamless class='rChart 
uvcharts
 '
id=iframe-
chartd2b7c6f4599
></iframe>
<style>iframe.rChart{ width: 100%; height: 400px;}</style>



