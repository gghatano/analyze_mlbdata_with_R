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
# dat = fread(paste(getwd(), "/pitch_fx/2013.csv", sep=""), 
#             select = col_used, showProgress=FALSE) 
dat = fread("pitchfx_data_for_plot.csv")

# remove the row includes "NA
# remove the row of Pre-Season Game
data = dat %>% filter(pitch_type!="NA") %>% 
  mutate(month = substr(sv_id, 4,4)) %>% 
  filter(month >= 4)

fastball = c("FF", "FT", "FC", "FS")

# check the fastball-ratio on each Ball/Strike count
data_fast = data %>% 
  mutate(FAST_FL = ifelse(pitch_type %in% fastball, "T", "F")) 

# check the data-table
data_fast %>% head %>% xtable %>% print(type="html")
```

<!-- html table generated in R 3.0.2 by xtable 1.7-3 package -->
<!-- Mon Mar 24 07:46:45 2014 -->
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
# output the fastball-ratio barplot of "pitcher"
# default : "Hiroki Kuroda"
fast_rate = function(pitcher = "Hiroki Kuroda"){
  # calculate fastball/non-fastball ratio 
  data_count = data_fast %>% 
    filter(pitcher_name == pitcher) %>% 
    group_by(count) %>% 
    dplyr::summarise(fast = sum(FAST_FL == "T"), 
                     non_fast = sum(FAST_FL == "F")) %>% 
    mutate(FAST = fast / (fast+non_fast), 
           non_FAST = non_fast / (fast+non_fast)) %>% 
    dplyr::select(count, FAST, non_FAST) %>% 
    melt(id.var = "count") %>% 
    setnames(c("count", "pitch", "freq"))
  
  # visualize by using rPlot
  rp = rPlot(data = data_count, freq ~ count, color = "pitch", type = "bar")
  return(rp)
}
  
```


### Fastball-ratio of Hiroki Kuroda (NYY).

```r
rp = fast_rate("Hiroki Kuroda")
rp$show("iframesrc", cdn = TRUE)
```

<iframe srcdoc='
&lt;!doctype HTML&gt;
&lt;meta charset = &#039;utf-8&#039;&gt;
&lt;html&gt;
  &lt;head&gt;
    
    &lt;script src=&#039;http://ramnathv.github.io/rCharts/libraries/widgets/polycharts/js/polychart2.standalone.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    
    &lt;style&gt;
    .rChart {
      display: block;
      margin-left: auto; 
      margin-right: auto;
      width: 800px;
      height: 400px;
    }  
    &lt;/style&gt;
    
  &lt;/head&gt;
  &lt;body&gt;
    &lt;div id=&#039;chart6d3e094d6e&#039; class=&#039;rChart polycharts&#039;&gt;&lt;/div&gt;  
    
    &lt;script type=&#039;text/javascript&#039;&gt;
    var chartParams = {
 &quot;dom&quot;: &quot;chart6d3e094d6e&quot;,
&quot;width&quot;:    800,
&quot;height&quot;:    400,
&quot;layers&quot;: [
 {
 &quot;x&quot;: &quot;count&quot;,
&quot;y&quot;: &quot;freq&quot;,
&quot;data&quot;: {
 &quot;count&quot;: [ &quot;0-0&quot;, &quot;0-1&quot;, &quot;0-2&quot;, &quot;1-0&quot;, &quot;1-1&quot;, &quot;1-2&quot;, &quot;2-0&quot;, &quot;2-1&quot;, &quot;2-2&quot;, &quot;3-0&quot;, &quot;3-1&quot;, &quot;3-2&quot;, &quot;0-0&quot;, &quot;0-1&quot;, &quot;0-2&quot;, &quot;1-0&quot;, &quot;1-1&quot;, &quot;1-2&quot;, &quot;2-0&quot;, &quot;2-1&quot;, &quot;2-2&quot;, &quot;3-0&quot;, &quot;3-1&quot;, &quot;3-2&quot; ],
&quot;pitch&quot;: [ &quot;FAST&quot;, &quot;FAST&quot;, &quot;FAST&quot;, &quot;FAST&quot;, &quot;FAST&quot;, &quot;FAST&quot;, &quot;FAST&quot;, &quot;FAST&quot;, &quot;FAST&quot;, &quot;FAST&quot;, &quot;FAST&quot;, &quot;FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot; ],
&quot;freq&quot;: [ 0.17032, 0.36019, 0.50336, 0.2082, 0.32402, 0.48026, 0.15888, 0.14035, 0.32886, 0.18182, 0.076923, 0.18978, 0.82968, 0.63981, 0.49664, 0.7918, 0.67598, 0.51974, 0.84112, 0.85965, 0.67114, 0.81818, 0.92308, 0.81022 ] 
},
&quot;facet&quot;: null,
&quot;color&quot;: &quot;pitch&quot;,
&quot;type&quot;: &quot;bar&quot; 
} 
],
&quot;facet&quot;: [],
&quot;guides&quot;: [],
&quot;coord&quot;: [],
&quot;id&quot;: &quot;chart6d3e094d6e&quot; 
}
    _.each(chartParams.layers, function(el){
        el.data = polyjs.data(el.data)
    })
    var graph_chart6d3e094d6e = polyjs.chart(chartParams);
&lt;/script&gt;
    
  &lt;/body&gt;
&lt;/html&gt;
' scrolling='no' seamless class='rChart 
polycharts
 '
id=iframe-
chart6d3e094d6e
></iframe>
<style>iframe.rChart{ width: 100%; height: 400px;}</style>


### Fastball-ratio of Yu Darvish (TEX).

```r
rp = fast_rate("Yu Darvish")
rp$show("iframesrc", cdn = TRUE)
```

<iframe srcdoc='
&lt;!doctype HTML&gt;
&lt;meta charset = &#039;utf-8&#039;&gt;
&lt;html&gt;
  &lt;head&gt;
    
    &lt;script src=&#039;http://ramnathv.github.io/rCharts/libraries/widgets/polycharts/js/polychart2.standalone.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    
    &lt;style&gt;
    .rChart {
      display: block;
      margin-left: auto; 
      margin-right: auto;
      width: 800px;
      height: 400px;
    }  
    &lt;/style&gt;
    
  &lt;/head&gt;
  &lt;body&gt;
    &lt;div id=&#039;chart6d36e19783f&#039; class=&#039;rChart polycharts&#039;&gt;&lt;/div&gt;  
    
    &lt;script type=&#039;text/javascript&#039;&gt;
    var chartParams = {
 &quot;dom&quot;: &quot;chart6d36e19783f&quot;,
&quot;width&quot;:    800,
&quot;height&quot;:    400,
&quot;layers&quot;: [
 {
 &quot;x&quot;: &quot;count&quot;,
&quot;y&quot;: &quot;freq&quot;,
&quot;data&quot;: {
 &quot;count&quot;: [ &quot;0-0&quot;, &quot;0-1&quot;, &quot;0-2&quot;, &quot;1-0&quot;, &quot;1-1&quot;, &quot;1-2&quot;, &quot;2-0&quot;, &quot;2-1&quot;, &quot;2-2&quot;, &quot;3-0&quot;, &quot;3-1&quot;, &quot;3-2&quot;, &quot;0-0&quot;, &quot;0-1&quot;, &quot;0-2&quot;, &quot;1-0&quot;, &quot;1-1&quot;, &quot;1-2&quot;, &quot;2-0&quot;, &quot;2-1&quot;, &quot;2-2&quot;, &quot;3-0&quot;, &quot;3-1&quot;, &quot;3-2&quot; ],
&quot;pitch&quot;: [ &quot;FAST&quot;, &quot;FAST&quot;, &quot;FAST&quot;, &quot;FAST&quot;, &quot;FAST&quot;, &quot;FAST&quot;, &quot;FAST&quot;, &quot;FAST&quot;, &quot;FAST&quot;, &quot;FAST&quot;, &quot;FAST&quot;, &quot;FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot; ],
&quot;freq&quot;: [ 0.7331, 0.65714, 0.58929, 0.64722, 0.60504, 0.50746,   0.75, 0.45366, 0.29773, 0.97727, 0.76923, 0.20144, 0.2669, 0.34286, 0.41071, 0.35278, 0.39496, 0.49254,   0.25, 0.54634, 0.70227, 0.022727, 0.23077, 0.79856 ] 
},
&quot;facet&quot;: null,
&quot;color&quot;: &quot;pitch&quot;,
&quot;type&quot;: &quot;bar&quot; 
} 
],
&quot;facet&quot;: [],
&quot;guides&quot;: [],
&quot;coord&quot;: [],
&quot;id&quot;: &quot;chart6d36e19783f&quot; 
}
    _.each(chartParams.layers, function(el){
        el.data = polyjs.data(el.data)
    })
    var graph_chart6d36e19783f = polyjs.chart(chartParams);
&lt;/script&gt;
    
  &lt;/body&gt;
&lt;/html&gt;
' scrolling='no' seamless class='rChart 
polycharts
 '
id=iframe-
chart6d36e19783f
></iframe>
<style>iframe.rChart{ width: 100%; height: 400px;}</style>


### Fastball ratio of Clayton Kershaw (LAD).

```r
rp = fast_rate("Clayton Kershaw")
rp$show("iframesrc", cdn = TRUE)
```

<iframe srcdoc='
&lt;!doctype HTML&gt;
&lt;meta charset = &#039;utf-8&#039;&gt;
&lt;html&gt;
  &lt;head&gt;
    
    &lt;script src=&#039;http://ramnathv.github.io/rCharts/libraries/widgets/polycharts/js/polychart2.standalone.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    
    &lt;style&gt;
    .rChart {
      display: block;
      margin-left: auto; 
      margin-right: auto;
      width: 800px;
      height: 400px;
    }  
    &lt;/style&gt;
    
  &lt;/head&gt;
  &lt;body&gt;
    &lt;div id=&#039;chart6d36e5ded9e&#039; class=&#039;rChart polycharts&#039;&gt;&lt;/div&gt;  
    
    &lt;script type=&#039;text/javascript&#039;&gt;
    var chartParams = {
 &quot;dom&quot;: &quot;chart6d36e5ded9e&quot;,
&quot;width&quot;:    800,
&quot;height&quot;:    400,
&quot;layers&quot;: [
 {
 &quot;x&quot;: &quot;count&quot;,
&quot;y&quot;: &quot;freq&quot;,
&quot;data&quot;: {
 &quot;count&quot;: [ &quot;0-0&quot;, &quot;0-1&quot;, &quot;0-2&quot;, &quot;1-0&quot;, &quot;1-1&quot;, &quot;1-2&quot;, &quot;2-0&quot;, &quot;2-1&quot;, &quot;2-2&quot;, &quot;3-0&quot;, &quot;3-1&quot;, &quot;3-2&quot;, &quot;0-0&quot;, &quot;0-1&quot;, &quot;0-2&quot;, &quot;1-0&quot;, &quot;1-1&quot;, &quot;1-2&quot;, &quot;2-0&quot;, &quot;2-1&quot;, &quot;2-2&quot;, &quot;3-0&quot;, &quot;3-1&quot;, &quot;3-2&quot; ],
&quot;pitch&quot;: [ &quot;FAST&quot;, &quot;FAST&quot;, &quot;FAST&quot;, &quot;FAST&quot;, &quot;FAST&quot;, &quot;FAST&quot;, &quot;FAST&quot;, &quot;FAST&quot;, &quot;FAST&quot;, &quot;FAST&quot;, &quot;FAST&quot;, &quot;FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot;, &quot;non_FAST&quot; ],
&quot;freq&quot;: [ 0.80199, 0.50429, 0.43284, 0.69497, 0.44762, 0.29444, 0.96296, 0.63699, 0.45614, 0.95833, 0.95082, 0.71523, 0.19801, 0.49571, 0.56716, 0.30503, 0.55238, 0.70556, 0.037037, 0.36301, 0.54386, 0.041667, 0.04918, 0.28477 ] 
},
&quot;facet&quot;: null,
&quot;color&quot;: &quot;pitch&quot;,
&quot;type&quot;: &quot;bar&quot; 
} 
],
&quot;facet&quot;: [],
&quot;guides&quot;: [],
&quot;coord&quot;: [],
&quot;id&quot;: &quot;chart6d36e5ded9e&quot; 
}
    _.each(chartParams.layers, function(el){
        el.data = polyjs.data(el.data)
    })
    var graph_chart6d36e5ded9e = polyjs.chart(chartParams);
&lt;/script&gt;
    
  &lt;/body&gt;
&lt;/html&gt;
' scrolling='no' seamless class='rChart 
polycharts
 '
id=iframe-
chart6d36e5ded9e
></iframe>
<style>iframe.rChart{ width: 100%; height: 400px;}</style>


