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
# data_fast %>% head %>% xtable %>% print(type="html")
data_fast %>% head %>% kable(format="html")
```

<table>
 <thead>
  <tr>
   <th> pitch_type </th>
   <th> sv_id </th>
   <th> type </th>
   <th> count </th>
   <th> pitcher_name </th>
   <th> month </th>
   <th> FAST_FL </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td> FF </td>
   <td> 130401_131510 </td>
   <td> S </td>
   <td> 0-0 </td>
   <td> Clayton Kershaw </td>
   <td> 4 </td>
   <td> T </td>
  </tr>
  <tr>
   <td> CU </td>
   <td> 130401_131526 </td>
   <td> X </td>
   <td> 0-1 </td>
   <td> Clayton Kershaw </td>
   <td> 4 </td>
   <td> F </td>
  </tr>
  <tr>
   <td> FF </td>
   <td> 130401_131606 </td>
   <td> B </td>
   <td> 0-0 </td>
   <td> Clayton Kershaw </td>
   <td> 4 </td>
   <td> T </td>
  </tr>
  <tr>
   <td> FF </td>
   <td> 130401_131619 </td>
   <td> S </td>
   <td> 1-0 </td>
   <td> Clayton Kershaw </td>
   <td> 4 </td>
   <td> T </td>
  </tr>
  <tr>
   <td> CU </td>
   <td> 130401_131652 </td>
   <td> B </td>
   <td> 1-1 </td>
   <td> Clayton Kershaw </td>
   <td> 4 </td>
   <td> F </td>
  </tr>
  <tr>
   <td> FF </td>
   <td> 130401_131712 </td>
   <td> B </td>
   <td> 2-1 </td>
   <td> Clayton Kershaw </td>
   <td> 4 </td>
   <td> T </td>
  </tr>
</tbody>
</table>



### ------------------------------------------------------------------
Function "fast_rate" calculates the pitcher's fastball-ratio of each Ball/Strike count and visualizes them

```r
# output the fastball-ratio badata_plotlot of "pitcher"
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
    setnames(c("count", "pitch", "freq")) %>% 
    mutate(count = paste(count))
  
  # make plot by using ggplot2
  gp = ggplot(data_count, aes(x = count,  y=freq, fill=pitch)) + 
    geom_bar(stat="identity") + 
    xlab("count") + ylab("frequency") + 
    ggtitle("Fastball-ratio") + 
    theme(plot.title=element_text(size=20, face="bold"))
  # make plot by using polychart.js
  rp = rPlot(freq~count, data = data_count, color="pitch", type="bar") 
    
  return(rp)
}
  
```


### Fastball-ratio of Hiroki Kuroda (NYY).

```r
plot = fast_rate("Hiroki Kuroda")
plot$show("iframesrc", cdn = TRUE)
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
    &lt;div id=&#039;chart11eb26daf83f&#039; class=&#039;rChart polycharts&#039;&gt;&lt;/div&gt;  
    
    &lt;script type=&#039;text/javascript&#039;&gt;
    var chartParams = {
 &quot;dom&quot;: &quot;chart11eb26daf83f&quot;,
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
&quot;id&quot;: &quot;chart11eb26daf83f&quot; 
}
    _.each(chartParams.layers, function(el){
        el.data = polyjs.data(el.data)
    })
    var graph_chart11eb26daf83f = polyjs.chart(chartParams);
&lt;/script&gt;
    
  &lt;/body&gt;
&lt;/html&gt;
' scrolling='no' seamless class='rChart 
polycharts
 '
id=iframe-
chart11eb26daf83f
></iframe>
<style>iframe.rChart{ width: 100%; height: 400px;}</style>

```r

```


### Fastball-ratio of Yu Darvish (TEX).

```r
plot = fast_rate("Yu Darvish")
plot$show("iframesrc", cdn = TRUE)
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
    &lt;div id=&#039;chart11eb2a286052&#039; class=&#039;rChart polycharts&#039;&gt;&lt;/div&gt;  
    
    &lt;script type=&#039;text/javascript&#039;&gt;
    var chartParams = {
 &quot;dom&quot;: &quot;chart11eb2a286052&quot;,
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
&quot;id&quot;: &quot;chart11eb2a286052&quot; 
}
    _.each(chartParams.layers, function(el){
        el.data = polyjs.data(el.data)
    })
    var graph_chart11eb2a286052 = polyjs.chart(chartParams);
&lt;/script&gt;
    
  &lt;/body&gt;
&lt;/html&gt;
' scrolling='no' seamless class='rChart 
polycharts
 '
id=iframe-
chart11eb2a286052
></iframe>
<style>iframe.rChart{ width: 100%; height: 400px;}</style>


### Fastball-ratio of Clayton Kershaw (LAD).

```r
plot = fast_rate("Clayton Kershaw")
plot$show("iframesrc", cdn = TRUE)
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
    &lt;div id=&#039;chart11eb7fecdc26&#039; class=&#039;rChart polycharts&#039;&gt;&lt;/div&gt;  
    
    &lt;script type=&#039;text/javascript&#039;&gt;
    var chartParams = {
 &quot;dom&quot;: &quot;chart11eb7fecdc26&quot;,
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
&quot;id&quot;: &quot;chart11eb7fecdc26&quot; 
}
    _.each(chartParams.layers, function(el){
        el.data = polyjs.data(el.data)
    })
    var graph_chart11eb7fecdc26 = polyjs.chart(chartParams);
&lt;/script&gt;
    
  &lt;/body&gt;
&lt;/html&gt;
' scrolling='no' seamless class='rChart 
polycharts
 '
id=iframe-
chart11eb7fecdc26
></iframe>
<style>iframe.rChart{ width: 100%; height: 400px;}</style>

```r

```

