rChartsを使ってレジェンドプレーヤーの成績を可視化したい
========================================================




Lahmanのデータベースを使って, 歴代の投手成績推移をrChartsで可視化します.

データは
http://seanlahman.com/files/database/lahman-csv_2014-02-14.zip
でダウンロードできます. 

解凍したら, Pitching.csvとMaster.csvを使います.

今回は, 250勝以上した投手の成績の伸び具合を見てみます.


```r
library(RPostgreSQL)
library(dplyr)
library(magrittr)
library(xtable)
# 投手成績が入ったデータ: Pitching.csv
pitch_data = fread("Pitching.csv")
# できたデータ
pitch_data %>% head %>% xtable() %>% print(type="html")
```

<!-- html table generated in R 3.0.2 by xtable 1.7-3 package -->
<!-- Sun Mar 23 18:21:20 2014 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH> playerID </TH> <TH> yearID </TH> <TH> stint </TH> <TH> teamID </TH> <TH> lgID </TH> <TH> W </TH> <TH> L </TH> <TH> G </TH> <TH> GS </TH> <TH> CG </TH> <TH> SHO </TH> <TH> SV </TH> <TH> IPouts </TH> <TH> H </TH> <TH> ER </TH> <TH> HR </TH> <TH> BB </TH> <TH> SO </TH> <TH> BAOpp </TH> <TH> ERA </TH> <TH> IBB </TH> <TH> WP </TH> <TH> HBP </TH> <TH> BK </TH> <TH> BFP </TH> <TH> GF </TH> <TH> R </TH> <TH> SH </TH> <TH> SF </TH> <TH> GIDP </TH>  </TR>
  <TR> <TD align="right"> 1 </TD> <TD> bechtge01 </TD> <TD align="right"> 1871 </TD> <TD align="right">   1 </TD> <TD> PH1 </TD> <TD>  </TD> <TD align="right">   1 </TD> <TD align="right">   2 </TD> <TD align="right">   3 </TD> <TD align="right">   3 </TD> <TD align="right">   2 </TD> <TD align="right">   0 </TD> <TD align="right">   0 </TD> <TD align="right">  78 </TD> <TD align="right">  43 </TD> <TD align="right">  23 </TD> <TD align="right">   0 </TD> <TD align="right">  11 </TD> <TD align="right">   1 </TD> <TD align="right">  </TD> <TD align="right"> 7.96 </TD> <TD align="right">  </TD> <TD align="right">  </TD> <TD align="right">  </TD> <TD align="right">   0 </TD> <TD align="right">  </TD> <TD align="right">  </TD> <TD align="right">  42 </TD> <TD align="right">  </TD> <TD align="right">  </TD> <TD align="right">  </TD> </TR>
  <TR> <TD align="right"> 2 </TD> <TD> brainas01 </TD> <TD align="right"> 1871 </TD> <TD align="right">   1 </TD> <TD> WS3 </TD> <TD>  </TD> <TD align="right">  12 </TD> <TD align="right">  15 </TD> <TD align="right">  30 </TD> <TD align="right">  30 </TD> <TD align="right">  30 </TD> <TD align="right">   0 </TD> <TD align="right">   0 </TD> <TD align="right"> 792 </TD> <TD align="right"> 361 </TD> <TD align="right"> 132 </TD> <TD align="right">   4 </TD> <TD align="right">  37 </TD> <TD align="right">  13 </TD> <TD align="right">  </TD> <TD align="right"> 4.50 </TD> <TD align="right">  </TD> <TD align="right">  </TD> <TD align="right">  </TD> <TD align="right">   0 </TD> <TD align="right">  </TD> <TD align="right">  </TD> <TD align="right"> 292 </TD> <TD align="right">  </TD> <TD align="right">  </TD> <TD align="right">  </TD> </TR>
  <TR> <TD align="right"> 3 </TD> <TD> fergubo01 </TD> <TD align="right"> 1871 </TD> <TD align="right">   1 </TD> <TD> NY2 </TD> <TD>  </TD> <TD align="right">   0 </TD> <TD align="right">   0 </TD> <TD align="right">   1 </TD> <TD align="right">   0 </TD> <TD align="right">   0 </TD> <TD align="right">   0 </TD> <TD align="right">   0 </TD> <TD align="right">   3 </TD> <TD align="right">   8 </TD> <TD align="right">   3 </TD> <TD align="right">   0 </TD> <TD align="right">   0 </TD> <TD align="right">   0 </TD> <TD align="right">  </TD> <TD align="right"> 27.00 </TD> <TD align="right">  </TD> <TD align="right">  </TD> <TD align="right">  </TD> <TD align="right">   0 </TD> <TD align="right">  </TD> <TD align="right">  </TD> <TD align="right">   9 </TD> <TD align="right">  </TD> <TD align="right">  </TD> <TD align="right">  </TD> </TR>
  <TR> <TD align="right"> 4 </TD> <TD> fishech01 </TD> <TD align="right"> 1871 </TD> <TD align="right">   1 </TD> <TD> RC1 </TD> <TD>  </TD> <TD align="right">   4 </TD> <TD align="right">  16 </TD> <TD align="right">  24 </TD> <TD align="right">  24 </TD> <TD align="right">  22 </TD> <TD align="right">   1 </TD> <TD align="right">   0 </TD> <TD align="right"> 639 </TD> <TD align="right"> 295 </TD> <TD align="right"> 103 </TD> <TD align="right">   3 </TD> <TD align="right">  31 </TD> <TD align="right">  15 </TD> <TD align="right">  </TD> <TD align="right"> 4.35 </TD> <TD align="right">  </TD> <TD align="right">  </TD> <TD align="right">  </TD> <TD align="right">   0 </TD> <TD align="right">  </TD> <TD align="right">  </TD> <TD align="right"> 257 </TD> <TD align="right">  </TD> <TD align="right">  </TD> <TD align="right">  </TD> </TR>
  <TR> <TD align="right"> 5 </TD> <TD> fleetfr01 </TD> <TD align="right"> 1871 </TD> <TD align="right">   1 </TD> <TD> NY2 </TD> <TD>  </TD> <TD align="right">   0 </TD> <TD align="right">   1 </TD> <TD align="right">   1 </TD> <TD align="right">   1 </TD> <TD align="right">   1 </TD> <TD align="right">   0 </TD> <TD align="right">   0 </TD> <TD align="right">  27 </TD> <TD align="right">  20 </TD> <TD align="right">  10 </TD> <TD align="right">   0 </TD> <TD align="right">   3 </TD> <TD align="right">   0 </TD> <TD align="right">  </TD> <TD align="right"> 10.00 </TD> <TD align="right">  </TD> <TD align="right">  </TD> <TD align="right">  </TD> <TD align="right">   0 </TD> <TD align="right">  </TD> <TD align="right">  </TD> <TD align="right">  21 </TD> <TD align="right">  </TD> <TD align="right">  </TD> <TD align="right">  </TD> </TR>
  <TR> <TD align="right"> 6 </TD> <TD> flowedi01 </TD> <TD align="right"> 1871 </TD> <TD align="right">   1 </TD> <TD> TRO </TD> <TD>  </TD> <TD align="right">   0 </TD> <TD align="right">   0 </TD> <TD align="right">   1 </TD> <TD align="right">   0 </TD> <TD align="right">   0 </TD> <TD align="right">   0 </TD> <TD align="right">   0 </TD> <TD align="right">   3 </TD> <TD align="right">   1 </TD> <TD align="right">   0 </TD> <TD align="right">   0 </TD> <TD align="right">   0 </TD> <TD align="right">   0 </TD> <TD align="right">  </TD> <TD align="right"> 0.00 </TD> <TD align="right">  </TD> <TD align="right">  </TD> <TD align="right">  </TD> <TD align="right">   0 </TD> <TD align="right">  </TD> <TD align="right">  </TD> <TD align="right">   0 </TD> <TD align="right">  </TD> <TD align="right">  </TD> <TD align="right">  </TD> </TR>
   </TABLE>

```r

# 各種選手情報が入ったデータ: Master.csv
master = fread("Master.csv")

# 250勝以上した投手を調べる
over250wins = pitch_data %>% 
  dplyr::select(playerID, W) %>% 
  group_by(playerID) %>% 
  dplyr::summarise(win = sum(W)) %>% 
  filter(win >= 250) %>% 
  dplyr::arrange(desc(win)) 

# 250勝以上した投手のデータを調べる
data_over250wins = inner_join(pitch_data, over250wins, by = "playerID") %>% as.data.table()

# シーズン途中で移籍した場合を考えて, 同じ年のデータはマージ
data_over250wins = 
  data_over250wins %>% 
  group_by(playerID, yearID) %>% 
  dplyr::summarise(win = sum(W), 
                   lose = sum(L), 
                   hit = sum(H), 
                   so = sum(SO),
                   hr = sum(HR), 
                   bb = sum(BB))

# フルネームを調べてマージ
fullname_id = 
  master %>% mutate(fullname = paste(nameFirst, nameLast, sep=" ")) %>% 
  select(lahman40ID, fullname) %>% 
  setnames(c("playerID", "fullname"))

data_over250wins_fullname = 
  data_over250wins %>% inner_join(fullname_id, by = "playerID")

# 通算成績を調べるためにcumsumする
career_data = 
  data_over250wins_fullname %>% 
  group_by(fullname) %>% 
  dplyr::summarise(year = yearID, 
                   careerWIN = cumsum(win), 
                   careerHR = cumsum(hr), 
                   careerSO = cumsum(so), 
                   careerBB = cumsum(bb))
# できたデータ
career_data %>% head %>% xtable %>% print(type="html")
```

<!-- html table generated in R 3.0.2 by xtable 1.7-3 package -->
<!-- Sun Mar 23 18:21:21 2014 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH> playerID </TH> <TH> fullname </TH> <TH> year </TH> <TH> careerWIN </TH> <TH> careerHR </TH> <TH> careerSO </TH> <TH> careerBB </TH>  </TR>
  <TR> <TD align="right"> 1 </TD> <TD> alexape01 </TD> <TD> Pete Alexander </TD> <TD align="right"> 1911 </TD> <TD align="right">  28 </TD> <TD align="right">   5 </TD> <TD align="right"> 227 </TD> <TD align="right"> 129 </TD> </TR>
  <TR> <TD align="right"> 2 </TD> <TD> alexape01 </TD> <TD> Pete Alexander </TD> <TD align="right"> 1912 </TD> <TD align="right">  47 </TD> <TD align="right">  16 </TD> <TD align="right"> 422 </TD> <TD align="right"> 234 </TD> </TR>
  <TR> <TD align="right"> 3 </TD> <TD> alexape01 </TD> <TD> Pete Alexander </TD> <TD align="right"> 1913 </TD> <TD align="right">  69 </TD> <TD align="right">  25 </TD> <TD align="right"> 581 </TD> <TD align="right"> 309 </TD> </TR>
  <TR> <TD align="right"> 4 </TD> <TD> alexape01 </TD> <TD> Pete Alexander </TD> <TD align="right"> 1914 </TD> <TD align="right">  96 </TD> <TD align="right">  33 </TD> <TD align="right"> 795 </TD> <TD align="right"> 385 </TD> </TR>
  <TR> <TD align="right"> 5 </TD> <TD> alexape01 </TD> <TD> Pete Alexander </TD> <TD align="right"> 1915 </TD> <TD align="right"> 127 </TD> <TD align="right">  36 </TD> <TD align="right"> 1036 </TD> <TD align="right"> 449 </TD> </TR>
  <TR> <TD align="right"> 6 </TD> <TD> alexape01 </TD> <TD> Pete Alexander </TD> <TD align="right"> 1916 </TD> <TD align="right"> 160 </TD> <TD align="right">  42 </TD> <TD align="right"> 1203 </TD> <TD align="right"> 499 </TD> </TR>
   </TABLE>

通算勝利数の推移を可視化してみます. 
nPlotが不安定なので, hPlotします. 

```r
library(rCharts)
hp = hPlot(data = career_data, x = "year", y = "careerWIN", group="fullname", type= "line")
hp$show("iframesrc", cdn = TRUE)
```

<iframe srcdoc='
&lt;!doctype HTML&gt;
&lt;meta charset = &#039;utf-8&#039;&gt;
&lt;html&gt;
  &lt;head&gt;
    
    &lt;script src=&#039;http://code.jquery.com/jquery-1.9.1.min.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    &lt;script src=&#039;http://code.highcharts.com/highcharts.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    &lt;script src=&#039;http://code.highcharts.com/highcharts-more.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    &lt;script src=&#039;http://code.highcharts.com/modules/exporting.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    
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
    &lt;div id=&#039;chart918370c435f7&#039; class=&#039;rChart highcharts&#039;&gt;&lt;/div&gt;  
    
    &lt;script type=&#039;text/javascript&#039;&gt;
    (function($){
        $(function () {
            var chart = new Highcharts.Chart({
 &quot;dom&quot;: &quot;chart918370c435f7&quot;,
&quot;width&quot;:            800,
&quot;height&quot;:            400,
&quot;credits&quot;: {
 &quot;href&quot;: null,
&quot;text&quot;: null 
},
&quot;exporting&quot;: {
 &quot;enabled&quot;: false 
},
&quot;title&quot;: {
 &quot;text&quot;: null 
},
&quot;yAxis&quot;: [
 {
 &quot;title&quot;: {
 &quot;text&quot;: &quot;careerWIN&quot; 
} 
} 
],
&quot;series&quot;: [
 {
 &quot;data&quot;: [
 [
 1871,
19 
],
[
 1872,
57 
],
[
 1873,
98 
],
[
 1874,
150 
],
[
 1875,
205 
],
[
 1876,
252 
],
[
 1877,
253 
] 
],
&quot;name&quot;: &quot;Al Spalding&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1995,
12 
],
[
 1996,
33 
],
[
 1997,
51 
],
[
 1998,
67 
],
[
 1999,
81 
],
[
 2000,
100 
],
[
 2001,
115 
],
[
 2002,
128 
],
[
 2003,
149 
],
[
 2004,
155 
],
[
 2005,
172 
],
[
 2006,
186 
],
[
 2007,
201 
],
[
 2008,
215 
],
[
 2009,
229 
],
[
 2010,
240 
],
[
 2012,
245 
],
[
 2013,
256 
] 
],
&quot;name&quot;: &quot;Andy Pettitte&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1970,
10 
],
[
 1971,
26 
],
[
 1972,
43 
],
[
 1973,
63 
],
[
 1974,
80 
],
[
 1975,
95 
],
[
 1976,
108 
],
[
 1977,
122 
],
[
 1978,
136 
],
[
 1979,
148 
],
[
 1980,
156 
],
[
 1981,
167 
],
[
 1982,
169 
],
[
 1983,
176 
],
[
 1984,
195 
],
[
 1985,
212 
],
[
 1986,
229 
],
[
 1987,
244 
],
[
 1988,
254 
],
[
 1989,
271 
],
[
 1990,
279 
],
[
 1992,
287 
] 
],
&quot;name&quot;: &quot;Bert Blyleven&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1936,
5 
],
[
 1937,
14 
],
[
 1938,
31 
],
[
 1939,
55 
],
[
 1940,
82 
],
[
 1941,
107 
],
[
 1945,
112 
],
[
 1946,
138 
],
[
 1947,
158 
],
[
 1948,
177 
],
[
 1949,
192 
],
[
 1950,
208 
],
[
 1951,
230 
],
[
 1952,
239 
],
[
 1953,
249 
],
[
 1954,
262 
],
[
 1955,
266 
],
[
 1956,
266 
] 
],
&quot;name&quot;: &quot;Bob Feller&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1959,
3 
],
[
 1960,
6 
],
[
 1961,
19 
],
[
 1962,
34 
],
[
 1963,
52 
],
[
 1964,
71 
],
[
 1965,
91 
],
[
 1966,
112 
],
[
 1967,
125 
],
[
 1968,
147 
],
[
 1969,
167 
],
[
 1970,
190 
],
[
 1971,
206 
],
[
 1972,
225 
],
[
 1973,
237 
],
[
 1974,
248 
],
[
 1975,
251 
] 
],
&quot;name&quot;: &quot;Bob Gibson&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1871,
6 
],
[
 1872,
31 
],
[
 1873,
60 
],
[
 1874,
102 
],
[
 1875,
131 
],
[
 1876,
152 
],
[
 1877,
155 
],
[
 1879,
167 
],
[
 1881,
172 
],
[
 1882,
191 
],
[
 1883,
221 
],
[
 1884,
251 
],
[
 1885,
281 
],
[
 1886,
294 
],
[
 1887,
297 
] 
],
&quot;name&quot;: &quot;Bobby Mathews&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1916,
2 
],
[
 1917,
5 
],
[
 1918,
24 
],
[
 1919,
34 
],
[
 1920,
57 
],
[
 1921,
79 
],
[
 1922,
96 
],
[
 1923,
117 
],
[
 1924,
139 
],
[
 1925,
151 
],
[
 1926,
163 
],
[
 1927,
182 
],
[
 1928,
207 
],
[
 1929,
224 
],
[
 1930,
240 
],
[
 1931,
257 
],
[
 1932,
263 
],
[
 1933,
266 
],
[
 1934,
270 
] 
],
&quot;name&quot;: &quot;Burleigh Grimes&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1928,
10 
],
[
 1929,
28 
],
[
 1930,
45 
],
[
 1931,
59 
],
[
 1932,
77 
],
[
 1933,
100 
],
[
 1934,
121 
],
[
 1935,
144 
],
[
 1936,
170 
],
[
 1937,
192 
],
[
 1938,
205 
],
[
 1939,
216 
],
[
 1940,
227 
],
[
 1941,
238 
],
[
 1942,
249 
],
[
 1943,
253 
] 
],
&quot;name&quot;: &quot;Carl Hubbell&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1881,
25 
],
[
 1882,
58 
],
[
 1883,
106 
],
[
 1884,
165 
],
[
 1885,
193 
],
[
 1886,
220 
],
[
 1887,
244 
],
[
 1888,
251 
],
[
 1889,
271 
],
[
 1890,
298 
],
[
 1891,
309 
] 
],
&quot;name&quot;: &quot;Charley Radbourn&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1900,
0 
],
[
 1901,
20 
],
[
 1902,
34 
],
[
 1903,
64 
],
[
 1904,
97 
],
[
 1905,
128 
],
[
 1906,
150 
],
[
 1907,
174 
],
[
 1908,
211 
],
[
 1909,
236 
],
[
 1910,
263 
],
[
 1911,
289 
],
[
 1912,
312 
],
[
 1913,
337 
],
[
 1914,
361 
],
[
 1915,
369 
],
[
 1916,
373 
] 
],
&quot;name&quot;: &quot;Christy Mathewson&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1890,
9 
],
[
 1891,
36 
],
[
 1892,
72 
],
[
 1893,
106 
],
[
 1894,
132 
],
[
 1895,
167 
],
[
 1896,
195 
],
[
 1897,
216 
],
[
 1898,
241 
],
[
 1899,
267 
],
[
 1900,
286 
],
[
 1901,
319 
],
[
 1902,
351 
],
[
 1903,
379 
],
[
 1904,
405 
],
[
 1905,
423 
],
[
 1906,
436 
],
[
 1907,
457 
],
[
 1908,
478 
],
[
 1909,
497 
],
[
 1910,
504 
],
[
 1911,
511 
] 
],
&quot;name&quot;: &quot;Cy Young&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1966,
12 
],
[
 1967,
23 
],
[
 1968,
34 
],
[
 1969,
51 
],
[
 1970,
66 
],
[
 1971,
83 
],
[
 1972,
102 
],
[
 1973,
120 
],
[
 1974,
139 
],
[
 1975,
155 
],
[
 1976,
176 
],
[
 1977,
190 
],
[
 1978,
205 
],
[
 1979,
217 
],
[
 1980,
230 
],
[
 1981,
241 
],
[
 1982,
258 
],
[
 1983,
266 
],
[
 1984,
280 
],
[
 1985,
295 
],
[
 1986,
310 
],
[
 1987,
321 
],
[
 1988,
324 
] 
],
&quot;name&quot;: &quot;Don Sutton&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1939,
0 
],
[
 1941,
3 
],
[
 1942,
13 
],
[
 1943,
31 
],
[
 1944,
39 
],
[
 1946,
47 
],
[
 1947,
64 
],
[
 1948,
72 
],
[
 1949,
83 
],
[
 1950,
101 
],
[
 1951,
121 
],
[
 1952,
144 
],
[
 1953,
161 
],
[
 1954,
184 
],
[
 1955,
201 
],
[
 1956,
221 
],
[
 1957,
235 
],
[
 1958,
249 
],
[
 1959,
271 
],
[
 1960,
284 
],
[
 1961,
292 
],
[
 1962,
299 
],
[
 1963,
300 
] 
],
&quot;name&quot;: &quot;Early Wynn&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1901,
17 
],
[
 1902,
37 
],
[
 1903,
60 
],
[
 1904,
86 
],
[
 1905,
110 
],
[
 1906,
129 
],
[
 1907,
153 
],
[
 1908,
167 
],
[
 1909,
186 
],
[
 1910,
202 
],
[
 1911,
225 
],
[
 1912,
251 
],
[
 1913,
269 
],
[
 1914,
284 
],
[
 1915,
305 
],
[
 1916,
321 
],
[
 1917,
326 
] 
],
&quot;name&quot;: &quot;Eddie Plank&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1912,
10 
],
[
 1913,
19 
],
[
 1914,
21 
],
[
 1915,
32 
],
[
 1916,
54 
],
[
 1917,
70 
],
[
 1919,
76 
],
[
 1920,
87 
],
[
 1921,
106 
],
[
 1922,
131 
],
[
 1923,
151 
],
[
 1924,
166 
],
[
 1925,
187 
],
[
 1926,
201 
],
[
 1927,
213 
],
[
 1928,
232 
],
[
 1929,
242 
],
[
 1930,
251 
],
[
 1931,
255 
],
[
 1932,
260 
],
[
 1933,
266 
] 
],
&quot;name&quot;: &quot;Eppa Rixey&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1965,
2 
],
[
 1966,
8 
],
[
 1967,
28 
],
[
 1968,
48 
],
[
 1969,
69 
],
[
 1970,
91 
],
[
 1971,
115 
],
[
 1972,
135 
],
[
 1973,
149 
],
[
 1974,
174 
],
[
 1975,
191 
],
[
 1976,
203 
],
[
 1977,
213 
],
[
 1978,
231 
],
[
 1979,
247 
],
[
 1980,
259 
],
[
 1981,
264 
],
[
 1982,
278 
],
[
 1983,
284 
] 
],
&quot;name&quot;: &quot;Fergie Jenkins&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1962,
3 
],
[
 1963,
4 
],
[
 1964,
16 
],
[
 1965,
24 
],
[
 1966,
45 
],
[
 1967,
60 
],
[
 1968,
76 
],
[
 1969,
95 
],
[
 1970,
118 
],
[
 1971,
134 
],
[
 1972,
158 
],
[
 1973,
177 
],
[
 1974,
198 
],
[
 1975,
216 
],
[
 1976,
231 
],
[
 1977,
246 
],
[
 1978,
267 
],
[
 1979,
279 
],
[
 1980,
289 
],
[
 1981,
297 
],
[
 1982,
307 
],
[
 1983,
314 
] 
],
&quot;name&quot;: &quot;Gaylord Perry&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1986,
2 
],
[
 1987,
8 
],
[
 1988,
26 
],
[
 1989,
45 
],
[
 1990,
60 
],
[
 1991,
75 
],
[
 1992,
95 
],
[
 1993,
115 
],
[
 1994,
131 
],
[
 1995,
150 
],
[
 1996,
165 
],
[
 1997,
184 
],
[
 1998,
202 
],
[
 1999,
221 
],
[
 2000,
240 
],
[
 2001,
257 
],
[
 2002,
273 
],
[
 2003,
289 
],
[
 2004,
305 
],
[
 2005,
318 
],
[
 2006,
333 
],
[
 2007,
347 
],
[
 2008,
355 
] 
],
&quot;name&quot;: &quot;Greg Maddux&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1887,
26 
],
[
 1888,
54 
],
[
 1889,
84 
],
[
 1890,
114 
],
[
 1891,
145 
],
[
 1892,
177 
],
[
 1893,
200 
],
[
 1894,
216 
],
[
 1895,
224 
],
[
 1896,
226 
],
[
 1898,
241 
],
[
 1899,
258 
],
[
 1900,
264 
],
[
 1901,
264 
] 
],
&quot;name&quot;: &quot;Gus Weyhing&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1977,
1 
],
[
 1978,
4 
],
[
 1979,
21 
],
[
 1980,
37 
],
[
 1981,
51 
],
[
 1982,
68 
],
[
 1983,
88 
],
[
 1984,
107 
],
[
 1985,
123 
],
[
 1986,
144 
],
[
 1987,
162 
],
[
 1988,
177 
],
[
 1989,
183 
],
[
 1990,
198 
],
[
 1991,
216 
],
[
 1992,
237 
],
[
 1993,
244 
],
[
 1994,
254 
] 
],
&quot;name&quot;: &quot;Jack Morris&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1986,
7 
],
[
 1987,
19 
],
[
 1988,
28 
],
[
 1989,
32 
],
[
 1990,
34 
],
[
 1991,
34 
],
[
 1993,
46 
],
[
 1994,
51 
],
[
 1995,
59 
],
[
 1996,
72 
],
[
 1997,
89 
],
[
 1998,
104 
],
[
 1999,
118 
],
[
 2000,
131 
],
[
 2001,
151 
],
[
 2002,
164 
],
[
 2003,
185 
],
[
 2004,
192 
],
[
 2005,
205 
],
[
 2006,
216 
],
[
 2007,
230 
],
[
 2008,
246 
],
[
 2009,
258 
],
[
 2010,
267 
],
[
 2012,
269 
] 
],
&quot;name&quot;: &quot;Jamie Moyer&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1959,
0 
],
[
 1960,
1 
],
[
 1961,
10 
],
[
 1962,
28 
],
[
 1963,
38 
],
[
 1964,
55 
],
[
 1965,
73 
],
[
 1966,
98 
],
[
 1967,
114 
],
[
 1968,
128 
],
[
 1969,
142 
],
[
 1970,
156 
],
[
 1971,
169 
],
[
 1972,
179 
],
[
 1973,
194 
],
[
 1974,
215 
],
[
 1975,
235 
],
[
 1976,
247 
],
[
 1977,
253 
],
[
 1978,
261 
],
[
 1979,
264 
],
[
 1980,
272 
],
[
 1981,
278 
],
[
 1982,
283 
],
[
 1983,
283 
] 
],
&quot;name&quot;: &quot;Jim Kaat&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1878,
5 
],
[
 1879,
25 
],
[
 1880,
70 
],
[
 1881,
96 
],
[
 1882,
132 
],
[
 1883,
160 
],
[
 1884,
200 
],
[
 1885,
221 
],
[
 1886,
252 
],
[
 1887,
265 
] 
],
&quot;name&quot;: &quot;Jim McCormick&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1965,
5 
],
[
 1966,
20 
],
[
 1967,
23 
],
[
 1969,
39 
],
[
 1970,
59 
],
[
 1971,
79 
],
[
 1972,
100 
],
[
 1973,
122 
],
[
 1974,
129 
],
[
 1975,
152 
],
[
 1976,
174 
],
[
 1977,
194 
],
[
 1978,
215 
],
[
 1979,
225 
],
[
 1980,
241 
],
[
 1981,
248 
],
[
 1982,
263 
],
[
 1983,
268 
],
[
 1984,
268 
] 
],
&quot;name&quot;: &quot;Jim Palmer&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1882,
1 
],
[
 1884,
11 
],
[
 1885,
64 
],
[
 1886,
100 
],
[
 1887,
138 
],
[
 1888,
171 
],
[
 1889,
220 
],
[
 1890,
246 
],
[
 1891,
279 
],
[
 1892,
304 
],
[
 1893,
320 
],
[
 1894,
328 
] 
],
&quot;name&quot;: &quot;John Clarkson&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1890,
27 
],
[
 1891,
57 
],
[
 1892,
92 
],
[
 1893,
126 
],
[
 1894,
158 
],
[
 1895,
184 
],
[
 1896,
214 
],
[
 1897,
245 
],
[
 1898,
276 
],
[
 1899,
297 
],
[
 1900,
310 
],
[
 1901,
329 
],
[
 1904,
350 
],
[
 1905,
361 
],
[
 1906,
361 
] 
],
&quot;name&quot;: &quot;Kid Nichols&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1925,
10 
],
[
 1926,
23 
],
[
 1927,
43 
],
[
 1928,
67 
],
[
 1929,
87 
],
[
 1930,
115 
],
[
 1931,
146 
],
[
 1932,
171 
],
[
 1933,
195 
],
[
 1934,
203 
],
[
 1935,
223 
],
[
 1936,
240 
],
[
 1937,
257 
],
[
 1938,
271 
],
[
 1939,
286 
],
[
 1940,
293 
],
[
 1941,
300 
] 
],
&quot;name&quot;: &quot;Lefty Grove&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1880,
34 
],
[
 1881,
55 
],
[
 1882,
69 
],
[
 1883,
94 
],
[
 1884,
133 
],
[
 1885,
177 
],
[
 1886,
210 
],
[
 1887,
232 
],
[
 1888,
258 
],
[
 1889,
285 
],
[
 1890,
302 
],
[
 1891,
307 
],
[
 1892,
307 
] 
],
&quot;name&quot;: &quot;Mickey Welch&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1991,
4 
],
[
 1992,
22 
],
[
 1993,
36 
],
[
 1994,
52 
],
[
 1995,
71 
],
[
 1996,
90 
],
[
 1997,
105 
],
[
 1998,
118 
],
[
 1999,
136 
],
[
 2000,
147 
],
[
 2001,
164 
],
[
 2002,
182 
],
[
 2003,
199 
],
[
 2004,
211 
],
[
 2005,
224 
],
[
 2006,
239 
],
[
 2007,
250 
],
[
 2008,
270 
] 
],
&quot;name&quot;: &quot;Mike Mussina&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1966,
0 
],
[
 1968,
6 
],
[
 1969,
12 
],
[
 1970,
19 
],
[
 1971,
29 
],
[
 1972,
48 
],
[
 1973,
69 
],
[
 1974,
91 
],
[
 1975,
105 
],
[
 1976,
122 
],
[
 1977,
141 
],
[
 1978,
151 
],
[
 1979,
167 
],
[
 1980,
178 
],
[
 1981,
189 
],
[
 1982,
205 
],
[
 1983,
219 
],
[
 1984,
231 
],
[
 1985,
241 
],
[
 1986,
253 
],
[
 1987,
261 
],
[
 1988,
273 
],
[
 1989,
289 
],
[
 1990,
302 
],
[
 1991,
314 
],
[
 1992,
319 
],
[
 1993,
324 
] 
],
&quot;name&quot;: &quot;Nolan Ryan&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1911,
28 
],
[
 1912,
47 
],
[
 1913,
69 
],
[
 1914,
96 
],
[
 1915,
127 
],
[
 1916,
160 
],
[
 1917,
190 
],
[
 1918,
192 
],
[
 1919,
208 
],
[
 1920,
235 
],
[
 1921,
250 
],
[
 1922,
266 
],
[
 1923,
288 
],
[
 1924,
300 
],
[
 1925,
315 
],
[
 1926,
327 
],
[
 1927,
348 
],
[
 1928,
364 
],
[
 1929,
373 
],
[
 1930,
373 
] 
],
&quot;name&quot;: &quot;Pete Alexander&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1964,
0 
],
[
 1965,
2 
],
[
 1966,
6 
],
[
 1967,
17 
],
[
 1968,
31 
],
[
 1969,
54 
],
[
 1970,
66 
],
[
 1971,
81 
],
[
 1972,
97 
],
[
 1973,
110 
],
[
 1974,
130 
],
[
 1975,
145 
],
[
 1976,
162 
],
[
 1977,
178 
],
[
 1978,
197 
],
[
 1979,
218 
],
[
 1980,
233 
],
[
 1981,
240 
],
[
 1982,
257 
],
[
 1983,
268 
],
[
 1984,
284 
],
[
 1985,
300 
],
[
 1986,
311 
],
[
 1987,
318 
] 
],
&quot;name&quot;: &quot;Phil Niekro&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1875,
4 
],
[
 1879,
41 
],
[
 1880,
61 
],
[
 1881,
89 
],
[
 1882,
117 
],
[
 1883,
163 
],
[
 1884,
209 
],
[
 1885,
225 
],
[
 1886,
254 
],
[
 1887,
282 
],
[
 1888,
305 
],
[
 1889,
328 
],
[
 1890,
340 
],
[
 1891,
354 
],
[
 1892,
364 
] 
],
&quot;name&quot;: &quot;Pud Galvin&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1988,
3 
],
[
 1989,
10 
],
[
 1990,
24 
],
[
 1991,
37 
],
[
 1992,
49 
],
[
 1993,
68 
],
[
 1994,
81 
],
[
 1995,
99 
],
[
 1996,
104 
],
[
 1997,
124 
],
[
 1998,
143 
],
[
 1999,
160 
],
[
 2000,
179 
],
[
 2001,
200 
],
[
 2002,
224 
],
[
 2003,
230 
],
[
 2004,
246 
],
[
 2005,
263 
],
[
 2006,
280 
],
[
 2007,
284 
],
[
 2008,
295 
],
[
 2009,
303 
] 
],
&quot;name&quot;: &quot;Randy Johnson&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1914,
10 
],
[
 1915,
34 
],
[
 1916,
51 
],
[
 1917,
67 
],
[
 1918,
71 
],
[
 1919,
82 
],
[
 1920,
105 
],
[
 1921,
130 
],
[
 1922,
151 
],
[
 1923,
165 
],
[
 1924,
174 
],
[
 1925,
186 
],
[
 1926,
201 
],
[
 1927,
205 
],
[
 1928,
218 
],
[
 1929,
231 
],
[
 1930,
239 
],
[
 1931,
249 
],
[
 1932,
251 
],
[
 1933,
254 
] 
],
&quot;name&quot;: &quot;Red Faber&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1924,
0 
],
[
 1925,
9 
],
[
 1926,
15 
],
[
 1927,
20 
],
[
 1928,
30 
],
[
 1929,
39 
],
[
 1930,
54 
],
[
 1931,
70 
],
[
 1932,
88 
],
[
 1933,
97 
],
[
 1934,
116 
],
[
 1935,
132 
],
[
 1936,
152 
],
[
 1937,
172 
],
[
 1938,
193 
],
[
 1939,
214 
],
[
 1940,
229 
],
[
 1941,
244 
],
[
 1942,
258 
],
[
 1945,
265 
],
[
 1946,
270 
],
[
 1947,
273 
] 
],
&quot;name&quot;: &quot;Red Ruffing&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1948,
7 
],
[
 1949,
22 
],
[
 1950,
42 
],
[
 1951,
63 
],
[
 1952,
91 
],
[
 1953,
114 
],
[
 1954,
137 
],
[
 1955,
160 
],
[
 1956,
179 
],
[
 1957,
189 
],
[
 1958,
206 
],
[
 1959,
221 
],
[
 1960,
233 
],
[
 1961,
234 
],
[
 1962,
244 
],
[
 1963,
258 
],
[
 1964,
271 
],
[
 1965,
281 
],
[
 1966,
286 
] 
],
&quot;name&quot;: &quot;Robin Roberts&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1984,
9 
],
[
 1985,
16 
],
[
 1986,
40 
],
[
 1987,
60 
],
[
 1988,
78 
],
[
 1989,
95 
],
[
 1990,
116 
],
[
 1991,
134 
],
[
 1992,
152 
],
[
 1993,
163 
],
[
 1994,
172 
],
[
 1995,
182 
],
[
 1996,
192 
],
[
 1997,
213 
],
[
 1998,
233 
],
[
 1999,
247 
],
[
 2000,
260 
],
[
 2001,
280 
],
[
 2002,
293 
],
[
 2003,
310 
],
[
 2004,
328 
],
[
 2005,
341 
],
[
 2006,
348 
],
[
 2007,
354 
] 
],
&quot;name&quot;: &quot;Roger Clemens&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1965,
0 
],
[
 1966,
3 
],
[
 1967,
17 
],
[
 1968,
30 
],
[
 1969,
47 
],
[
 1970,
57 
],
[
 1971,
77 
],
[
 1972,
104 
],
[
 1973,
117 
],
[
 1974,
133 
],
[
 1975,
148 
],
[
 1976,
168 
],
[
 1977,
191 
],
[
 1978,
207 
],
[
 1979,
225 
],
[
 1980,
249 
],
[
 1981,
262 
],
[
 1982,
285 
],
[
 1983,
300 
],
[
 1984,
313 
],
[
 1985,
314 
],
[
 1986,
323 
],
[
 1987,
329 
],
[
 1988,
329 
] 
],
&quot;name&quot;: &quot;Steve Carlton&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1923,
2 
],
[
 1924,
14 
],
[
 1925,
35 
],
[
 1926,
53 
],
[
 1927,
75 
],
[
 1928,
90 
],
[
 1929,
104 
],
[
 1930,
126 
],
[
 1931,
130 
],
[
 1932,
140 
],
[
 1933,
150 
],
[
 1934,
161 
],
[
 1935,
176 
],
[
 1936,
186 
],
[
 1937,
198 
],
[
 1938,
207 
],
[
 1939,
221 
],
[
 1940,
233 
],
[
 1941,
245 
],
[
 1942,
259 
],
[
 1946,
260 
] 
],
&quot;name&quot;: &quot;Ted Lyons&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1880,
6 
],
[
 1881,
24 
],
[
 1882,
41 
],
[
 1883,
82 
],
[
 1884,
119 
],
[
 1885,
151 
],
[
 1886,
193 
],
[
 1887,
228 
],
[
 1888,
263 
],
[
 1889,
291 
],
[
 1890,
308 
],
[
 1891,
313 
],
[
 1892,
332 
],
[
 1893,
342 
] 
],
&quot;name&quot;: &quot;Tim Keefe&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1987,
2 
],
[
 1988,
9 
],
[
 1989,
23 
],
[
 1990,
33 
],
[
 1991,
53 
],
[
 1992,
73 
],
[
 1993,
95 
],
[
 1994,
108 
],
[
 1995,
124 
],
[
 1996,
139 
],
[
 1997,
153 
],
[
 1998,
173 
],
[
 1999,
187 
],
[
 2000,
208 
],
[
 2001,
224 
],
[
 2002,
242 
],
[
 2003,
251 
],
[
 2004,
262 
],
[
 2005,
275 
],
[
 2006,
290 
],
[
 2007,
303 
],
[
 2008,
305 
] 
],
&quot;name&quot;: &quot;Tom Glavine&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1967,
16 
],
[
 1968,
32 
],
[
 1969,
57 
],
[
 1970,
75 
],
[
 1971,
95 
],
[
 1972,
116 
],
[
 1973,
135 
],
[
 1974,
146 
],
[
 1975,
168 
],
[
 1976,
182 
],
[
 1977,
203 
],
[
 1978,
219 
],
[
 1979,
235 
],
[
 1980,
245 
],
[
 1981,
259 
],
[
 1982,
264 
],
[
 1983,
273 
],
[
 1984,
288 
],
[
 1985,
304 
],
[
 1986,
311 
] 
],
&quot;name&quot;: &quot;Tom Seaver&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1963,
0 
],
[
 1964,
2 
],
[
 1965,
16 
],
[
 1966,
30 
],
[
 1967,
40 
],
[
 1968,
50 
],
[
 1969,
59 
],
[
 1970,
71 
],
[
 1971,
84 
],
[
 1972,
95 
],
[
 1973,
111 
],
[
 1974,
124 
],
[
 1976,
134 
],
[
 1977,
154 
],
[
 1978,
171 
],
[
 1979,
192 
],
[
 1980,
214 
],
[
 1981,
223 
],
[
 1982,
237 
],
[
 1983,
248 
],
[
 1984,
255 
],
[
 1985,
259 
],
[
 1986,
264 
],
[
 1987,
277 
],
[
 1988,
286 
],
[
 1989,
288 
] 
],
&quot;name&quot;: &quot;Tommy John&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1881,
1 
],
[
 1882,
31 
],
[
 1883,
66 
],
[
 1884,
102 
],
[
 1886,
135 
],
[
 1887,
166 
],
[
 1888,
192 
],
[
 1889,
203 
],
[
 1890,
215 
],
[
 1891,
238 
],
[
 1892,
259 
],
[
 1893,
277 
],
[
 1894,
284 
] 
],
&quot;name&quot;: &quot;Tony Mullane&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1907,
5 
],
[
 1908,
19 
],
[
 1909,
32 
],
[
 1910,
57 
],
[
 1911,
82 
],
[
 1912,
115 
],
[
 1913,
151 
],
[
 1914,
179 
],
[
 1915,
206 
],
[
 1916,
231 
],
[
 1917,
254 
],
[
 1918,
277 
],
[
 1919,
297 
],
[
 1920,
305 
],
[
 1921,
322 
],
[
 1922,
337 
],
[
 1923,
354 
],
[
 1924,
377 
],
[
 1925,
397 
],
[
 1926,
412 
],
[
 1927,
417 
] 
],
&quot;name&quot;: &quot;Walter Johnson&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
},
{
 &quot;data&quot;: [
 [
 1942,
0 
],
[
 1946,
8 
],
[
 1947,
29 
],
[
 1948,
44 
],
[
 1949,
65 
],
[
 1950,
86 
],
[
 1951,
108 
],
[
 1952,
122 
],
[
 1953,
145 
],
[
 1954,
166 
],
[
 1955,
183 
],
[
 1956,
203 
],
[
 1957,
224 
],
[
 1958,
246 
],
[
 1959,
267 
],
[
 1960,
288 
],
[
 1961,
309 
],
[
 1962,
327 
],
[
 1963,
350 
],
[
 1964,
356 
],
[
 1965,
363 
] 
],
&quot;name&quot;: &quot;Warren Spahn&quot;,
&quot;type&quot;: &quot;line&quot;,
&quot;marker&quot;: {
 &quot;radius&quot;:              3 
} 
} 
],
&quot;xAxis&quot;: [
 {
 &quot;title&quot;: {
 &quot;text&quot;: &quot;year&quot; 
} 
} 
],
&quot;subtitle&quot;: {
 &quot;text&quot;: null 
},
&quot;id&quot;: &quot;chart918370c435f7&quot;,
&quot;chart&quot;: {
 &quot;renderTo&quot;: &quot;chart918370c435f7&quot; 
} 
});
        });
    })(jQuery);
&lt;/script&gt;
    
  &lt;/body&gt;
&lt;/html&gt;
' scrolling='no' seamless class='rChart 
highcharts
 '
id=iframe-
chart918370c435f7
></iframe>
<style>iframe.rChart{ width: 100%; height: 400px;}</style>




```r
np = nPlot(data = career_data, careerWIN ~ year, group = "fullname", type="lineChart")
np$show("iframesrc", cdn = TRUE)
```

<iframe srcdoc='
&lt;!doctype HTML&gt;
&lt;meta charset = &#039;utf-8&#039;&gt;
&lt;html&gt;
  &lt;head&gt;
    &lt;link rel=&#039;stylesheet&#039; href=&#039;http://nvd3.org/src/nv.d3.css&#039;&gt;
    
    &lt;script src=&#039;http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    &lt;script src=&#039;http://d3js.org/d3.v3.min.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    &lt;script src=&#039;http://timelyportfolio.github.io/rCharts_nvd3_tests/libraries/widgets/nvd3/js/nv.d3.min-new.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    &lt;script src=&#039;http://nvd3.org/lib/fisheye.js&#039; type=&#039;text/javascript&#039;&gt;&lt;/script&gt;
    
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
    &lt;div id=&#039;chart91833840063d&#039; class=&#039;rChart nvd3&#039;&gt;&lt;/div&gt;  
    
    &lt;script type=&#039;text/javascript&#039;&gt;
 $(document).ready(function(){
      drawchart91833840063d()
    });
    function drawchart91833840063d(){  
      var opts = {
 &quot;dom&quot;: &quot;chart91833840063d&quot;,
&quot;width&quot;:    800,
&quot;height&quot;:    400,
&quot;x&quot;: &quot;year&quot;,
&quot;y&quot;: &quot;careerWIN&quot;,
&quot;group&quot;: &quot;fullname&quot;,
&quot;type&quot;: &quot;lineChart&quot;,
&quot;id&quot;: &quot;chart91833840063d&quot; 
},
        data = [
 {
 &quot;playerID&quot;: &quot;alexape01&quot;,
&quot;fullname&quot;: &quot;Pete Alexander&quot;,
&quot;year&quot;: 1911,
&quot;careerWIN&quot;: 28,
&quot;careerHR&quot;: 5,
&quot;careerSO&quot;: 227,
&quot;careerBB&quot;: 129 
},
{
 &quot;playerID&quot;: &quot;alexape01&quot;,
&quot;fullname&quot;: &quot;Pete Alexander&quot;,
&quot;year&quot;: 1912,
&quot;careerWIN&quot;: 47,
&quot;careerHR&quot;: 16,
&quot;careerSO&quot;: 422,
&quot;careerBB&quot;: 234 
},
{
 &quot;playerID&quot;: &quot;alexape01&quot;,
&quot;fullname&quot;: &quot;Pete Alexander&quot;,
&quot;year&quot;: 1913,
&quot;careerWIN&quot;: 69,
&quot;careerHR&quot;: 25,
&quot;careerSO&quot;: 581,
&quot;careerBB&quot;: 309 
},
{
 &quot;playerID&quot;: &quot;alexape01&quot;,
&quot;fullname&quot;: &quot;Pete Alexander&quot;,
&quot;year&quot;: 1914,
&quot;careerWIN&quot;: 96,
&quot;careerHR&quot;: 33,
&quot;careerSO&quot;: 795,
&quot;careerBB&quot;: 385 
},
{
 &quot;playerID&quot;: &quot;alexape01&quot;,
&quot;fullname&quot;: &quot;Pete Alexander&quot;,
&quot;year&quot;: 1915,
&quot;careerWIN&quot;: 127,
&quot;careerHR&quot;: 36,
&quot;careerSO&quot;: 1036,
&quot;careerBB&quot;: 449 
},
{
 &quot;playerID&quot;: &quot;alexape01&quot;,
&quot;fullname&quot;: &quot;Pete Alexander&quot;,
&quot;year&quot;: 1916,
&quot;careerWIN&quot;: 160,
&quot;careerHR&quot;: 42,
&quot;careerSO&quot;: 1203,
&quot;careerBB&quot;: 499 
},
{
 &quot;playerID&quot;: &quot;alexape01&quot;,
&quot;fullname&quot;: &quot;Pete Alexander&quot;,
&quot;year&quot;: 1917,
&quot;careerWIN&quot;: 190,
&quot;careerHR&quot;: 46,
&quot;careerSO&quot;: 1403,
&quot;careerBB&quot;: 555 
},
{
 &quot;playerID&quot;: &quot;alexape01&quot;,
&quot;fullname&quot;: &quot;Pete Alexander&quot;,
&quot;year&quot;: 1918,
&quot;careerWIN&quot;: 192,
&quot;careerHR&quot;: 46,
&quot;careerSO&quot;: 1418,
&quot;careerBB&quot;: 558 
},
{
 &quot;playerID&quot;: &quot;alexape01&quot;,
&quot;fullname&quot;: &quot;Pete Alexander&quot;,
&quot;year&quot;: 1919,
&quot;careerWIN&quot;: 208,
&quot;careerHR&quot;: 49,
&quot;careerSO&quot;: 1539,
&quot;careerBB&quot;: 596 
},
{
 &quot;playerID&quot;: &quot;alexape01&quot;,
&quot;fullname&quot;: &quot;Pete Alexander&quot;,
&quot;year&quot;: 1920,
&quot;careerWIN&quot;: 235,
&quot;careerHR&quot;: 57,
&quot;careerSO&quot;: 1712,
&quot;careerBB&quot;: 665 
},
{
 &quot;playerID&quot;: &quot;alexape01&quot;,
&quot;fullname&quot;: &quot;Pete Alexander&quot;,
&quot;year&quot;: 1921,
&quot;careerWIN&quot;: 250,
&quot;careerHR&quot;: 67,
&quot;careerSO&quot;: 1789,
&quot;careerBB&quot;: 698 
},
{
 &quot;playerID&quot;: &quot;alexape01&quot;,
&quot;fullname&quot;: &quot;Pete Alexander&quot;,
&quot;year&quot;: 1922,
&quot;careerWIN&quot;: 266,
&quot;careerHR&quot;: 75,
&quot;careerSO&quot;: 1837,
&quot;careerBB&quot;: 732 
},
{
 &quot;playerID&quot;: &quot;alexape01&quot;,
&quot;fullname&quot;: &quot;Pete Alexander&quot;,
&quot;year&quot;: 1923,
&quot;careerWIN&quot;: 288,
&quot;careerHR&quot;: 92,
&quot;careerSO&quot;: 1909,
&quot;careerBB&quot;: 762 
},
{
 &quot;playerID&quot;: &quot;alexape01&quot;,
&quot;fullname&quot;: &quot;Pete Alexander&quot;,
&quot;year&quot;: 1924,
&quot;careerWIN&quot;: 300,
&quot;careerHR&quot;: 101,
&quot;careerSO&quot;: 1942,
&quot;careerBB&quot;: 787 
},
{
 &quot;playerID&quot;: &quot;alexape01&quot;,
&quot;fullname&quot;: &quot;Pete Alexander&quot;,
&quot;year&quot;: 1925,
&quot;careerWIN&quot;: 315,
&quot;careerHR&quot;: 115,
&quot;careerSO&quot;: 2005,
&quot;careerBB&quot;: 816 
},
{
 &quot;playerID&quot;: &quot;alexape01&quot;,
&quot;fullname&quot;: &quot;Pete Alexander&quot;,
&quot;year&quot;: 1926,
&quot;careerWIN&quot;: 327,
&quot;careerHR&quot;: 123,
&quot;careerSO&quot;: 2052,
&quot;careerBB&quot;: 847 
},
{
 &quot;playerID&quot;: &quot;alexape01&quot;,
&quot;fullname&quot;: &quot;Pete Alexander&quot;,
&quot;year&quot;: 1927,
&quot;careerWIN&quot;: 348,
&quot;careerHR&quot;: 134,
&quot;careerSO&quot;: 2100,
&quot;careerBB&quot;: 885 
},
{
 &quot;playerID&quot;: &quot;alexape01&quot;,
&quot;fullname&quot;: &quot;Pete Alexander&quot;,
&quot;year&quot;: 1928,
&quot;careerWIN&quot;: 364,
&quot;careerHR&quot;: 149,
&quot;careerSO&quot;: 2159,
&quot;careerBB&quot;: 922 
},
{
 &quot;playerID&quot;: &quot;alexape01&quot;,
&quot;fullname&quot;: &quot;Pete Alexander&quot;,
&quot;year&quot;: 1929,
&quot;careerWIN&quot;: 373,
&quot;careerHR&quot;: 159,
&quot;careerSO&quot;: 2192,
&quot;careerBB&quot;: 945 
},
{
 &quot;playerID&quot;: &quot;alexape01&quot;,
&quot;fullname&quot;: &quot;Pete Alexander&quot;,
&quot;year&quot;: 1930,
&quot;careerWIN&quot;: 373,
&quot;careerHR&quot;: 164,
&quot;careerSO&quot;: 2198,
&quot;careerBB&quot;: 951 
},
{
 &quot;playerID&quot;: &quot;blylebe01&quot;,
&quot;fullname&quot;: &quot;Bert Blyleven&quot;,
&quot;year&quot;: 1970,
&quot;careerWIN&quot;: 10,
&quot;careerHR&quot;: 17,
&quot;careerSO&quot;: 135,
&quot;careerBB&quot;: 47 
},
{
 &quot;playerID&quot;: &quot;blylebe01&quot;,
&quot;fullname&quot;: &quot;Bert Blyleven&quot;,
&quot;year&quot;: 1971,
&quot;careerWIN&quot;: 26,
&quot;careerHR&quot;: 38,
&quot;careerSO&quot;: 359,
&quot;careerBB&quot;: 106 
},
{
 &quot;playerID&quot;: &quot;blylebe01&quot;,
&quot;fullname&quot;: &quot;Bert Blyleven&quot;,
&quot;year&quot;: 1972,
&quot;careerWIN&quot;: 43,
&quot;careerHR&quot;: 60,
&quot;careerSO&quot;: 587,
&quot;careerBB&quot;: 175 
},
{
 &quot;playerID&quot;: &quot;blylebe01&quot;,
&quot;fullname&quot;: &quot;Bert Blyleven&quot;,
&quot;year&quot;: 1973,
&quot;careerWIN&quot;: 63,
&quot;careerHR&quot;: 76,
&quot;careerSO&quot;: 845,
&quot;careerBB&quot;: 242 
},
{
 &quot;playerID&quot;: &quot;blylebe01&quot;,
&quot;fullname&quot;: &quot;Bert Blyleven&quot;,
&quot;year&quot;: 1974,
&quot;careerWIN&quot;: 80,
&quot;careerHR&quot;: 90,
&quot;careerSO&quot;: 1094,
&quot;careerBB&quot;: 319 
},
{
 &quot;playerID&quot;: &quot;blylebe01&quot;,
&quot;fullname&quot;: &quot;Bert Blyleven&quot;,
&quot;year&quot;: 1975,
&quot;careerWIN&quot;: 95,
&quot;careerHR&quot;: 114,
&quot;careerSO&quot;: 1327,
&quot;careerBB&quot;: 403 
},
{
 &quot;playerID&quot;: &quot;blylebe01&quot;,
&quot;fullname&quot;: &quot;Bert Blyleven&quot;,
&quot;year&quot;: 1976,
&quot;careerWIN&quot;: 108,
&quot;careerHR&quot;: 128,
&quot;careerSO&quot;: 1546,
&quot;careerBB&quot;: 484 
},
{
 &quot;playerID&quot;: &quot;blylebe01&quot;,
&quot;fullname&quot;: &quot;Bert Blyleven&quot;,
&quot;year&quot;: 1977,
&quot;careerWIN&quot;: 122,
&quot;careerHR&quot;: 148,
&quot;careerSO&quot;: 1728,
&quot;careerBB&quot;: 553 
},
{
 &quot;playerID&quot;: &quot;blylebe01&quot;,
&quot;fullname&quot;: &quot;Bert Blyleven&quot;,
&quot;year&quot;: 1978,
&quot;careerWIN&quot;: 136,
&quot;careerHR&quot;: 165,
&quot;careerSO&quot;: 1910,
&quot;careerBB&quot;: 619 
},
{
 &quot;playerID&quot;: &quot;blylebe01&quot;,
&quot;fullname&quot;: &quot;Bert Blyleven&quot;,
&quot;year&quot;: 1979,
&quot;careerWIN&quot;: 148,
&quot;careerHR&quot;: 186,
&quot;careerSO&quot;: 2082,
&quot;careerBB&quot;: 711 
},
{
 &quot;playerID&quot;: &quot;blylebe01&quot;,
&quot;fullname&quot;: &quot;Bert Blyleven&quot;,
&quot;year&quot;: 1980,
&quot;careerWIN&quot;: 156,
&quot;careerHR&quot;: 206,
&quot;careerSO&quot;: 2250,
&quot;careerBB&quot;: 770 
},
{
 &quot;playerID&quot;: &quot;blylebe01&quot;,
&quot;fullname&quot;: &quot;Bert Blyleven&quot;,
&quot;year&quot;: 1981,
&quot;careerWIN&quot;: 167,
&quot;careerHR&quot;: 215,
&quot;careerSO&quot;: 2357,
&quot;careerBB&quot;: 810 
},
{
 &quot;playerID&quot;: &quot;blylebe01&quot;,
&quot;fullname&quot;: &quot;Bert Blyleven&quot;,
&quot;year&quot;: 1982,
&quot;careerWIN&quot;: 169,
&quot;careerHR&quot;: 217,
&quot;careerSO&quot;: 2376,
&quot;careerBB&quot;: 821 
},
{
 &quot;playerID&quot;: &quot;blylebe01&quot;,
&quot;fullname&quot;: &quot;Bert Blyleven&quot;,
&quot;year&quot;: 1983,
&quot;careerWIN&quot;: 176,
&quot;careerHR&quot;: 225,
&quot;careerSO&quot;: 2499,
&quot;careerBB&quot;: 865 
},
{
 &quot;playerID&quot;: &quot;blylebe01&quot;,
&quot;fullname&quot;: &quot;Bert Blyleven&quot;,
&quot;year&quot;: 1984,
&quot;careerWIN&quot;: 195,
&quot;careerHR&quot;: 244,
&quot;careerSO&quot;: 2669,
&quot;careerBB&quot;: 939 
},
{
 &quot;playerID&quot;: &quot;blylebe01&quot;,
&quot;fullname&quot;: &quot;Bert Blyleven&quot;,
&quot;year&quot;: 1985,
&quot;careerWIN&quot;: 212,
&quot;careerHR&quot;: 267,
&quot;careerSO&quot;: 2875,
&quot;careerBB&quot;: 1014 
},
{
 &quot;playerID&quot;: &quot;blylebe01&quot;,
&quot;fullname&quot;: &quot;Bert Blyleven&quot;,
&quot;year&quot;: 1986,
&quot;careerWIN&quot;: 229,
&quot;careerHR&quot;: 317,
&quot;careerSO&quot;: 3090,
&quot;careerBB&quot;: 1072 
},
{
 &quot;playerID&quot;: &quot;blylebe01&quot;,
&quot;fullname&quot;: &quot;Bert Blyleven&quot;,
&quot;year&quot;: 1987,
&quot;careerWIN&quot;: 244,
&quot;careerHR&quot;: 363,
&quot;careerSO&quot;: 3286,
&quot;careerBB&quot;: 1173 
},
{
 &quot;playerID&quot;: &quot;blylebe01&quot;,
&quot;fullname&quot;: &quot;Bert Blyleven&quot;,
&quot;year&quot;: 1988,
&quot;careerWIN&quot;: 254,
&quot;careerHR&quot;: 384,
&quot;careerSO&quot;: 3431,
&quot;careerBB&quot;: 1224 
},
{
 &quot;playerID&quot;: &quot;blylebe01&quot;,
&quot;fullname&quot;: &quot;Bert Blyleven&quot;,
&quot;year&quot;: 1989,
&quot;careerWIN&quot;: 271,
&quot;careerHR&quot;: 398,
&quot;careerSO&quot;: 3562,
&quot;careerBB&quot;: 1268 
},
{
 &quot;playerID&quot;: &quot;blylebe01&quot;,
&quot;fullname&quot;: &quot;Bert Blyleven&quot;,
&quot;year&quot;: 1990,
&quot;careerWIN&quot;: 279,
&quot;careerHR&quot;: 413,
&quot;careerSO&quot;: 3631,
&quot;careerBB&quot;: 1293 
},
{
 &quot;playerID&quot;: &quot;blylebe01&quot;,
&quot;fullname&quot;: &quot;Bert Blyleven&quot;,
&quot;year&quot;: 1992,
&quot;careerWIN&quot;: 287,
&quot;careerHR&quot;: 430,
&quot;careerSO&quot;: 3701,
&quot;careerBB&quot;: 1322 
},
{
 &quot;playerID&quot;: &quot;carltst01&quot;,
&quot;fullname&quot;: &quot;Steve Carlton&quot;,
&quot;year&quot;: 1965,
&quot;careerWIN&quot;: 0,
&quot;careerHR&quot;: 3,
&quot;careerSO&quot;: 21,
&quot;careerBB&quot;: 8 
},
{
 &quot;playerID&quot;: &quot;carltst01&quot;,
&quot;fullname&quot;: &quot;Steve Carlton&quot;,
&quot;year&quot;: 1966,
&quot;careerWIN&quot;: 3,
&quot;careerHR&quot;: 5,
&quot;careerSO&quot;: 46,
&quot;careerBB&quot;: 26 
},
{
 &quot;playerID&quot;: &quot;carltst01&quot;,
&quot;fullname&quot;: &quot;Steve Carlton&quot;,
&quot;year&quot;: 1967,
&quot;careerWIN&quot;: 17,
&quot;careerHR&quot;: 15,
&quot;careerSO&quot;: 214,
&quot;careerBB&quot;: 88 
},
{
 &quot;playerID&quot;: &quot;carltst01&quot;,
&quot;fullname&quot;: &quot;Steve Carlton&quot;,
&quot;year&quot;: 1968,
&quot;careerWIN&quot;: 30,
&quot;careerHR&quot;: 26,
&quot;careerSO&quot;: 376,
&quot;careerBB&quot;: 149 
},
{
 &quot;playerID&quot;: &quot;carltst01&quot;,
&quot;fullname&quot;: &quot;Steve Carlton&quot;,
&quot;year&quot;: 1969,
&quot;careerWIN&quot;: 47,
&quot;careerHR&quot;: 41,
&quot;careerSO&quot;: 586,
&quot;careerBB&quot;: 242 
},
{
 &quot;playerID&quot;: &quot;carltst01&quot;,
&quot;fullname&quot;: &quot;Steve Carlton&quot;,
&quot;year&quot;: 1970,
&quot;careerWIN&quot;: 57,
&quot;careerHR&quot;: 66,
&quot;careerSO&quot;: 779,
&quot;careerBB&quot;: 351 
},
{
 &quot;playerID&quot;: &quot;carltst01&quot;,
&quot;fullname&quot;: &quot;Steve Carlton&quot;,
&quot;year&quot;: 1971,
&quot;careerWIN&quot;: 77,
&quot;careerHR&quot;: 89,
&quot;careerSO&quot;: 951,
&quot;careerBB&quot;: 449 
},
{
 &quot;playerID&quot;: &quot;carltst01&quot;,
&quot;fullname&quot;: &quot;Steve Carlton&quot;,
&quot;year&quot;: 1972,
&quot;careerWIN&quot;: 104,
&quot;careerHR&quot;: 106,
&quot;careerSO&quot;: 1261,
&quot;careerBB&quot;: 536 
},
{
 &quot;playerID&quot;: &quot;carltst01&quot;,
&quot;fullname&quot;: &quot;Steve Carlton&quot;,
&quot;year&quot;: 1973,
&quot;careerWIN&quot;: 117,
&quot;careerHR&quot;: 135,
&quot;careerSO&quot;: 1484,
&quot;careerBB&quot;: 649 
},
{
 &quot;playerID&quot;: &quot;carltst01&quot;,
&quot;fullname&quot;: &quot;Steve Carlton&quot;,
&quot;year&quot;: 1974,
&quot;careerWIN&quot;: 133,
&quot;careerHR&quot;: 156,
&quot;careerSO&quot;: 1724,
&quot;careerBB&quot;: 785 
},
{
 &quot;playerID&quot;: &quot;carltst01&quot;,
&quot;fullname&quot;: &quot;Steve Carlton&quot;,
&quot;year&quot;: 1975,
&quot;careerWIN&quot;: 148,
&quot;careerHR&quot;: 180,
&quot;careerSO&quot;: 1916,
&quot;careerBB&quot;: 889 
},
{
 &quot;playerID&quot;: &quot;carltst01&quot;,
&quot;fullname&quot;: &quot;Steve Carlton&quot;,
&quot;year&quot;: 1976,
&quot;careerWIN&quot;: 168,
&quot;careerHR&quot;: 199,
&quot;careerSO&quot;: 2111,
&quot;careerBB&quot;: 961 
},
{
 &quot;playerID&quot;: &quot;carltst01&quot;,
&quot;fullname&quot;: &quot;Steve Carlton&quot;,
&quot;year&quot;: 1977,
&quot;careerWIN&quot;: 191,
&quot;careerHR&quot;: 224,
&quot;careerSO&quot;: 2309,
&quot;careerBB&quot;: 1050 
},
{
 &quot;playerID&quot;: &quot;carltst01&quot;,
&quot;fullname&quot;: &quot;Steve Carlton&quot;,
&quot;year&quot;: 1978,
&quot;careerWIN&quot;: 207,
&quot;careerHR&quot;: 254,
&quot;careerSO&quot;: 2470,
&quot;careerBB&quot;: 1113 
},
{
 &quot;playerID&quot;: &quot;carltst01&quot;,
&quot;fullname&quot;: &quot;Steve Carlton&quot;,
&quot;year&quot;: 1979,
&quot;careerWIN&quot;: 225,
&quot;careerHR&quot;: 279,
&quot;careerSO&quot;: 2683,
&quot;careerBB&quot;: 1202 
},
{
 &quot;playerID&quot;: &quot;carltst01&quot;,
&quot;fullname&quot;: &quot;Steve Carlton&quot;,
&quot;year&quot;: 1980,
&quot;careerWIN&quot;: 249,
&quot;careerHR&quot;: 294,
&quot;careerSO&quot;: 2969,
&quot;careerBB&quot;: 1292 
},
{
 &quot;playerID&quot;: &quot;carltst01&quot;,
&quot;fullname&quot;: &quot;Steve Carlton&quot;,
&quot;year&quot;: 1981,
&quot;careerWIN&quot;: 262,
&quot;careerHR&quot;: 303,
&quot;careerSO&quot;: 3148,
&quot;careerBB&quot;: 1354 
},
{
 &quot;playerID&quot;: &quot;carltst01&quot;,
&quot;fullname&quot;: &quot;Steve Carlton&quot;,
&quot;year&quot;: 1982,
&quot;careerWIN&quot;: 285,
&quot;careerHR&quot;: 320,
&quot;careerSO&quot;: 3434,
&quot;careerBB&quot;: 1440 
},
{
 &quot;playerID&quot;: &quot;carltst01&quot;,
&quot;fullname&quot;: &quot;Steve Carlton&quot;,
&quot;year&quot;: 1983,
&quot;careerWIN&quot;: 300,
&quot;careerHR&quot;: 340,
&quot;careerSO&quot;: 3709,
&quot;careerBB&quot;: 1524 
},
{
 &quot;playerID&quot;: &quot;carltst01&quot;,
&quot;fullname&quot;: &quot;Steve Carlton&quot;,
&quot;year&quot;: 1984,
&quot;careerWIN&quot;: 313,
&quot;careerHR&quot;: 354,
&quot;careerSO&quot;: 3872,
&quot;careerBB&quot;: 1603 
},
{
 &quot;playerID&quot;: &quot;carltst01&quot;,
&quot;fullname&quot;: &quot;Steve Carlton&quot;,
&quot;year&quot;: 1985,
&quot;careerWIN&quot;: 314,
&quot;careerHR&quot;: 360,
&quot;careerSO&quot;: 3920,
&quot;careerBB&quot;: 1656 
},
{
 &quot;playerID&quot;: &quot;carltst01&quot;,
&quot;fullname&quot;: &quot;Steve Carlton&quot;,
&quot;year&quot;: 1986,
&quot;careerWIN&quot;: 323,
&quot;careerHR&quot;: 385,
&quot;careerSO&quot;: 4040,
&quot;careerBB&quot;: 1742 
},
{
 &quot;playerID&quot;: &quot;carltst01&quot;,
&quot;fullname&quot;: &quot;Steve Carlton&quot;,
&quot;year&quot;: 1987,
&quot;careerWIN&quot;: 329,
&quot;careerHR&quot;: 409,
&quot;careerSO&quot;: 4131,
&quot;careerBB&quot;: 1828 
},
{
 &quot;playerID&quot;: &quot;carltst01&quot;,
&quot;fullname&quot;: &quot;Steve Carlton&quot;,
&quot;year&quot;: 1988,
&quot;careerWIN&quot;: 329,
&quot;careerHR&quot;: 414,
&quot;careerSO&quot;: 4136,
&quot;careerBB&quot;: 1833 
},
{
 &quot;playerID&quot;: &quot;clarkjo01&quot;,
&quot;fullname&quot;: &quot;John Clarkson&quot;,
&quot;year&quot;: 1882,
&quot;careerWIN&quot;: 1,
&quot;careerHR&quot;: 0,
&quot;careerSO&quot;: 3,
&quot;careerBB&quot;: 2 
},
{
 &quot;playerID&quot;: &quot;clarkjo01&quot;,
&quot;fullname&quot;: &quot;John Clarkson&quot;,
&quot;year&quot;: 1884,
&quot;careerWIN&quot;: 11,
&quot;careerHR&quot;: 10,
&quot;careerSO&quot;: 105,
&quot;careerBB&quot;: 27 
},
{
 &quot;playerID&quot;: &quot;clarkjo01&quot;,
&quot;fullname&quot;: &quot;John Clarkson&quot;,
&quot;year&quot;: 1885,
&quot;careerWIN&quot;: 64,
&quot;careerHR&quot;: 31,
&quot;careerSO&quot;: 413,
&quot;careerBB&quot;: 124 
},
{
 &quot;playerID&quot;: &quot;clarkjo01&quot;,
&quot;fullname&quot;: &quot;John Clarkson&quot;,
&quot;year&quot;: 1886,
&quot;careerWIN&quot;: 100,
&quot;careerHR&quot;: 51,
&quot;careerSO&quot;: 726,
&quot;careerBB&quot;: 210 
},
{
 &quot;playerID&quot;: &quot;clarkjo01&quot;,
&quot;fullname&quot;: &quot;John Clarkson&quot;,
&quot;year&quot;: 1887,
&quot;careerWIN&quot;: 138,
&quot;careerHR&quot;: 71,
&quot;careerSO&quot;: 963,
&quot;careerBB&quot;: 302 
},
{
 &quot;playerID&quot;: &quot;clarkjo01&quot;,
&quot;fullname&quot;: &quot;John Clarkson&quot;,
&quot;year&quot;: 1888,
&quot;careerWIN&quot;: 171,
&quot;careerHR&quot;: 88,
&quot;careerSO&quot;: 1186,
&quot;careerBB&quot;: 421 
},
{
 &quot;playerID&quot;: &quot;clarkjo01&quot;,
&quot;fullname&quot;: &quot;John Clarkson&quot;,
&quot;year&quot;: 1889,
&quot;careerWIN&quot;: 220,
&quot;careerHR&quot;: 104,
&quot;careerSO&quot;: 1470,
&quot;careerBB&quot;: 624 
},
{
 &quot;playerID&quot;: &quot;clarkjo01&quot;,
&quot;fullname&quot;: &quot;John Clarkson&quot;,
&quot;year&quot;: 1890,
&quot;careerWIN&quot;: 246,
&quot;careerHR&quot;: 118,
&quot;careerSO&quot;: 1608,
&quot;careerBB&quot;: 764 
},
{
 &quot;playerID&quot;: &quot;clarkjo01&quot;,
&quot;fullname&quot;: &quot;John Clarkson&quot;,
&quot;year&quot;: 1891,
&quot;careerWIN&quot;: 279,
&quot;careerHR&quot;: 136,
&quot;careerSO&quot;: 1749,
&quot;careerBB&quot;: 918 
},
{
 &quot;playerID&quot;: &quot;clarkjo01&quot;,
&quot;fullname&quot;: &quot;John Clarkson&quot;,
&quot;year&quot;: 1892,
&quot;careerWIN&quot;: 304,
&quot;careerHR&quot;: 144,
&quot;careerSO&quot;: 1888,
&quot;careerBB&quot;: 1050 
},
{
 &quot;playerID&quot;: &quot;clarkjo01&quot;,
&quot;fullname&quot;: &quot;John Clarkson&quot;,
&quot;year&quot;: 1893,
&quot;careerWIN&quot;: 320,
&quot;careerHR&quot;: 155,
&quot;careerSO&quot;: 1950,
&quot;careerBB&quot;: 1145 
},
{
 &quot;playerID&quot;: &quot;clarkjo01&quot;,
&quot;fullname&quot;: &quot;John Clarkson&quot;,
&quot;year&quot;: 1894,
&quot;careerWIN&quot;: 328,
&quot;careerHR&quot;: 161,
&quot;careerSO&quot;: 1978,
&quot;careerBB&quot;: 1191 
},
{
 &quot;playerID&quot;: &quot;clemero02&quot;,
&quot;fullname&quot;: &quot;Roger Clemens&quot;,
&quot;year&quot;: 1984,
&quot;careerWIN&quot;: 9,
&quot;careerHR&quot;: 13,
&quot;careerSO&quot;: 126,
&quot;careerBB&quot;: 29 
},
{
 &quot;playerID&quot;: &quot;clemero02&quot;,
&quot;fullname&quot;: &quot;Roger Clemens&quot;,
&quot;year&quot;: 1985,
&quot;careerWIN&quot;: 16,
&quot;careerHR&quot;: 18,
&quot;careerSO&quot;: 200,
&quot;careerBB&quot;: 66 
},
{
 &quot;playerID&quot;: &quot;clemero02&quot;,
&quot;fullname&quot;: &quot;Roger Clemens&quot;,
&quot;year&quot;: 1986,
&quot;careerWIN&quot;: 40,
&quot;careerHR&quot;: 39,
&quot;careerSO&quot;: 438,
&quot;careerBB&quot;: 133 
},
{
 &quot;playerID&quot;: &quot;clemero02&quot;,
&quot;fullname&quot;: &quot;Roger Clemens&quot;,
&quot;year&quot;: 1987,
&quot;careerWIN&quot;: 60,
&quot;careerHR&quot;: 58,
&quot;careerSO&quot;: 694,
&quot;careerBB&quot;: 216 
},
{
 &quot;playerID&quot;: &quot;clemero02&quot;,
&quot;fullname&quot;: &quot;Roger Clemens&quot;,
&quot;year&quot;: 1988,
&quot;careerWIN&quot;: 78,
&quot;careerHR&quot;: 75,
&quot;careerSO&quot;: 985,
&quot;careerBB&quot;: 278 
},
{
 &quot;playerID&quot;: &quot;clemero02&quot;,
&quot;fullname&quot;: &quot;Roger Clemens&quot;,
&quot;year&quot;: 1989,
&quot;careerWIN&quot;: 95,
&quot;careerHR&quot;: 95,
&quot;careerSO&quot;: 1215,
&quot;careerBB&quot;: 371 
},
{
 &quot;playerID&quot;: &quot;clemero02&quot;,
&quot;fullname&quot;: &quot;Roger Clemens&quot;,
&quot;year&quot;: 1990,
&quot;careerWIN&quot;: 116,
&quot;careerHR&quot;: 102,
&quot;careerSO&quot;: 1424,
&quot;careerBB&quot;: 425 
},
{
 &quot;playerID&quot;: &quot;clemero02&quot;,
&quot;fullname&quot;: &quot;Roger Clemens&quot;,
&quot;year&quot;: 1991,
&quot;careerWIN&quot;: 134,
&quot;careerHR&quot;: 117,
&quot;careerSO&quot;: 1665,
&quot;careerBB&quot;: 490 
},
{
 &quot;playerID&quot;: &quot;clemero02&quot;,
&quot;fullname&quot;: &quot;Roger Clemens&quot;,
&quot;year&quot;: 1992,
&quot;careerWIN&quot;: 152,
&quot;careerHR&quot;: 128,
&quot;careerSO&quot;: 1873,
&quot;careerBB&quot;: 552 
},
{
 &quot;playerID&quot;: &quot;clemero02&quot;,
&quot;fullname&quot;: &quot;Roger Clemens&quot;,
&quot;year&quot;: 1993,
&quot;careerWIN&quot;: 163,
&quot;careerHR&quot;: 145,
&quot;careerSO&quot;: 2033,
&quot;careerBB&quot;: 619 
},
{
 &quot;playerID&quot;: &quot;clemero02&quot;,
&quot;fullname&quot;: &quot;Roger Clemens&quot;,
&quot;year&quot;: 1994,
&quot;careerWIN&quot;: 172,
&quot;careerHR&quot;: 160,
&quot;careerSO&quot;: 2201,
&quot;careerBB&quot;: 690 
},
{
 &quot;playerID&quot;: &quot;clemero02&quot;,
&quot;fullname&quot;: &quot;Roger Clemens&quot;,
&quot;year&quot;: 1995,
&quot;careerWIN&quot;: 182,
&quot;careerHR&quot;: 175,
&quot;careerSO&quot;: 2333,
&quot;careerBB&quot;: 750 
},
{
 &quot;playerID&quot;: &quot;clemero02&quot;,
&quot;fullname&quot;: &quot;Roger Clemens&quot;,
&quot;year&quot;: 1996,
&quot;careerWIN&quot;: 192,
&quot;careerHR&quot;: 194,
&quot;careerSO&quot;: 2590,
&quot;careerBB&quot;: 856 
},
{
 &quot;playerID&quot;: &quot;clemero02&quot;,
&quot;fullname&quot;: &quot;Roger Clemens&quot;,
&quot;year&quot;: 1997,
&quot;careerWIN&quot;: 213,
&quot;careerHR&quot;: 203,
&quot;careerSO&quot;: 2882,
&quot;careerBB&quot;: 924 
},
{
 &quot;playerID&quot;: &quot;clemero02&quot;,
&quot;fullname&quot;: &quot;Roger Clemens&quot;,
&quot;year&quot;: 1998,
&quot;careerWIN&quot;: 233,
&quot;careerHR&quot;: 214,
&quot;careerSO&quot;: 3153,
&quot;careerBB&quot;: 1012 
},
{
 &quot;playerID&quot;: &quot;clemero02&quot;,
&quot;fullname&quot;: &quot;Roger Clemens&quot;,
&quot;year&quot;: 1999,
&quot;careerWIN&quot;: 247,
&quot;careerHR&quot;: 234,
&quot;careerSO&quot;: 3316,
&quot;careerBB&quot;: 1102 
},
{
 &quot;playerID&quot;: &quot;clemero02&quot;,
&quot;fullname&quot;: &quot;Roger Clemens&quot;,
&quot;year&quot;: 2000,
&quot;careerWIN&quot;: 260,
&quot;careerHR&quot;: 260,
&quot;careerSO&quot;: 3504,
&quot;careerBB&quot;: 1186 
},
{
 &quot;playerID&quot;: &quot;clemero02&quot;,
&quot;fullname&quot;: &quot;Roger Clemens&quot;,
&quot;year&quot;: 2001,
&quot;careerWIN&quot;: 280,
&quot;careerHR&quot;: 279,
&quot;careerSO&quot;: 3717,
&quot;careerBB&quot;: 1258 
},
{
 &quot;playerID&quot;: &quot;clemero02&quot;,
&quot;fullname&quot;: &quot;Roger Clemens&quot;,
&quot;year&quot;: 2002,
&quot;careerWIN&quot;: 293,
&quot;careerHR&quot;: 297,
&quot;careerSO&quot;: 3909,
&quot;careerBB&quot;: 1321 
},
{
 &quot;playerID&quot;: &quot;clemero02&quot;,
&quot;fullname&quot;: &quot;Roger Clemens&quot;,
&quot;year&quot;: 2003,
&quot;careerWIN&quot;: 310,
&quot;careerHR&quot;: 321,
&quot;careerSO&quot;: 4099,
&quot;careerBB&quot;: 1379 
},
{
 &quot;playerID&quot;: &quot;clemero02&quot;,
&quot;fullname&quot;: &quot;Roger Clemens&quot;,
&quot;year&quot;: 2004,
&quot;careerWIN&quot;: 328,
&quot;careerHR&quot;: 336,
&quot;careerSO&quot;: 4317,
&quot;careerBB&quot;: 1458 
},
{
 &quot;playerID&quot;: &quot;clemero02&quot;,
&quot;fullname&quot;: &quot;Roger Clemens&quot;,
&quot;year&quot;: 2005,
&quot;careerWIN&quot;: 341,
&quot;careerHR&quot;: 347,
&quot;careerSO&quot;: 4502,
&quot;careerBB&quot;: 1520 
},
{
 &quot;playerID&quot;: &quot;clemero02&quot;,
&quot;fullname&quot;: &quot;Roger Clemens&quot;,
&quot;year&quot;: 2006,
&quot;careerWIN&quot;: 348,
&quot;careerHR&quot;: 354,
&quot;careerSO&quot;: 4604,
&quot;careerBB&quot;: 1549 
},
{
 &quot;playerID&quot;: &quot;clemero02&quot;,
&quot;fullname&quot;: &quot;Roger Clemens&quot;,
&quot;year&quot;: 2007,
&quot;careerWIN&quot;: 354,
&quot;careerHR&quot;: 363,
&quot;careerSO&quot;: 4672,
&quot;careerBB&quot;: 1580 
},
{
 &quot;playerID&quot;: &quot;faberre01&quot;,
&quot;fullname&quot;: &quot;Red Faber&quot;,
&quot;year&quot;: 1914,
&quot;careerWIN&quot;: 10,
&quot;careerHR&quot;: 3,
&quot;careerSO&quot;: 88,
&quot;careerBB&quot;: 64 
},
{
 &quot;playerID&quot;: &quot;faberre01&quot;,
&quot;fullname&quot;: &quot;Red Faber&quot;,
&quot;year&quot;: 1915,
&quot;careerWIN&quot;: 34,
&quot;careerHR&quot;: 6,
&quot;careerSO&quot;: 270,
&quot;careerBB&quot;: 163 
},
{
 &quot;playerID&quot;: &quot;faberre01&quot;,
&quot;fullname&quot;: &quot;Red Faber&quot;,
&quot;year&quot;: 1916,
&quot;careerWIN&quot;: 51,
&quot;careerHR&quot;: 7,
&quot;careerSO&quot;: 357,
&quot;careerBB&quot;: 224 
},
{
 &quot;playerID&quot;: &quot;faberre01&quot;,
&quot;fullname&quot;: &quot;Red Faber&quot;,
&quot;year&quot;: 1917,
&quot;careerWIN&quot;: 67,
&quot;careerHR&quot;: 8,
&quot;careerSO&quot;: 441,
&quot;careerBB&quot;: 309 
},
{
 &quot;playerID&quot;: &quot;faberre01&quot;,
&quot;fullname&quot;: &quot;Red Faber&quot;,
&quot;year&quot;: 1918,
&quot;careerWIN&quot;: 71,
&quot;careerHR&quot;: 11,
&quot;careerSO&quot;: 467,
&quot;careerBB&quot;: 332 
},
{
 &quot;playerID&quot;: &quot;faberre01&quot;,
&quot;fullname&quot;: &quot;Red Faber&quot;,
&quot;year&quot;: 1919,
&quot;careerWIN&quot;: 82,
&quot;careerHR&quot;: 18,
&quot;careerSO&quot;: 512,
&quot;careerBB&quot;: 377 
},
{
 &quot;playerID&quot;: &quot;faberre01&quot;,
&quot;fullname&quot;: &quot;Red Faber&quot;,
&quot;year&quot;: 1920,
&quot;careerWIN&quot;: 105,
&quot;careerHR&quot;: 26,
&quot;careerSO&quot;: 620,
&quot;careerBB&quot;: 465 
},
{
 &quot;playerID&quot;: &quot;faberre01&quot;,
&quot;fullname&quot;: &quot;Red Faber&quot;,
&quot;year&quot;: 1921,
&quot;careerWIN&quot;: 130,
&quot;careerHR&quot;: 36,
&quot;careerSO&quot;: 744,
&quot;careerBB&quot;: 552 
},
{
 &quot;playerID&quot;: &quot;faberre01&quot;,
&quot;fullname&quot;: &quot;Red Faber&quot;,
&quot;year&quot;: 1922,
&quot;careerWIN&quot;: 151,
&quot;careerHR&quot;: 46,
&quot;careerSO&quot;: 892,
&quot;careerBB&quot;: 635 
},
{
 &quot;playerID&quot;: &quot;faberre01&quot;,
&quot;fullname&quot;: &quot;Red Faber&quot;,
&quot;year&quot;: 1923,
&quot;careerWIN&quot;: 165,
&quot;careerHR&quot;: 52,
&quot;careerSO&quot;: 983,
&quot;careerBB&quot;: 697 
},
{
 &quot;playerID&quot;: &quot;faberre01&quot;,
&quot;fullname&quot;: &quot;Red Faber&quot;,
&quot;year&quot;: 1924,
&quot;careerWIN&quot;: 174,
&quot;careerHR&quot;: 57,
&quot;careerSO&quot;: 1030,
&quot;careerBB&quot;: 755 
},
{
 &quot;playerID&quot;: &quot;faberre01&quot;,
&quot;fullname&quot;: &quot;Red Faber&quot;,
&quot;year&quot;: 1925,
&quot;careerWIN&quot;: 186,
&quot;careerHR&quot;: 65,
&quot;careerSO&quot;: 1101,
&quot;careerBB&quot;: 814 
},
{
 &quot;playerID&quot;: &quot;faberre01&quot;,
&quot;fullname&quot;: &quot;Red Faber&quot;,
&quot;year&quot;: 1926,
&quot;careerWIN&quot;: 201,
&quot;careerHR&quot;: 68,
&quot;careerSO&quot;: 1166,
&quot;careerBB&quot;: 871 
},
{
 &quot;playerID&quot;: &quot;faberre01&quot;,
&quot;fullname&quot;: &quot;Red Faber&quot;,
&quot;year&quot;: 1927,
&quot;careerWIN&quot;: 205,
&quot;careerHR&quot;: 70,
&quot;careerSO&quot;: 1205,
&quot;careerBB&quot;: 912 
},
{
 &quot;playerID&quot;: &quot;faberre01&quot;,
&quot;fullname&quot;: &quot;Red Faber&quot;,
&quot;year&quot;: 1928,
&quot;careerWIN&quot;: 218,
&quot;careerHR&quot;: 81,
&quot;careerSO&quot;: 1248,
&quot;careerBB&quot;: 980 
},
{
 &quot;playerID&quot;: &quot;faberre01&quot;,
&quot;fullname&quot;: &quot;Red Faber&quot;,
&quot;year&quot;: 1929,
&quot;careerWIN&quot;: 231,
&quot;careerHR&quot;: 91,
&quot;careerSO&quot;: 1316,
&quot;careerBB&quot;: 1041 
},
{
 &quot;playerID&quot;: &quot;faberre01&quot;,
&quot;fullname&quot;: &quot;Red Faber&quot;,
&quot;year&quot;: 1930,
&quot;careerWIN&quot;: 239,
&quot;careerHR&quot;: 98,
&quot;careerSO&quot;: 1378,
&quot;careerBB&quot;: 1090 
},
{
 &quot;playerID&quot;: &quot;faberre01&quot;,
&quot;fullname&quot;: &quot;Red Faber&quot;,
&quot;year&quot;: 1931,
&quot;careerWIN&quot;: 249,
&quot;careerHR&quot;: 109,
&quot;careerSO&quot;: 1427,
&quot;careerBB&quot;: 1147 
},
{
 &quot;playerID&quot;: &quot;faberre01&quot;,
&quot;fullname&quot;: &quot;Red Faber&quot;,
&quot;year&quot;: 1932,
&quot;careerWIN&quot;: 251,
&quot;careerHR&quot;: 109,
&quot;careerSO&quot;: 1453,
&quot;careerBB&quot;: 1185 
},
{
 &quot;playerID&quot;: &quot;faberre01&quot;,
&quot;fullname&quot;: &quot;Red Faber&quot;,
&quot;year&quot;: 1933,
&quot;careerWIN&quot;: 254,
&quot;careerHR&quot;: 111,
&quot;careerSO&quot;: 1471,
&quot;careerBB&quot;: 1213 
},
{
 &quot;playerID&quot;: &quot;fellebo01&quot;,
&quot;fullname&quot;: &quot;Bob Feller&quot;,
&quot;year&quot;: 1936,
&quot;careerWIN&quot;: 5,
&quot;careerHR&quot;: 1,
&quot;careerSO&quot;: 76,
&quot;careerBB&quot;: 47 
},
{
 &quot;playerID&quot;: &quot;fellebo01&quot;,
&quot;fullname&quot;: &quot;Bob Feller&quot;,
&quot;year&quot;: 1937,
&quot;careerWIN&quot;: 14,
&quot;careerHR&quot;: 5,
&quot;careerSO&quot;: 226,
&quot;careerBB&quot;: 153 
},
{
 &quot;playerID&quot;: &quot;fellebo01&quot;,
&quot;fullname&quot;: &quot;Bob Feller&quot;,
&quot;year&quot;: 1938,
&quot;careerWIN&quot;: 31,
&quot;careerHR&quot;: 18,
&quot;careerSO&quot;: 466,
&quot;careerBB&quot;: 361 
},
{
 &quot;playerID&quot;: &quot;fellebo01&quot;,
&quot;fullname&quot;: &quot;Bob Feller&quot;,
&quot;year&quot;: 1939,
&quot;careerWIN&quot;: 55,
&quot;careerHR&quot;: 31,
&quot;careerSO&quot;: 712,
&quot;careerBB&quot;: 503 
},
{
 &quot;playerID&quot;: &quot;fellebo01&quot;,
&quot;fullname&quot;: &quot;Bob Feller&quot;,
&quot;year&quot;: 1940,
&quot;careerWIN&quot;: 82,
&quot;careerHR&quot;: 44,
&quot;careerSO&quot;: 973,
&quot;careerBB&quot;: 621 
},
{
 &quot;playerID&quot;: &quot;fellebo01&quot;,
&quot;fullname&quot;: &quot;Bob Feller&quot;,
&quot;year&quot;: 1941,
&quot;careerWIN&quot;: 107,
&quot;careerHR&quot;: 59,
&quot;careerSO&quot;: 1233,
&quot;careerBB&quot;: 815 
},
{
 &quot;playerID&quot;: &quot;fellebo01&quot;,
&quot;fullname&quot;: &quot;Bob Feller&quot;,
&quot;year&quot;: 1945,
&quot;careerWIN&quot;: 112,
&quot;careerHR&quot;: 60,
&quot;careerSO&quot;: 1292,
&quot;careerBB&quot;: 850 
},
{
 &quot;playerID&quot;: &quot;fellebo01&quot;,
&quot;fullname&quot;: &quot;Bob Feller&quot;,
&quot;year&quot;: 1946,
&quot;careerWIN&quot;: 138,
&quot;careerHR&quot;: 71,
&quot;careerSO&quot;: 1640,
&quot;careerBB&quot;: 1003 
},
{
 &quot;playerID&quot;: &quot;fellebo01&quot;,
&quot;fullname&quot;: &quot;Bob Feller&quot;,
&quot;year&quot;: 1947,
&quot;careerWIN&quot;: 158,
&quot;careerHR&quot;: 88,
&quot;careerSO&quot;: 1836,
&quot;careerBB&quot;: 1130 
},
{
 &quot;playerID&quot;: &quot;fellebo01&quot;,
&quot;fullname&quot;: &quot;Bob Feller&quot;,
&quot;year&quot;: 1948,
&quot;careerWIN&quot;: 177,
&quot;careerHR&quot;: 108,
&quot;careerSO&quot;: 2000,
&quot;careerBB&quot;: 1246 
},
{
 &quot;playerID&quot;: &quot;fellebo01&quot;,
&quot;fullname&quot;: &quot;Bob Feller&quot;,
&quot;year&quot;: 1949,
&quot;careerWIN&quot;: 192,
&quot;careerHR&quot;: 126,
&quot;careerSO&quot;: 2108,
&quot;careerBB&quot;: 1330 
},
{
 &quot;playerID&quot;: &quot;fellebo01&quot;,
&quot;fullname&quot;: &quot;Bob Feller&quot;,
&quot;year&quot;: 1950,
&quot;careerWIN&quot;: 208,
&quot;careerHR&quot;: 146,
&quot;careerSO&quot;: 2227,
&quot;careerBB&quot;: 1433 
},
{
 &quot;playerID&quot;: &quot;fellebo01&quot;,
&quot;fullname&quot;: &quot;Bob Feller&quot;,
&quot;year&quot;: 1951,
&quot;careerWIN&quot;: 230,
&quot;careerHR&quot;: 168,
&quot;careerSO&quot;: 2338,
&quot;careerBB&quot;: 1528 
},
{
 &quot;playerID&quot;: &quot;fellebo01&quot;,
&quot;fullname&quot;: &quot;Bob Feller&quot;,
&quot;year&quot;: 1952,
&quot;careerWIN&quot;: 239,
&quot;careerHR&quot;: 181,
&quot;careerSO&quot;: 2419,
&quot;careerBB&quot;: 1611 
},
{
 &quot;playerID&quot;: &quot;fellebo01&quot;,
&quot;fullname&quot;: &quot;Bob Feller&quot;,
&quot;year&quot;: 1953,
&quot;careerWIN&quot;: 249,
&quot;careerHR&quot;: 197,
&quot;careerSO&quot;: 2479,
&quot;careerBB&quot;: 1671 
},
{
 &quot;playerID&quot;: &quot;fellebo01&quot;,
&quot;fullname&quot;: &quot;Bob Feller&quot;,
&quot;year&quot;: 1954,
&quot;careerWIN&quot;: 262,
&quot;careerHR&quot;: 210,
&quot;careerSO&quot;: 2538,
&quot;careerBB&quot;: 1710 
},
{
 &quot;playerID&quot;: &quot;fellebo01&quot;,
&quot;fullname&quot;: &quot;Bob Feller&quot;,
&quot;year&quot;: 1955,
&quot;careerWIN&quot;: 266,
&quot;careerHR&quot;: 217,
&quot;careerSO&quot;: 2563,
&quot;careerBB&quot;: 1741 
},
{
 &quot;playerID&quot;: &quot;fellebo01&quot;,
&quot;fullname&quot;: &quot;Bob Feller&quot;,
&quot;year&quot;: 1956,
&quot;careerWIN&quot;: 266,
&quot;careerHR&quot;: 224,
&quot;careerSO&quot;: 2581,
&quot;careerBB&quot;: 1764 
},
{
 &quot;playerID&quot;: &quot;galvipu01&quot;,
&quot;fullname&quot;: &quot;Pud Galvin&quot;,
&quot;year&quot;: 1875,
&quot;careerWIN&quot;: 4,
&quot;careerHR&quot;: 0,
&quot;careerSO&quot;: 7,
&quot;careerBB&quot;: 1 
},
{
 &quot;playerID&quot;: &quot;galvipu01&quot;,
&quot;fullname&quot;: &quot;Pud Galvin&quot;,
&quot;year&quot;: 1879,
&quot;careerWIN&quot;: 41,
&quot;careerHR&quot;: 3,
&quot;careerSO&quot;: 143,
&quot;careerBB&quot;: 32 
},
{
 &quot;playerID&quot;: &quot;galvipu01&quot;,
&quot;fullname&quot;: &quot;Pud Galvin&quot;,
&quot;year&quot;: 1880,
&quot;careerWIN&quot;: 61,
&quot;careerHR&quot;: 8,
&quot;careerSO&quot;: 271,
&quot;careerBB&quot;: 64 
},
{
 &quot;playerID&quot;: &quot;galvipu01&quot;,
&quot;fullname&quot;: &quot;Pud Galvin&quot;,
&quot;year&quot;: 1881,
&quot;careerWIN&quot;: 89,
&quot;careerHR&quot;: 12,
&quot;careerSO&quot;: 407,
&quot;careerBB&quot;: 110 
},
{
 &quot;playerID&quot;: &quot;galvipu01&quot;,
&quot;fullname&quot;: &quot;Pud Galvin&quot;,
&quot;year&quot;: 1882,
&quot;careerWIN&quot;: 117,
&quot;careerHR&quot;: 20,
&quot;careerSO&quot;: 569,
&quot;careerBB&quot;: 150 
},
{
 &quot;playerID&quot;: &quot;galvipu01&quot;,
&quot;fullname&quot;: &quot;Pud Galvin&quot;,
&quot;year&quot;: 1883,
&quot;careerWIN&quot;: 163,
&quot;careerHR&quot;: 29,
&quot;careerSO&quot;: 848,
&quot;careerBB&quot;: 200 
},
{
 &quot;playerID&quot;: &quot;galvipu01&quot;,
&quot;fullname&quot;: &quot;Pud Galvin&quot;,
&quot;year&quot;: 1884,
&quot;careerWIN&quot;: 209,
&quot;careerHR&quot;: 52,
&quot;careerSO&quot;: 1217,
&quot;careerBB&quot;: 263 
},
{
 &quot;playerID&quot;: &quot;galvipu01&quot;,
&quot;fullname&quot;: &quot;Pud Galvin&quot;,
&quot;year&quot;: 1885,
&quot;careerWIN&quot;: 225,
&quot;careerHR&quot;: 62,
&quot;careerSO&quot;: 1337,
&quot;careerBB&quot;: 307 
},
{
 &quot;playerID&quot;: &quot;galvipu01&quot;,
&quot;fullname&quot;: &quot;Pud Galvin&quot;,
&quot;year&quot;: 1886,
&quot;careerWIN&quot;: 254,
&quot;careerHR&quot;: 65,
&quot;careerSO&quot;: 1409,
&quot;careerBB&quot;: 382 
},
{
 &quot;playerID&quot;: &quot;galvipu01&quot;,
&quot;fullname&quot;: &quot;Pud Galvin&quot;,
&quot;year&quot;: 1887,
&quot;careerWIN&quot;: 282,
&quot;careerHR&quot;: 77,
&quot;careerSO&quot;: 1485,
&quot;careerBB&quot;: 449 
},
{
 &quot;playerID&quot;: &quot;galvipu01&quot;,
&quot;fullname&quot;: &quot;Pud Galvin&quot;,
&quot;year&quot;: 1888,
&quot;careerWIN&quot;: 305,
&quot;careerHR&quot;: 86,
&quot;careerSO&quot;: 1592,
&quot;careerBB&quot;: 502 
},
{
 &quot;playerID&quot;: &quot;galvipu01&quot;,
&quot;fullname&quot;: &quot;Pud Galvin&quot;,
&quot;year&quot;: 1889,
&quot;careerWIN&quot;: 328,
&quot;careerHR&quot;: 105,
&quot;careerSO&quot;: 1669,
&quot;careerBB&quot;: 580 
},
{
 &quot;playerID&quot;: &quot;galvipu01&quot;,
&quot;fullname&quot;: &quot;Pud Galvin&quot;,
&quot;year&quot;: 1890,
&quot;careerWIN&quot;: 340,
&quot;careerHR&quot;: 108,
&quot;careerSO&quot;: 1704,
&quot;careerBB&quot;: 629 
},
{
 &quot;playerID&quot;: &quot;galvipu01&quot;,
&quot;fullname&quot;: &quot;Pud Galvin&quot;,
&quot;year&quot;: 1891,
&quot;careerWIN&quot;: 354,
&quot;careerHR&quot;: 118,
&quot;careerSO&quot;: 1750,
&quot;careerBB&quot;: 691 
},
{
 &quot;playerID&quot;: &quot;galvipu01&quot;,
&quot;fullname&quot;: &quot;Pud Galvin&quot;,
&quot;year&quot;: 1892,
&quot;careerWIN&quot;: 364,
&quot;careerHR&quot;: 122,
&quot;careerSO&quot;: 1806,
&quot;careerBB&quot;: 745 
},
{
 &quot;playerID&quot;: &quot;gibsobo01&quot;,
&quot;fullname&quot;: &quot;Bob Gibson&quot;,
&quot;year&quot;: 1959,
&quot;careerWIN&quot;: 3,
&quot;careerHR&quot;: 4,
&quot;careerSO&quot;: 48,
&quot;careerBB&quot;: 39 
},
{
 &quot;playerID&quot;: &quot;gibsobo01&quot;,
&quot;fullname&quot;: &quot;Bob Gibson&quot;,
&quot;year&quot;: 1960,
&quot;careerWIN&quot;: 6,
&quot;careerHR&quot;: 11,
&quot;careerSO&quot;: 117,
&quot;careerBB&quot;: 87 
},
{
 &quot;playerID&quot;: &quot;gibsobo01&quot;,
&quot;fullname&quot;: &quot;Bob Gibson&quot;,
&quot;year&quot;: 1961,
&quot;careerWIN&quot;: 19,
&quot;careerHR&quot;: 24,
&quot;careerSO&quot;: 283,
&quot;careerBB&quot;: 206 
},
{
 &quot;playerID&quot;: &quot;gibsobo01&quot;,
&quot;fullname&quot;: &quot;Bob Gibson&quot;,
&quot;year&quot;: 1962,
&quot;careerWIN&quot;: 34,
&quot;careerHR&quot;: 39,
&quot;careerSO&quot;: 491,
&quot;careerBB&quot;: 301 
},
{
 &quot;playerID&quot;: &quot;gibsobo01&quot;,
&quot;fullname&quot;: &quot;Bob Gibson&quot;,
&quot;year&quot;: 1963,
&quot;careerWIN&quot;: 52,
&quot;careerHR&quot;: 58,
&quot;careerSO&quot;: 695,
&quot;careerBB&quot;: 397 
},
{
 &quot;playerID&quot;: &quot;gibsobo01&quot;,
&quot;fullname&quot;: &quot;Bob Gibson&quot;,
&quot;year&quot;: 1964,
&quot;careerWIN&quot;: 71,
&quot;careerHR&quot;: 83,
&quot;careerSO&quot;: 940,
&quot;careerBB&quot;: 483 
},
{
 &quot;playerID&quot;: &quot;gibsobo01&quot;,
&quot;fullname&quot;: &quot;Bob Gibson&quot;,
&quot;year&quot;: 1965,
&quot;careerWIN&quot;: 91,
&quot;careerHR&quot;: 117,
&quot;careerSO&quot;: 1210,
&quot;careerBB&quot;: 586 
},
{
 &quot;playerID&quot;: &quot;gibsobo01&quot;,
&quot;fullname&quot;: &quot;Bob Gibson&quot;,
&quot;year&quot;: 1966,
&quot;careerWIN&quot;: 112,
&quot;careerHR&quot;: 137,
&quot;careerSO&quot;: 1435,
&quot;careerBB&quot;: 664 
},
{
 &quot;playerID&quot;: &quot;gibsobo01&quot;,
&quot;fullname&quot;: &quot;Bob Gibson&quot;,
&quot;year&quot;: 1967,
&quot;careerWIN&quot;: 125,
&quot;careerHR&quot;: 147,
&quot;careerSO&quot;: 1582,
&quot;careerBB&quot;: 704 
},
{
 &quot;playerID&quot;: &quot;gibsobo01&quot;,
&quot;fullname&quot;: &quot;Bob Gibson&quot;,
&quot;year&quot;: 1968,
&quot;careerWIN&quot;: 147,
&quot;careerHR&quot;: 158,
&quot;careerSO&quot;: 1850,
&quot;careerBB&quot;: 766 
},
{
 &quot;playerID&quot;: &quot;gibsobo01&quot;,
&quot;fullname&quot;: &quot;Bob Gibson&quot;,
&quot;year&quot;: 1969,
&quot;careerWIN&quot;: 167,
&quot;careerHR&quot;: 170,
&quot;careerSO&quot;: 2119,
&quot;careerBB&quot;: 861 
},
{
 &quot;playerID&quot;: &quot;gibsobo01&quot;,
&quot;fullname&quot;: &quot;Bob Gibson&quot;,
&quot;year&quot;: 1970,
&quot;careerWIN&quot;: 190,
&quot;careerHR&quot;: 183,
&quot;careerSO&quot;: 2393,
&quot;careerBB&quot;: 949 
},
{
 &quot;playerID&quot;: &quot;gibsobo01&quot;,
&quot;fullname&quot;: &quot;Bob Gibson&quot;,
&quot;year&quot;: 1971,
&quot;careerWIN&quot;: 206,
&quot;careerHR&quot;: 197,
&quot;careerSO&quot;: 2578,
&quot;careerBB&quot;: 1025 
},
{
 &quot;playerID&quot;: &quot;gibsobo01&quot;,
&quot;fullname&quot;: &quot;Bob Gibson&quot;,
&quot;year&quot;: 1972,
&quot;careerWIN&quot;: 225,
&quot;careerHR&quot;: 211,
&quot;careerSO&quot;: 2786,
&quot;careerBB&quot;: 1113 
},
{
 &quot;playerID&quot;: &quot;gibsobo01&quot;,
&quot;fullname&quot;: &quot;Bob Gibson&quot;,
&quot;year&quot;: 1973,
&quot;careerWIN&quot;: 237,
&quot;careerHR&quot;: 223,
&quot;careerSO&quot;: 2928,
&quot;careerBB&quot;: 1170 
},
{
 &quot;playerID&quot;: &quot;gibsobo01&quot;,
&quot;fullname&quot;: &quot;Bob Gibson&quot;,
&quot;year&quot;: 1974,
&quot;careerWIN&quot;: 248,
&quot;careerHR&quot;: 247,
&quot;careerSO&quot;: 3057,
&quot;careerBB&quot;: 1274 
},
{
 &quot;playerID&quot;: &quot;gibsobo01&quot;,
&quot;fullname&quot;: &quot;Bob Gibson&quot;,
&quot;year&quot;: 1975,
&quot;careerWIN&quot;: 251,
&quot;careerHR&quot;: 257,
&quot;careerSO&quot;: 3117,
&quot;careerBB&quot;: 1336 
},
{
 &quot;playerID&quot;: &quot;glavito02&quot;,
&quot;fullname&quot;: &quot;Tom Glavine&quot;,
&quot;year&quot;: 1987,
&quot;careerWIN&quot;: 2,
&quot;careerHR&quot;: 5,
&quot;careerSO&quot;: 20,
&quot;careerBB&quot;: 33 
},
{
 &quot;playerID&quot;: &quot;glavito02&quot;,
&quot;fullname&quot;: &quot;Tom Glavine&quot;,
&quot;year&quot;: 1988,
&quot;careerWIN&quot;: 9,
&quot;careerHR&quot;: 17,
&quot;careerSO&quot;: 104,
&quot;careerBB&quot;: 96 
},
{
 &quot;playerID&quot;: &quot;glavito02&quot;,
&quot;fullname&quot;: &quot;Tom Glavine&quot;,
&quot;year&quot;: 1989,
&quot;careerWIN&quot;: 23,
&quot;careerHR&quot;: 37,
&quot;careerSO&quot;: 194,
&quot;careerBB&quot;: 136 
},
{
 &quot;playerID&quot;: &quot;glavito02&quot;,
&quot;fullname&quot;: &quot;Tom Glavine&quot;,
&quot;year&quot;: 1990,
&quot;careerWIN&quot;: 33,
&quot;careerHR&quot;: 55,
&quot;careerSO&quot;: 323,
&quot;careerBB&quot;: 214 
},
{
 &quot;playerID&quot;: &quot;glavito02&quot;,
&quot;fullname&quot;: &quot;Tom Glavine&quot;,
&quot;year&quot;: 1991,
&quot;careerWIN&quot;: 53,
&quot;careerHR&quot;: 72,
&quot;careerSO&quot;: 515,
&quot;careerBB&quot;: 283 
},
{
 &quot;playerID&quot;: &quot;glavito02&quot;,
&quot;fullname&quot;: &quot;Tom Glavine&quot;,
&quot;year&quot;: 1992,
&quot;careerWIN&quot;: 73,
&quot;careerHR&quot;: 78,
&quot;careerSO&quot;: 644,
&quot;careerBB&quot;: 353 
},
{
 &quot;playerID&quot;: &quot;glavito02&quot;,
&quot;fullname&quot;: &quot;Tom Glavine&quot;,
&quot;year&quot;: 1993,
&quot;careerWIN&quot;: 95,
&quot;careerHR&quot;: 94,
&quot;careerSO&quot;: 764,
&quot;careerBB&quot;: 443 
},
{
 &quot;playerID&quot;: &quot;glavito02&quot;,
&quot;fullname&quot;: &quot;Tom Glavine&quot;,
&quot;year&quot;: 1994,
&quot;careerWIN&quot;: 108,
&quot;careerHR&quot;: 104,
&quot;careerSO&quot;: 904,
&quot;careerBB&quot;: 513 
},
{
 &quot;playerID&quot;: &quot;glavito02&quot;,
&quot;fullname&quot;: &quot;Tom Glavine&quot;,
&quot;year&quot;: 1995,
&quot;careerWIN&quot;: 124,
&quot;careerHR&quot;: 113,
&quot;careerSO&quot;: 1031,
&quot;careerBB&quot;: 579 
},
{
 &quot;playerID&quot;: &quot;glavito02&quot;,
&quot;fullname&quot;: &quot;Tom Glavine&quot;,
&quot;year&quot;: 1996,
&quot;careerWIN&quot;: 139,
&quot;careerHR&quot;: 127,
&quot;careerSO&quot;: 1212,
&quot;careerBB&quot;: 664 
},
{
 &quot;playerID&quot;: &quot;glavito02&quot;,
&quot;fullname&quot;: &quot;Tom Glavine&quot;,
&quot;year&quot;: 1997,
&quot;careerWIN&quot;: 153,
&quot;careerHR&quot;: 147,
&quot;careerSO&quot;: 1364,
&quot;careerBB&quot;: 743 
},
{
 &quot;playerID&quot;: &quot;glavito02&quot;,
&quot;fullname&quot;: &quot;Tom Glavine&quot;,
&quot;year&quot;: 1998,
&quot;careerWIN&quot;: 173,
&quot;careerHR&quot;: 160,
&quot;careerSO&quot;: 1521,
&quot;careerBB&quot;: 817 
},
{
 &quot;playerID&quot;: &quot;glavito02&quot;,
&quot;fullname&quot;: &quot;Tom Glavine&quot;,
&quot;year&quot;: 1999,
&quot;careerWIN&quot;: 187,
&quot;careerHR&quot;: 178,
&quot;careerSO&quot;: 1659,
&quot;careerBB&quot;: 900 
},
{
 &quot;playerID&quot;: &quot;glavito02&quot;,
&quot;fullname&quot;: &quot;Tom Glavine&quot;,
&quot;year&quot;: 2000,
&quot;careerWIN&quot;: 208,
&quot;careerHR&quot;: 202,
&quot;careerSO&quot;: 1811,
&quot;careerBB&quot;: 965 
},
{
 &quot;playerID&quot;: &quot;glavito02&quot;,
&quot;fullname&quot;: &quot;Tom Glavine&quot;,
&quot;year&quot;: 2001,
&quot;careerWIN&quot;: 224,
&quot;careerHR&quot;: 226,
&quot;careerSO&quot;: 1927,
&quot;careerBB&quot;: 1062 
},
{
 &quot;playerID&quot;: &quot;glavito02&quot;,
&quot;fullname&quot;: &quot;Tom Glavine&quot;,
&quot;year&quot;: 2002,
&quot;careerWIN&quot;: 242,
&quot;careerHR&quot;: 247,
&quot;careerSO&quot;: 2054,
&quot;careerBB&quot;: 1140 
},
{
 &quot;playerID&quot;: &quot;glavito02&quot;,
&quot;fullname&quot;: &quot;Tom Glavine&quot;,
&quot;year&quot;: 2003,
&quot;careerWIN&quot;: 251,
&quot;careerHR&quot;: 268,
&quot;careerSO&quot;: 2136,
&quot;careerBB&quot;: 1206 
},
{
 &quot;playerID&quot;: &quot;glavito02&quot;,
&quot;fullname&quot;: &quot;Tom Glavine&quot;,
&quot;year&quot;: 2004,
&quot;careerWIN&quot;: 262,
&quot;careerHR&quot;: 288,
&quot;careerSO&quot;: 2245,
&quot;careerBB&quot;: 1276 
},
{
 &quot;playerID&quot;: &quot;glavito02&quot;,
&quot;fullname&quot;: &quot;Tom Glavine&quot;,
&quot;year&quot;: 2005,
&quot;careerWIN&quot;: 275,
&quot;careerHR&quot;: 300,
&quot;careerSO&quot;: 2350,
&quot;careerBB&quot;: 1337 
},
{
 &quot;playerID&quot;: &quot;glavito02&quot;,
&quot;fullname&quot;: &quot;Tom Glavine&quot;,
&quot;year&quot;: 2006,
&quot;careerWIN&quot;: 290,
&quot;careerHR&quot;: 322,
&quot;careerSO&quot;: 2481,
&quot;careerBB&quot;: 1399 
},
{
 &quot;playerID&quot;: &quot;glavito02&quot;,
&quot;fullname&quot;: &quot;Tom Glavine&quot;,
&quot;year&quot;: 2007,
&quot;careerWIN&quot;: 303,
&quot;careerHR&quot;: 345,
&quot;careerSO&quot;: 2570,
&quot;careerBB&quot;: 1463 
},
{
 &quot;playerID&quot;: &quot;glavito02&quot;,
&quot;fullname&quot;: &quot;Tom Glavine&quot;,
&quot;year&quot;: 2008,
&quot;careerWIN&quot;: 305,
&quot;careerHR&quot;: 356,
&quot;careerSO&quot;: 2607,
&quot;careerBB&quot;: 1500 
},
{
 &quot;playerID&quot;: &quot;grimebu01&quot;,
&quot;fullname&quot;: &quot;Burleigh Grimes&quot;,
&quot;year&quot;: 1916,
&quot;careerWIN&quot;: 2,
&quot;careerHR&quot;: 1,
&quot;careerSO&quot;: 20,
&quot;careerBB&quot;: 10 
},
{
 &quot;playerID&quot;: &quot;grimebu01&quot;,
&quot;fullname&quot;: &quot;Burleigh Grimes&quot;,
&quot;year&quot;: 1917,
&quot;careerWIN&quot;: 5,
&quot;careerHR&quot;: 6,
&quot;careerSO&quot;: 92,
&quot;careerBB&quot;: 80 
},
{
 &quot;playerID&quot;: &quot;grimebu01&quot;,
&quot;fullname&quot;: &quot;Burleigh Grimes&quot;,
&quot;year&quot;: 1918,
&quot;careerWIN&quot;: 24,
&quot;careerHR&quot;: 9,
&quot;careerSO&quot;: 205,
&quot;careerBB&quot;: 156 
},
{
 &quot;playerID&quot;: &quot;grimebu01&quot;,
&quot;fullname&quot;: &quot;Burleigh Grimes&quot;,
&quot;year&quot;: 1919,
&quot;careerWIN&quot;: 34,
&quot;careerHR&quot;: 11,
&quot;careerSO&quot;: 287,
&quot;careerBB&quot;: 216 
},
{
 &quot;playerID&quot;: &quot;grimebu01&quot;,
&quot;fullname&quot;: &quot;Burleigh Grimes&quot;,
&quot;year&quot;: 1920,
&quot;careerWIN&quot;: 57,
&quot;careerHR&quot;: 16,
&quot;careerSO&quot;: 418,
&quot;careerBB&quot;: 283 
},
{
 &quot;playerID&quot;: &quot;grimebu01&quot;,
&quot;fullname&quot;: &quot;Burleigh Grimes&quot;,
&quot;year&quot;: 1921,
&quot;careerWIN&quot;: 79,
&quot;careerHR&quot;: 22,
&quot;careerSO&quot;: 554,
&quot;careerBB&quot;: 359 
},
{
 &quot;playerID&quot;: &quot;grimebu01&quot;,
&quot;fullname&quot;: &quot;Burleigh Grimes&quot;,
&quot;year&quot;: 1922,
&quot;careerWIN&quot;: 96,
&quot;careerHR&quot;: 39,
&quot;careerSO&quot;: 653,
&quot;careerBB&quot;: 443 
},
{
 &quot;playerID&quot;: &quot;grimebu01&quot;,
&quot;fullname&quot;: &quot;Burleigh Grimes&quot;,
&quot;year&quot;: 1923,
&quot;careerWIN&quot;: 117,
&quot;careerHR&quot;: 48,
&quot;careerSO&quot;: 772,
&quot;careerBB&quot;: 543 
},
{
 &quot;playerID&quot;: &quot;grimebu01&quot;,
&quot;fullname&quot;: &quot;Burleigh Grimes&quot;,
&quot;year&quot;: 1924,
&quot;careerWIN&quot;: 139,
&quot;careerHR&quot;: 63,
&quot;careerSO&quot;: 907,
&quot;careerBB&quot;: 634 
},
{
 &quot;playerID&quot;: &quot;grimebu01&quot;,
&quot;fullname&quot;: &quot;Burleigh Grimes&quot;,
&quot;year&quot;: 1925,
&quot;careerWIN&quot;: 151,
&quot;careerHR&quot;: 78,
&quot;careerSO&quot;: 980,
&quot;careerBB&quot;: 736 
},
{
 &quot;playerID&quot;: &quot;grimebu01&quot;,
&quot;fullname&quot;: &quot;Burleigh Grimes&quot;,
&quot;year&quot;: 1926,
&quot;careerWIN&quot;: 163,
&quot;careerHR&quot;: 82,
&quot;careerSO&quot;: 1044,
&quot;careerBB&quot;: 824 
},
{
 &quot;playerID&quot;: &quot;grimebu01&quot;,
&quot;fullname&quot;: &quot;Burleigh Grimes&quot;,
&quot;year&quot;: 1927,
&quot;careerWIN&quot;: 182,
&quot;careerHR&quot;: 94,
&quot;careerSO&quot;: 1146,
&quot;careerBB&quot;: 911 
},
{
 &quot;playerID&quot;: &quot;grimebu01&quot;,
&quot;fullname&quot;: &quot;Burleigh Grimes&quot;,
&quot;year&quot;: 1928,
&quot;careerWIN&quot;: 207,
&quot;careerHR&quot;: 105,
&quot;careerSO&quot;: 1243,
&quot;careerBB&quot;: 988 
},
{
 &quot;playerID&quot;: &quot;grimebu01&quot;,
&quot;fullname&quot;: &quot;Burleigh Grimes&quot;,
&quot;year&quot;: 1929,
&quot;careerWIN&quot;: 224,
&quot;careerHR&quot;: 116,
&quot;careerSO&quot;: 1305,
&quot;careerBB&quot;: 1058 
},
{
 &quot;playerID&quot;: &quot;grimebu01&quot;,
&quot;fullname&quot;: &quot;Burleigh Grimes&quot;,
&quot;year&quot;: 1930,
&quot;careerWIN&quot;: 240,
&quot;careerHR&quot;: 125,
&quot;careerSO&quot;: 1378,
&quot;careerBB&quot;: 1123 
},
{
 &quot;playerID&quot;: &quot;grimebu01&quot;,
&quot;fullname&quot;: &quot;Burleigh Grimes&quot;,
&quot;year&quot;: 1931,
&quot;careerWIN&quot;: 257,
&quot;careerHR&quot;: 136,
&quot;careerSO&quot;: 1445,
&quot;careerBB&quot;: 1182 
},
{
 &quot;playerID&quot;: &quot;grimebu01&quot;,
&quot;fullname&quot;: &quot;Burleigh Grimes&quot;,
&quot;year&quot;: 1932,
&quot;careerWIN&quot;: 263,
&quot;careerHR&quot;: 144,
&quot;careerSO&quot;: 1481,
&quot;careerBB&quot;: 1232 
},
{
 &quot;playerID&quot;: &quot;grimebu01&quot;,
&quot;fullname&quot;: &quot;Burleigh Grimes&quot;,
&quot;year&quot;: 1933,
&quot;careerWIN&quot;: 266,
&quot;careerHR&quot;: 147,
&quot;careerSO&quot;: 1497,
&quot;careerBB&quot;: 1269 
},
{
 &quot;playerID&quot;: &quot;grimebu01&quot;,
&quot;fullname&quot;: &quot;Burleigh Grimes&quot;,
&quot;year&quot;: 1934,
&quot;careerWIN&quot;: 270,
&quot;careerHR&quot;: 148,
&quot;careerSO&quot;: 1512,
&quot;careerBB&quot;: 1295 
},
{
 &quot;playerID&quot;: &quot;grovele01&quot;,
&quot;fullname&quot;: &quot;Lefty Grove&quot;,
&quot;year&quot;: 1925,
&quot;careerWIN&quot;: 10,
&quot;careerHR&quot;: 11,
&quot;careerSO&quot;: 116,
&quot;careerBB&quot;: 131 
},
{
 &quot;playerID&quot;: &quot;grovele01&quot;,
&quot;fullname&quot;: &quot;Lefty Grove&quot;,
&quot;year&quot;: 1926,
&quot;careerWIN&quot;: 23,
&quot;careerHR&quot;: 17,
&quot;careerSO&quot;: 310,
&quot;careerBB&quot;: 232 
},
{
 &quot;playerID&quot;: &quot;grovele01&quot;,
&quot;fullname&quot;: &quot;Lefty Grove&quot;,
&quot;year&quot;: 1927,
&quot;careerWIN&quot;: 43,
&quot;careerHR&quot;: 23,
&quot;careerSO&quot;: 484,
&quot;careerBB&quot;: 311 
},
{
 &quot;playerID&quot;: &quot;grovele01&quot;,
&quot;fullname&quot;: &quot;Lefty Grove&quot;,
&quot;year&quot;: 1928,
&quot;careerWIN&quot;: 67,
&quot;careerHR&quot;: 33,
&quot;careerSO&quot;: 667,
&quot;careerBB&quot;: 375 
},
{
 &quot;playerID&quot;: &quot;grovele01&quot;,
&quot;fullname&quot;: &quot;Lefty Grove&quot;,
&quot;year&quot;: 1929,
&quot;careerWIN&quot;: 87,
&quot;careerHR&quot;: 41,
&quot;careerSO&quot;: 837,
&quot;careerBB&quot;: 456 
},
{
 &quot;playerID&quot;: &quot;grovele01&quot;,
&quot;fullname&quot;: &quot;Lefty Grove&quot;,
&quot;year&quot;: 1930,
&quot;careerWIN&quot;: 115,
&quot;careerHR&quot;: 49,
&quot;careerSO&quot;: 1046,
&quot;careerBB&quot;: 516 
},
{
 &quot;playerID&quot;: &quot;grovele01&quot;,
&quot;fullname&quot;: &quot;Lefty Grove&quot;,
&quot;year&quot;: 1931,
&quot;careerWIN&quot;: 146,
&quot;careerHR&quot;: 59,
&quot;careerSO&quot;: 1221,
&quot;careerBB&quot;: 578 
},
{
 &quot;playerID&quot;: &quot;grovele01&quot;,
&quot;fullname&quot;: &quot;Lefty Grove&quot;,
&quot;year&quot;: 1932,
&quot;careerWIN&quot;: 171,
&quot;careerHR&quot;: 72,
&quot;careerSO&quot;: 1409,
&quot;careerBB&quot;: 657 
},
{
 &quot;playerID&quot;: &quot;grovele01&quot;,
&quot;fullname&quot;: &quot;Lefty Grove&quot;,
&quot;year&quot;: 1933,
&quot;careerWIN&quot;: 195,
&quot;careerHR&quot;: 84,
&quot;careerSO&quot;: 1523,
&quot;careerBB&quot;: 740 
},
{
 &quot;playerID&quot;: &quot;grovele01&quot;,
&quot;fullname&quot;: &quot;Lefty Grove&quot;,
&quot;year&quot;: 1934,
&quot;careerWIN&quot;: 203,
&quot;careerHR&quot;: 89,
&quot;careerSO&quot;: 1566,
&quot;careerBB&quot;: 772 
},
{
 &quot;playerID&quot;: &quot;grovele01&quot;,
&quot;fullname&quot;: &quot;Lefty Grove&quot;,
&quot;year&quot;: 1935,
&quot;careerWIN&quot;: 223,
&quot;careerHR&quot;: 95,
&quot;careerSO&quot;: 1687,
&quot;careerBB&quot;: 837 
},
{
 &quot;playerID&quot;: &quot;grovele01&quot;,
&quot;fullname&quot;: &quot;Lefty Grove&quot;,
&quot;year&quot;: 1936,
&quot;careerWIN&quot;: 240,
&quot;careerHR&quot;: 109,
&quot;careerSO&quot;: 1817,
&quot;careerBB&quot;: 902 
},
{
 &quot;playerID&quot;: &quot;grovele01&quot;,
&quot;fullname&quot;: &quot;Lefty Grove&quot;,
&quot;year&quot;: 1937,
&quot;careerWIN&quot;: 257,
&quot;careerHR&quot;: 118,
&quot;careerSO&quot;: 1970,
&quot;careerBB&quot;: 985 
},
{
 &quot;playerID&quot;: &quot;grovele01&quot;,
&quot;fullname&quot;: &quot;Lefty Grove&quot;,
&quot;year&quot;: 1938,
&quot;careerWIN&quot;: 271,
&quot;careerHR&quot;: 126,
&quot;careerSO&quot;: 2069,
&quot;careerBB&quot;: 1037 
},
{
 &quot;playerID&quot;: &quot;grovele01&quot;,
&quot;fullname&quot;: &quot;Lefty Grove&quot;,
&quot;year&quot;: 1939,
&quot;careerWIN&quot;: 286,
&quot;careerHR&quot;: 134,
&quot;careerSO&quot;: 2150,
&quot;careerBB&quot;: 1095 
},
{
 &quot;playerID&quot;: &quot;grovele01&quot;,
&quot;fullname&quot;: &quot;Lefty Grove&quot;,
&quot;year&quot;: 1940,
&quot;careerWIN&quot;: 293,
&quot;careerHR&quot;: 154,
&quot;careerSO&quot;: 2212,
&quot;careerBB&quot;: 1145 
},
{
 &quot;playerID&quot;: &quot;grovele01&quot;,
&quot;fullname&quot;: &quot;Lefty Grove&quot;,
&quot;year&quot;: 1941,
&quot;careerWIN&quot;: 300,
&quot;careerHR&quot;: 162,
&quot;careerSO&quot;: 2266,
&quot;careerBB&quot;: 1187 
},
{
 &quot;playerID&quot;: &quot;hubbeca01&quot;,
&quot;fullname&quot;: &quot;Carl Hubbell&quot;,
&quot;year&quot;: 1928,
&quot;careerWIN&quot;: 10,
&quot;careerHR&quot;: 7,
&quot;careerSO&quot;: 37,
&quot;careerBB&quot;: 21 
},
{
 &quot;playerID&quot;: &quot;hubbeca01&quot;,
&quot;fullname&quot;: &quot;Carl Hubbell&quot;,
&quot;year&quot;: 1929,
&quot;careerWIN&quot;: 28,
&quot;careerHR&quot;: 24,
&quot;careerSO&quot;: 143,
&quot;careerBB&quot;: 88 
},
{
 &quot;playerID&quot;: &quot;hubbeca01&quot;,
&quot;fullname&quot;: &quot;Carl Hubbell&quot;,
&quot;year&quot;: 1930,
&quot;careerWIN&quot;: 45,
&quot;careerHR&quot;: 35,
&quot;careerSO&quot;: 260,
&quot;careerBB&quot;: 146 
},
{
 &quot;playerID&quot;: &quot;hubbeca01&quot;,
&quot;fullname&quot;: &quot;Carl Hubbell&quot;,
&quot;year&quot;: 1931,
&quot;careerWIN&quot;: 59,
&quot;careerHR&quot;: 49,
&quot;careerSO&quot;: 415,
&quot;careerBB&quot;: 213 
},
{
 &quot;playerID&quot;: &quot;hubbeca01&quot;,
&quot;fullname&quot;: &quot;Carl Hubbell&quot;,
&quot;year&quot;: 1932,
&quot;careerWIN&quot;: 77,
&quot;careerHR&quot;: 69,
&quot;careerSO&quot;: 552,
&quot;careerBB&quot;: 253 
},
{
 &quot;playerID&quot;: &quot;hubbeca01&quot;,
&quot;fullname&quot;: &quot;Carl Hubbell&quot;,
&quot;year&quot;: 1933,
&quot;careerWIN&quot;: 100,
&quot;careerHR&quot;: 75,
&quot;careerSO&quot;: 708,
&quot;careerBB&quot;: 300 
},
{
 &quot;playerID&quot;: &quot;hubbeca01&quot;,
&quot;fullname&quot;: &quot;Carl Hubbell&quot;,
&quot;year&quot;: 1934,
&quot;careerWIN&quot;: 121,
&quot;careerHR&quot;: 92,
&quot;careerSO&quot;: 826,
&quot;careerBB&quot;: 337 
},
{
 &quot;playerID&quot;: &quot;hubbeca01&quot;,
&quot;fullname&quot;: &quot;Carl Hubbell&quot;,
&quot;year&quot;: 1935,
&quot;careerWIN&quot;: 144,
&quot;careerHR&quot;: 119,
&quot;careerSO&quot;: 976,
&quot;careerBB&quot;: 386 
},
{
 &quot;playerID&quot;: &quot;hubbeca01&quot;,
&quot;fullname&quot;: &quot;Carl Hubbell&quot;,
&quot;year&quot;: 1936,
&quot;careerWIN&quot;: 170,
&quot;careerHR&quot;: 126,
&quot;careerSO&quot;: 1099,
&quot;careerBB&quot;: 443 
},
{
 &quot;playerID&quot;: &quot;hubbeca01&quot;,
&quot;fullname&quot;: &quot;Carl Hubbell&quot;,
&quot;year&quot;: 1937,
&quot;careerWIN&quot;: 192,
&quot;careerHR&quot;: 144,
&quot;careerSO&quot;: 1258,
&quot;careerBB&quot;: 498 
},
{
 &quot;playerID&quot;: &quot;hubbeca01&quot;,
&quot;fullname&quot;: &quot;Carl Hubbell&quot;,
&quot;year&quot;: 1938,
&quot;careerWIN&quot;: 205,
&quot;careerHR&quot;: 160,
&quot;careerSO&quot;: 1362,
&quot;careerBB&quot;: 531 
},
{
 &quot;playerID&quot;: &quot;hubbeca01&quot;,
&quot;fullname&quot;: &quot;Carl Hubbell&quot;,
&quot;year&quot;: 1939,
&quot;careerWIN&quot;: 216,
&quot;careerHR&quot;: 171,
&quot;careerSO&quot;: 1424,
&quot;careerBB&quot;: 555 
},
{
 &quot;playerID&quot;: &quot;hubbeca01&quot;,
&quot;fullname&quot;: &quot;Carl Hubbell&quot;,
&quot;year&quot;: 1940,
&quot;careerWIN&quot;: 227,
&quot;careerHR&quot;: 193,
&quot;careerSO&quot;: 1510,
&quot;careerBB&quot;: 614 
},
{
 &quot;playerID&quot;: &quot;hubbeca01&quot;,
&quot;fullname&quot;: &quot;Carl Hubbell&quot;,
&quot;year&quot;: 1941,
&quot;careerWIN&quot;: 238,
&quot;careerHR&quot;: 203,
&quot;careerSO&quot;: 1585,
&quot;careerBB&quot;: 667 
},
{
 &quot;playerID&quot;: &quot;hubbeca01&quot;,
&quot;fullname&quot;: &quot;Carl Hubbell&quot;,
&quot;year&quot;: 1942,
&quot;careerWIN&quot;: 249,
&quot;careerHR&quot;: 220,
&quot;careerSO&quot;: 1646,
&quot;careerBB&quot;: 701 
},
{
 &quot;playerID&quot;: &quot;hubbeca01&quot;,
&quot;fullname&quot;: &quot;Carl Hubbell&quot;,
&quot;year&quot;: 1943,
&quot;careerWIN&quot;: 253,
&quot;careerHR&quot;: 227,
&quot;careerSO&quot;: 1677,
&quot;careerBB&quot;: 725 
},
{
 &quot;playerID&quot;: &quot;jenkife01&quot;,
&quot;fullname&quot;: &quot;Fergie Jenkins&quot;,
&quot;year&quot;: 1965,
&quot;careerWIN&quot;: 2,
&quot;careerHR&quot;: 2,
&quot;careerSO&quot;: 10,
&quot;careerBB&quot;: 2 
},
{
 &quot;playerID&quot;: &quot;jenkife01&quot;,
&quot;fullname&quot;: &quot;Fergie Jenkins&quot;,
&quot;year&quot;: 1966,
&quot;careerWIN&quot;: 8,
&quot;careerHR&quot;: 26,
&quot;careerSO&quot;: 160,
&quot;careerBB&quot;: 54 
},
{
 &quot;playerID&quot;: &quot;jenkife01&quot;,
&quot;fullname&quot;: &quot;Fergie Jenkins&quot;,
&quot;year&quot;: 1967,
&quot;careerWIN&quot;: 28,
&quot;careerHR&quot;: 56,
&quot;careerSO&quot;: 396,
&quot;careerBB&quot;: 137 
},
{
 &quot;playerID&quot;: &quot;jenkife01&quot;,
&quot;fullname&quot;: &quot;Fergie Jenkins&quot;,
&quot;year&quot;: 1968,
&quot;careerWIN&quot;: 48,
&quot;careerHR&quot;: 82,
&quot;careerSO&quot;: 656,
&quot;careerBB&quot;: 202 
},
{
 &quot;playerID&quot;: &quot;jenkife01&quot;,
&quot;fullname&quot;: &quot;Fergie Jenkins&quot;,
&quot;year&quot;: 1969,
&quot;careerWIN&quot;: 69,
&quot;careerHR&quot;: 109,
&quot;careerSO&quot;: 929,
&quot;careerBB&quot;: 273 
},
{
 &quot;playerID&quot;: &quot;jenkife01&quot;,
&quot;fullname&quot;: &quot;Fergie Jenkins&quot;,
&quot;year&quot;: 1970,
&quot;careerWIN&quot;: 91,
&quot;careerHR&quot;: 139,
&quot;careerSO&quot;: 1203,
&quot;careerBB&quot;: 333 
},
{
 &quot;playerID&quot;: &quot;jenkife01&quot;,
&quot;fullname&quot;: &quot;Fergie Jenkins&quot;,
&quot;year&quot;: 1971,
&quot;careerWIN&quot;: 115,
&quot;careerHR&quot;: 168,
&quot;careerSO&quot;: 1466,
&quot;careerBB&quot;: 370 
},
{
 &quot;playerID&quot;: &quot;jenkife01&quot;,
&quot;fullname&quot;: &quot;Fergie Jenkins&quot;,
&quot;year&quot;: 1972,
&quot;careerWIN&quot;: 135,
&quot;careerHR&quot;: 200,
&quot;careerSO&quot;: 1650,
&quot;careerBB&quot;: 432 
},
{
 &quot;playerID&quot;: &quot;jenkife01&quot;,
&quot;fullname&quot;: &quot;Fergie Jenkins&quot;,
&quot;year&quot;: 1973,
&quot;careerWIN&quot;: 149,
&quot;careerHR&quot;: 235,
&quot;careerSO&quot;: 1820,
&quot;careerBB&quot;: 489 
},
{
 &quot;playerID&quot;: &quot;jenkife01&quot;,
&quot;fullname&quot;: &quot;Fergie Jenkins&quot;,
&quot;year&quot;: 1974,
&quot;careerWIN&quot;: 174,
&quot;careerHR&quot;: 262,
&quot;careerSO&quot;: 2045,
&quot;careerBB&quot;: 534 
},
{
 &quot;playerID&quot;: &quot;jenkife01&quot;,
&quot;fullname&quot;: &quot;Fergie Jenkins&quot;,
&quot;year&quot;: 1975,
&quot;careerWIN&quot;: 191,
&quot;careerHR&quot;: 299,
&quot;careerSO&quot;: 2202,
&quot;careerBB&quot;: 590 
},
{
 &quot;playerID&quot;: &quot;jenkife01&quot;,
&quot;fullname&quot;: &quot;Fergie Jenkins&quot;,
&quot;year&quot;: 1976,
&quot;careerWIN&quot;: 203,
&quot;careerHR&quot;: 319,
&quot;careerSO&quot;: 2344,
&quot;careerBB&quot;: 633 
},
{
 &quot;playerID&quot;: &quot;jenkife01&quot;,
&quot;fullname&quot;: &quot;Fergie Jenkins&quot;,
&quot;year&quot;: 1977,
&quot;careerWIN&quot;: 213,
&quot;careerHR&quot;: 349,
&quot;careerSO&quot;: 2449,
&quot;careerBB&quot;: 669 
},
{
 &quot;playerID&quot;: &quot;jenkife01&quot;,
&quot;fullname&quot;: &quot;Fergie Jenkins&quot;,
&quot;year&quot;: 1978,
&quot;careerWIN&quot;: 231,
&quot;careerHR&quot;: 370,
&quot;careerSO&quot;: 2606,
&quot;careerBB&quot;: 710 
},
{
 &quot;playerID&quot;: &quot;jenkife01&quot;,
&quot;fullname&quot;: &quot;Fergie Jenkins&quot;,
&quot;year&quot;: 1979,
&quot;careerWIN&quot;: 247,
&quot;careerHR&quot;: 410,
&quot;careerSO&quot;: 2770,
&quot;careerBB&quot;: 791 
},
{
 &quot;playerID&quot;: &quot;jenkife01&quot;,
&quot;fullname&quot;: &quot;Fergie Jenkins&quot;,
&quot;year&quot;: 1980,
&quot;careerWIN&quot;: 259,
&quot;careerHR&quot;: 432,
&quot;careerSO&quot;: 2899,
&quot;careerBB&quot;: 843 
},
{
 &quot;playerID&quot;: &quot;jenkife01&quot;,
&quot;fullname&quot;: &quot;Fergie Jenkins&quot;,
&quot;year&quot;: 1981,
&quot;careerWIN&quot;: 264,
&quot;careerHR&quot;: 446,
&quot;careerSO&quot;: 2962,
&quot;careerBB&quot;: 883 
},
{
 &quot;playerID&quot;: &quot;jenkife01&quot;,
&quot;fullname&quot;: &quot;Fergie Jenkins&quot;,
&quot;year&quot;: 1982,
&quot;careerWIN&quot;: 278,
&quot;careerHR&quot;: 465,
&quot;careerSO&quot;: 3096,
&quot;careerBB&quot;: 951 
},
{
 &quot;playerID&quot;: &quot;jenkife01&quot;,
&quot;fullname&quot;: &quot;Fergie Jenkins&quot;,
&quot;year&quot;: 1983,
&quot;careerWIN&quot;: 284,
&quot;careerHR&quot;: 484,
&quot;careerSO&quot;: 3192,
&quot;careerBB&quot;: 997 
},
{
 &quot;playerID&quot;: &quot;johnsra05&quot;,
&quot;fullname&quot;: &quot;Randy Johnson&quot;,
&quot;year&quot;: 1988,
&quot;careerWIN&quot;: 3,
&quot;careerHR&quot;: 3,
&quot;careerSO&quot;: 25,
&quot;careerBB&quot;: 7 
},
{
 &quot;playerID&quot;: &quot;johnsra05&quot;,
&quot;fullname&quot;: &quot;Randy Johnson&quot;,
&quot;year&quot;: 1989,
&quot;careerWIN&quot;: 10,
&quot;careerHR&quot;: 16,
&quot;careerSO&quot;: 155,
&quot;careerBB&quot;: 103 
},
{
 &quot;playerID&quot;: &quot;johnsra05&quot;,
&quot;fullname&quot;: &quot;Randy Johnson&quot;,
&quot;year&quot;: 1990,
&quot;careerWIN&quot;: 24,
&quot;careerHR&quot;: 42,
&quot;careerSO&quot;: 349,
&quot;careerBB&quot;: 223 
},
{
 &quot;playerID&quot;: &quot;johnsra05&quot;,
&quot;fullname&quot;: &quot;Randy Johnson&quot;,
&quot;year&quot;: 1991,
&quot;careerWIN&quot;: 37,
&quot;careerHR&quot;: 57,
&quot;careerSO&quot;: 577,
&quot;careerBB&quot;: 375 
},
{
 &quot;playerID&quot;: &quot;johnsra05&quot;,
&quot;fullname&quot;: &quot;Randy Johnson&quot;,
&quot;year&quot;: 1992,
&quot;careerWIN&quot;: 49,
&quot;careerHR&quot;: 70,
&quot;careerSO&quot;: 818,
&quot;careerBB&quot;: 519 
},
{
 &quot;playerID&quot;: &quot;johnsra05&quot;,
&quot;fullname&quot;: &quot;Randy Johnson&quot;,
&quot;year&quot;: 1993,
&quot;careerWIN&quot;: 68,
&quot;careerHR&quot;: 92,
&quot;careerSO&quot;: 1126,
&quot;careerBB&quot;: 618 
},
{
 &quot;playerID&quot;: &quot;johnsra05&quot;,
&quot;fullname&quot;: &quot;Randy Johnson&quot;,
&quot;year&quot;: 1994,
&quot;careerWIN&quot;: 81,
&quot;careerHR&quot;: 106,
&quot;careerSO&quot;: 1330,
&quot;careerBB&quot;: 690 
},
{
 &quot;playerID&quot;: &quot;johnsra05&quot;,
&quot;fullname&quot;: &quot;Randy Johnson&quot;,
&quot;year&quot;: 1995,
&quot;careerWIN&quot;: 99,
&quot;careerHR&quot;: 118,
&quot;careerSO&quot;: 1624,
&quot;careerBB&quot;: 755 
},
{
 &quot;playerID&quot;: &quot;johnsra05&quot;,
&quot;fullname&quot;: &quot;Randy Johnson&quot;,
&quot;year&quot;: 1996,
&quot;careerWIN&quot;: 104,
&quot;careerHR&quot;: 126,
&quot;careerSO&quot;: 1709,
&quot;careerBB&quot;: 780 
},
{
 &quot;playerID&quot;: &quot;johnsra05&quot;,
&quot;fullname&quot;: &quot;Randy Johnson&quot;,
&quot;year&quot;: 1997,
&quot;careerWIN&quot;: 124,
&quot;careerHR&quot;: 146,
&quot;careerSO&quot;: 2000,
&quot;careerBB&quot;: 857 
},
{
 &quot;playerID&quot;: &quot;johnsra05&quot;,
&quot;fullname&quot;: &quot;Randy Johnson&quot;,
&quot;year&quot;: 1998,
&quot;careerWIN&quot;: 143,
&quot;careerHR&quot;: 169,
&quot;careerSO&quot;: 2329,
&quot;careerBB&quot;: 943 
},
{
 &quot;playerID&quot;: &quot;johnsra05&quot;,
&quot;fullname&quot;: &quot;Randy Johnson&quot;,
&quot;year&quot;: 1999,
&quot;careerWIN&quot;: 160,
&quot;careerHR&quot;: 199,
&quot;careerSO&quot;: 2693,
&quot;careerBB&quot;: 1013 
},
{
 &quot;playerID&quot;: &quot;johnsra05&quot;,
&quot;fullname&quot;: &quot;Randy Johnson&quot;,
&quot;year&quot;: 2000,
&quot;careerWIN&quot;: 179,
&quot;careerHR&quot;: 222,
&quot;careerSO&quot;: 3040,
&quot;careerBB&quot;: 1089 
},
{
 &quot;playerID&quot;: &quot;johnsra05&quot;,
&quot;fullname&quot;: &quot;Randy Johnson&quot;,
&quot;year&quot;: 2001,
&quot;careerWIN&quot;: 200,
&quot;careerHR&quot;: 241,
&quot;careerSO&quot;: 3412,
&quot;careerBB&quot;: 1160 
},
{
 &quot;playerID&quot;: &quot;johnsra05&quot;,
&quot;fullname&quot;: &quot;Randy Johnson&quot;,
&quot;year&quot;: 2002,
&quot;careerWIN&quot;: 224,
&quot;careerHR&quot;: 267,
&quot;careerSO&quot;: 3746,
&quot;careerBB&quot;: 1231 
},
{
 &quot;playerID&quot;: &quot;johnsra05&quot;,
&quot;fullname&quot;: &quot;Randy Johnson&quot;,
&quot;year&quot;: 2003,
&quot;careerWIN&quot;: 230,
&quot;careerHR&quot;: 283,
&quot;careerSO&quot;: 3871,
&quot;careerBB&quot;: 1258 
},
{
 &quot;playerID&quot;: &quot;johnsra05&quot;,
&quot;fullname&quot;: &quot;Randy Johnson&quot;,
&quot;year&quot;: 2004,
&quot;careerWIN&quot;: 246,
&quot;careerHR&quot;: 301,
&quot;careerSO&quot;: 4161,
&quot;careerBB&quot;: 1302 
},
{
 &quot;playerID&quot;: &quot;johnsra05&quot;,
&quot;fullname&quot;: &quot;Randy Johnson&quot;,
&quot;year&quot;: 2005,
&quot;careerWIN&quot;: 263,
&quot;careerHR&quot;: 333,
&quot;careerSO&quot;: 4372,
&quot;careerBB&quot;: 1349 
},
{
 &quot;playerID&quot;: &quot;johnsra05&quot;,
&quot;fullname&quot;: &quot;Randy Johnson&quot;,
&quot;year&quot;: 2006,
&quot;careerWIN&quot;: 280,
&quot;careerHR&quot;: 361,
&quot;careerSO&quot;: 4544,
&quot;careerBB&quot;: 1409 
},
{
 &quot;playerID&quot;: &quot;johnsra05&quot;,
&quot;fullname&quot;: &quot;Randy Johnson&quot;,
&quot;year&quot;: 2007,
&quot;careerWIN&quot;: 284,
&quot;careerHR&quot;: 368,
&quot;careerSO&quot;: 4616,
&quot;careerBB&quot;: 1422 
},
{
 &quot;playerID&quot;: &quot;johnsra05&quot;,
&quot;fullname&quot;: &quot;Randy Johnson&quot;,
&quot;year&quot;: 2008,
&quot;careerWIN&quot;: 295,
&quot;careerHR&quot;: 392,
&quot;careerSO&quot;: 4789,
&quot;careerBB&quot;: 1466 
},
{
 &quot;playerID&quot;: &quot;johnsra05&quot;,
&quot;fullname&quot;: &quot;Randy Johnson&quot;,
&quot;year&quot;: 2009,
&quot;careerWIN&quot;: 303,
&quot;careerHR&quot;: 411,
&quot;careerSO&quot;: 4875,
&quot;careerBB&quot;: 1497 
},
{
 &quot;playerID&quot;: &quot;johnswa01&quot;,
&quot;fullname&quot;: &quot;Walter Johnson&quot;,
&quot;year&quot;: 1907,
&quot;careerWIN&quot;: 5,
&quot;careerHR&quot;: 1,
&quot;careerSO&quot;: 71,
&quot;careerBB&quot;: 20 
},
{
 &quot;playerID&quot;: &quot;johnswa01&quot;,
&quot;fullname&quot;: &quot;Walter Johnson&quot;,
&quot;year&quot;: 1908,
&quot;careerWIN&quot;: 19,
&quot;careerHR&quot;: 1,
&quot;careerSO&quot;: 231,
&quot;careerBB&quot;: 73 
},
{
 &quot;playerID&quot;: &quot;johnswa01&quot;,
&quot;fullname&quot;: &quot;Walter Johnson&quot;,
&quot;year&quot;: 1909,
&quot;careerWIN&quot;: 32,
&quot;careerHR&quot;: 2,
&quot;careerSO&quot;: 395,
&quot;careerBB&quot;: 157 
},
{
 &quot;playerID&quot;: &quot;johnswa01&quot;,
&quot;fullname&quot;: &quot;Walter Johnson&quot;,
&quot;year&quot;: 1910,
&quot;careerWIN&quot;: 57,
&quot;careerHR&quot;: 3,
&quot;careerSO&quot;: 708,
&quot;careerBB&quot;: 233 
},
{
 &quot;playerID&quot;: &quot;johnswa01&quot;,
&quot;fullname&quot;: &quot;Walter Johnson&quot;,
&quot;year&quot;: 1911,
&quot;careerWIN&quot;: 82,
&quot;careerHR&quot;: 11,
&quot;careerSO&quot;: 915,
&quot;careerBB&quot;: 303 
},
{
 &quot;playerID&quot;: &quot;johnswa01&quot;,
&quot;fullname&quot;: &quot;Walter Johnson&quot;,
&quot;year&quot;: 1912,
&quot;careerWIN&quot;: 115,
&quot;careerHR&quot;: 13,
&quot;careerSO&quot;: 1218,
&quot;careerBB&quot;: 379 
},
{
 &quot;playerID&quot;: &quot;johnswa01&quot;,
&quot;fullname&quot;: &quot;Walter Johnson&quot;,
&quot;year&quot;: 1913,
&quot;careerWIN&quot;: 151,
&quot;careerHR&quot;: 22,
&quot;careerSO&quot;: 1461,
&quot;careerBB&quot;: 417 
},
{
 &quot;playerID&quot;: &quot;johnswa01&quot;,
&quot;fullname&quot;: &quot;Walter Johnson&quot;,
&quot;year&quot;: 1914,
&quot;careerWIN&quot;: 179,
&quot;careerHR&quot;: 25,
&quot;careerSO&quot;: 1686,
&quot;careerBB&quot;: 491 
},
{
 &quot;playerID&quot;: &quot;johnswa01&quot;,
&quot;fullname&quot;: &quot;Walter Johnson&quot;,
&quot;year&quot;: 1915,
&quot;careerWIN&quot;: 206,
&quot;careerHR&quot;: 26,
&quot;careerSO&quot;: 1889,
&quot;careerBB&quot;: 547 
},
{
 &quot;playerID&quot;: &quot;johnswa01&quot;,
&quot;fullname&quot;: &quot;Walter Johnson&quot;,
&quot;year&quot;: 1916,
&quot;careerWIN&quot;: 231,
&quot;careerHR&quot;: 26,
&quot;careerSO&quot;: 2117,
&quot;careerBB&quot;: 629 
},
{
 &quot;playerID&quot;: &quot;johnswa01&quot;,
&quot;fullname&quot;: &quot;Walter Johnson&quot;,
&quot;year&quot;: 1917,
&quot;careerWIN&quot;: 254,
&quot;careerHR&quot;: 29,
&quot;careerSO&quot;: 2305,
&quot;careerBB&quot;: 697 
},
{
 &quot;playerID&quot;: &quot;johnswa01&quot;,
&quot;fullname&quot;: &quot;Walter Johnson&quot;,
&quot;year&quot;: 1918,
&quot;careerWIN&quot;: 277,
&quot;careerHR&quot;: 31,
&quot;careerSO&quot;: 2467,
&quot;careerBB&quot;: 767 
},
{
 &quot;playerID&quot;: &quot;johnswa01&quot;,
&quot;fullname&quot;: &quot;Walter Johnson&quot;,
&quot;year&quot;: 1919,
&quot;careerWIN&quot;: 297,
&quot;careerHR&quot;: 31,
&quot;careerSO&quot;: 2614,
&quot;careerBB&quot;: 818 
},
{
 &quot;playerID&quot;: &quot;johnswa01&quot;,
&quot;fullname&quot;: &quot;Walter Johnson&quot;,
&quot;year&quot;: 1920,
&quot;careerWIN&quot;: 305,
&quot;careerHR&quot;: 36,
&quot;careerSO&quot;: 2692,
&quot;careerBB&quot;: 845 
},
{
 &quot;playerID&quot;: &quot;johnswa01&quot;,
&quot;fullname&quot;: &quot;Walter Johnson&quot;,
&quot;year&quot;: 1921,
&quot;careerWIN&quot;: 322,
&quot;careerHR&quot;: 43,
&quot;careerSO&quot;: 2835,
&quot;careerBB&quot;: 937 
},
{
 &quot;playerID&quot;: &quot;johnswa01&quot;,
&quot;fullname&quot;: &quot;Walter Johnson&quot;,
&quot;year&quot;: 1922,
&quot;careerWIN&quot;: 337,
&quot;careerHR&quot;: 51,
&quot;careerSO&quot;: 2940,
&quot;careerBB&quot;: 1036 
},
{
 &quot;playerID&quot;: &quot;johnswa01&quot;,
&quot;fullname&quot;: &quot;Walter Johnson&quot;,
&quot;year&quot;: 1923,
&quot;careerWIN&quot;: 354,
&quot;careerHR&quot;: 60,
&quot;careerSO&quot;: 3070,
&quot;careerBB&quot;: 1109 
},
{
 &quot;playerID&quot;: &quot;johnswa01&quot;,
&quot;fullname&quot;: &quot;Walter Johnson&quot;,
&quot;year&quot;: 1924,
&quot;careerWIN&quot;: 377,
&quot;careerHR&quot;: 70,
&quot;careerSO&quot;: 3228,
&quot;careerBB&quot;: 1186 
},
{
 &quot;playerID&quot;: &quot;johnswa01&quot;,
&quot;fullname&quot;: &quot;Walter Johnson&quot;,
&quot;year&quot;: 1925,
&quot;careerWIN&quot;: 397,
&quot;careerHR&quot;: 77,
&quot;careerSO&quot;: 3336,
&quot;careerBB&quot;: 1264 
},
{
 &quot;playerID&quot;: &quot;johnswa01&quot;,
&quot;fullname&quot;: &quot;Walter Johnson&quot;,
&quot;year&quot;: 1926,
&quot;careerWIN&quot;: 412,
&quot;careerHR&quot;: 90,
&quot;careerSO&quot;: 3461,
&quot;careerBB&quot;: 1337 
},
{
 &quot;playerID&quot;: &quot;johnswa01&quot;,
&quot;fullname&quot;: &quot;Walter Johnson&quot;,
&quot;year&quot;: 1927,
&quot;careerWIN&quot;: 417,
&quot;careerHR&quot;: 97,
&quot;careerSO&quot;: 3509,
&quot;careerBB&quot;: 1363 
},
{
 &quot;playerID&quot;: &quot;johnto01&quot;,
&quot;fullname&quot;: &quot;Tommy John&quot;,
&quot;year&quot;: 1963,
&quot;careerWIN&quot;: 0,
&quot;careerHR&quot;: 1,
&quot;careerSO&quot;: 9,
&quot;careerBB&quot;: 6 
},
{
 &quot;playerID&quot;: &quot;johnto01&quot;,
&quot;fullname&quot;: &quot;Tommy John&quot;,
&quot;year&quot;: 1964,
&quot;careerWIN&quot;: 2,
&quot;careerHR&quot;: 11,
&quot;careerSO&quot;: 74,
&quot;careerBB&quot;: 41 
},
{
 &quot;playerID&quot;: &quot;johnto01&quot;,
&quot;fullname&quot;: &quot;Tommy John&quot;,
&quot;year&quot;: 1965,
&quot;careerWIN&quot;: 16,
&quot;careerHR&quot;: 23,
&quot;careerSO&quot;: 200,
&quot;careerBB&quot;: 99 
},
{
 &quot;playerID&quot;: &quot;johnto01&quot;,
&quot;fullname&quot;: &quot;Tommy John&quot;,
&quot;year&quot;: 1966,
&quot;careerWIN&quot;: 30,
&quot;careerHR&quot;: 36,
&quot;careerSO&quot;: 338,
&quot;careerBB&quot;: 156 
},
{
 &quot;playerID&quot;: &quot;johnto01&quot;,
&quot;fullname&quot;: &quot;Tommy John&quot;,
&quot;year&quot;: 1967,
&quot;careerWIN&quot;: 40,
&quot;careerHR&quot;: 48,
&quot;careerSO&quot;: 448,
&quot;careerBB&quot;: 203 
},
{
 &quot;playerID&quot;: &quot;johnto01&quot;,
&quot;fullname&quot;: &quot;Tommy John&quot;,
&quot;year&quot;: 1968,
&quot;careerWIN&quot;: 50,
&quot;careerHR&quot;: 58,
&quot;careerSO&quot;: 565,
&quot;careerBB&quot;: 252 
},
{
 &quot;playerID&quot;: &quot;johnto01&quot;,
&quot;fullname&quot;: &quot;Tommy John&quot;,
&quot;year&quot;: 1969,
&quot;careerWIN&quot;: 59,
&quot;careerHR&quot;: 74,
&quot;careerSO&quot;: 693,
&quot;careerBB&quot;: 342 
},
{
 &quot;playerID&quot;: &quot;johnto01&quot;,
&quot;fullname&quot;: &quot;Tommy John&quot;,
&quot;year&quot;: 1970,
&quot;careerWIN&quot;: 71,
&quot;careerHR&quot;: 93,
&quot;careerSO&quot;: 831,
&quot;careerBB&quot;: 443 
},
{
 &quot;playerID&quot;: &quot;johnto01&quot;,
&quot;fullname&quot;: &quot;Tommy John&quot;,
&quot;year&quot;: 1971,
&quot;careerWIN&quot;: 84,
&quot;careerHR&quot;: 110,
&quot;careerSO&quot;: 962,
&quot;careerBB&quot;: 501 
},
{
 &quot;playerID&quot;: &quot;johnto01&quot;,
&quot;fullname&quot;: &quot;Tommy John&quot;,
&quot;year&quot;: 1972,
&quot;careerWIN&quot;: 95,
&quot;careerHR&quot;: 124,
&quot;careerSO&quot;: 1079,
&quot;careerBB&quot;: 541 
},
{
 &quot;playerID&quot;: &quot;johnto01&quot;,
&quot;fullname&quot;: &quot;Tommy John&quot;,
&quot;year&quot;: 1973,
&quot;careerWIN&quot;: 111,
&quot;careerHR&quot;: 140,
&quot;careerSO&quot;: 1195,
&quot;careerBB&quot;: 591 
},
{
 &quot;playerID&quot;: &quot;johnto01&quot;,
&quot;fullname&quot;: &quot;Tommy John&quot;,
&quot;year&quot;: 1974,
&quot;careerWIN&quot;: 124,
&quot;careerHR&quot;: 144,
&quot;careerSO&quot;: 1273,
&quot;careerBB&quot;: 633 
},
{
 &quot;playerID&quot;: &quot;johnto01&quot;,
&quot;fullname&quot;: &quot;Tommy John&quot;,
&quot;year&quot;: 1976,
&quot;careerWIN&quot;: 134,
&quot;careerHR&quot;: 151,
&quot;careerSO&quot;: 1364,
&quot;careerBB&quot;: 694 
},
{
 &quot;playerID&quot;: &quot;johnto01&quot;,
&quot;fullname&quot;: &quot;Tommy John&quot;,
&quot;year&quot;: 1977,
&quot;careerWIN&quot;: 154,
&quot;careerHR&quot;: 163,
&quot;careerSO&quot;: 1487,
&quot;careerBB&quot;: 744 
},
{
 &quot;playerID&quot;: &quot;johnto01&quot;,
&quot;fullname&quot;: &quot;Tommy John&quot;,
&quot;year&quot;: 1978,
&quot;careerWIN&quot;: 171,
&quot;careerHR&quot;: 174,
&quot;careerSO&quot;: 1611,
&quot;careerBB&quot;: 797 
},
{
 &quot;playerID&quot;: &quot;johnto01&quot;,
&quot;fullname&quot;: &quot;Tommy John&quot;,
&quot;year&quot;: 1979,
&quot;careerWIN&quot;: 192,
&quot;careerHR&quot;: 183,
&quot;careerSO&quot;: 1722,
&quot;careerBB&quot;: 862 
},
{
 &quot;playerID&quot;: &quot;johnto01&quot;,
&quot;fullname&quot;: &quot;Tommy John&quot;,
&quot;year&quot;: 1980,
&quot;careerWIN&quot;: 214,
&quot;careerHR&quot;: 196,
&quot;careerSO&quot;: 1800,
&quot;careerBB&quot;: 918 
},
{
 &quot;playerID&quot;: &quot;johnto01&quot;,
&quot;fullname&quot;: &quot;Tommy John&quot;,
&quot;year&quot;: 1981,
&quot;careerWIN&quot;: 223,
&quot;careerHR&quot;: 206,
&quot;careerSO&quot;: 1850,
&quot;careerBB&quot;: 957 
},
{
 &quot;playerID&quot;: &quot;johnto01&quot;,
&quot;fullname&quot;: &quot;Tommy John&quot;,
&quot;year&quot;: 1982,
&quot;careerWIN&quot;: 237,
&quot;careerHR&quot;: 221,
&quot;careerSO&quot;: 1918,
&quot;careerBB&quot;: 996 
},
{
 &quot;playerID&quot;: &quot;johnto01&quot;,
&quot;fullname&quot;: &quot;Tommy John&quot;,
&quot;year&quot;: 1983,
&quot;careerWIN&quot;: 248,
&quot;careerHR&quot;: 241,
&quot;careerSO&quot;: 1983,
&quot;careerBB&quot;: 1045 
},
{
 &quot;playerID&quot;: &quot;johnto01&quot;,
&quot;fullname&quot;: &quot;Tommy John&quot;,
&quot;year&quot;: 1984,
&quot;careerWIN&quot;: 255,
&quot;careerHR&quot;: 256,
&quot;careerSO&quot;: 2030,
&quot;careerBB&quot;: 1101 
},
{
 &quot;playerID&quot;: &quot;johnto01&quot;,
&quot;fullname&quot;: &quot;Tommy John&quot;,
&quot;year&quot;: 1985,
&quot;careerWIN&quot;: 259,
&quot;careerHR&quot;: 265,
&quot;careerSO&quot;: 2055,
&quot;careerBB&quot;: 1129 
},
{
 &quot;playerID&quot;: &quot;johnto01&quot;,
&quot;fullname&quot;: &quot;Tommy John&quot;,
&quot;year&quot;: 1986,
&quot;careerWIN&quot;: 264,
&quot;careerHR&quot;: 273,
&quot;careerSO&quot;: 2083,
&quot;careerBB&quot;: 1144 
},
{
 &quot;playerID&quot;: &quot;johnto01&quot;,
&quot;fullname&quot;: &quot;Tommy John&quot;,
&quot;year&quot;: 1987,
&quot;careerWIN&quot;: 277,
&quot;careerHR&quot;: 285,
&quot;careerSO&quot;: 2146,
&quot;careerBB&quot;: 1191 
},
{
 &quot;playerID&quot;: &quot;johnto01&quot;,
&quot;fullname&quot;: &quot;Tommy John&quot;,
&quot;year&quot;: 1988,
&quot;careerWIN&quot;: 286,
&quot;careerHR&quot;: 296,
&quot;careerSO&quot;: 2227,
&quot;careerBB&quot;: 1237 
},
{
 &quot;playerID&quot;: &quot;johnto01&quot;,
&quot;fullname&quot;: &quot;Tommy John&quot;,
&quot;year&quot;: 1989,
&quot;careerWIN&quot;: 288,
&quot;careerHR&quot;: 302,
&quot;careerSO&quot;: 2245,
&quot;careerBB&quot;: 1259 
},
{
 &quot;playerID&quot;: &quot;kaatji01&quot;,
&quot;fullname&quot;: &quot;Jim Kaat&quot;,
&quot;year&quot;: 1959,
&quot;careerWIN&quot;: 0,
&quot;careerHR&quot;: 1,
&quot;careerSO&quot;: 2,
&quot;careerBB&quot;: 4 
},
{
 &quot;playerID&quot;: &quot;kaatji01&quot;,
&quot;fullname&quot;: &quot;Jim Kaat&quot;,
&quot;year&quot;: 1960,
&quot;careerWIN&quot;: 1,
&quot;careerHR&quot;: 9,
&quot;careerSO&quot;: 27,
&quot;careerBB&quot;: 35 
},
{
 &quot;playerID&quot;: &quot;kaatji01&quot;,
&quot;fullname&quot;: &quot;Jim Kaat&quot;,
&quot;year&quot;: 1961,
&quot;careerWIN&quot;: 10,
&quot;careerHR&quot;: 21,
&quot;careerSO&quot;: 149,
&quot;careerBB&quot;: 117 
},
{
 &quot;playerID&quot;: &quot;kaatji01&quot;,
&quot;fullname&quot;: &quot;Jim Kaat&quot;,
&quot;year&quot;: 1962,
&quot;careerWIN&quot;: 28,
&quot;careerHR&quot;: 44,
&quot;careerSO&quot;: 322,
&quot;careerBB&quot;: 192 
},
{
 &quot;playerID&quot;: &quot;kaatji01&quot;,
&quot;fullname&quot;: &quot;Jim Kaat&quot;,
&quot;year&quot;: 1963,
&quot;careerWIN&quot;: 38,
&quot;careerHR&quot;: 68,
&quot;careerSO&quot;: 427,
&quot;careerBB&quot;: 230 
},
{
 &quot;playerID&quot;: &quot;kaatji01&quot;,
&quot;fullname&quot;: &quot;Jim Kaat&quot;,
&quot;year&quot;: 1964,
&quot;careerWIN&quot;: 55,
&quot;careerHR&quot;: 91,
&quot;careerSO&quot;: 598,
&quot;careerBB&quot;: 290 
},
{
 &quot;playerID&quot;: &quot;kaatji01&quot;,
&quot;fullname&quot;: &quot;Jim Kaat&quot;,
&quot;year&quot;: 1965,
&quot;careerWIN&quot;: 73,
&quot;careerHR&quot;: 116,
&quot;careerSO&quot;: 752,
&quot;careerBB&quot;: 353 
},
{
 &quot;playerID&quot;: &quot;kaatji01&quot;,
&quot;fullname&quot;: &quot;Jim Kaat&quot;,
&quot;year&quot;: 1966,
&quot;careerWIN&quot;: 98,
&quot;careerHR&quot;: 145,
&quot;careerSO&quot;: 957,
&quot;careerBB&quot;: 408 
},
{
 &quot;playerID&quot;: &quot;kaatji01&quot;,
&quot;fullname&quot;: &quot;Jim Kaat&quot;,
&quot;year&quot;: 1967,
&quot;careerWIN&quot;: 114,
&quot;careerHR&quot;: 166,
&quot;careerSO&quot;: 1168,
&quot;careerBB&quot;: 450 
},
{
 &quot;playerID&quot;: &quot;kaatji01&quot;,
&quot;fullname&quot;: &quot;Jim Kaat&quot;,
&quot;year&quot;: 1968,
&quot;careerWIN&quot;: 128,
&quot;careerHR&quot;: 182,
&quot;careerSO&quot;: 1298,
&quot;careerBB&quot;: 490 
},
{
 &quot;playerID&quot;: &quot;kaatji01&quot;,
&quot;fullname&quot;: &quot;Jim Kaat&quot;,
&quot;year&quot;: 1969,
&quot;careerWIN&quot;: 142,
&quot;careerHR&quot;: 205,
&quot;careerSO&quot;: 1437,
&quot;careerBB&quot;: 565 
},
{
 &quot;playerID&quot;: &quot;kaatji01&quot;,
&quot;fullname&quot;: &quot;Jim Kaat&quot;,
&quot;year&quot;: 1970,
&quot;careerWIN&quot;: 156,
&quot;careerHR&quot;: 231,
&quot;careerSO&quot;: 1557,
&quot;careerBB&quot;: 623 
},
{
 &quot;playerID&quot;: &quot;kaatji01&quot;,
&quot;fullname&quot;: &quot;Jim Kaat&quot;,
&quot;year&quot;: 1971,
&quot;careerWIN&quot;: 169,
&quot;careerHR&quot;: 247,
&quot;careerSO&quot;: 1694,
&quot;careerBB&quot;: 670 
},
{
 &quot;playerID&quot;: &quot;kaatji01&quot;,
&quot;fullname&quot;: &quot;Jim Kaat&quot;,
&quot;year&quot;: 1972,
&quot;careerWIN&quot;: 179,
&quot;careerHR&quot;: 253,
&quot;careerSO&quot;: 1758,
&quot;careerBB&quot;: 690 
},
{
 &quot;playerID&quot;: &quot;kaatji01&quot;,
&quot;fullname&quot;: &quot;Jim Kaat&quot;,
&quot;year&quot;: 1973,
&quot;careerWIN&quot;: 194,
&quot;careerHR&quot;: 283,
&quot;careerSO&quot;: 1867,
&quot;careerBB&quot;: 733 
},
{
 &quot;playerID&quot;: &quot;kaatji01&quot;,
&quot;fullname&quot;: &quot;Jim Kaat&quot;,
&quot;year&quot;: 1974,
&quot;careerWIN&quot;: 215,
&quot;careerHR&quot;: 301,
&quot;careerSO&quot;: 2009,
&quot;careerBB&quot;: 796 
},
{
 &quot;playerID&quot;: &quot;kaatji01&quot;,
&quot;fullname&quot;: &quot;Jim Kaat&quot;,
&quot;year&quot;: 1975,
&quot;careerWIN&quot;: 235,
&quot;careerHR&quot;: 321,
&quot;careerSO&quot;: 2151,
&quot;careerBB&quot;: 873 
},
{
 &quot;playerID&quot;: &quot;kaatji01&quot;,
&quot;fullname&quot;: &quot;Jim Kaat&quot;,
&quot;year&quot;: 1976,
&quot;careerWIN&quot;: 247,
&quot;careerHR&quot;: 342,
&quot;careerSO&quot;: 2234,
&quot;careerBB&quot;: 905 
},
{
 &quot;playerID&quot;: &quot;kaatji01&quot;,
&quot;fullname&quot;: &quot;Jim Kaat&quot;,
&quot;year&quot;: 1977,
&quot;careerWIN&quot;: 253,
&quot;careerHR&quot;: 362,
&quot;careerSO&quot;: 2289,
&quot;careerBB&quot;: 945 
},
{
 &quot;playerID&quot;: &quot;kaatji01&quot;,
&quot;fullname&quot;: &quot;Jim Kaat&quot;,
&quot;year&quot;: 1978,
&quot;careerWIN&quot;: 261,
&quot;careerHR&quot;: 371,
&quot;careerSO&quot;: 2337,
&quot;careerBB&quot;: 977 
},
{
 &quot;playerID&quot;: &quot;kaatji01&quot;,
&quot;fullname&quot;: &quot;Jim Kaat&quot;,
&quot;year&quot;: 1979,
&quot;careerWIN&quot;: 264,
&quot;careerHR&quot;: 376,
&quot;careerSO&quot;: 2362,
&quot;careerBB&quot;: 996 
},
{
 &quot;playerID&quot;: &quot;kaatji01&quot;,
&quot;fullname&quot;: &quot;Jim Kaat&quot;,
&quot;year&quot;: 1980,
&quot;careerWIN&quot;: 272,
&quot;careerHR&quot;: 382,
&quot;careerSO&quot;: 2399,
&quot;careerBB&quot;: 1033 
},
{
 &quot;playerID&quot;: &quot;kaatji01&quot;,
&quot;fullname&quot;: &quot;Jim Kaat&quot;,
&quot;year&quot;: 1981,
&quot;careerWIN&quot;: 278,
&quot;careerHR&quot;: 384,
&quot;careerSO&quot;: 2407,
&quot;careerBB&quot;: 1050 
},
{
 &quot;playerID&quot;: &quot;kaatji01&quot;,
&quot;fullname&quot;: &quot;Jim Kaat&quot;,
&quot;year&quot;: 1982,
&quot;careerWIN&quot;: 283,
&quot;careerHR&quot;: 390,
&quot;careerSO&quot;: 2442,
&quot;careerBB&quot;: 1073 
},
{
 &quot;playerID&quot;: &quot;kaatji01&quot;,
&quot;fullname&quot;: &quot;Jim Kaat&quot;,
&quot;year&quot;: 1983,
&quot;careerWIN&quot;: 283,
&quot;careerHR&quot;: 395,
&quot;careerSO&quot;: 2461,
&quot;careerBB&quot;: 1083 
},
{
 &quot;playerID&quot;: &quot;keefeti01&quot;,
&quot;fullname&quot;: &quot;Tim Keefe&quot;,
&quot;year&quot;: 1880,
&quot;careerWIN&quot;: 6,
&quot;careerHR&quot;: 0,
&quot;careerSO&quot;: 43,
&quot;careerBB&quot;: 17 
},
{
 &quot;playerID&quot;: &quot;keefeti01&quot;,
&quot;fullname&quot;: &quot;Tim Keefe&quot;,
&quot;year&quot;: 1881,
&quot;careerWIN&quot;: 24,
&quot;careerHR&quot;: 4,
&quot;careerSO&quot;: 146,
&quot;careerBB&quot;: 98 
},
{
 &quot;playerID&quot;: &quot;keefeti01&quot;,
&quot;fullname&quot;: &quot;Tim Keefe&quot;,
&quot;year&quot;: 1882,
&quot;careerWIN&quot;: 41,
&quot;careerHR&quot;: 8,
&quot;careerSO&quot;: 262,
&quot;careerBB&quot;: 179 
},
{
 &quot;playerID&quot;: &quot;keefeti01&quot;,
&quot;fullname&quot;: &quot;Tim Keefe&quot;,
&quot;year&quot;: 1883,
&quot;careerWIN&quot;: 82,
&quot;careerHR&quot;: 14,
&quot;careerSO&quot;: 623,
&quot;careerBB&quot;: 277 
},
{
 &quot;playerID&quot;: &quot;keefeti01&quot;,
&quot;fullname&quot;: &quot;Tim Keefe&quot;,
&quot;year&quot;: 1884,
&quot;careerWIN&quot;: 119,
&quot;careerHR&quot;: 25,
&quot;careerSO&quot;: 957,
&quot;careerBB&quot;: 348 
},
{
 &quot;playerID&quot;: &quot;keefeti01&quot;,
&quot;fullname&quot;: &quot;Tim Keefe&quot;,
&quot;year&quot;: 1885,
&quot;careerWIN&quot;: 151,
&quot;careerHR&quot;: 31,
&quot;careerSO&quot;: 1184,
&quot;careerBB&quot;: 450 
},
{
 &quot;playerID&quot;: &quot;keefeti01&quot;,
&quot;fullname&quot;: &quot;Tim Keefe&quot;,
&quot;year&quot;: 1886,
&quot;careerWIN&quot;: 193,
&quot;careerHR&quot;: 40,
&quot;careerSO&quot;: 1481,
&quot;careerBB&quot;: 552 
},
{
 &quot;playerID&quot;: &quot;keefeti01&quot;,
&quot;fullname&quot;: &quot;Tim Keefe&quot;,
&quot;year&quot;: 1887,
&quot;careerWIN&quot;: 228,
&quot;careerHR&quot;: 51,
&quot;careerSO&quot;: 1670,
&quot;careerBB&quot;: 660 
},
{
 &quot;playerID&quot;: &quot;keefeti01&quot;,
&quot;fullname&quot;: &quot;Tim Keefe&quot;,
&quot;year&quot;: 1888,
&quot;careerWIN&quot;: 263,
&quot;careerHR&quot;: 56,
&quot;careerSO&quot;: 2005,
&quot;careerBB&quot;: 750 
},
{
 &quot;playerID&quot;: &quot;keefeti01&quot;,
&quot;fullname&quot;: &quot;Tim Keefe&quot;,
&quot;year&quot;: 1889,
&quot;careerWIN&quot;: 291,
&quot;careerHR&quot;: 65,
&quot;careerSO&quot;: 2230,
&quot;careerBB&quot;: 901 
},
{
 &quot;playerID&quot;: &quot;keefeti01&quot;,
&quot;fullname&quot;: &quot;Tim Keefe&quot;,
&quot;year&quot;: 1890,
&quot;careerWIN&quot;: 308,
&quot;careerHR&quot;: 71,
&quot;careerSO&quot;: 2318,
&quot;careerBB&quot;: 986 
},
{
 &quot;playerID&quot;: &quot;keefeti01&quot;,
&quot;fullname&quot;: &quot;Tim Keefe&quot;,
&quot;year&quot;: 1891,
&quot;careerWIN&quot;: 313,
&quot;careerHR&quot;: 74,
&quot;careerSO&quot;: 2382,
&quot;careerBB&quot;: 1041 
},
{
 &quot;playerID&quot;: &quot;keefeti01&quot;,
&quot;fullname&quot;: &quot;Tim Keefe&quot;,
&quot;year&quot;: 1892,
&quot;careerWIN&quot;: 332,
&quot;careerHR&quot;: 78,
&quot;careerSO&quot;: 2509,
&quot;careerBB&quot;: 1141 
},
{
 &quot;playerID&quot;: &quot;keefeti01&quot;,
&quot;fullname&quot;: &quot;Tim Keefe&quot;,
&quot;year&quot;: 1893,
&quot;careerWIN&quot;: 342,
&quot;careerHR&quot;: 81,
&quot;careerSO&quot;: 2562,
&quot;careerBB&quot;: 1220 
},
{
 &quot;playerID&quot;: &quot;lyonste01&quot;,
&quot;fullname&quot;: &quot;Ted Lyons&quot;,
&quot;year&quot;: 1923,
&quot;careerWIN&quot;: 2,
&quot;careerHR&quot;: 2,
&quot;careerSO&quot;: 6,
&quot;careerBB&quot;: 15 
},
{
 &quot;playerID&quot;: &quot;lyonste01&quot;,
&quot;fullname&quot;: &quot;Ted Lyons&quot;,
&quot;year&quot;: 1924,
&quot;careerWIN&quot;: 14,
&quot;careerHR&quot;: 12,
&quot;careerSO&quot;: 58,
&quot;careerBB&quot;: 87 
},
{
 &quot;playerID&quot;: &quot;lyonste01&quot;,
&quot;fullname&quot;: &quot;Ted Lyons&quot;,
&quot;year&quot;: 1925,
&quot;careerWIN&quot;: 35,
&quot;careerHR&quot;: 19,
&quot;careerSO&quot;: 103,
&quot;careerBB&quot;: 170 
},
{
 &quot;playerID&quot;: &quot;lyonste01&quot;,
&quot;fullname&quot;: &quot;Ted Lyons&quot;,
&quot;year&quot;: 1926,
&quot;careerWIN&quot;: 53,
&quot;careerHR&quot;: 25,
&quot;careerSO&quot;: 154,
&quot;careerBB&quot;: 276 
},
{
 &quot;playerID&quot;: &quot;lyonste01&quot;,
&quot;fullname&quot;: &quot;Ted Lyons&quot;,
&quot;year&quot;: 1927,
&quot;careerWIN&quot;: 75,
&quot;careerHR&quot;: 32,
&quot;careerSO&quot;: 225,
&quot;careerBB&quot;: 343 
},
{
 &quot;playerID&quot;: &quot;lyonste01&quot;,
&quot;fullname&quot;: &quot;Ted Lyons&quot;,
&quot;year&quot;: 1928,
&quot;careerWIN&quot;: 90,
&quot;careerHR&quot;: 43,
&quot;careerSO&quot;: 285,
&quot;careerBB&quot;: 411 
},
{
 &quot;playerID&quot;: &quot;lyonste01&quot;,
&quot;fullname&quot;: &quot;Ted Lyons&quot;,
&quot;year&quot;: 1929,
&quot;careerWIN&quot;: 104,
&quot;careerHR&quot;: 54,
&quot;careerSO&quot;: 342,
&quot;careerBB&quot;: 487 
},
{
 &quot;playerID&quot;: &quot;lyonste01&quot;,
&quot;fullname&quot;: &quot;Ted Lyons&quot;,
&quot;year&quot;: 1930,
&quot;careerWIN&quot;: 126,
&quot;careerHR&quot;: 66,
&quot;careerSO&quot;: 411,
&quot;careerBB&quot;: 544 
},
{
 &quot;playerID&quot;: &quot;lyonste01&quot;,
&quot;fullname&quot;: &quot;Ted Lyons&quot;,
&quot;year&quot;: 1931,
&quot;careerWIN&quot;: 130,
&quot;careerHR&quot;: 72,
&quot;careerSO&quot;: 427,
&quot;careerBB&quot;: 577 
},
{
 &quot;playerID&quot;: &quot;lyonste01&quot;,
&quot;fullname&quot;: &quot;Ted Lyons&quot;,
&quot;year&quot;: 1932,
&quot;careerWIN&quot;: 140,
&quot;careerHR&quot;: 82,
&quot;careerSO&quot;: 485,
&quot;careerBB&quot;: 648 
},
{
 &quot;playerID&quot;: &quot;lyonste01&quot;,
&quot;fullname&quot;: &quot;Ted Lyons&quot;,
&quot;year&quot;: 1933,
&quot;careerWIN&quot;: 150,
&quot;careerHR&quot;: 92,
&quot;careerSO&quot;: 559,
&quot;careerBB&quot;: 722 
},
{
 &quot;playerID&quot;: &quot;lyonste01&quot;,
&quot;fullname&quot;: &quot;Ted Lyons&quot;,
&quot;year&quot;: 1934,
&quot;careerWIN&quot;: 161,
&quot;careerHR&quot;: 107,
&quot;careerSO&quot;: 612,
&quot;careerBB&quot;: 788 
},
{
 &quot;playerID&quot;: &quot;lyonste01&quot;,
&quot;fullname&quot;: &quot;Ted Lyons&quot;,
&quot;year&quot;: 1935,
&quot;careerWIN&quot;: 176,
&quot;careerHR&quot;: 122,
&quot;careerSO&quot;: 666,
&quot;careerBB&quot;: 844 
},
{
 &quot;playerID&quot;: &quot;lyonste01&quot;,
&quot;fullname&quot;: &quot;Ted Lyons&quot;,
&quot;year&quot;: 1936,
&quot;careerWIN&quot;: 186,
&quot;careerHR&quot;: 143,
&quot;careerSO&quot;: 714,
&quot;careerBB&quot;: 889 
},
{
 &quot;playerID&quot;: &quot;lyonste01&quot;,
&quot;fullname&quot;: &quot;Ted Lyons&quot;,
&quot;year&quot;: 1937,
&quot;careerWIN&quot;: 198,
&quot;careerHR&quot;: 164,
&quot;careerSO&quot;: 759,
&quot;careerBB&quot;: 934 
},
{
 &quot;playerID&quot;: &quot;lyonste01&quot;,
&quot;fullname&quot;: &quot;Ted Lyons&quot;,
&quot;year&quot;: 1938,
&quot;careerWIN&quot;: 207,
&quot;careerHR&quot;: 177,
&quot;careerSO&quot;: 813,
&quot;careerBB&quot;: 986 
},
{
 &quot;playerID&quot;: &quot;lyonste01&quot;,
&quot;fullname&quot;: &quot;Ted Lyons&quot;,
&quot;year&quot;: 1939,
&quot;careerWIN&quot;: 221,
&quot;careerHR&quot;: 184,
&quot;careerSO&quot;: 878,
&quot;careerBB&quot;: 1012 
},
{
 &quot;playerID&quot;: &quot;lyonste01&quot;,
&quot;fullname&quot;: &quot;Ted Lyons&quot;,
&quot;year&quot;: 1940,
&quot;careerWIN&quot;: 233,
&quot;careerHR&quot;: 201,
&quot;careerSO&quot;: 950,
&quot;careerBB&quot;: 1049 
},
{
 &quot;playerID&quot;: &quot;lyonste01&quot;,
&quot;fullname&quot;: &quot;Ted Lyons&quot;,
&quot;year&quot;: 1941,
&quot;careerWIN&quot;: 245,
&quot;careerHR&quot;: 210,
&quot;careerSO&quot;: 1013,
&quot;careerBB&quot;: 1086 
},
{
 &quot;playerID&quot;: &quot;lyonste01&quot;,
&quot;fullname&quot;: &quot;Ted Lyons&quot;,
&quot;year&quot;: 1942,
&quot;careerWIN&quot;: 259,
&quot;careerHR&quot;: 221,
&quot;careerSO&quot;: 1063,
&quot;careerBB&quot;: 1112 
},
{
 &quot;playerID&quot;: &quot;lyonste01&quot;,
&quot;fullname&quot;: &quot;Ted Lyons&quot;,
&quot;year&quot;: 1946,
&quot;careerWIN&quot;: 260,
&quot;careerHR&quot;: 223,
&quot;careerSO&quot;: 1073,
&quot;careerBB&quot;: 1121 
},
{
 &quot;playerID&quot;: &quot;maddugr01&quot;,
&quot;fullname&quot;: &quot;Greg Maddux&quot;,
&quot;year&quot;: 1986,
&quot;careerWIN&quot;: 2,
&quot;careerHR&quot;: 3,
&quot;careerSO&quot;: 20,
&quot;careerBB&quot;: 11 
},
{
 &quot;playerID&quot;: &quot;maddugr01&quot;,
&quot;fullname&quot;: &quot;Greg Maddux&quot;,
&quot;year&quot;: 1987,
&quot;careerWIN&quot;: 8,
&quot;careerHR&quot;: 20,
&quot;careerSO&quot;: 121,
&quot;careerBB&quot;: 85 
},
{
 &quot;playerID&quot;: &quot;maddugr01&quot;,
&quot;fullname&quot;: &quot;Greg Maddux&quot;,
&quot;year&quot;: 1988,
&quot;careerWIN&quot;: 26,
&quot;careerHR&quot;: 33,
&quot;careerSO&quot;: 261,
&quot;careerBB&quot;: 166 
},
{
 &quot;playerID&quot;: &quot;maddugr01&quot;,
&quot;fullname&quot;: &quot;Greg Maddux&quot;,
&quot;year&quot;: 1989,
&quot;careerWIN&quot;: 45,
&quot;careerHR&quot;: 46,
&quot;careerSO&quot;: 396,
&quot;careerBB&quot;: 248 
},
{
 &quot;playerID&quot;: &quot;maddugr01&quot;,
&quot;fullname&quot;: &quot;Greg Maddux&quot;,
&quot;year&quot;: 1990,
&quot;careerWIN&quot;: 60,
&quot;careerHR&quot;: 57,
&quot;careerSO&quot;: 540,
&quot;careerBB&quot;: 319 
},
{
 &quot;playerID&quot;: &quot;maddugr01&quot;,
&quot;fullname&quot;: &quot;Greg Maddux&quot;,
&quot;year&quot;: 1991,
&quot;careerWIN&quot;: 75,
&quot;careerHR&quot;: 75,
&quot;careerSO&quot;: 738,
&quot;careerBB&quot;: 385 
},
{
 &quot;playerID&quot;: &quot;maddugr01&quot;,
&quot;fullname&quot;: &quot;Greg Maddux&quot;,
&quot;year&quot;: 1992,
&quot;careerWIN&quot;: 95,
&quot;careerHR&quot;: 82,
&quot;careerSO&quot;: 937,
&quot;careerBB&quot;: 455 
},
{
 &quot;playerID&quot;: &quot;maddugr01&quot;,
&quot;fullname&quot;: &quot;Greg Maddux&quot;,
&quot;year&quot;: 1993,
&quot;careerWIN&quot;: 115,
&quot;careerHR&quot;: 96,
&quot;careerSO&quot;: 1134,
&quot;careerBB&quot;: 507 
},
{
 &quot;playerID&quot;: &quot;maddugr01&quot;,
&quot;fullname&quot;: &quot;Greg Maddux&quot;,
&quot;year&quot;: 1994,
&quot;careerWIN&quot;: 131,
&quot;careerHR&quot;: 100,
&quot;careerSO&quot;: 1290,
&quot;careerBB&quot;: 538 
},
{
 &quot;playerID&quot;: &quot;maddugr01&quot;,
&quot;fullname&quot;: &quot;Greg Maddux&quot;,
&quot;year&quot;: 1995,
&quot;careerWIN&quot;: 150,
&quot;careerHR&quot;: 108,
&quot;careerSO&quot;: 1471,
&quot;careerBB&quot;: 561 
},
{
 &quot;playerID&quot;: &quot;maddugr01&quot;,
&quot;fullname&quot;: &quot;Greg Maddux&quot;,
&quot;year&quot;: 1996,
&quot;careerWIN&quot;: 165,
&quot;careerHR&quot;: 119,
&quot;careerSO&quot;: 1643,
&quot;careerBB&quot;: 589 
},
{
 &quot;playerID&quot;: &quot;maddugr01&quot;,
&quot;fullname&quot;: &quot;Greg Maddux&quot;,
&quot;year&quot;: 1997,
&quot;careerWIN&quot;: 184,
&quot;careerHR&quot;: 128,
&quot;careerSO&quot;: 1820,
&quot;careerBB&quot;: 609 
},
{
 &quot;playerID&quot;: &quot;maddugr01&quot;,
&quot;fullname&quot;: &quot;Greg Maddux&quot;,
&quot;year&quot;: 1998,
&quot;careerWIN&quot;: 202,
&quot;careerHR&quot;: 141,
&quot;careerSO&quot;: 2024,
&quot;careerBB&quot;: 654 
},
{
 &quot;playerID&quot;: &quot;maddugr01&quot;,
&quot;fullname&quot;: &quot;Greg Maddux&quot;,
&quot;year&quot;: 1999,
&quot;careerWIN&quot;: 221,
&quot;careerHR&quot;: 157,
&quot;careerSO&quot;: 2160,
&quot;careerBB&quot;: 691 
},
{
 &quot;playerID&quot;: &quot;maddugr01&quot;,
&quot;fullname&quot;: &quot;Greg Maddux&quot;,
&quot;year&quot;: 2000,
&quot;careerWIN&quot;: 240,
&quot;careerHR&quot;: 176,
&quot;careerSO&quot;: 2350,
&quot;careerBB&quot;: 733 
},
{
 &quot;playerID&quot;: &quot;maddugr01&quot;,
&quot;fullname&quot;: &quot;Greg Maddux&quot;,
&quot;year&quot;: 2001,
&quot;careerWIN&quot;: 257,
&quot;careerHR&quot;: 196,
&quot;careerSO&quot;: 2523,
&quot;careerBB&quot;: 760 
},
{
 &quot;playerID&quot;: &quot;maddugr01&quot;,
&quot;fullname&quot;: &quot;Greg Maddux&quot;,
&quot;year&quot;: 2002,
&quot;careerWIN&quot;: 273,
&quot;careerHR&quot;: 210,
&quot;careerSO&quot;: 2641,
&quot;careerBB&quot;: 805 
},
{
 &quot;playerID&quot;: &quot;maddugr01&quot;,
&quot;fullname&quot;: &quot;Greg Maddux&quot;,
&quot;year&quot;: 2003,
&quot;careerWIN&quot;: 289,
&quot;careerHR&quot;: 234,
&quot;careerSO&quot;: 2765,
&quot;careerBB&quot;: 838 
},
{
 &quot;playerID&quot;: &quot;maddugr01&quot;,
&quot;fullname&quot;: &quot;Greg Maddux&quot;,
&quot;year&quot;: 2004,
&quot;careerWIN&quot;: 305,
&quot;careerHR&quot;: 269,
&quot;careerSO&quot;: 2916,
&quot;careerBB&quot;: 871 
},
{
 &quot;playerID&quot;: &quot;maddugr01&quot;,
&quot;fullname&quot;: &quot;Greg Maddux&quot;,
&quot;year&quot;: 2005,
&quot;careerWIN&quot;: 318,
&quot;careerHR&quot;: 298,
&quot;careerSO&quot;: 3052,
&quot;careerBB&quot;: 907 
},
{
 &quot;playerID&quot;: &quot;maddugr01&quot;,
&quot;fullname&quot;: &quot;Greg Maddux&quot;,
&quot;year&quot;: 2006,
&quot;careerWIN&quot;: 333,
&quot;careerHR&quot;: 318,
&quot;careerSO&quot;: 3169,
&quot;careerBB&quot;: 944 
},
{
 &quot;playerID&quot;: &quot;maddugr01&quot;,
&quot;fullname&quot;: &quot;Greg Maddux&quot;,
&quot;year&quot;: 2007,
&quot;careerWIN&quot;: 347,
&quot;careerHR&quot;: 332,
&quot;careerSO&quot;: 3273,
&quot;careerBB&quot;: 969 
},
{
 &quot;playerID&quot;: &quot;maddugr01&quot;,
&quot;fullname&quot;: &quot;Greg Maddux&quot;,
&quot;year&quot;: 2008,
&quot;careerWIN&quot;: 355,
&quot;careerHR&quot;: 353,
&quot;careerSO&quot;: 3371,
&quot;careerBB&quot;: 999 
},
{
 &quot;playerID&quot;: &quot;mathebo01&quot;,
&quot;fullname&quot;: &quot;Bobby Mathews&quot;,
&quot;year&quot;: 1871,
&quot;careerWIN&quot;: 6,
&quot;careerHR&quot;: 5,
&quot;careerSO&quot;: 17,
&quot;careerBB&quot;: 21 
},
{
 &quot;playerID&quot;: &quot;mathebo01&quot;,
&quot;fullname&quot;: &quot;Bobby Mathews&quot;,
&quot;year&quot;: 1872,
&quot;careerWIN&quot;: 31,
&quot;careerHR&quot;: 8,
&quot;careerSO&quot;: 72,
&quot;careerBB&quot;: 73 
},
{
 &quot;playerID&quot;: &quot;mathebo01&quot;,
&quot;fullname&quot;: &quot;Bobby Mathews&quot;,
&quot;year&quot;: 1873,
&quot;careerWIN&quot;: 60,
&quot;careerHR&quot;: 13,
&quot;careerSO&quot;: 147,
&quot;careerBB&quot;: 135 
},
{
 &quot;playerID&quot;: &quot;mathebo01&quot;,
&quot;fullname&quot;: &quot;Bobby Mathews&quot;,
&quot;year&quot;: 1874,
&quot;careerWIN&quot;: 102,
&quot;careerHR&quot;: 16,
&quot;careerSO&quot;: 157,
&quot;careerBB&quot;: 174 
},
{
 &quot;playerID&quot;: &quot;mathebo01&quot;,
&quot;fullname&quot;: &quot;Bobby Mathews&quot;,
&quot;year&quot;: 1875,
&quot;careerWIN&quot;: 131,
&quot;careerHR&quot;: 19,
&quot;careerSO&quot;: 167,
&quot;careerBB&quot;: 197 
},
{
 &quot;playerID&quot;: &quot;mathebo01&quot;,
&quot;fullname&quot;: &quot;Bobby Mathews&quot;,
&quot;year&quot;: 1876,
&quot;careerWIN&quot;: 152,
&quot;careerHR&quot;: 27,
&quot;careerSO&quot;: 204,
&quot;careerBB&quot;: 221 
},
{
 &quot;playerID&quot;: &quot;mathebo01&quot;,
&quot;fullname&quot;: &quot;Bobby Mathews&quot;,
&quot;year&quot;: 1877,
&quot;careerWIN&quot;: 155,
&quot;careerHR&quot;: 27,
&quot;careerSO&quot;: 213,
&quot;careerBB&quot;: 238 
},
{
 &quot;playerID&quot;: &quot;mathebo01&quot;,
&quot;fullname&quot;: &quot;Bobby Mathews&quot;,
&quot;year&quot;: 1879,
&quot;careerWIN&quot;: 167,
&quot;careerHR&quot;: 31,
&quot;careerSO&quot;: 303,
&quot;careerBB&quot;: 264 
},
{
 &quot;playerID&quot;: &quot;mathebo01&quot;,
&quot;fullname&quot;: &quot;Bobby Mathews&quot;,
&quot;year&quot;: 1881,
&quot;careerWIN&quot;: 172,
&quot;careerHR&quot;: 33,
&quot;careerSO&quot;: 336,
&quot;careerBB&quot;: 296 
},
{
 &quot;playerID&quot;: &quot;mathebo01&quot;,
&quot;fullname&quot;: &quot;Bobby Mathews&quot;,
&quot;year&quot;: 1882,
&quot;careerWIN&quot;: 191,
&quot;careerHR&quot;: 38,
&quot;careerSO&quot;: 489,
&quot;careerBB&quot;: 318 
},
{
 &quot;playerID&quot;: &quot;mathebo01&quot;,
&quot;fullname&quot;: &quot;Bobby Mathews&quot;,
&quot;year&quot;: 1883,
&quot;careerWIN&quot;: 221,
&quot;careerHR&quot;: 49,
&quot;careerSO&quot;: 692,
&quot;careerBB&quot;: 349 
},
{
 &quot;playerID&quot;: &quot;mathebo01&quot;,
&quot;fullname&quot;: &quot;Bobby Mathews&quot;,
&quot;year&quot;: 1884,
&quot;careerWIN&quot;: 251,
&quot;careerHR&quot;: 59,
&quot;careerSO&quot;: 978,
&quot;careerBB&quot;: 398 
},
{
 &quot;playerID&quot;: &quot;mathebo01&quot;,
&quot;fullname&quot;: &quot;Bobby Mathews&quot;,
&quot;year&quot;: 1885,
&quot;careerWIN&quot;: 281,
&quot;careerHR&quot;: 62,
&quot;careerSO&quot;: 1264,
&quot;careerBB&quot;: 455 
},
{
 &quot;playerID&quot;: &quot;mathebo01&quot;,
&quot;fullname&quot;: &quot;Bobby Mathews&quot;,
&quot;year&quot;: 1886,
&quot;careerWIN&quot;: 294,
&quot;careerHR&quot;: 65,
&quot;careerSO&quot;: 1357,
&quot;careerBB&quot;: 508 
},
{
 &quot;playerID&quot;: &quot;mathebo01&quot;,
&quot;fullname&quot;: &quot;Bobby Mathews&quot;,
&quot;year&quot;: 1887,
&quot;careerWIN&quot;: 297,
&quot;careerHR&quot;: 69,
&quot;careerSO&quot;: 1366,
&quot;careerBB&quot;: 533 
},
{
 &quot;playerID&quot;: &quot;mathech01&quot;,
&quot;fullname&quot;: &quot;Christy Mathewson&quot;,
&quot;year&quot;: 1900,
&quot;careerWIN&quot;: 0,
&quot;careerHR&quot;: 1,
&quot;careerSO&quot;: 15,
&quot;careerBB&quot;: 20 
},
{
 &quot;playerID&quot;: &quot;mathech01&quot;,
&quot;fullname&quot;: &quot;Christy Mathewson&quot;,
&quot;year&quot;: 1901,
&quot;careerWIN&quot;: 20,
&quot;careerHR&quot;: 4,
&quot;careerSO&quot;: 236,
&quot;careerBB&quot;: 117 
},
{
 &quot;playerID&quot;: &quot;mathech01&quot;,
&quot;fullname&quot;: &quot;Christy Mathewson&quot;,
&quot;year&quot;: 1902,
&quot;careerWIN&quot;: 34,
&quot;careerHR&quot;: 7,
&quot;careerSO&quot;: 395,
&quot;careerBB&quot;: 190 
},
{
 &quot;playerID&quot;: &quot;mathech01&quot;,
&quot;fullname&quot;: &quot;Christy Mathewson&quot;,
&quot;year&quot;: 1903,
&quot;careerWIN&quot;: 64,
&quot;careerHR&quot;: 11,
&quot;careerSO&quot;: 662,
&quot;careerBB&quot;: 290 
},
{
 &quot;playerID&quot;: &quot;mathech01&quot;,
&quot;fullname&quot;: &quot;Christy Mathewson&quot;,
&quot;year&quot;: 1904,
&quot;careerWIN&quot;: 97,
&quot;careerHR&quot;: 18,
&quot;careerSO&quot;: 874,
&quot;careerBB&quot;: 368 
},
{
 &quot;playerID&quot;: &quot;mathech01&quot;,
&quot;fullname&quot;: &quot;Christy Mathewson&quot;,
&quot;year&quot;: 1905,
&quot;careerWIN&quot;: 128,
&quot;careerHR&quot;: 22,
&quot;careerSO&quot;: 1080,
&quot;careerBB&quot;: 432 
},
{
 &quot;playerID&quot;: &quot;mathech01&quot;,
&quot;fullname&quot;: &quot;Christy Mathewson&quot;,
&quot;year&quot;: 1906,
&quot;careerWIN&quot;: 150,
&quot;careerHR&quot;: 25,
&quot;careerSO&quot;: 1208,
&quot;careerBB&quot;: 509 
},
{
 &quot;playerID&quot;: &quot;mathech01&quot;,
&quot;fullname&quot;: &quot;Christy Mathewson&quot;,
&quot;year&quot;: 1907,
&quot;careerWIN&quot;: 174,
&quot;careerHR&quot;: 31,
&quot;careerSO&quot;: 1386,
&quot;careerBB&quot;: 562 
},
{
 &quot;playerID&quot;: &quot;mathech01&quot;,
&quot;fullname&quot;: &quot;Christy Mathewson&quot;,
&quot;year&quot;: 1908,
&quot;careerWIN&quot;: 211,
&quot;careerHR&quot;: 36,
&quot;careerSO&quot;: 1645,
&quot;careerBB&quot;: 604 
},
{
 &quot;playerID&quot;: &quot;mathech01&quot;,
&quot;fullname&quot;: &quot;Christy Mathewson&quot;,
&quot;year&quot;: 1909,
&quot;careerWIN&quot;: 236,
&quot;careerHR&quot;: 38,
&quot;careerSO&quot;: 1794,
&quot;careerBB&quot;: 640 
},
{
 &quot;playerID&quot;: &quot;mathech01&quot;,
&quot;fullname&quot;: &quot;Christy Mathewson&quot;,
&quot;year&quot;: 1910,
&quot;careerWIN&quot;: 263,
&quot;careerHR&quot;: 43,
&quot;careerSO&quot;: 1978,
&quot;careerBB&quot;: 700 
},
{
 &quot;playerID&quot;: &quot;mathech01&quot;,
&quot;fullname&quot;: &quot;Christy Mathewson&quot;,
&quot;year&quot;: 1911,
&quot;careerWIN&quot;: 289,
&quot;careerHR&quot;: 48,
&quot;careerSO&quot;: 2119,
&quot;careerBB&quot;: 738 
},
{
 &quot;playerID&quot;: &quot;mathech01&quot;,
&quot;fullname&quot;: &quot;Christy Mathewson&quot;,
&quot;year&quot;: 1912,
&quot;careerWIN&quot;: 312,
&quot;careerHR&quot;: 54,
&quot;careerSO&quot;: 2253,
&quot;careerBB&quot;: 772 
},
{
 &quot;playerID&quot;: &quot;mathech01&quot;,
&quot;fullname&quot;: &quot;Christy Mathewson&quot;,
&quot;year&quot;: 1913,
&quot;careerWIN&quot;: 337,
&quot;careerHR&quot;: 62,
&quot;careerSO&quot;: 2346,
&quot;careerBB&quot;: 793 
},
{
 &quot;playerID&quot;: &quot;mathech01&quot;,
&quot;fullname&quot;: &quot;Christy Mathewson&quot;,
&quot;year&quot;: 1914,
&quot;careerWIN&quot;: 361,
&quot;careerHR&quot;: 78,
&quot;careerSO&quot;: 2426,
&quot;careerBB&quot;: 816 
},
{
 &quot;playerID&quot;: &quot;mathech01&quot;,
&quot;fullname&quot;: &quot;Christy Mathewson&quot;,
&quot;year&quot;: 1915,
&quot;careerWIN&quot;: 369,
&quot;careerHR&quot;: 87,
&quot;careerSO&quot;: 2483,
&quot;careerBB&quot;: 836 
},
{
 &quot;playerID&quot;: &quot;mathech01&quot;,
&quot;fullname&quot;: &quot;Christy Mathewson&quot;,
&quot;year&quot;: 1916,
&quot;careerWIN&quot;: 373,
&quot;careerHR&quot;: 91,
&quot;careerSO&quot;: 2502,
&quot;careerBB&quot;: 844 
},
{
 &quot;playerID&quot;: &quot;mccorji01&quot;,
&quot;fullname&quot;: &quot;Jim McCormick&quot;,
&quot;year&quot;: 1878,
&quot;careerWIN&quot;: 5,
&quot;careerHR&quot;: 0,
&quot;careerSO&quot;: 36,
&quot;careerBB&quot;: 15 
},
{
 &quot;playerID&quot;: &quot;mccorji01&quot;,
&quot;fullname&quot;: &quot;Jim McCormick&quot;,
&quot;year&quot;: 1879,
&quot;careerWIN&quot;: 25,
&quot;careerHR&quot;: 3,
&quot;careerSO&quot;: 233,
&quot;careerBB&quot;: 89 
},
{
 &quot;playerID&quot;: &quot;mccorji01&quot;,
&quot;fullname&quot;: &quot;Jim McCormick&quot;,
&quot;year&quot;: 1880,
&quot;careerWIN&quot;: 70,
&quot;careerHR&quot;: 5,
&quot;careerSO&quot;: 493,
&quot;careerBB&quot;: 164 
},
{
 &quot;playerID&quot;: &quot;mccorji01&quot;,
&quot;fullname&quot;: &quot;Jim McCormick&quot;,
&quot;year&quot;: 1881,
&quot;careerWIN&quot;: 96,
&quot;careerHR&quot;: 9,
&quot;careerSO&quot;: 671,
&quot;careerBB&quot;: 248 
},
{
 &quot;playerID&quot;: &quot;mccorji01&quot;,
&quot;fullname&quot;: &quot;Jim McCormick&quot;,
&quot;year&quot;: 1882,
&quot;careerWIN&quot;: 132,
&quot;careerHR&quot;: 23,
&quot;careerSO&quot;: 871,
&quot;careerBB&quot;: 351 
},
{
 &quot;playerID&quot;: &quot;mccorji01&quot;,
&quot;fullname&quot;: &quot;Jim McCormick&quot;,
&quot;year&quot;: 1883,
&quot;careerWIN&quot;: 160,
&quot;careerHR&quot;: 24,
&quot;careerSO&quot;: 1016,
&quot;careerBB&quot;: 416 
},
{
 &quot;playerID&quot;: &quot;mccorji01&quot;,
&quot;fullname&quot;: &quot;Jim McCormick&quot;,
&quot;year&quot;: 1884,
&quot;careerWIN&quot;: 200,
&quot;careerHR&quot;: 44,
&quot;careerSO&quot;: 1359,
&quot;careerBB&quot;: 505 
},
{
 &quot;playerID&quot;: &quot;mccorji01&quot;,
&quot;fullname&quot;: &quot;Jim McCormick&quot;,
&quot;year&quot;: 1885,
&quot;careerWIN&quot;: 221,
&quot;careerHR&quot;: 53,
&quot;careerSO&quot;: 1455,
&quot;careerBB&quot;: 565 
},
{
 &quot;playerID&quot;: &quot;mccorji01&quot;,
&quot;fullname&quot;: &quot;Jim McCormick&quot;,
&quot;year&quot;: 1886,
&quot;careerWIN&quot;: 252,
&quot;careerHR&quot;: 71,
&quot;careerSO&quot;: 1627,
&quot;careerBB&quot;: 665 
},
{
 &quot;playerID&quot;: &quot;mccorji01&quot;,
&quot;fullname&quot;: &quot;Jim McCormick&quot;,
&quot;year&quot;: 1887,
&quot;careerWIN&quot;: 265,
&quot;careerHR&quot;: 83,
&quot;careerSO&quot;: 1704,
&quot;careerBB&quot;: 749 
},
{
 &quot;playerID&quot;: &quot;morrija02&quot;,
&quot;fullname&quot;: &quot;Jack Morris&quot;,
&quot;year&quot;: 1977,
&quot;careerWIN&quot;: 1,
&quot;careerHR&quot;: 4,
&quot;careerSO&quot;: 28,
&quot;careerBB&quot;: 23 
},
{
 &quot;playerID&quot;: &quot;morrija02&quot;,
&quot;fullname&quot;: &quot;Jack Morris&quot;,
&quot;year&quot;: 1978,
&quot;careerWIN&quot;: 4,
&quot;careerHR&quot;: 12,
&quot;careerSO&quot;: 76,
&quot;careerBB&quot;: 72 
},
{
 &quot;playerID&quot;: &quot;morrija02&quot;,
&quot;fullname&quot;: &quot;Jack Morris&quot;,
&quot;year&quot;: 1979,
&quot;careerWIN&quot;: 21,
&quot;careerHR&quot;: 31,
&quot;careerSO&quot;: 189,
&quot;careerBB&quot;: 131 
},
{
 &quot;playerID&quot;: &quot;morrija02&quot;,
&quot;fullname&quot;: &quot;Jack Morris&quot;,
&quot;year&quot;: 1980,
&quot;careerWIN&quot;: 37,
&quot;careerHR&quot;: 51,
&quot;careerSO&quot;: 301,
&quot;careerBB&quot;: 218 
},
{
 &quot;playerID&quot;: &quot;morrija02&quot;,
&quot;fullname&quot;: &quot;Jack Morris&quot;,
&quot;year&quot;: 1981,
&quot;careerWIN&quot;: 51,
&quot;careerHR&quot;: 65,
&quot;careerSO&quot;: 398,
&quot;careerBB&quot;: 296 
},
{
 &quot;playerID&quot;: &quot;morrija02&quot;,
&quot;fullname&quot;: &quot;Jack Morris&quot;,
&quot;year&quot;: 1982,
&quot;careerWIN&quot;: 68,
&quot;careerHR&quot;: 102,
&quot;careerSO&quot;: 533,
&quot;careerBB&quot;: 392 
},
{
 &quot;playerID&quot;: &quot;morrija02&quot;,
&quot;fullname&quot;: &quot;Jack Morris&quot;,
&quot;year&quot;: 1983,
&quot;careerWIN&quot;: 88,
&quot;careerHR&quot;: 132,
&quot;careerSO&quot;: 765,
&quot;careerBB&quot;: 475 
},
{
 &quot;playerID&quot;: &quot;morrija02&quot;,
&quot;fullname&quot;: &quot;Jack Morris&quot;,
&quot;year&quot;: 1984,
&quot;careerWIN&quot;: 107,
&quot;careerHR&quot;: 152,
&quot;careerSO&quot;: 913,
&quot;careerBB&quot;: 562 
},
{
 &quot;playerID&quot;: &quot;morrija02&quot;,
&quot;fullname&quot;: &quot;Jack Morris&quot;,
&quot;year&quot;: 1985,
&quot;careerWIN&quot;: 123,
&quot;careerHR&quot;: 173,
&quot;careerSO&quot;: 1104,
&quot;careerBB&quot;: 672 
},
{
 &quot;playerID&quot;: &quot;morrija02&quot;,
&quot;fullname&quot;: &quot;Jack Morris&quot;,
&quot;year&quot;: 1986,
&quot;careerWIN&quot;: 144,
&quot;careerHR&quot;: 213,
&quot;careerSO&quot;: 1327,
&quot;careerBB&quot;: 754 
},
{
 &quot;playerID&quot;: &quot;morrija02&quot;,
&quot;fullname&quot;: &quot;Jack Morris&quot;,
&quot;year&quot;: 1987,
&quot;careerWIN&quot;: 162,
&quot;careerHR&quot;: 252,
&quot;careerSO&quot;: 1535,
&quot;careerBB&quot;: 847 
},
{
 &quot;playerID&quot;: &quot;morrija02&quot;,
&quot;fullname&quot;: &quot;Jack Morris&quot;,
&quot;year&quot;: 1988,
&quot;careerWIN&quot;: 177,
&quot;careerHR&quot;: 272,
&quot;careerSO&quot;: 1703,
&quot;careerBB&quot;: 930 
},
{
 &quot;playerID&quot;: &quot;morrija02&quot;,
&quot;fullname&quot;: &quot;Jack Morris&quot;,
&quot;year&quot;: 1989,
&quot;careerWIN&quot;: 183,
&quot;careerHR&quot;: 295,
&quot;careerSO&quot;: 1818,
&quot;careerBB&quot;: 989 
},
{
 &quot;playerID&quot;: &quot;morrija02&quot;,
&quot;fullname&quot;: &quot;Jack Morris&quot;,
&quot;year&quot;: 1990,
&quot;careerWIN&quot;: 198,
&quot;careerHR&quot;: 321,
&quot;careerSO&quot;: 1980,
&quot;careerBB&quot;: 1086 
},
{
 &quot;playerID&quot;: &quot;morrija02&quot;,
&quot;fullname&quot;: &quot;Jack Morris&quot;,
&quot;year&quot;: 1991,
&quot;careerWIN&quot;: 216,
&quot;careerHR&quot;: 339,
&quot;careerSO&quot;: 2143,
&quot;careerBB&quot;: 1178 
},
{
 &quot;playerID&quot;: &quot;morrija02&quot;,
&quot;fullname&quot;: &quot;Jack Morris&quot;,
&quot;year&quot;: 1992,
&quot;careerWIN&quot;: 237,
&quot;careerHR&quot;: 357,
&quot;careerSO&quot;: 2275,
&quot;careerBB&quot;: 1258 
},
{
 &quot;playerID&quot;: &quot;morrija02&quot;,
&quot;fullname&quot;: &quot;Jack Morris&quot;,
&quot;year&quot;: 1993,
&quot;careerWIN&quot;: 244,
&quot;careerHR&quot;: 375,
&quot;careerSO&quot;: 2378,
&quot;careerBB&quot;: 1323 
},
{
 &quot;playerID&quot;: &quot;morrija02&quot;,
&quot;fullname&quot;: &quot;Jack Morris&quot;,
&quot;year&quot;: 1994,
&quot;careerWIN&quot;: 254,
&quot;careerHR&quot;: 389,
&quot;careerSO&quot;: 2478,
&quot;careerBB&quot;: 1390 
},
{
 &quot;playerID&quot;: &quot;moyerja01&quot;,
&quot;fullname&quot;: &quot;Jamie Moyer&quot;,
&quot;year&quot;: 1986,
&quot;careerWIN&quot;: 7,
&quot;careerHR&quot;: 10,
&quot;careerSO&quot;: 45,
&quot;careerBB&quot;: 42 
},
{
 &quot;playerID&quot;: &quot;moyerja01&quot;,
&quot;fullname&quot;: &quot;Jamie Moyer&quot;,
&quot;year&quot;: 1987,
&quot;careerWIN&quot;: 19,
&quot;careerHR&quot;: 38,
&quot;careerSO&quot;: 192,
&quot;careerBB&quot;: 139 
},
{
 &quot;playerID&quot;: &quot;moyerja01&quot;,
&quot;fullname&quot;: &quot;Jamie Moyer&quot;,
&quot;year&quot;: 1988,
&quot;careerWIN&quot;: 28,
&quot;careerHR&quot;: 58,
&quot;careerSO&quot;: 313,
&quot;careerBB&quot;: 194 
},
{
 &quot;playerID&quot;: &quot;moyerja01&quot;,
&quot;fullname&quot;: &quot;Jamie Moyer&quot;,
&quot;year&quot;: 1989,
&quot;careerWIN&quot;: 32,
&quot;careerHR&quot;: 68,
&quot;careerSO&quot;: 357,
&quot;careerBB&quot;: 227 
},
{
 &quot;playerID&quot;: &quot;moyerja01&quot;,
&quot;fullname&quot;: &quot;Jamie Moyer&quot;,
&quot;year&quot;: 1990,
&quot;careerWIN&quot;: 34,
&quot;careerHR&quot;: 74,
&quot;careerSO&quot;: 415,
&quot;careerBB&quot;: 266 
},
{
 &quot;playerID&quot;: &quot;moyerja01&quot;,
&quot;fullname&quot;: &quot;Jamie Moyer&quot;,
&quot;year&quot;: 1991,
&quot;careerWIN&quot;: 34,
&quot;careerHR&quot;: 79,
&quot;careerSO&quot;: 435,
&quot;careerBB&quot;: 282 
},
{
 &quot;playerID&quot;: &quot;moyerja01&quot;,
&quot;fullname&quot;: &quot;Jamie Moyer&quot;,
&quot;year&quot;: 1993,
&quot;careerWIN&quot;: 46,
&quot;careerHR&quot;: 90,
&quot;careerSO&quot;: 525,
&quot;careerBB&quot;: 320 
},
{
 &quot;playerID&quot;: &quot;moyerja01&quot;,
&quot;fullname&quot;: &quot;Jamie Moyer&quot;,
&quot;year&quot;: 1994,
&quot;careerWIN&quot;: 51,
&quot;careerHR&quot;: 113,
&quot;careerSO&quot;: 612,
&quot;careerBB&quot;: 358 
},
{
 &quot;playerID&quot;: &quot;moyerja01&quot;,
&quot;fullname&quot;: &quot;Jamie Moyer&quot;,
&quot;year&quot;: 1995,
&quot;careerWIN&quot;: 59,
&quot;careerHR&quot;: 131,
&quot;careerSO&quot;: 677,
&quot;careerBB&quot;: 388 
},
{
 &quot;playerID&quot;: &quot;moyerja01&quot;,
&quot;fullname&quot;: &quot;Jamie Moyer&quot;,
&quot;year&quot;: 1996,
&quot;careerWIN&quot;: 72,
&quot;careerHR&quot;: 154,
&quot;careerSO&quot;: 756,
&quot;careerBB&quot;: 434 
},
{
 &quot;playerID&quot;: &quot;moyerja01&quot;,
&quot;fullname&quot;: &quot;Jamie Moyer&quot;,
&quot;year&quot;: 1997,
&quot;careerWIN&quot;: 89,
&quot;careerHR&quot;: 175,
&quot;careerSO&quot;: 869,
&quot;careerBB&quot;: 477 
},
{
 &quot;playerID&quot;: &quot;moyerja01&quot;,
&quot;fullname&quot;: &quot;Jamie Moyer&quot;,
&quot;year&quot;: 1998,
&quot;careerWIN&quot;: 104,
&quot;careerHR&quot;: 198,
&quot;careerSO&quot;: 1027,
&quot;careerBB&quot;: 519 
},
{
 &quot;playerID&quot;: &quot;moyerja01&quot;,
&quot;fullname&quot;: &quot;Jamie Moyer&quot;,
&quot;year&quot;: 1999,
&quot;careerWIN&quot;: 118,
&quot;careerHR&quot;: 221,
&quot;careerSO&quot;: 1164,
&quot;careerBB&quot;: 567 
},
{
 &quot;playerID&quot;: &quot;moyerja01&quot;,
&quot;fullname&quot;: &quot;Jamie Moyer&quot;,
&quot;year&quot;: 2000,
&quot;careerWIN&quot;: 131,
&quot;careerHR&quot;: 243,
&quot;careerSO&quot;: 1262,
&quot;careerBB&quot;: 620 
},
{
 &quot;playerID&quot;: &quot;moyerja01&quot;,
&quot;fullname&quot;: &quot;Jamie Moyer&quot;,
&quot;year&quot;: 2001,
&quot;careerWIN&quot;: 151,
&quot;careerHR&quot;: 267,
&quot;careerSO&quot;: 1381,
&quot;careerBB&quot;: 664 
},
{
 &quot;playerID&quot;: &quot;moyerja01&quot;,
&quot;fullname&quot;: &quot;Jamie Moyer&quot;,
&quot;year&quot;: 2002,
&quot;careerWIN&quot;: 164,
&quot;careerHR&quot;: 295,
&quot;careerSO&quot;: 1528,
&quot;careerBB&quot;: 714 
},
{
 &quot;playerID&quot;: &quot;moyerja01&quot;,
&quot;fullname&quot;: &quot;Jamie Moyer&quot;,
&quot;year&quot;: 2003,
&quot;careerWIN&quot;: 185,
&quot;careerHR&quot;: 314,
&quot;careerSO&quot;: 1657,
&quot;careerBB&quot;: 780 
},
{
 &quot;playerID&quot;: &quot;moyerja01&quot;,
&quot;fullname&quot;: &quot;Jamie Moyer&quot;,
&quot;year&quot;: 2004,
&quot;careerWIN&quot;: 192,
&quot;careerHR&quot;: 358,
&quot;careerSO&quot;: 1782,
&quot;careerBB&quot;: 843 
},
{
 &quot;playerID&quot;: &quot;moyerja01&quot;,
&quot;fullname&quot;: &quot;Jamie Moyer&quot;,
&quot;year&quot;: 2005,
&quot;careerWIN&quot;: 205,
&quot;careerHR&quot;: 381,
&quot;careerSO&quot;: 1884,
&quot;careerBB&quot;: 895 
},
{
 &quot;playerID&quot;: &quot;moyerja01&quot;,
&quot;fullname&quot;: &quot;Jamie Moyer&quot;,
&quot;year&quot;: 2006,
&quot;careerWIN&quot;: 216,
&quot;careerHR&quot;: 414,
&quot;careerSO&quot;: 1992,
&quot;careerBB&quot;: 946 
},
{
 &quot;playerID&quot;: &quot;moyerja01&quot;,
&quot;fullname&quot;: &quot;Jamie Moyer&quot;,
&quot;year&quot;: 2007,
&quot;careerWIN&quot;: 230,
&quot;careerHR&quot;: 444,
&quot;careerSO&quot;: 2125,
&quot;careerBB&quot;: 1012 
},
{
 &quot;playerID&quot;: &quot;moyerja01&quot;,
&quot;fullname&quot;: &quot;Jamie Moyer&quot;,
&quot;year&quot;: 2008,
&quot;careerWIN&quot;: 246,
&quot;careerHR&quot;: 464,
&quot;careerSO&quot;: 2248,
&quot;careerBB&quot;: 1074 
},
{
 &quot;playerID&quot;: &quot;moyerja01&quot;,
&quot;fullname&quot;: &quot;Jamie Moyer&quot;,
&quot;year&quot;: 2009,
&quot;careerWIN&quot;: 258,
&quot;careerHR&quot;: 491,
&quot;careerSO&quot;: 2342,
&quot;careerBB&quot;: 1117 
},
{
 &quot;playerID&quot;: &quot;moyerja01&quot;,
&quot;fullname&quot;: &quot;Jamie Moyer&quot;,
&quot;year&quot;: 2010,
&quot;careerWIN&quot;: 267,
&quot;careerHR&quot;: 511,
&quot;careerSO&quot;: 2405,
&quot;careerBB&quot;: 1137 
},
{
 &quot;playerID&quot;: &quot;moyerja01&quot;,
&quot;fullname&quot;: &quot;Jamie Moyer&quot;,
&quot;year&quot;: 2012,
&quot;careerWIN&quot;: 269,
&quot;careerHR&quot;: 522,
&quot;careerSO&quot;: 2441,
&quot;careerBB&quot;: 1155 
},
{
 &quot;playerID&quot;: &quot;mullato01&quot;,
&quot;fullname&quot;: &quot;Tony Mullane&quot;,
&quot;year&quot;: 1881,
&quot;careerWIN&quot;: 1,
&quot;careerHR&quot;: 2,
&quot;careerSO&quot;: 7,
&quot;careerBB&quot;: 17 
},
{
 &quot;playerID&quot;: &quot;mullato01&quot;,
&quot;fullname&quot;: &quot;Tony Mullane&quot;,
&quot;year&quot;: 1882,
&quot;careerWIN&quot;: 31,
&quot;careerHR&quot;: 6,
&quot;careerSO&quot;: 177,
&quot;careerBB&quot;: 95 
},
{
 &quot;playerID&quot;: &quot;mullato01&quot;,
&quot;fullname&quot;: &quot;Tony Mullane&quot;,
&quot;year&quot;: 1883,
&quot;careerWIN&quot;: 66,
&quot;careerHR&quot;: 9,
&quot;careerSO&quot;: 368,
&quot;careerBB&quot;: 169 
},
{
 &quot;playerID&quot;: &quot;mullato01&quot;,
&quot;fullname&quot;: &quot;Tony Mullane&quot;,
&quot;year&quot;: 1884,
&quot;careerWIN&quot;: 102,
&quot;careerHR&quot;: 14,
&quot;careerSO&quot;: 693,
&quot;careerBB&quot;: 258 
},
{
 &quot;playerID&quot;: &quot;mullato01&quot;,
&quot;fullname&quot;: &quot;Tony Mullane&quot;,
&quot;year&quot;: 1886,
&quot;careerWIN&quot;: 135,
&quot;careerHR&quot;: 25,
&quot;careerSO&quot;: 943,
&quot;careerBB&quot;: 424 
},
{
 &quot;playerID&quot;: &quot;mullato01&quot;,
&quot;fullname&quot;: &quot;Tony Mullane&quot;,
&quot;year&quot;: 1887,
&quot;careerWIN&quot;: 166,
&quot;careerHR&quot;: 36,
&quot;careerSO&quot;: 1040,
&quot;careerBB&quot;: 545 
},
{
 &quot;playerID&quot;: &quot;mullato01&quot;,
&quot;fullname&quot;: &quot;Tony Mullane&quot;,
&quot;year&quot;: 1888,
&quot;careerWIN&quot;: 192,
&quot;careerHR&quot;: 45,
&quot;careerSO&quot;: 1226,
&quot;careerBB&quot;: 620 
},
{
 &quot;playerID&quot;: &quot;mullato01&quot;,
&quot;fullname&quot;: &quot;Tony Mullane&quot;,
&quot;year&quot;: 1889,
&quot;careerWIN&quot;: 203,
&quot;careerHR&quot;: 49,
&quot;careerSO&quot;: 1338,
&quot;careerBB&quot;: 709 
},
{
 &quot;playerID&quot;: &quot;mullato01&quot;,
&quot;fullname&quot;: &quot;Tony Mullane&quot;,
&quot;year&quot;: 1890,
&quot;careerWIN&quot;: 215,
&quot;careerHR&quot;: 56,
&quot;careerSO&quot;: 1429,
&quot;careerBB&quot;: 805 
},
{
 &quot;playerID&quot;: &quot;mullato01&quot;,
&quot;fullname&quot;: &quot;Tony Mullane&quot;,
&quot;year&quot;: 1891,
&quot;careerWIN&quot;: 238,
&quot;careerHR&quot;: 71,
&quot;careerSO&quot;: 1553,
&quot;careerBB&quot;: 992 
},
{
 &quot;playerID&quot;: &quot;mullato01&quot;,
&quot;fullname&quot;: &quot;Tony Mullane&quot;,
&quot;year&quot;: 1892,
&quot;careerWIN&quot;: 259,
&quot;careerHR&quot;: 83,
&quot;careerSO&quot;: 1662,
&quot;careerBB&quot;: 1119 
},
{
 &quot;playerID&quot;: &quot;mullato01&quot;,
&quot;fullname&quot;: &quot;Tony Mullane&quot;,
&quot;year&quot;: 1893,
&quot;careerWIN&quot;: 277,
&quot;careerHR&quot;: 91,
&quot;careerSO&quot;: 1757,
&quot;careerBB&quot;: 1308 
},
{
 &quot;playerID&quot;: &quot;mullato01&quot;,
&quot;fullname&quot;: &quot;Tony Mullane&quot;,
&quot;year&quot;: 1894,
&quot;careerWIN&quot;: 284,
&quot;careerHR&quot;: 98,
&quot;careerSO&quot;: 1803,
&quot;careerBB&quot;: 1408 
},
{
 &quot;playerID&quot;: &quot;mussimi01&quot;,
&quot;fullname&quot;: &quot;Mike Mussina&quot;,
&quot;year&quot;: 1991,
&quot;careerWIN&quot;: 4,
&quot;careerHR&quot;: 7,
&quot;careerSO&quot;: 52,
&quot;careerBB&quot;: 21 
},
{
 &quot;playerID&quot;: &quot;mussimi01&quot;,
&quot;fullname&quot;: &quot;Mike Mussina&quot;,
&quot;year&quot;: 1992,
&quot;careerWIN&quot;: 22,
&quot;careerHR&quot;: 23,
&quot;careerSO&quot;: 182,
&quot;careerBB&quot;: 69 
},
{
 &quot;playerID&quot;: &quot;mussimi01&quot;,
&quot;fullname&quot;: &quot;Mike Mussina&quot;,
&quot;year&quot;: 1993,
&quot;careerWIN&quot;: 36,
&quot;careerHR&quot;: 43,
&quot;careerSO&quot;: 299,
&quot;careerBB&quot;: 113 
},
{
 &quot;playerID&quot;: &quot;mussimi01&quot;,
&quot;fullname&quot;: &quot;Mike Mussina&quot;,
&quot;year&quot;: 1994,
&quot;careerWIN&quot;: 52,
&quot;careerHR&quot;: 62,
&quot;careerSO&quot;: 398,
&quot;careerBB&quot;: 155 
},
{
 &quot;playerID&quot;: &quot;mussimi01&quot;,
&quot;fullname&quot;: &quot;Mike Mussina&quot;,
&quot;year&quot;: 1995,
&quot;careerWIN&quot;: 71,
&quot;careerHR&quot;: 86,
&quot;careerSO&quot;: 556,
&quot;careerBB&quot;: 205 
},
{
 &quot;playerID&quot;: &quot;mussimi01&quot;,
&quot;fullname&quot;: &quot;Mike Mussina&quot;,
&quot;year&quot;: 1996,
&quot;careerWIN&quot;: 90,
&quot;careerHR&quot;: 117,
&quot;careerSO&quot;: 760,
&quot;careerBB&quot;: 274 
},
{
 &quot;playerID&quot;: &quot;mussimi01&quot;,
&quot;fullname&quot;: &quot;Mike Mussina&quot;,
&quot;year&quot;: 1997,
&quot;careerWIN&quot;: 105,
&quot;careerHR&quot;: 144,
&quot;careerSO&quot;: 978,
&quot;careerBB&quot;: 328 
},
{
 &quot;playerID&quot;: &quot;mussimi01&quot;,
&quot;fullname&quot;: &quot;Mike Mussina&quot;,
&quot;year&quot;: 1998,
&quot;careerWIN&quot;: 118,
&quot;careerHR&quot;: 166,
&quot;careerSO&quot;: 1153,
&quot;careerBB&quot;: 369 
},
{
 &quot;playerID&quot;: &quot;mussimi01&quot;,
&quot;fullname&quot;: &quot;Mike Mussina&quot;,
&quot;year&quot;: 1999,
&quot;careerWIN&quot;: 136,
&quot;careerHR&quot;: 182,
&quot;careerSO&quot;: 1325,
&quot;careerBB&quot;: 421 
},
{
 &quot;playerID&quot;: &quot;mussimi01&quot;,
&quot;fullname&quot;: &quot;Mike Mussina&quot;,
&quot;year&quot;: 2000,
&quot;careerWIN&quot;: 147,
&quot;careerHR&quot;: 210,
&quot;careerSO&quot;: 1535,
&quot;careerBB&quot;: 467 
},
{
 &quot;playerID&quot;: &quot;mussimi01&quot;,
&quot;fullname&quot;: &quot;Mike Mussina&quot;,
&quot;year&quot;: 2001,
&quot;careerWIN&quot;: 164,
&quot;careerHR&quot;: 230,
&quot;careerSO&quot;: 1749,
&quot;careerBB&quot;: 509 
},
{
 &quot;playerID&quot;: &quot;mussimi01&quot;,
&quot;fullname&quot;: &quot;Mike Mussina&quot;,
&quot;year&quot;: 2002,
&quot;careerWIN&quot;: 182,
&quot;careerHR&quot;: 257,
&quot;careerSO&quot;: 1931,
&quot;careerBB&quot;: 557 
},
{
 &quot;playerID&quot;: &quot;mussimi01&quot;,
&quot;fullname&quot;: &quot;Mike Mussina&quot;,
&quot;year&quot;: 2003,
&quot;careerWIN&quot;: 199,
&quot;careerHR&quot;: 278,
&quot;careerSO&quot;: 2126,
&quot;careerBB&quot;: 597 
},
{
 &quot;playerID&quot;: &quot;mussimi01&quot;,
&quot;fullname&quot;: &quot;Mike Mussina&quot;,
&quot;year&quot;: 2004,
&quot;careerWIN&quot;: 211,
&quot;careerHR&quot;: 300,
&quot;careerSO&quot;: 2258,
&quot;careerBB&quot;: 637 
},
{
 &quot;playerID&quot;: &quot;mussimi01&quot;,
&quot;fullname&quot;: &quot;Mike Mussina&quot;,
&quot;year&quot;: 2005,
&quot;careerWIN&quot;: 224,
&quot;careerHR&quot;: 323,
&quot;careerSO&quot;: 2400,
&quot;careerBB&quot;: 684 
},
{
 &quot;playerID&quot;: &quot;mussimi01&quot;,
&quot;fullname&quot;: &quot;Mike Mussina&quot;,
&quot;year&quot;: 2006,
&quot;careerWIN&quot;: 239,
&quot;careerHR&quot;: 345,
&quot;careerSO&quot;: 2572,
&quot;careerBB&quot;: 719 
},
{
 &quot;playerID&quot;: &quot;mussimi01&quot;,
&quot;fullname&quot;: &quot;Mike Mussina&quot;,
&quot;year&quot;: 2007,
&quot;careerWIN&quot;: 250,
&quot;careerHR&quot;: 359,
&quot;careerSO&quot;: 2663,
&quot;careerBB&quot;: 754 
},
{
 &quot;playerID&quot;: &quot;mussimi01&quot;,
&quot;fullname&quot;: &quot;Mike Mussina&quot;,
&quot;year&quot;: 2008,
&quot;careerWIN&quot;: 270,
&quot;careerHR&quot;: 376,
&quot;careerSO&quot;: 2813,
&quot;careerBB&quot;: 785 
},
{
 &quot;playerID&quot;: &quot;nichoki01&quot;,
&quot;fullname&quot;: &quot;Kid Nichols&quot;,
&quot;year&quot;: 1890,
&quot;careerWIN&quot;: 27,
&quot;careerHR&quot;: 8,
&quot;careerSO&quot;: 222,
&quot;careerBB&quot;: 112 
},
{
 &quot;playerID&quot;: &quot;nichoki01&quot;,
&quot;fullname&quot;: &quot;Kid Nichols&quot;,
&quot;year&quot;: 1891,
&quot;careerWIN&quot;: 57,
&quot;careerHR&quot;: 23,
&quot;careerSO&quot;: 462,
&quot;careerBB&quot;: 215 
},
{
 &quot;playerID&quot;: &quot;nichoki01&quot;,
&quot;fullname&quot;: &quot;Kid Nichols&quot;,
&quot;year&quot;: 1892,
&quot;careerWIN&quot;: 92,
&quot;careerHR&quot;: 38,
&quot;careerSO&quot;: 649,
&quot;careerBB&quot;: 336 
},
{
 &quot;playerID&quot;: &quot;nichoki01&quot;,
&quot;fullname&quot;: &quot;Kid Nichols&quot;,
&quot;year&quot;: 1893,
&quot;careerWIN&quot;: 126,
&quot;careerHR&quot;: 53,
&quot;careerSO&quot;: 743,
&quot;careerBB&quot;: 454 
},
{
 &quot;playerID&quot;: &quot;nichoki01&quot;,
&quot;fullname&quot;: &quot;Kid Nichols&quot;,
&quot;year&quot;: 1894,
&quot;careerWIN&quot;: 158,
&quot;careerHR&quot;: 76,
&quot;careerSO&quot;: 856,
&quot;careerBB&quot;: 575 
},
{
 &quot;playerID&quot;: &quot;nichoki01&quot;,
&quot;fullname&quot;: &quot;Kid Nichols&quot;,
&quot;year&quot;: 1895,
&quot;careerWIN&quot;: 184,
&quot;careerHR&quot;: 91,
&quot;careerSO&quot;: 996,
&quot;careerBB&quot;: 661 
},
{
 &quot;playerID&quot;: &quot;nichoki01&quot;,
&quot;fullname&quot;: &quot;Kid Nichols&quot;,
&quot;year&quot;: 1896,
&quot;careerWIN&quot;: 214,
&quot;careerHR&quot;: 105,
&quot;careerSO&quot;: 1098,
&quot;careerBB&quot;: 762 
},
{
 &quot;playerID&quot;: &quot;nichoki01&quot;,
&quot;fullname&quot;: &quot;Kid Nichols&quot;,
&quot;year&quot;: 1897,
&quot;careerWIN&quot;: 245,
&quot;careerHR&quot;: 114,
&quot;careerSO&quot;: 1225,
&quot;careerBB&quot;: 830 
},
{
 &quot;playerID&quot;: &quot;nichoki01&quot;,
&quot;fullname&quot;: &quot;Kid Nichols&quot;,
&quot;year&quot;: 1898,
&quot;careerWIN&quot;: 276,
&quot;careerHR&quot;: 121,
&quot;careerSO&quot;: 1363,
&quot;careerBB&quot;: 915 
},
{
 &quot;playerID&quot;: &quot;nichoki01&quot;,
&quot;fullname&quot;: &quot;Kid Nichols&quot;,
&quot;year&quot;: 1899,
&quot;careerWIN&quot;: 297,
&quot;careerHR&quot;: 132,
&quot;careerSO&quot;: 1471,
&quot;careerBB&quot;: 997 
},
{
 &quot;playerID&quot;: &quot;nichoki01&quot;,
&quot;fullname&quot;: &quot;Kid Nichols&quot;,
&quot;year&quot;: 1900,
&quot;careerWIN&quot;: 310,
&quot;careerHR&quot;: 143,
&quot;careerSO&quot;: 1524,
&quot;careerBB&quot;: 1069 
},
{
 &quot;playerID&quot;: &quot;nichoki01&quot;,
&quot;fullname&quot;: &quot;Kid Nichols&quot;,
&quot;year&quot;: 1901,
&quot;careerWIN&quot;: 329,
&quot;careerHR&quot;: 151,
&quot;careerSO&quot;: 1667,
&quot;careerBB&quot;: 1159 
},
{
 &quot;playerID&quot;: &quot;nichoki01&quot;,
&quot;fullname&quot;: &quot;Kid Nichols&quot;,
&quot;year&quot;: 1904,
&quot;careerWIN&quot;: 350,
&quot;careerHR&quot;: 154,
&quot;careerSO&quot;: 1801,
&quot;careerBB&quot;: 1209 
},
{
 &quot;playerID&quot;: &quot;nichoki01&quot;,
&quot;fullname&quot;: &quot;Kid Nichols&quot;,
&quot;year&quot;: 1905,
&quot;careerWIN&quot;: 361,
&quot;careerHR&quot;: 156,
&quot;careerSO&quot;: 1867,
&quot;careerBB&quot;: 1255 
},
{
 &quot;playerID&quot;: &quot;nichoki01&quot;,
&quot;fullname&quot;: &quot;Kid Nichols&quot;,
&quot;year&quot;: 1906,
&quot;careerWIN&quot;: 361,
&quot;careerHR&quot;: 156,
&quot;careerSO&quot;: 1868,
&quot;careerBB&quot;: 1268 
},
{
 &quot;playerID&quot;: &quot;niekrph01&quot;,
&quot;fullname&quot;: &quot;Phil Niekro&quot;,
&quot;year&quot;: 1964,
&quot;careerWIN&quot;: 0,
&quot;careerHR&quot;: 1,
&quot;careerSO&quot;: 8,
&quot;careerBB&quot;: 7 
},
{
 &quot;playerID&quot;: &quot;niekrph01&quot;,
&quot;fullname&quot;: &quot;Phil Niekro&quot;,
&quot;year&quot;: 1965,
&quot;careerWIN&quot;: 2,
&quot;careerHR&quot;: 6,
&quot;careerSO&quot;: 57,
&quot;careerBB&quot;: 33 
},
{
 &quot;playerID&quot;: &quot;niekrph01&quot;,
&quot;fullname&quot;: &quot;Phil Niekro&quot;,
&quot;year&quot;: 1966,
&quot;careerWIN&quot;: 6,
&quot;careerHR&quot;: 10,
&quot;careerSO&quot;: 74,
&quot;careerBB&quot;: 56 
},
{
 &quot;playerID&quot;: &quot;niekrph01&quot;,
&quot;fullname&quot;: &quot;Phil Niekro&quot;,
&quot;year&quot;: 1967,
&quot;careerWIN&quot;: 17,
&quot;careerHR&quot;: 19,
&quot;careerSO&quot;: 203,
&quot;careerBB&quot;: 111 
},
{
 &quot;playerID&quot;: &quot;niekrph01&quot;,
&quot;fullname&quot;: &quot;Phil Niekro&quot;,
&quot;year&quot;: 1968,
&quot;careerWIN&quot;: 31,
&quot;careerHR&quot;: 35,
&quot;careerSO&quot;: 343,
&quot;careerBB&quot;: 156 
},
{
 &quot;playerID&quot;: &quot;niekrph01&quot;,
&quot;fullname&quot;: &quot;Phil Niekro&quot;,
&quot;year&quot;: 1969,
&quot;careerWIN&quot;: 54,
&quot;careerHR&quot;: 56,
&quot;careerSO&quot;: 536,
&quot;careerBB&quot;: 213 
},
{
 &quot;playerID&quot;: &quot;niekrph01&quot;,
&quot;fullname&quot;: &quot;Phil Niekro&quot;,
&quot;year&quot;: 1970,
&quot;careerWIN&quot;: 66,
&quot;careerHR&quot;: 96,
&quot;careerSO&quot;: 704,
&quot;careerBB&quot;: 281 
},
{
 &quot;playerID&quot;: &quot;niekrph01&quot;,
&quot;fullname&quot;: &quot;Phil Niekro&quot;,
&quot;year&quot;: 1971,
&quot;careerWIN&quot;: 81,
&quot;careerHR&quot;: 123,
&quot;careerSO&quot;: 877,
&quot;careerBB&quot;: 351 
},
{
 &quot;playerID&quot;: &quot;niekrph01&quot;,
&quot;fullname&quot;: &quot;Phil Niekro&quot;,
&quot;year&quot;: 1972,
&quot;careerWIN&quot;: 97,
&quot;careerHR&quot;: 145,
&quot;careerSO&quot;: 1041,
&quot;careerBB&quot;: 404 
},
{
 &quot;playerID&quot;: &quot;niekrph01&quot;,
&quot;fullname&quot;: &quot;Phil Niekro&quot;,
&quot;year&quot;: 1973,
&quot;careerWIN&quot;: 110,
&quot;careerHR&quot;: 166,
&quot;careerSO&quot;: 1172,
&quot;careerBB&quot;: 493 
},
{
 &quot;playerID&quot;: &quot;niekrph01&quot;,
&quot;fullname&quot;: &quot;Phil Niekro&quot;,
&quot;year&quot;: 1974,
&quot;careerWIN&quot;: 130,
&quot;careerHR&quot;: 185,
&quot;careerSO&quot;: 1367,
&quot;careerBB&quot;: 581 
},
{
 &quot;playerID&quot;: &quot;niekrph01&quot;,
&quot;fullname&quot;: &quot;Phil Niekro&quot;,
&quot;year&quot;: 1975,
&quot;careerWIN&quot;: 145,
&quot;careerHR&quot;: 214,
&quot;careerSO&quot;: 1511,
&quot;careerBB&quot;: 653 
},
{
 &quot;playerID&quot;: &quot;niekrph01&quot;,
&quot;fullname&quot;: &quot;Phil Niekro&quot;,
&quot;year&quot;: 1976,
&quot;careerWIN&quot;: 162,
&quot;careerHR&quot;: 232,
&quot;careerSO&quot;: 1684,
&quot;careerBB&quot;: 754 
},
{
 &quot;playerID&quot;: &quot;niekrph01&quot;,
&quot;fullname&quot;: &quot;Phil Niekro&quot;,
&quot;year&quot;: 1977,
&quot;careerWIN&quot;: 178,
&quot;careerHR&quot;: 258,
&quot;careerSO&quot;: 1946,
&quot;careerBB&quot;: 918 
},
{
 &quot;playerID&quot;: &quot;niekrph01&quot;,
&quot;fullname&quot;: &quot;Phil Niekro&quot;,
&quot;year&quot;: 1978,
&quot;careerWIN&quot;: 197,
&quot;careerHR&quot;: 274,
&quot;careerSO&quot;: 2194,
&quot;careerBB&quot;: 1020 
},
{
 &quot;playerID&quot;: &quot;niekrph01&quot;,
&quot;fullname&quot;: &quot;Phil Niekro&quot;,
&quot;year&quot;: 1979,
&quot;careerWIN&quot;: 218,
&quot;careerHR&quot;: 315,
&quot;careerSO&quot;: 2402,
&quot;careerBB&quot;: 1133 
},
{
 &quot;playerID&quot;: &quot;niekrph01&quot;,
&quot;fullname&quot;: &quot;Phil Niekro&quot;,
&quot;year&quot;: 1980,
&quot;careerWIN&quot;: 233,
&quot;careerHR&quot;: 345,
&quot;careerSO&quot;: 2578,
&quot;careerBB&quot;: 1218 
},
{
 &quot;playerID&quot;: &quot;niekrph01&quot;,
&quot;fullname&quot;: &quot;Phil Niekro&quot;,
&quot;year&quot;: 1981,
&quot;careerWIN&quot;: 240,
&quot;careerHR&quot;: 351,
&quot;careerSO&quot;: 2640,
&quot;careerBB&quot;: 1274 
},
{
 &quot;playerID&quot;: &quot;niekrph01&quot;,
&quot;fullname&quot;: &quot;Phil Niekro&quot;,
&quot;year&quot;: 1982,
&quot;careerWIN&quot;: 257,
&quot;careerHR&quot;: 374,
&quot;careerSO&quot;: 2784,
&quot;careerBB&quot;: 1347 
},
{
 &quot;playerID&quot;: &quot;niekrph01&quot;,
&quot;fullname&quot;: &quot;Phil Niekro&quot;,
&quot;year&quot;: 1983,
&quot;careerWIN&quot;: 268,
&quot;careerHR&quot;: 392,
&quot;careerSO&quot;: 2912,
&quot;careerBB&quot;: 1452 
},
{
 &quot;playerID&quot;: &quot;niekrph01&quot;,
&quot;fullname&quot;: &quot;Phil Niekro&quot;,
&quot;year&quot;: 1984,
&quot;careerWIN&quot;: 284,
&quot;careerHR&quot;: 407,
&quot;careerSO&quot;: 3048,
&quot;careerBB&quot;: 1528 
},
{
 &quot;playerID&quot;: &quot;niekrph01&quot;,
&quot;fullname&quot;: &quot;Phil Niekro&quot;,
&quot;year&quot;: 1985,
&quot;careerWIN&quot;: 300,
&quot;careerHR&quot;: 436,
&quot;careerSO&quot;: 3197,
&quot;careerBB&quot;: 1648 
},
{
 &quot;playerID&quot;: &quot;niekrph01&quot;,
&quot;fullname&quot;: &quot;Phil Niekro&quot;,
&quot;year&quot;: 1986,
&quot;careerWIN&quot;: 311,
&quot;careerHR&quot;: 460,
&quot;careerSO&quot;: 3278,
&quot;careerBB&quot;: 1743 
},
{
 &quot;playerID&quot;: &quot;niekrph01&quot;,
&quot;fullname&quot;: &quot;Phil Niekro&quot;,
&quot;year&quot;: 1987,
&quot;careerWIN&quot;: 318,
&quot;careerHR&quot;: 482,
&quot;careerSO&quot;: 3342,
&quot;careerBB&quot;: 1809 
},
{
 &quot;playerID&quot;: &quot;palmeji01&quot;,
&quot;fullname&quot;: &quot;Jim Palmer&quot;,
&quot;year&quot;: 1965,
&quot;careerWIN&quot;: 5,
&quot;careerHR&quot;: 6,
&quot;careerSO&quot;: 75,
&quot;careerBB&quot;: 56 
},
{
 &quot;playerID&quot;: &quot;palmeji01&quot;,
&quot;fullname&quot;: &quot;Jim Palmer&quot;,
&quot;year&quot;: 1966,
&quot;careerWIN&quot;: 20,
&quot;careerHR&quot;: 27,
&quot;careerSO&quot;: 222,
&quot;careerBB&quot;: 147 
},
{
 &quot;playerID&quot;: &quot;palmeji01&quot;,
&quot;fullname&quot;: &quot;Jim Palmer&quot;,
&quot;year&quot;: 1967,
&quot;careerWIN&quot;: 23,
&quot;careerHR&quot;: 33,
&quot;careerSO&quot;: 245,
&quot;careerBB&quot;: 167 
},
{
 &quot;playerID&quot;: &quot;palmeji01&quot;,
&quot;fullname&quot;: &quot;Jim Palmer&quot;,
&quot;year&quot;: 1969,
&quot;careerWIN&quot;: 39,
&quot;careerHR&quot;: 44,
&quot;careerSO&quot;: 368,
&quot;careerBB&quot;: 231 
},
{
 &quot;playerID&quot;: &quot;palmeji01&quot;,
&quot;fullname&quot;: &quot;Jim Palmer&quot;,
&quot;year&quot;: 1970,
&quot;careerWIN&quot;: 59,
&quot;careerHR&quot;: 65,
&quot;careerSO&quot;: 567,
&quot;careerBB&quot;: 331 
},
{
 &quot;playerID&quot;: &quot;palmeji01&quot;,
&quot;fullname&quot;: &quot;Jim Palmer&quot;,
&quot;year&quot;: 1971,
&quot;careerWIN&quot;: 79,
&quot;careerHR&quot;: 84,
&quot;careerSO&quot;: 751,
&quot;careerBB&quot;: 437 
},
{
 &quot;playerID&quot;: &quot;palmeji01&quot;,
&quot;fullname&quot;: &quot;Jim Palmer&quot;,
&quot;year&quot;: 1972,
&quot;careerWIN&quot;: 100,
&quot;careerHR&quot;: 105,
&quot;careerSO&quot;: 935,
&quot;careerBB&quot;: 507 
},
{
 &quot;playerID&quot;: &quot;palmeji01&quot;,
&quot;fullname&quot;: &quot;Jim Palmer&quot;,
&quot;year&quot;: 1973,
&quot;careerWIN&quot;: 122,
&quot;careerHR&quot;: 121,
&quot;careerSO&quot;: 1093,
&quot;careerBB&quot;: 620 
},
{
 &quot;playerID&quot;: &quot;palmeji01&quot;,
&quot;fullname&quot;: &quot;Jim Palmer&quot;,
&quot;year&quot;: 1974,
&quot;careerWIN&quot;: 129,
&quot;careerHR&quot;: 133,
&quot;careerSO&quot;: 1177,
&quot;careerBB&quot;: 689 
},
{
 &quot;playerID&quot;: &quot;palmeji01&quot;,
&quot;fullname&quot;: &quot;Jim Palmer&quot;,
&quot;year&quot;: 1975,
&quot;careerWIN&quot;: 152,
&quot;careerHR&quot;: 153,
&quot;careerSO&quot;: 1370,
&quot;careerBB&quot;: 769 
},
{
 &quot;playerID&quot;: &quot;palmeji01&quot;,
&quot;fullname&quot;: &quot;Jim Palmer&quot;,
&quot;year&quot;: 1976,
&quot;careerWIN&quot;: 174,
&quot;careerHR&quot;: 173,
&quot;careerSO&quot;: 1529,
&quot;careerBB&quot;: 853 
},
{
 &quot;playerID&quot;: &quot;palmeji01&quot;,
&quot;fullname&quot;: &quot;Jim Palmer&quot;,
&quot;year&quot;: 1977,
&quot;careerWIN&quot;: 194,
&quot;careerHR&quot;: 197,
&quot;careerSO&quot;: 1722,
&quot;careerBB&quot;: 952 
},
{
 &quot;playerID&quot;: &quot;palmeji01&quot;,
&quot;fullname&quot;: &quot;Jim Palmer&quot;,
&quot;year&quot;: 1978,
&quot;careerWIN&quot;: 215,
&quot;careerHR&quot;: 216,
&quot;careerSO&quot;: 1860,
&quot;careerBB&quot;: 1049 
},
{
 &quot;playerID&quot;: &quot;palmeji01&quot;,
&quot;fullname&quot;: &quot;Jim Palmer&quot;,
&quot;year&quot;: 1979,
&quot;careerWIN&quot;: 225,
&quot;careerHR&quot;: 228,
&quot;careerSO&quot;: 1927,
&quot;careerBB&quot;: 1092 
},
{
 &quot;playerID&quot;: &quot;palmeji01&quot;,
&quot;fullname&quot;: &quot;Jim Palmer&quot;,
&quot;year&quot;: 1980,
&quot;careerWIN&quot;: 241,
&quot;careerHR&quot;: 254,
&quot;careerSO&quot;: 2036,
&quot;careerBB&quot;: 1166 
},
{
 &quot;playerID&quot;: &quot;palmeji01&quot;,
&quot;fullname&quot;: &quot;Jim Palmer&quot;,
&quot;year&quot;: 1981,
&quot;careerWIN&quot;: 248,
&quot;careerHR&quot;: 268,
&quot;careerSO&quot;: 2071,
&quot;careerBB&quot;: 1212 
},
{
 &quot;playerID&quot;: &quot;palmeji01&quot;,
&quot;fullname&quot;: &quot;Jim Palmer&quot;,
&quot;year&quot;: 1982,
&quot;careerWIN&quot;: 263,
&quot;careerHR&quot;: 290,
&quot;careerSO&quot;: 2174,
&quot;careerBB&quot;: 1275 
},
{
 &quot;playerID&quot;: &quot;palmeji01&quot;,
&quot;fullname&quot;: &quot;Jim Palmer&quot;,
&quot;year&quot;: 1983,
&quot;careerWIN&quot;: 268,
&quot;careerHR&quot;: 301,
&quot;careerSO&quot;: 2208,
&quot;careerBB&quot;: 1294 
},
{
 &quot;playerID&quot;: &quot;palmeji01&quot;,
&quot;fullname&quot;: &quot;Jim Palmer&quot;,
&quot;year&quot;: 1984,
&quot;careerWIN&quot;: 268,
&quot;careerHR&quot;: 303,
&quot;careerSO&quot;: 2212,
&quot;careerBB&quot;: 1311 
},
{
 &quot;playerID&quot;: &quot;perryga01&quot;,
&quot;fullname&quot;: &quot;Gaylord Perry&quot;,
&quot;year&quot;: 1962,
&quot;careerWIN&quot;: 3,
&quot;careerHR&quot;: 3,
&quot;careerSO&quot;: 20,
&quot;careerBB&quot;: 14 
},
{
 &quot;playerID&quot;: &quot;perryga01&quot;,
&quot;fullname&quot;: &quot;Gaylord Perry&quot;,
&quot;year&quot;: 1963,
&quot;careerWIN&quot;: 4,
&quot;careerHR&quot;: 13,
&quot;careerSO&quot;: 72,
&quot;careerBB&quot;: 43 
},
{
 &quot;playerID&quot;: &quot;perryga01&quot;,
&quot;fullname&quot;: &quot;Gaylord Perry&quot;,
&quot;year&quot;: 1964,
&quot;careerWIN&quot;: 16,
&quot;careerHR&quot;: 29,
&quot;careerSO&quot;: 227,
&quot;careerBB&quot;: 86 
},
{
 &quot;playerID&quot;: &quot;perryga01&quot;,
&quot;fullname&quot;: &quot;Gaylord Perry&quot;,
&quot;year&quot;: 1965,
&quot;careerWIN&quot;: 24,
&quot;careerHR&quot;: 50,
&quot;careerSO&quot;: 397,
&quot;careerBB&quot;: 156 
},
{
 &quot;playerID&quot;: &quot;perryga01&quot;,
&quot;fullname&quot;: &quot;Gaylord Perry&quot;,
&quot;year&quot;: 1966,
&quot;careerWIN&quot;: 45,
&quot;careerHR&quot;: 65,
&quot;careerSO&quot;: 598,
&quot;careerBB&quot;: 196 
},
{
 &quot;playerID&quot;: &quot;perryga01&quot;,
&quot;fullname&quot;: &quot;Gaylord Perry&quot;,
&quot;year&quot;: 1967,
&quot;careerWIN&quot;: 60,
&quot;careerHR&quot;: 85,
&quot;careerSO&quot;: 828,
&quot;careerBB&quot;: 280 
},
{
 &quot;playerID&quot;: &quot;perryga01&quot;,
&quot;fullname&quot;: &quot;Gaylord Perry&quot;,
&quot;year&quot;: 1968,
&quot;careerWIN&quot;: 76,
&quot;careerHR&quot;: 95,
&quot;careerSO&quot;: 1001,
&quot;careerBB&quot;: 339 
},
{
 &quot;playerID&quot;: &quot;perryga01&quot;,
&quot;fullname&quot;: &quot;Gaylord Perry&quot;,
&quot;year&quot;: 1969,
&quot;careerWIN&quot;: 95,
&quot;careerHR&quot;: 118,
&quot;careerSO&quot;: 1234,
&quot;careerBB&quot;: 430 
},
{
 &quot;playerID&quot;: &quot;perryga01&quot;,
&quot;fullname&quot;: &quot;Gaylord Perry&quot;,
&quot;year&quot;: 1970,
&quot;careerWIN&quot;: 118,
&quot;careerHR&quot;: 145,
&quot;careerSO&quot;: 1448,
&quot;careerBB&quot;: 514 
},
{
 &quot;playerID&quot;: &quot;perryga01&quot;,
&quot;fullname&quot;: &quot;Gaylord Perry&quot;,
&quot;year&quot;: 1971,
&quot;careerWIN&quot;: 134,
&quot;careerHR&quot;: 165,
&quot;careerSO&quot;: 1606,
&quot;careerBB&quot;: 581 
},
{
 &quot;playerID&quot;: &quot;perryga01&quot;,
&quot;fullname&quot;: &quot;Gaylord Perry&quot;,
&quot;year&quot;: 1972,
&quot;careerWIN&quot;: 158,
&quot;careerHR&quot;: 182,
&quot;careerSO&quot;: 1840,
&quot;careerBB&quot;: 663 
},
{
 &quot;playerID&quot;: &quot;perryga01&quot;,
&quot;fullname&quot;: &quot;Gaylord Perry&quot;,
&quot;year&quot;: 1973,
&quot;careerWIN&quot;: 177,
&quot;careerHR&quot;: 216,
&quot;careerSO&quot;: 2078,
&quot;careerBB&quot;: 778 
},
{
 &quot;playerID&quot;: &quot;perryga01&quot;,
&quot;fullname&quot;: &quot;Gaylord Perry&quot;,
&quot;year&quot;: 1974,
&quot;careerWIN&quot;: 198,
&quot;careerHR&quot;: 241,
&quot;careerSO&quot;: 2294,
&quot;careerBB&quot;: 877 
},
{
 &quot;playerID&quot;: &quot;perryga01&quot;,
&quot;fullname&quot;: &quot;Gaylord Perry&quot;,
&quot;year&quot;: 1975,
&quot;careerWIN&quot;: 216,
&quot;careerHR&quot;: 269,
&quot;careerSO&quot;: 2527,
&quot;careerBB&quot;: 947 
},
{
 &quot;playerID&quot;: &quot;perryga01&quot;,
&quot;fullname&quot;: &quot;Gaylord Perry&quot;,
&quot;year&quot;: 1976,
&quot;careerWIN&quot;: 231,
&quot;careerHR&quot;: 283,
&quot;careerSO&quot;: 2670,
&quot;careerBB&quot;: 999 
},
{
 &quot;playerID&quot;: &quot;perryga01&quot;,
&quot;fullname&quot;: &quot;Gaylord Perry&quot;,
&quot;year&quot;: 1977,
&quot;careerWIN&quot;: 246,
&quot;careerHR&quot;: 304,
&quot;careerSO&quot;: 2847,
&quot;careerBB&quot;: 1055 
},
{
 &quot;playerID&quot;: &quot;perryga01&quot;,
&quot;fullname&quot;: &quot;Gaylord Perry&quot;,
&quot;year&quot;: 1978,
&quot;careerWIN&quot;: 267,
&quot;careerHR&quot;: 313,
&quot;careerSO&quot;: 3001,
&quot;careerBB&quot;: 1121 
},
{
 &quot;playerID&quot;: &quot;perryga01&quot;,
&quot;fullname&quot;: &quot;Gaylord Perry&quot;,
&quot;year&quot;: 1979,
&quot;careerWIN&quot;: 279,
&quot;careerHR&quot;: 325,
&quot;careerSO&quot;: 3141,
&quot;careerBB&quot;: 1188 
},
{
 &quot;playerID&quot;: &quot;perryga01&quot;,
&quot;fullname&quot;: &quot;Gaylord Perry&quot;,
&quot;year&quot;: 1980,
&quot;careerWIN&quot;: 289,
&quot;careerHR&quot;: 339,
&quot;careerSO&quot;: 3276,
&quot;careerBB&quot;: 1252 
},
{
 &quot;playerID&quot;: &quot;perryga01&quot;,
&quot;fullname&quot;: &quot;Gaylord Perry&quot;,
&quot;year&quot;: 1981,
&quot;careerWIN&quot;: 297,
&quot;careerHR&quot;: 348,
&quot;careerSO&quot;: 3336,
&quot;careerBB&quot;: 1276 
},
{
 &quot;playerID&quot;: &quot;perryga01&quot;,
&quot;fullname&quot;: &quot;Gaylord Perry&quot;,
&quot;year&quot;: 1982,
&quot;careerWIN&quot;: 307,
&quot;careerHR&quot;: 375,
&quot;careerSO&quot;: 3452,
&quot;careerBB&quot;: 1330 
},
{
 &quot;playerID&quot;: &quot;perryga01&quot;,
&quot;fullname&quot;: &quot;Gaylord Perry&quot;,
&quot;year&quot;: 1983,
&quot;careerWIN&quot;: 314,
&quot;careerHR&quot;: 399,
&quot;careerSO&quot;: 3534,
&quot;careerBB&quot;: 1379 
},
{
 &quot;playerID&quot;: &quot;pettian01&quot;,
&quot;fullname&quot;: &quot;Andy Pettitte&quot;,
&quot;year&quot;: 1995,
&quot;careerWIN&quot;: 12,
&quot;careerHR&quot;: 15,
&quot;careerSO&quot;: 114,
&quot;careerBB&quot;: 63 
},
{
 &quot;playerID&quot;: &quot;pettian01&quot;,
&quot;fullname&quot;: &quot;Andy Pettitte&quot;,
&quot;year&quot;: 1996,
&quot;careerWIN&quot;: 33,
&quot;careerHR&quot;: 38,
&quot;careerSO&quot;: 276,
&quot;careerBB&quot;: 135 
},
{
 &quot;playerID&quot;: &quot;pettian01&quot;,
&quot;fullname&quot;: &quot;Andy Pettitte&quot;,
&quot;year&quot;: 1997,
&quot;careerWIN&quot;: 51,
&quot;careerHR&quot;: 45,
&quot;careerSO&quot;: 442,
&quot;careerBB&quot;: 200 
},
{
 &quot;playerID&quot;: &quot;pettian01&quot;,
&quot;fullname&quot;: &quot;Andy Pettitte&quot;,
&quot;year&quot;: 1998,
&quot;careerWIN&quot;: 67,
&quot;careerHR&quot;: 65,
&quot;careerSO&quot;: 588,
&quot;careerBB&quot;: 287 
},
{
 &quot;playerID&quot;: &quot;pettian01&quot;,
&quot;fullname&quot;: &quot;Andy Pettitte&quot;,
&quot;year&quot;: 1999,
&quot;careerWIN&quot;: 81,
&quot;careerHR&quot;: 85,
&quot;careerSO&quot;: 709,
&quot;careerBB&quot;: 376 
},
{
 &quot;playerID&quot;: &quot;pettian01&quot;,
&quot;fullname&quot;: &quot;Andy Pettitte&quot;,
&quot;year&quot;: 2000,
&quot;careerWIN&quot;: 100,
&quot;careerHR&quot;: 102,
&quot;careerSO&quot;: 834,
&quot;careerBB&quot;: 456 
},
{
 &quot;playerID&quot;: &quot;pettian01&quot;,
&quot;fullname&quot;: &quot;Andy Pettitte&quot;,
&quot;year&quot;: 2001,
&quot;careerWIN&quot;: 115,
&quot;careerHR&quot;: 116,
&quot;careerSO&quot;: 998,
&quot;careerBB&quot;: 497 
},
{
 &quot;playerID&quot;: &quot;pettian01&quot;,
&quot;fullname&quot;: &quot;Andy Pettitte&quot;,
&quot;year&quot;: 2002,
&quot;careerWIN&quot;: 128,
&quot;careerHR&quot;: 122,
&quot;careerSO&quot;: 1095,
&quot;careerBB&quot;: 529 
},
{
 &quot;playerID&quot;: &quot;pettian01&quot;,
&quot;fullname&quot;: &quot;Andy Pettitte&quot;,
&quot;year&quot;: 2003,
&quot;careerWIN&quot;: 149,
&quot;careerHR&quot;: 143,
&quot;careerSO&quot;: 1275,
&quot;careerBB&quot;: 579 
},
{
 &quot;playerID&quot;: &quot;pettian01&quot;,
&quot;fullname&quot;: &quot;Andy Pettitte&quot;,
&quot;year&quot;: 2004,
&quot;careerWIN&quot;: 155,
&quot;careerHR&quot;: 151,
&quot;careerSO&quot;: 1354,
&quot;careerBB&quot;: 610 
},
{
 &quot;playerID&quot;: &quot;pettian01&quot;,
&quot;fullname&quot;: &quot;Andy Pettitte&quot;,
&quot;year&quot;: 2005,
&quot;careerWIN&quot;: 172,
&quot;careerHR&quot;: 168,
&quot;careerSO&quot;: 1525,
&quot;careerBB&quot;: 651 
},
{
 &quot;playerID&quot;: &quot;pettian01&quot;,
&quot;fullname&quot;: &quot;Andy Pettitte&quot;,
&quot;year&quot;: 2006,
&quot;careerWIN&quot;: 186,
&quot;careerHR&quot;: 195,
&quot;careerSO&quot;: 1703,
&quot;careerBB&quot;: 721 
},
{
 &quot;playerID&quot;: &quot;pettian01&quot;,
&quot;fullname&quot;: &quot;Andy Pettitte&quot;,
&quot;year&quot;: 2007,
&quot;careerWIN&quot;: 201,
&quot;careerHR&quot;: 211,
&quot;careerSO&quot;: 1844,
&quot;careerBB&quot;: 790 
},
{
 &quot;playerID&quot;: &quot;pettian01&quot;,
&quot;fullname&quot;: &quot;Andy Pettitte&quot;,
&quot;year&quot;: 2008,
&quot;careerWIN&quot;: 215,
&quot;careerHR&quot;: 230,
&quot;careerSO&quot;: 2002,
&quot;careerBB&quot;: 845 
},
{
 &quot;playerID&quot;: &quot;pettian01&quot;,
&quot;fullname&quot;: &quot;Andy Pettitte&quot;,
&quot;year&quot;: 2009,
&quot;careerWIN&quot;: 229,
&quot;careerHR&quot;: 250,
&quot;careerSO&quot;: 2150,
&quot;careerBB&quot;: 921 
},
{
 &quot;playerID&quot;: &quot;pettian01&quot;,
&quot;fullname&quot;: &quot;Andy Pettitte&quot;,
&quot;year&quot;: 2010,
&quot;careerWIN&quot;: 240,
&quot;careerHR&quot;: 263,
&quot;careerSO&quot;: 2251,
&quot;careerBB&quot;: 962 
},
{
 &quot;playerID&quot;: &quot;pettian01&quot;,
&quot;fullname&quot;: &quot;Andy Pettitte&quot;,
&quot;year&quot;: 2012,
&quot;careerWIN&quot;: 245,
&quot;careerHR&quot;: 271,
&quot;careerSO&quot;: 2320,
&quot;careerBB&quot;: 983 
},
{
 &quot;playerID&quot;: &quot;pettian01&quot;,
&quot;fullname&quot;: &quot;Andy Pettitte&quot;,
&quot;year&quot;: 2013,
&quot;careerWIN&quot;: 256,
&quot;careerHR&quot;: 288,
&quot;careerSO&quot;: 2448,
&quot;careerBB&quot;: 1031 
},
{
 &quot;playerID&quot;: &quot;planked01&quot;,
&quot;fullname&quot;: &quot;Eddie Plank&quot;,
&quot;year&quot;: 1901,
&quot;careerWIN&quot;: 17,
&quot;careerHR&quot;: 2,
&quot;careerSO&quot;: 90,
&quot;careerBB&quot;: 68 
},
{
 &quot;playerID&quot;: &quot;planked01&quot;,
&quot;fullname&quot;: &quot;Eddie Plank&quot;,
&quot;year&quot;: 1902,
&quot;careerWIN&quot;: 37,
&quot;careerHR&quot;: 7,
&quot;careerSO&quot;: 197,
&quot;careerBB&quot;: 129 
},
{
 &quot;playerID&quot;: &quot;planked01&quot;,
&quot;fullname&quot;: &quot;Eddie Plank&quot;,
&quot;year&quot;: 1903,
&quot;careerWIN&quot;: 60,
&quot;careerHR&quot;: 12,
&quot;careerSO&quot;: 373,
&quot;careerBB&quot;: 194 
},
{
 &quot;playerID&quot;: &quot;planked01&quot;,
&quot;fullname&quot;: &quot;Eddie Plank&quot;,
&quot;year&quot;: 1904,
&quot;careerWIN&quot;: 86,
&quot;careerHR&quot;: 14,
&quot;careerSO&quot;: 574,
&quot;careerBB&quot;: 280 
},
{
 &quot;playerID&quot;: &quot;planked01&quot;,
&quot;fullname&quot;: &quot;Eddie Plank&quot;,
&quot;year&quot;: 1905,
&quot;careerWIN&quot;: 110,
&quot;careerHR&quot;: 17,
&quot;careerSO&quot;: 784,
&quot;careerBB&quot;: 355 
},
{
 &quot;playerID&quot;: &quot;planked01&quot;,
&quot;fullname&quot;: &quot;Eddie Plank&quot;,
&quot;year&quot;: 1906,
&quot;careerWIN&quot;: 129,
&quot;careerHR&quot;: 18,
&quot;careerSO&quot;: 892,
&quot;careerBB&quot;: 406 
},
{
 &quot;playerID&quot;: &quot;planked01&quot;,
&quot;fullname&quot;: &quot;Eddie Plank&quot;,
&quot;year&quot;: 1907,
&quot;careerWIN&quot;: 153,
&quot;careerHR&quot;: 23,
&quot;careerSO&quot;: 1075,
&quot;careerBB&quot;: 491 
},
{
 &quot;playerID&quot;: &quot;planked01&quot;,
&quot;fullname&quot;: &quot;Eddie Plank&quot;,
&quot;year&quot;: 1908,
&quot;careerWIN&quot;: 167,
&quot;careerHR&quot;: 24,
&quot;careerSO&quot;: 1210,
&quot;careerBB&quot;: 537 
},
{
 &quot;playerID&quot;: &quot;planked01&quot;,
&quot;fullname&quot;: &quot;Eddie Plank&quot;,
&quot;year&quot;: 1909,
&quot;careerWIN&quot;: 186,
&quot;careerHR&quot;: 25,
&quot;careerSO&quot;: 1342,
&quot;careerBB&quot;: 599 
},
{
 &quot;playerID&quot;: &quot;planked01&quot;,
&quot;fullname&quot;: &quot;Eddie Plank&quot;,
&quot;year&quot;: 1910,
&quot;careerWIN&quot;: 202,
&quot;careerHR&quot;: 28,
&quot;careerSO&quot;: 1465,
&quot;careerBB&quot;: 654 
},
{
 &quot;playerID&quot;: &quot;planked01&quot;,
&quot;fullname&quot;: &quot;Eddie Plank&quot;,
&quot;year&quot;: 1911,
&quot;careerWIN&quot;: 225,
&quot;careerHR&quot;: 30,
&quot;careerSO&quot;: 1614,
&quot;careerBB&quot;: 731 
},
{
 &quot;playerID&quot;: &quot;planked01&quot;,
&quot;fullname&quot;: &quot;Eddie Plank&quot;,
&quot;year&quot;: 1912,
&quot;careerWIN&quot;: 251,
&quot;careerHR&quot;: 31,
&quot;careerSO&quot;: 1724,
&quot;careerBB&quot;: 814 
},
{
 &quot;playerID&quot;: &quot;planked01&quot;,
&quot;fullname&quot;: &quot;Eddie Plank&quot;,
&quot;year&quot;: 1913,
&quot;careerWIN&quot;: 269,
&quot;careerHR&quot;: 34,
&quot;careerSO&quot;: 1875,
&quot;careerBB&quot;: 871 
},
{
 &quot;playerID&quot;: &quot;planked01&quot;,
&quot;fullname&quot;: &quot;Eddie Plank&quot;,
&quot;year&quot;: 1914,
&quot;careerWIN&quot;: 284,
&quot;careerHR&quot;: 36,
&quot;careerSO&quot;: 1985,
&quot;careerBB&quot;: 913 
},
{
 &quot;playerID&quot;: &quot;planked01&quot;,
&quot;fullname&quot;: &quot;Eddie Plank&quot;,
&quot;year&quot;: 1915,
&quot;careerWIN&quot;: 305,
&quot;careerHR&quot;: 37,
&quot;careerSO&quot;: 2132,
&quot;careerBB&quot;: 967 
},
{
 &quot;playerID&quot;: &quot;planked01&quot;,
&quot;fullname&quot;: &quot;Eddie Plank&quot;,
&quot;year&quot;: 1916,
&quot;careerWIN&quot;: 321,
&quot;careerHR&quot;: 39,
&quot;careerSO&quot;: 2220,
&quot;careerBB&quot;: 1034 
},
{
 &quot;playerID&quot;: &quot;planked01&quot;,
&quot;fullname&quot;: &quot;Eddie Plank&quot;,
&quot;year&quot;: 1917,
&quot;careerWIN&quot;: 326,
&quot;careerHR&quot;: 41,
&quot;careerSO&quot;: 2246,
&quot;careerBB&quot;: 1072 
},
{
 &quot;playerID&quot;: &quot;radboch01&quot;,
&quot;fullname&quot;: &quot;Charley Radbourn&quot;,
&quot;year&quot;: 1881,
&quot;careerWIN&quot;: 25,
&quot;careerHR&quot;: 1,
&quot;careerSO&quot;: 117,
&quot;careerBB&quot;: 64 
},
{
 &quot;playerID&quot;: &quot;radboch01&quot;,
&quot;fullname&quot;: &quot;Charley Radbourn&quot;,
&quot;year&quot;: 1882,
&quot;careerWIN&quot;: 58,
&quot;careerHR&quot;: 7,
&quot;careerSO&quot;: 318,
&quot;careerBB&quot;: 115 
},
{
 &quot;playerID&quot;: &quot;radboch01&quot;,
&quot;fullname&quot;: &quot;Charley Radbourn&quot;,
&quot;year&quot;: 1883,
&quot;careerWIN&quot;: 106,
&quot;careerHR&quot;: 14,
&quot;careerSO&quot;: 633,
&quot;careerBB&quot;: 171 
},
{
 &quot;playerID&quot;: &quot;radboch01&quot;,
&quot;fullname&quot;: &quot;Charley Radbourn&quot;,
&quot;year&quot;: 1884,
&quot;careerWIN&quot;: 165,
&quot;careerHR&quot;: 32,
&quot;careerSO&quot;: 1074,
&quot;careerBB&quot;: 269 
},
{
 &quot;playerID&quot;: &quot;radboch01&quot;,
&quot;fullname&quot;: &quot;Charley Radbourn&quot;,
&quot;year&quot;: 1885,
&quot;careerWIN&quot;: 193,
&quot;careerHR&quot;: 36,
&quot;careerSO&quot;: 1228,
&quot;careerBB&quot;: 352 
},
{
 &quot;playerID&quot;: &quot;radboch01&quot;,
&quot;fullname&quot;: &quot;Charley Radbourn&quot;,
&quot;year&quot;: 1886,
&quot;careerWIN&quot;: 220,
&quot;careerHR&quot;: 54,
&quot;careerSO&quot;: 1446,
&quot;careerBB&quot;: 463 
},
{
 &quot;playerID&quot;: &quot;radboch01&quot;,
&quot;fullname&quot;: &quot;Charley Radbourn&quot;,
&quot;year&quot;: 1887,
&quot;careerWIN&quot;: 244,
&quot;careerHR&quot;: 74,
&quot;careerSO&quot;: 1533,
&quot;careerBB&quot;: 596 
},
{
 &quot;playerID&quot;: &quot;radboch01&quot;,
&quot;fullname&quot;: &quot;Charley Radbourn&quot;,
&quot;year&quot;: 1888,
&quot;careerWIN&quot;: 251,
&quot;careerHR&quot;: 82,
&quot;careerSO&quot;: 1597,
&quot;careerBB&quot;: 641 
},
{
 &quot;playerID&quot;: &quot;radboch01&quot;,
&quot;fullname&quot;: &quot;Charley Radbourn&quot;,
&quot;year&quot;: 1889,
&quot;careerWIN&quot;: 271,
&quot;careerHR&quot;: 96,
&quot;careerSO&quot;: 1696,
&quot;careerBB&quot;: 713 
},
{
 &quot;playerID&quot;: &quot;radboch01&quot;,
&quot;fullname&quot;: &quot;Charley Radbourn&quot;,
&quot;year&quot;: 1890,
&quot;careerWIN&quot;: 298,
&quot;careerHR&quot;: 104,
&quot;careerSO&quot;: 1776,
&quot;careerBB&quot;: 813 
},
{
 &quot;playerID&quot;: &quot;radboch01&quot;,
&quot;fullname&quot;: &quot;Charley Radbourn&quot;,
&quot;year&quot;: 1891,
&quot;careerWIN&quot;: 309,
&quot;careerHR&quot;: 117,
&quot;careerSO&quot;: 1830,
&quot;careerBB&quot;: 875 
},
{
 &quot;playerID&quot;: &quot;rixeyep01&quot;,
&quot;fullname&quot;: &quot;Eppa Rixey&quot;,
&quot;year&quot;: 1912,
&quot;careerWIN&quot;: 10,
&quot;careerHR&quot;: 2,
&quot;careerSO&quot;: 59,
&quot;careerBB&quot;: 54 
},
{
 &quot;playerID&quot;: &quot;rixeyep01&quot;,
&quot;fullname&quot;: &quot;Eppa Rixey&quot;,
&quot;year&quot;: 1913,
&quot;careerWIN&quot;: 19,
&quot;careerHR&quot;: 6,
&quot;careerSO&quot;: 134,
&quot;careerBB&quot;: 110 
},
{
 &quot;playerID&quot;: &quot;rixeyep01&quot;,
&quot;fullname&quot;: &quot;Eppa Rixey&quot;,
&quot;year&quot;: 1914,
&quot;careerWIN&quot;: 21,
&quot;careerHR&quot;: 6,
&quot;careerSO&quot;: 175,
&quot;careerBB&quot;: 155 
},
{
 &quot;playerID&quot;: &quot;rixeyep01&quot;,
&quot;fullname&quot;: &quot;Eppa Rixey&quot;,
&quot;year&quot;: 1915,
&quot;careerWIN&quot;: 32,
&quot;careerHR&quot;: 8,
&quot;careerSO&quot;: 263,
&quot;careerBB&quot;: 219 
},
{
 &quot;playerID&quot;: &quot;rixeyep01&quot;,
&quot;fullname&quot;: &quot;Eppa Rixey&quot;,
&quot;year&quot;: 1916,
&quot;careerWIN&quot;: 54,
&quot;careerHR&quot;: 10,
&quot;careerSO&quot;: 397,
&quot;careerBB&quot;: 293 
},
{
 &quot;playerID&quot;: &quot;rixeyep01&quot;,
&quot;fullname&quot;: &quot;Eppa Rixey&quot;,
&quot;year&quot;: 1917,
&quot;careerWIN&quot;: 70,
&quot;careerHR&quot;: 11,
&quot;careerSO&quot;: 518,
&quot;careerBB&quot;: 360 
},
{
 &quot;playerID&quot;: &quot;rixeyep01&quot;,
&quot;fullname&quot;: &quot;Eppa Rixey&quot;,
&quot;year&quot;: 1919,
&quot;careerWIN&quot;: 76,
&quot;careerHR&quot;: 15,
&quot;careerSO&quot;: 581,
&quot;careerBB&quot;: 410 
},
{
 &quot;playerID&quot;: &quot;rixeyep01&quot;,
&quot;fullname&quot;: &quot;Eppa Rixey&quot;,
&quot;year&quot;: 1920,
&quot;careerWIN&quot;: 87,
&quot;careerHR&quot;: 20,
&quot;careerSO&quot;: 690,
&quot;careerBB&quot;: 479 
},
{
 &quot;playerID&quot;: &quot;rixeyep01&quot;,
&quot;fullname&quot;: &quot;Eppa Rixey&quot;,
&quot;year&quot;: 1921,
&quot;careerWIN&quot;: 106,
&quot;careerHR&quot;: 21,
&quot;careerSO&quot;: 766,
&quot;careerBB&quot;: 545 
},
{
 &quot;playerID&quot;: &quot;rixeyep01&quot;,
&quot;fullname&quot;: &quot;Eppa Rixey&quot;,
&quot;year&quot;: 1922,
&quot;careerWIN&quot;: 131,
&quot;careerHR&quot;: 34,
&quot;careerSO&quot;: 846,
&quot;careerBB&quot;: 590 
},
{
 &quot;playerID&quot;: &quot;rixeyep01&quot;,
&quot;fullname&quot;: &quot;Eppa Rixey&quot;,
&quot;year&quot;: 1923,
&quot;careerWIN&quot;: 151,
&quot;careerHR&quot;: 37,
&quot;careerSO&quot;: 943,
&quot;careerBB&quot;: 655 
},
{
 &quot;playerID&quot;: &quot;rixeyep01&quot;,
&quot;fullname&quot;: &quot;Eppa Rixey&quot;,
&quot;year&quot;: 1924,
&quot;careerWIN&quot;: 166,
&quot;careerHR&quot;: 40,
&quot;careerSO&quot;: 1000,
&quot;careerBB&quot;: 702 
},
{
 &quot;playerID&quot;: &quot;rixeyep01&quot;,
&quot;fullname&quot;: &quot;Eppa Rixey&quot;,
&quot;year&quot;: 1925,
&quot;careerWIN&quot;: 187,
&quot;careerHR&quot;: 48,
&quot;careerSO&quot;: 1069,
&quot;careerBB&quot;: 749 
},
{
 &quot;playerID&quot;: &quot;rixeyep01&quot;,
&quot;fullname&quot;: &quot;Eppa Rixey&quot;,
&quot;year&quot;: 1926,
&quot;careerWIN&quot;: 201,
&quot;careerHR&quot;: 60,
&quot;careerSO&quot;: 1130,
&quot;careerBB&quot;: 807 
},
{
 &quot;playerID&quot;: &quot;rixeyep01&quot;,
&quot;fullname&quot;: &quot;Eppa Rixey&quot;,
&quot;year&quot;: 1927,
&quot;careerWIN&quot;: 213,
&quot;careerHR&quot;: 63,
&quot;careerSO&quot;: 1172,
&quot;careerBB&quot;: 850 
},
{
 &quot;playerID&quot;: &quot;rixeyep01&quot;,
&quot;fullname&quot;: &quot;Eppa Rixey&quot;,
&quot;year&quot;: 1928,
&quot;careerWIN&quot;: 232,
&quot;careerHR&quot;: 67,
&quot;careerSO&quot;: 1230,
&quot;careerBB&quot;: 917 
},
{
 &quot;playerID&quot;: &quot;rixeyep01&quot;,
&quot;fullname&quot;: &quot;Eppa Rixey&quot;,
&quot;year&quot;: 1929,
&quot;careerWIN&quot;: 242,
&quot;careerHR&quot;: 73,
&quot;careerSO&quot;: 1267,
&quot;careerBB&quot;: 977 
},
{
 &quot;playerID&quot;: &quot;rixeyep01&quot;,
&quot;fullname&quot;: &quot;Eppa Rixey&quot;,
&quot;year&quot;: 1930,
&quot;careerWIN&quot;: 251,
&quot;careerHR&quot;: 84,
&quot;careerSO&quot;: 1304,
&quot;careerBB&quot;: 1024 
},
{
 &quot;playerID&quot;: &quot;rixeyep01&quot;,
&quot;fullname&quot;: &quot;Eppa Rixey&quot;,
&quot;year&quot;: 1931,
&quot;careerWIN&quot;: 255,
&quot;careerHR&quot;: 88,
&quot;careerSO&quot;: 1326,
&quot;careerBB&quot;: 1054 
},
{
 &quot;playerID&quot;: &quot;rixeyep01&quot;,
&quot;fullname&quot;: &quot;Eppa Rixey&quot;,
&quot;year&quot;: 1932,
&quot;careerWIN&quot;: 260,
&quot;careerHR&quot;: 91,
&quot;careerSO&quot;: 1340,
&quot;careerBB&quot;: 1070 
},
{
 &quot;playerID&quot;: &quot;rixeyep01&quot;,
&quot;fullname&quot;: &quot;Eppa Rixey&quot;,
&quot;year&quot;: 1933,
&quot;careerWIN&quot;: 266,
&quot;careerHR&quot;: 92,
&quot;careerSO&quot;: 1350,
&quot;careerBB&quot;: 1082 
},
{
 &quot;playerID&quot;: &quot;roberro01&quot;,
&quot;fullname&quot;: &quot;Robin Roberts&quot;,
&quot;year&quot;: 1948,
&quot;careerWIN&quot;: 7,
&quot;careerHR&quot;: 10,
&quot;careerSO&quot;: 84,
&quot;careerBB&quot;: 61 
},
{
 &quot;playerID&quot;: &quot;roberro01&quot;,
&quot;fullname&quot;: &quot;Robin Roberts&quot;,
&quot;year&quot;: 1949,
&quot;careerWIN&quot;: 22,
&quot;careerHR&quot;: 25,
&quot;careerSO&quot;: 179,
&quot;careerBB&quot;: 136 
},
{
 &quot;playerID&quot;: &quot;roberro01&quot;,
&quot;fullname&quot;: &quot;Robin Roberts&quot;,
&quot;year&quot;: 1950,
&quot;careerWIN&quot;: 42,
&quot;careerHR&quot;: 54,
&quot;careerSO&quot;: 325,
&quot;careerBB&quot;: 213 
},
{
 &quot;playerID&quot;: &quot;roberro01&quot;,
&quot;fullname&quot;: &quot;Robin Roberts&quot;,
&quot;year&quot;: 1951,
&quot;careerWIN&quot;: 63,
&quot;careerHR&quot;: 74,
&quot;careerSO&quot;: 452,
&quot;careerBB&quot;: 277 
},
{
 &quot;playerID&quot;: &quot;roberro01&quot;,
&quot;fullname&quot;: &quot;Robin Roberts&quot;,
&quot;year&quot;: 1952,
&quot;careerWIN&quot;: 91,
&quot;careerHR&quot;: 96,
&quot;careerSO&quot;: 600,
&quot;careerBB&quot;: 322 
},
{
 &quot;playerID&quot;: &quot;roberro01&quot;,
&quot;fullname&quot;: &quot;Robin Roberts&quot;,
&quot;year&quot;: 1953,
&quot;careerWIN&quot;: 114,
&quot;careerHR&quot;: 126,
&quot;careerSO&quot;: 798,
&quot;careerBB&quot;: 383 
},
{
 &quot;playerID&quot;: &quot;roberro01&quot;,
&quot;fullname&quot;: &quot;Robin Roberts&quot;,
&quot;year&quot;: 1954,
&quot;careerWIN&quot;: 137,
&quot;careerHR&quot;: 161,
&quot;careerSO&quot;: 983,
&quot;careerBB&quot;: 439 
},
{
 &quot;playerID&quot;: &quot;roberro01&quot;,
&quot;fullname&quot;: &quot;Robin Roberts&quot;,
&quot;year&quot;: 1955,
&quot;careerWIN&quot;: 160,
&quot;careerHR&quot;: 202,
&quot;careerSO&quot;: 1143,
&quot;careerBB&quot;: 492 
},
{
 &quot;playerID&quot;: &quot;roberro01&quot;,
&quot;fullname&quot;: &quot;Robin Roberts&quot;,
&quot;year&quot;: 1956,
&quot;careerWIN&quot;: 179,
&quot;careerHR&quot;: 248,
&quot;careerSO&quot;: 1300,
&quot;careerBB&quot;: 532 
},
{
 &quot;playerID&quot;: &quot;roberro01&quot;,
&quot;fullname&quot;: &quot;Robin Roberts&quot;,
&quot;year&quot;: 1957,
&quot;careerWIN&quot;: 189,
&quot;careerHR&quot;: 288,
&quot;careerSO&quot;: 1428,
&quot;careerBB&quot;: 575 
},
{
 &quot;playerID&quot;: &quot;roberro01&quot;,
&quot;fullname&quot;: &quot;Robin Roberts&quot;,
&quot;year&quot;: 1958,
&quot;careerWIN&quot;: 206,
&quot;careerHR&quot;: 318,
&quot;careerSO&quot;: 1558,
&quot;careerBB&quot;: 626 
},
{
 &quot;playerID&quot;: &quot;roberro01&quot;,
&quot;fullname&quot;: &quot;Robin Roberts&quot;,
&quot;year&quot;: 1959,
&quot;careerWIN&quot;: 221,
&quot;careerHR&quot;: 352,
&quot;careerSO&quot;: 1695,
&quot;careerBB&quot;: 661 
},
{
 &quot;playerID&quot;: &quot;roberro01&quot;,
&quot;fullname&quot;: &quot;Robin Roberts&quot;,
&quot;year&quot;: 1960,
&quot;careerWIN&quot;: 233,
&quot;careerHR&quot;: 383,
&quot;careerSO&quot;: 1817,
&quot;careerBB&quot;: 695 
},
{
 &quot;playerID&quot;: &quot;roberro01&quot;,
&quot;fullname&quot;: &quot;Robin Roberts&quot;,
&quot;year&quot;: 1961,
&quot;careerWIN&quot;: 234,
&quot;careerHR&quot;: 402,
&quot;careerSO&quot;: 1871,
&quot;careerBB&quot;: 718 
},
{
 &quot;playerID&quot;: &quot;roberro01&quot;,
&quot;fullname&quot;: &quot;Robin Roberts&quot;,
&quot;year&quot;: 1962,
&quot;careerWIN&quot;: 244,
&quot;careerHR&quot;: 419,
&quot;careerSO&quot;: 1973,
&quot;careerBB&quot;: 759 
},
{
 &quot;playerID&quot;: &quot;roberro01&quot;,
&quot;fullname&quot;: &quot;Robin Roberts&quot;,
&quot;year&quot;: 1963,
&quot;careerWIN&quot;: 258,
&quot;careerHR&quot;: 454,
&quot;careerSO&quot;: 2097,
&quot;careerBB&quot;: 799 
},
{
 &quot;playerID&quot;: &quot;roberro01&quot;,
&quot;fullname&quot;: &quot;Robin Roberts&quot;,
&quot;year&quot;: 1964,
&quot;careerWIN&quot;: 271,
&quot;careerHR&quot;: 472,
&quot;careerSO&quot;: 2206,
&quot;careerBB&quot;: 851 
},
{
 &quot;playerID&quot;: &quot;roberro01&quot;,
&quot;fullname&quot;: &quot;Robin Roberts&quot;,
&quot;year&quot;: 1965,
&quot;careerWIN&quot;: 281,
&quot;careerHR&quot;: 490,
&quot;careerSO&quot;: 2303,
&quot;careerBB&quot;: 881 
},
{
 &quot;playerID&quot;: &quot;roberro01&quot;,
&quot;fullname&quot;: &quot;Robin Roberts&quot;,
&quot;year&quot;: 1966,
&quot;careerWIN&quot;: 286,
&quot;careerHR&quot;: 505,
&quot;careerSO&quot;: 2357,
&quot;careerBB&quot;: 902 
},
{
 &quot;playerID&quot;: &quot;ruffire01&quot;,
&quot;fullname&quot;: &quot;Red Ruffing&quot;,
&quot;year&quot;: 1924,
&quot;careerWIN&quot;: 0,
&quot;careerHR&quot;: 0,
&quot;careerSO&quot;: 10,
&quot;careerBB&quot;: 9 
},
{
 &quot;playerID&quot;: &quot;ruffire01&quot;,
&quot;fullname&quot;: &quot;Red Ruffing&quot;,
&quot;year&quot;: 1925,
&quot;careerWIN&quot;: 9,
&quot;careerHR&quot;: 10,
&quot;careerSO&quot;: 74,
&quot;careerBB&quot;: 84 
},
{
 &quot;playerID&quot;: &quot;ruffire01&quot;,
&quot;fullname&quot;: &quot;Red Ruffing&quot;,
&quot;year&quot;: 1926,
&quot;careerWIN&quot;: 15,
&quot;careerHR&quot;: 14,
&quot;careerSO&quot;: 132,
&quot;careerBB&quot;: 152 
},
{
 &quot;playerID&quot;: &quot;ruffire01&quot;,
&quot;fullname&quot;: &quot;Red Ruffing&quot;,
&quot;year&quot;: 1927,
&quot;careerWIN&quot;: 20,
&quot;careerHR&quot;: 21,
&quot;careerSO&quot;: 209,
&quot;careerBB&quot;: 239 
},
{
 &quot;playerID&quot;: &quot;ruffire01&quot;,
&quot;fullname&quot;: &quot;Red Ruffing&quot;,
&quot;year&quot;: 1928,
&quot;careerWIN&quot;: 30,
&quot;careerHR&quot;: 29,
&quot;careerSO&quot;: 327,
&quot;careerBB&quot;: 335 
},
{
 &quot;playerID&quot;: &quot;ruffire01&quot;,
&quot;fullname&quot;: &quot;Red Ruffing&quot;,
&quot;year&quot;: 1929,
&quot;careerWIN&quot;: 39,
&quot;careerHR&quot;: 46,
&quot;careerSO&quot;: 436,
&quot;careerBB&quot;: 453 
},
{
 &quot;playerID&quot;: &quot;ruffire01&quot;,
&quot;fullname&quot;: &quot;Red Ruffing&quot;,
&quot;year&quot;: 1930,
&quot;careerWIN&quot;: 54,
&quot;careerHR&quot;: 57,
&quot;careerSO&quot;: 567,
&quot;careerBB&quot;: 521 
},
{
 &quot;playerID&quot;: &quot;ruffire01&quot;,
&quot;fullname&quot;: &quot;Red Ruffing&quot;,
&quot;year&quot;: 1931,
&quot;careerWIN&quot;: 70,
&quot;careerHR&quot;: 68,
&quot;careerSO&quot;: 699,
&quot;careerBB&quot;: 608 
},
{
 &quot;playerID&quot;: &quot;ruffire01&quot;,
&quot;fullname&quot;: &quot;Red Ruffing&quot;,
&quot;year&quot;: 1932,
&quot;careerWIN&quot;: 88,
&quot;careerHR&quot;: 84,
&quot;careerSO&quot;: 889,
&quot;careerBB&quot;: 723 
},
{
 &quot;playerID&quot;: &quot;ruffire01&quot;,
&quot;fullname&quot;: &quot;Red Ruffing&quot;,
&quot;year&quot;: 1933,
&quot;careerWIN&quot;: 97,
&quot;careerHR&quot;: 91,
&quot;careerSO&quot;: 1011,
&quot;careerBB&quot;: 816 
},
{
 &quot;playerID&quot;: &quot;ruffire01&quot;,
&quot;fullname&quot;: &quot;Red Ruffing&quot;,
&quot;year&quot;: 1934,
&quot;careerWIN&quot;: 116,
&quot;careerHR&quot;: 109,
&quot;careerSO&quot;: 1160,
&quot;careerBB&quot;: 920 
},
{
 &quot;playerID&quot;: &quot;ruffire01&quot;,
&quot;fullname&quot;: &quot;Red Ruffing&quot;,
&quot;year&quot;: 1935,
&quot;careerWIN&quot;: 132,
&quot;careerHR&quot;: 126,
&quot;careerSO&quot;: 1241,
&quot;careerBB&quot;: 996 
},
{
 &quot;playerID&quot;: &quot;ruffire01&quot;,
&quot;fullname&quot;: &quot;Red Ruffing&quot;,
&quot;year&quot;: 1936,
&quot;careerWIN&quot;: 152,
&quot;careerHR&quot;: 148,
&quot;careerSO&quot;: 1343,
&quot;careerBB&quot;: 1086 
},
{
 &quot;playerID&quot;: &quot;ruffire01&quot;,
&quot;fullname&quot;: &quot;Red Ruffing&quot;,
&quot;year&quot;: 1937,
&quot;careerWIN&quot;: 172,
&quot;careerHR&quot;: 165,
&quot;careerSO&quot;: 1474,
&quot;careerBB&quot;: 1154 
},
{
 &quot;playerID&quot;: &quot;ruffire01&quot;,
&quot;fullname&quot;: &quot;Red Ruffing&quot;,
&quot;year&quot;: 1938,
&quot;careerWIN&quot;: 193,
&quot;careerHR&quot;: 181,
&quot;careerSO&quot;: 1601,
&quot;careerBB&quot;: 1236 
},
{
 &quot;playerID&quot;: &quot;ruffire01&quot;,
&quot;fullname&quot;: &quot;Red Ruffing&quot;,
&quot;year&quot;: 1939,
&quot;careerWIN&quot;: 214,
&quot;careerHR&quot;: 196,
&quot;careerSO&quot;: 1696,
&quot;careerBB&quot;: 1311 
},
{
 &quot;playerID&quot;: &quot;ruffire01&quot;,
&quot;fullname&quot;: &quot;Red Ruffing&quot;,
&quot;year&quot;: 1940,
&quot;careerWIN&quot;: 229,
&quot;careerHR&quot;: 220,
&quot;careerSO&quot;: 1793,
&quot;careerBB&quot;: 1387 
},
{
 &quot;playerID&quot;: &quot;ruffire01&quot;,
&quot;fullname&quot;: &quot;Red Ruffing&quot;,
&quot;year&quot;: 1941,
&quot;careerWIN&quot;: 244,
&quot;careerHR&quot;: 233,
&quot;careerSO&quot;: 1853,
&quot;careerBB&quot;: 1441 
},
{
 &quot;playerID&quot;: &quot;ruffire01&quot;,
&quot;fullname&quot;: &quot;Red Ruffing&quot;,
&quot;year&quot;: 1942,
&quot;careerWIN&quot;: 258,
&quot;careerHR&quot;: 243,
&quot;careerSO&quot;: 1933,
&quot;careerBB&quot;: 1482 
},
{
 &quot;playerID&quot;: &quot;ruffire01&quot;,
&quot;fullname&quot;: &quot;Red Ruffing&quot;,
&quot;year&quot;: 1945,
&quot;careerWIN&quot;: 265,
&quot;careerHR&quot;: 245,
&quot;careerSO&quot;: 1957,
&quot;careerBB&quot;: 1502 
},
{
 &quot;playerID&quot;: &quot;ruffire01&quot;,
&quot;fullname&quot;: &quot;Red Ruffing&quot;,
&quot;year&quot;: 1946,
&quot;careerWIN&quot;: 270,
&quot;careerHR&quot;: 247,
&quot;careerSO&quot;: 1976,
&quot;careerBB&quot;: 1525 
},
{
 &quot;playerID&quot;: &quot;ruffire01&quot;,
&quot;fullname&quot;: &quot;Red Ruffing&quot;,
&quot;year&quot;: 1947,
&quot;careerWIN&quot;: 273,
&quot;careerHR&quot;: 254,
&quot;careerSO&quot;: 1987,
&quot;careerBB&quot;: 1541 
},
{
 &quot;playerID&quot;: &quot;ryanno01&quot;,
&quot;fullname&quot;: &quot;Nolan Ryan&quot;,
&quot;year&quot;: 1966,
&quot;careerWIN&quot;: 0,
&quot;careerHR&quot;: 1,
&quot;careerSO&quot;: 6,
&quot;careerBB&quot;: 3 
},
{
 &quot;playerID&quot;: &quot;ryanno01&quot;,
&quot;fullname&quot;: &quot;Nolan Ryan&quot;,
&quot;year&quot;: 1968,
&quot;careerWIN&quot;: 6,
&quot;careerHR&quot;: 13,
&quot;careerSO&quot;: 139,
&quot;careerBB&quot;: 78 
},
{
 &quot;playerID&quot;: &quot;ryanno01&quot;,
&quot;fullname&quot;: &quot;Nolan Ryan&quot;,
&quot;year&quot;: 1969,
&quot;careerWIN&quot;: 12,
&quot;careerHR&quot;: 16,
&quot;careerSO&quot;: 231,
&quot;careerBB&quot;: 131 
},
{
 &quot;playerID&quot;: &quot;ryanno01&quot;,
&quot;fullname&quot;: &quot;Nolan Ryan&quot;,
&quot;year&quot;: 1970,
&quot;careerWIN&quot;: 19,
&quot;careerHR&quot;: 26,
&quot;careerSO&quot;: 356,
&quot;careerBB&quot;: 228 
},
{
 &quot;playerID&quot;: &quot;ryanno01&quot;,
&quot;fullname&quot;: &quot;Nolan Ryan&quot;,
&quot;year&quot;: 1971,
&quot;careerWIN&quot;: 29,
&quot;careerHR&quot;: 34,
&quot;careerSO&quot;: 493,
&quot;careerBB&quot;: 344 
},
{
 &quot;playerID&quot;: &quot;ryanno01&quot;,
&quot;fullname&quot;: &quot;Nolan Ryan&quot;,
&quot;year&quot;: 1972,
&quot;careerWIN&quot;: 48,
&quot;careerHR&quot;: 48,
&quot;careerSO&quot;: 822,
&quot;careerBB&quot;: 501 
},
{
 &quot;playerID&quot;: &quot;ryanno01&quot;,
&quot;fullname&quot;: &quot;Nolan Ryan&quot;,
&quot;year&quot;: 1973,
&quot;careerWIN&quot;: 69,
&quot;careerHR&quot;: 66,
&quot;careerSO&quot;: 1205,
&quot;careerBB&quot;: 663 
},
{
 &quot;playerID&quot;: &quot;ryanno01&quot;,
&quot;fullname&quot;: &quot;Nolan Ryan&quot;,
&quot;year&quot;: 1974,
&quot;careerWIN&quot;: 91,
&quot;careerHR&quot;: 84,
&quot;careerSO&quot;: 1572,
&quot;careerBB&quot;: 865 
},
{
 &quot;playerID&quot;: &quot;ryanno01&quot;,
&quot;fullname&quot;: &quot;Nolan Ryan&quot;,
&quot;year&quot;: 1975,
&quot;careerWIN&quot;: 105,
&quot;careerHR&quot;: 97,
&quot;careerSO&quot;: 1758,
&quot;careerBB&quot;: 997 
},
{
 &quot;playerID&quot;: &quot;ryanno01&quot;,
&quot;fullname&quot;: &quot;Nolan Ryan&quot;,
&quot;year&quot;: 1976,
&quot;careerWIN&quot;: 122,
&quot;careerHR&quot;: 110,
&quot;careerSO&quot;: 2085,
&quot;careerBB&quot;: 1180 
},
{
 &quot;playerID&quot;: &quot;ryanno01&quot;,
&quot;fullname&quot;: &quot;Nolan Ryan&quot;,
&quot;year&quot;: 1977,
&quot;careerWIN&quot;: 141,
&quot;careerHR&quot;: 122,
&quot;careerSO&quot;: 2426,
&quot;careerBB&quot;: 1384 
},
{
 &quot;playerID&quot;: &quot;ryanno01&quot;,
&quot;fullname&quot;: &quot;Nolan Ryan&quot;,
&quot;year&quot;: 1978,
&quot;careerWIN&quot;: 151,
&quot;careerHR&quot;: 134,
&quot;careerSO&quot;: 2686,
&quot;careerBB&quot;: 1532 
},
{
 &quot;playerID&quot;: &quot;ryanno01&quot;,
&quot;fullname&quot;: &quot;Nolan Ryan&quot;,
&quot;year&quot;: 1979,
&quot;careerWIN&quot;: 167,
&quot;careerHR&quot;: 149,
&quot;careerSO&quot;: 2909,
&quot;careerBB&quot;: 1646 
},
{
 &quot;playerID&quot;: &quot;ryanno01&quot;,
&quot;fullname&quot;: &quot;Nolan Ryan&quot;,
&quot;year&quot;: 1980,
&quot;careerWIN&quot;: 178,
&quot;careerHR&quot;: 159,
&quot;careerSO&quot;: 3109,
&quot;careerBB&quot;: 1744 
},
{
 &quot;playerID&quot;: &quot;ryanno01&quot;,
&quot;fullname&quot;: &quot;Nolan Ryan&quot;,
&quot;year&quot;: 1981,
&quot;careerWIN&quot;: 189,
&quot;careerHR&quot;: 161,
&quot;careerSO&quot;: 3249,
&quot;careerBB&quot;: 1812 
},
{
 &quot;playerID&quot;: &quot;ryanno01&quot;,
&quot;fullname&quot;: &quot;Nolan Ryan&quot;,
&quot;year&quot;: 1982,
&quot;careerWIN&quot;: 205,
&quot;careerHR&quot;: 181,
&quot;careerSO&quot;: 3494,
&quot;careerBB&quot;: 1921 
},
{
 &quot;playerID&quot;: &quot;ryanno01&quot;,
&quot;fullname&quot;: &quot;Nolan Ryan&quot;,
&quot;year&quot;: 1983,
&quot;careerWIN&quot;: 219,
&quot;careerHR&quot;: 190,
&quot;careerSO&quot;: 3677,
&quot;careerBB&quot;: 2022 
},
{
 &quot;playerID&quot;: &quot;ryanno01&quot;,
&quot;fullname&quot;: &quot;Nolan Ryan&quot;,
&quot;year&quot;: 1984,
&quot;careerWIN&quot;: 231,
&quot;careerHR&quot;: 202,
&quot;careerSO&quot;: 3874,
&quot;careerBB&quot;: 2091 
},
{
 &quot;playerID&quot;: &quot;ryanno01&quot;,
&quot;fullname&quot;: &quot;Nolan Ryan&quot;,
&quot;year&quot;: 1985,
&quot;careerWIN&quot;: 241,
&quot;careerHR&quot;: 214,
&quot;careerSO&quot;: 4083,
&quot;careerBB&quot;: 2186 
},
{
 &quot;playerID&quot;: &quot;ryanno01&quot;,
&quot;fullname&quot;: &quot;Nolan Ryan&quot;,
&quot;year&quot;: 1986,
&quot;careerWIN&quot;: 253,
&quot;careerHR&quot;: 228,
&quot;careerSO&quot;: 4277,
&quot;careerBB&quot;: 2268 
},
{
 &quot;playerID&quot;: &quot;ryanno01&quot;,
&quot;fullname&quot;: &quot;Nolan Ryan&quot;,
&quot;year&quot;: 1987,
&quot;careerWIN&quot;: 261,
&quot;careerHR&quot;: 242,
&quot;careerSO&quot;: 4547,
&quot;careerBB&quot;: 2355 
},
{
 &quot;playerID&quot;: &quot;ryanno01&quot;,
&quot;fullname&quot;: &quot;Nolan Ryan&quot;,
&quot;year&quot;: 1988,
&quot;careerWIN&quot;: 273,
&quot;careerHR&quot;: 260,
&quot;careerSO&quot;: 4775,
&quot;careerBB&quot;: 2442 
},
{
 &quot;playerID&quot;: &quot;ryanno01&quot;,
&quot;fullname&quot;: &quot;Nolan Ryan&quot;,
&quot;year&quot;: 1989,
&quot;careerWIN&quot;: 289,
&quot;careerHR&quot;: 277,
&quot;careerSO&quot;: 5076,
&quot;careerBB&quot;: 2540 
},
{
 &quot;playerID&quot;: &quot;ryanno01&quot;,
&quot;fullname&quot;: &quot;Nolan Ryan&quot;,
&quot;year&quot;: 1990,
&quot;careerWIN&quot;: 302,
&quot;careerHR&quot;: 295,
&quot;careerSO&quot;: 5308,
&quot;careerBB&quot;: 2614 
},
{
 &quot;playerID&quot;: &quot;ryanno01&quot;,
&quot;fullname&quot;: &quot;Nolan Ryan&quot;,
&quot;year&quot;: 1991,
&quot;careerWIN&quot;: 314,
&quot;careerHR&quot;: 307,
&quot;careerSO&quot;: 5511,
&quot;careerBB&quot;: 2686 
},
{
 &quot;playerID&quot;: &quot;ryanno01&quot;,
&quot;fullname&quot;: &quot;Nolan Ryan&quot;,
&quot;year&quot;: 1992,
&quot;careerWIN&quot;: 319,
&quot;careerHR&quot;: 316,
&quot;careerSO&quot;: 5668,
&quot;careerBB&quot;: 2755 
},
{
 &quot;playerID&quot;: &quot;ryanno01&quot;,
&quot;fullname&quot;: &quot;Nolan Ryan&quot;,
&quot;year&quot;: 1993,
&quot;careerWIN&quot;: 324,
&quot;careerHR&quot;: 321,
&quot;careerSO&quot;: 5714,
&quot;careerBB&quot;: 2795 
},
{
 &quot;playerID&quot;: &quot;seaveto01&quot;,
&quot;fullname&quot;: &quot;Tom Seaver&quot;,
&quot;year&quot;: 1967,
&quot;careerWIN&quot;: 16,
&quot;careerHR&quot;: 19,
&quot;careerSO&quot;: 170,
&quot;careerBB&quot;: 78 
},
{
 &quot;playerID&quot;: &quot;seaveto01&quot;,
&quot;fullname&quot;: &quot;Tom Seaver&quot;,
&quot;year&quot;: 1968,
&quot;careerWIN&quot;: 32,
&quot;careerHR&quot;: 34,
&quot;careerSO&quot;: 375,
&quot;careerBB&quot;: 126 
},
{
 &quot;playerID&quot;: &quot;seaveto01&quot;,
&quot;fullname&quot;: &quot;Tom Seaver&quot;,
&quot;year&quot;: 1969,
&quot;careerWIN&quot;: 57,
&quot;careerHR&quot;: 58,
&quot;careerSO&quot;: 583,
&quot;careerBB&quot;: 208 
},
{
 &quot;playerID&quot;: &quot;seaveto01&quot;,
&quot;fullname&quot;: &quot;Tom Seaver&quot;,
&quot;year&quot;: 1970,
&quot;careerWIN&quot;: 75,
&quot;careerHR&quot;: 79,
&quot;careerSO&quot;: 866,
&quot;careerBB&quot;: 291 
},
{
 &quot;playerID&quot;: &quot;seaveto01&quot;,
&quot;fullname&quot;: &quot;Tom Seaver&quot;,
&quot;year&quot;: 1971,
&quot;careerWIN&quot;: 95,
&quot;careerHR&quot;: 97,
&quot;careerSO&quot;: 1155,
&quot;careerBB&quot;: 352 
},
{
 &quot;playerID&quot;: &quot;seaveto01&quot;,
&quot;fullname&quot;: &quot;Tom Seaver&quot;,
&quot;year&quot;: 1972,
&quot;careerWIN&quot;: 116,
&quot;careerHR&quot;: 120,
&quot;careerSO&quot;: 1404,
&quot;careerBB&quot;: 429 
},
{
 &quot;playerID&quot;: &quot;seaveto01&quot;,
&quot;fullname&quot;: &quot;Tom Seaver&quot;,
&quot;year&quot;: 1973,
&quot;careerWIN&quot;: 135,
&quot;careerHR&quot;: 143,
&quot;careerSO&quot;: 1655,
&quot;careerBB&quot;: 493 
},
{
 &quot;playerID&quot;: &quot;seaveto01&quot;,
&quot;fullname&quot;: &quot;Tom Seaver&quot;,
&quot;year&quot;: 1974,
&quot;careerWIN&quot;: 146,
&quot;careerHR&quot;: 162,
&quot;careerSO&quot;: 1856,
&quot;careerBB&quot;: 568 
},
{
 &quot;playerID&quot;: &quot;seaveto01&quot;,
&quot;fullname&quot;: &quot;Tom Seaver&quot;,
&quot;year&quot;: 1975,
&quot;careerWIN&quot;: 168,
&quot;careerHR&quot;: 173,
&quot;careerSO&quot;: 2099,
&quot;careerBB&quot;: 656 
},
{
 &quot;playerID&quot;: &quot;seaveto01&quot;,
&quot;fullname&quot;: &quot;Tom Seaver&quot;,
&quot;year&quot;: 1976,
&quot;careerWIN&quot;: 182,
&quot;careerHR&quot;: 187,
&quot;careerSO&quot;: 2334,
&quot;careerBB&quot;: 733 
},
{
 &quot;playerID&quot;: &quot;seaveto01&quot;,
&quot;fullname&quot;: &quot;Tom Seaver&quot;,
&quot;year&quot;: 1977,
&quot;careerWIN&quot;: 203,
&quot;careerHR&quot;: 206,
&quot;careerSO&quot;: 2530,
&quot;careerBB&quot;: 799 
},
{
 &quot;playerID&quot;: &quot;seaveto01&quot;,
&quot;fullname&quot;: &quot;Tom Seaver&quot;,
&quot;year&quot;: 1978,
&quot;careerWIN&quot;: 219,
&quot;careerHR&quot;: 232,
&quot;careerSO&quot;: 2756,
&quot;careerBB&quot;: 888 
},
{
 &quot;playerID&quot;: &quot;seaveto01&quot;,
&quot;fullname&quot;: &quot;Tom Seaver&quot;,
&quot;year&quot;: 1979,
&quot;careerWIN&quot;: 235,
&quot;careerHR&quot;: 248,
&quot;careerSO&quot;: 2887,
&quot;careerBB&quot;: 949 
},
{
 &quot;playerID&quot;: &quot;seaveto01&quot;,
&quot;fullname&quot;: &quot;Tom Seaver&quot;,
&quot;year&quot;: 1980,
&quot;careerWIN&quot;: 245,
&quot;careerHR&quot;: 272,
&quot;careerSO&quot;: 2988,
&quot;careerBB&quot;: 1008 
},
{
 &quot;playerID&quot;: &quot;seaveto01&quot;,
&quot;fullname&quot;: &quot;Tom Seaver&quot;,
&quot;year&quot;: 1981,
&quot;careerWIN&quot;: 259,
&quot;careerHR&quot;: 282,
&quot;careerSO&quot;: 3075,
&quot;careerBB&quot;: 1074 
},
{
 &quot;playerID&quot;: &quot;seaveto01&quot;,
&quot;fullname&quot;: &quot;Tom Seaver&quot;,
&quot;year&quot;: 1982,
&quot;careerWIN&quot;: 264,
&quot;careerHR&quot;: 296,
&quot;careerSO&quot;: 3137,
&quot;careerBB&quot;: 1118 
},
{
 &quot;playerID&quot;: &quot;seaveto01&quot;,
&quot;fullname&quot;: &quot;Tom Seaver&quot;,
&quot;year&quot;: 1983,
&quot;careerWIN&quot;: 273,
&quot;careerHR&quot;: 314,
&quot;careerSO&quot;: 3272,
&quot;careerBB&quot;: 1204 
},
{
 &quot;playerID&quot;: &quot;seaveto01&quot;,
&quot;fullname&quot;: &quot;Tom Seaver&quot;,
&quot;year&quot;: 1984,
&quot;careerWIN&quot;: 288,
&quot;careerHR&quot;: 341,
&quot;careerSO&quot;: 3403,
&quot;careerBB&quot;: 1265 
},
{
 &quot;playerID&quot;: &quot;seaveto01&quot;,
&quot;fullname&quot;: &quot;Tom Seaver&quot;,
&quot;year&quot;: 1985,
&quot;careerWIN&quot;: 304,
&quot;careerHR&quot;: 363,
&quot;careerSO&quot;: 3537,
&quot;careerBB&quot;: 1334 
},
{
 &quot;playerID&quot;: &quot;seaveto01&quot;,
&quot;fullname&quot;: &quot;Tom Seaver&quot;,
&quot;year&quot;: 1986,
&quot;careerWIN&quot;: 311,
&quot;careerHR&quot;: 380,
&quot;careerSO&quot;: 3640,
&quot;careerBB&quot;: 1390 
},
{
 &quot;playerID&quot;: &quot;spahnwa01&quot;,
&quot;fullname&quot;: &quot;Warren Spahn&quot;,
&quot;year&quot;: 1942,
&quot;careerWIN&quot;: 0,
&quot;careerHR&quot;: 0,
&quot;careerSO&quot;: 7,
&quot;careerBB&quot;: 11 
},
{
 &quot;playerID&quot;: &quot;spahnwa01&quot;,
&quot;fullname&quot;: &quot;Warren Spahn&quot;,
&quot;year&quot;: 1946,
&quot;careerWIN&quot;: 8,
&quot;careerHR&quot;: 6,
&quot;careerSO&quot;: 74,
&quot;careerBB&quot;: 47 
},
{
 &quot;playerID&quot;: &quot;spahnwa01&quot;,
&quot;fullname&quot;: &quot;Warren Spahn&quot;,
&quot;year&quot;: 1947,
&quot;careerWIN&quot;: 29,
&quot;careerHR&quot;: 21,
&quot;careerSO&quot;: 197,
&quot;careerBB&quot;: 131 
},
{
 &quot;playerID&quot;: &quot;spahnwa01&quot;,
&quot;fullname&quot;: &quot;Warren Spahn&quot;,
&quot;year&quot;: 1948,
&quot;careerWIN&quot;: 44,
&quot;careerHR&quot;: 40,
&quot;careerSO&quot;: 311,
&quot;careerBB&quot;: 208 
},
{
 &quot;playerID&quot;: &quot;spahnwa01&quot;,
&quot;fullname&quot;: &quot;Warren Spahn&quot;,
&quot;year&quot;: 1949,
&quot;careerWIN&quot;: 65,
&quot;careerHR&quot;: 67,
&quot;careerSO&quot;: 462,
&quot;careerBB&quot;: 294 
},
{
 &quot;playerID&quot;: &quot;spahnwa01&quot;,
&quot;fullname&quot;: &quot;Warren Spahn&quot;,
&quot;year&quot;: 1950,
&quot;careerWIN&quot;: 86,
&quot;careerHR&quot;: 89,
&quot;careerSO&quot;: 653,
&quot;careerBB&quot;: 405 
},
{
 &quot;playerID&quot;: &quot;spahnwa01&quot;,
&quot;fullname&quot;: &quot;Warren Spahn&quot;,
&quot;year&quot;: 1951,
&quot;careerWIN&quot;: 108,
&quot;careerHR&quot;: 109,
&quot;careerSO&quot;: 817,
&quot;careerBB&quot;: 514 
},
{
 &quot;playerID&quot;: &quot;spahnwa01&quot;,
&quot;fullname&quot;: &quot;Warren Spahn&quot;,
&quot;year&quot;: 1952,
&quot;careerWIN&quot;: 122,
&quot;careerHR&quot;: 128,
&quot;careerSO&quot;: 1000,
&quot;careerBB&quot;: 587 
},
{
 &quot;playerID&quot;: &quot;spahnwa01&quot;,
&quot;fullname&quot;: &quot;Warren Spahn&quot;,
&quot;year&quot;: 1953,
&quot;careerWIN&quot;: 145,
&quot;careerHR&quot;: 142,
&quot;careerSO&quot;: 1148,
&quot;careerBB&quot;: 657 
},
{
 &quot;playerID&quot;: &quot;spahnwa01&quot;,
&quot;fullname&quot;: &quot;Warren Spahn&quot;,
&quot;year&quot;: 1954,
&quot;careerWIN&quot;: 166,
&quot;careerHR&quot;: 166,
&quot;careerSO&quot;: 1284,
&quot;careerBB&quot;: 743 
},
{
 &quot;playerID&quot;: &quot;spahnwa01&quot;,
&quot;fullname&quot;: &quot;Warren Spahn&quot;,
&quot;year&quot;: 1955,
&quot;careerWIN&quot;: 183,
&quot;careerHR&quot;: 191,
&quot;careerSO&quot;: 1394,
&quot;careerBB&quot;: 808 
},
{
 &quot;playerID&quot;: &quot;spahnwa01&quot;,
&quot;fullname&quot;: &quot;Warren Spahn&quot;,
&quot;year&quot;: 1956,
&quot;careerWIN&quot;: 203,
&quot;careerHR&quot;: 216,
&quot;careerSO&quot;: 1522,
&quot;careerBB&quot;: 860 
},
{
 &quot;playerID&quot;: &quot;spahnwa01&quot;,
&quot;fullname&quot;: &quot;Warren Spahn&quot;,
&quot;year&quot;: 1957,
&quot;careerWIN&quot;: 224,
&quot;careerHR&quot;: 239,
&quot;careerSO&quot;: 1633,
&quot;careerBB&quot;: 938 
},
{
 &quot;playerID&quot;: &quot;spahnwa01&quot;,
&quot;fullname&quot;: &quot;Warren Spahn&quot;,
&quot;year&quot;: 1958,
&quot;careerWIN&quot;: 246,
&quot;careerHR&quot;: 268,
&quot;careerSO&quot;: 1783,
&quot;careerBB&quot;: 1014 
},
{
 &quot;playerID&quot;: &quot;spahnwa01&quot;,
&quot;fullname&quot;: &quot;Warren Spahn&quot;,
&quot;year&quot;: 1959,
&quot;careerWIN&quot;: 267,
&quot;careerHR&quot;: 289,
&quot;careerSO&quot;: 1926,
&quot;careerBB&quot;: 1084 
},
{
 &quot;playerID&quot;: &quot;spahnwa01&quot;,
&quot;fullname&quot;: &quot;Warren Spahn&quot;,
&quot;year&quot;: 1960,
&quot;careerWIN&quot;: 288,
&quot;careerHR&quot;: 313,
&quot;careerSO&quot;: 2080,
&quot;careerBB&quot;: 1158 
},
{
 &quot;playerID&quot;: &quot;spahnwa01&quot;,
&quot;fullname&quot;: &quot;Warren Spahn&quot;,
&quot;year&quot;: 1961,
&quot;careerWIN&quot;: 309,
&quot;careerHR&quot;: 337,
&quot;careerSO&quot;: 2195,
&quot;careerBB&quot;: 1222 
},
{
 &quot;playerID&quot;: &quot;spahnwa01&quot;,
&quot;fullname&quot;: &quot;Warren Spahn&quot;,
&quot;year&quot;: 1962,
&quot;careerWIN&quot;: 327,
&quot;careerHR&quot;: 362,
&quot;careerSO&quot;: 2313,
&quot;careerBB&quot;: 1277 
},
{
 &quot;playerID&quot;: &quot;spahnwa01&quot;,
&quot;fullname&quot;: &quot;Warren Spahn&quot;,
&quot;year&quot;: 1963,
&quot;careerWIN&quot;: 350,
&quot;careerHR&quot;: 385,
&quot;careerSO&quot;: 2415,
&quot;careerBB&quot;: 1326 
},
{
 &quot;playerID&quot;: &quot;spahnwa01&quot;,
&quot;fullname&quot;: &quot;Warren Spahn&quot;,
&quot;year&quot;: 1964,
&quot;careerWIN&quot;: 356,
&quot;careerHR&quot;: 408,
&quot;careerSO&quot;: 2493,
&quot;careerBB&quot;: 1378 
},
{
 &quot;playerID&quot;: &quot;spahnwa01&quot;,
&quot;fullname&quot;: &quot;Warren Spahn&quot;,
&quot;year&quot;: 1965,
&quot;careerWIN&quot;: 363,
&quot;careerHR&quot;: 434,
&quot;careerSO&quot;: 2583,
&quot;careerBB&quot;: 1434 
},
{
 &quot;playerID&quot;: &quot;spaldal01&quot;,
&quot;fullname&quot;: &quot;Al Spalding&quot;,
&quot;year&quot;: 1871,
&quot;careerWIN&quot;: 19,
&quot;careerHR&quot;: 2,
&quot;careerSO&quot;: 23,
&quot;careerBB&quot;: 38 
},
{
 &quot;playerID&quot;: &quot;spaldal01&quot;,
&quot;fullname&quot;: &quot;Al Spalding&quot;,
&quot;year&quot;: 1872,
&quot;careerWIN&quot;: 57,
&quot;careerHR&quot;: 2,
&quot;careerSO&quot;: 50,
&quot;careerBB&quot;: 65 
},
{
 &quot;playerID&quot;: &quot;spaldal01&quot;,
&quot;fullname&quot;: &quot;Al Spalding&quot;,
&quot;year&quot;: 1873,
&quot;careerWIN&quot;: 98,
&quot;careerHR&quot;: 7,
&quot;careerSO&quot;: 81,
&quot;careerBB&quot;: 93 
},
{
 &quot;playerID&quot;: &quot;spaldal01&quot;,
&quot;fullname&quot;: &quot;Al Spalding&quot;,
&quot;year&quot;: 1874,
&quot;careerWIN&quot;: 150,
&quot;careerHR&quot;: 8,
&quot;careerSO&quot;: 92,
&quot;careerBB&quot;: 116 
},
{
 &quot;playerID&quot;: &quot;spaldal01&quot;,
&quot;fullname&quot;: &quot;Al Spalding&quot;,
&quot;year&quot;: 1875,
&quot;careerWIN&quot;: 205,
&quot;careerHR&quot;: 9,
&quot;careerSO&quot;: 101,
&quot;careerBB&quot;: 130 
},
{
 &quot;playerID&quot;: &quot;spaldal01&quot;,
&quot;fullname&quot;: &quot;Al Spalding&quot;,
&quot;year&quot;: 1876,
&quot;careerWIN&quot;: 252,
&quot;careerHR&quot;: 15,
&quot;careerSO&quot;: 140,
&quot;careerBB&quot;: 156 
},
{
 &quot;playerID&quot;: &quot;spaldal01&quot;,
&quot;fullname&quot;: &quot;Al Spalding&quot;,
&quot;year&quot;: 1877,
&quot;careerWIN&quot;: 253,
&quot;careerHR&quot;: 15,
&quot;careerSO&quot;: 142,
&quot;careerBB&quot;: 156 
},
{
 &quot;playerID&quot;: &quot;suttodo01&quot;,
&quot;fullname&quot;: &quot;Don Sutton&quot;,
&quot;year&quot;: 1966,
&quot;careerWIN&quot;: 12,
&quot;careerHR&quot;: 19,
&quot;careerSO&quot;: 209,
&quot;careerBB&quot;: 52 
},
{
 &quot;playerID&quot;: &quot;suttodo01&quot;,
&quot;fullname&quot;: &quot;Don Sutton&quot;,
&quot;year&quot;: 1967,
&quot;careerWIN&quot;: 23,
&quot;careerHR&quot;: 37,
&quot;careerSO&quot;: 378,
&quot;careerBB&quot;: 109 
},
{
 &quot;playerID&quot;: &quot;suttodo01&quot;,
&quot;fullname&quot;: &quot;Don Sutton&quot;,
&quot;year&quot;: 1968,
&quot;careerWIN&quot;: 34,
&quot;careerHR&quot;: 43,
&quot;careerSO&quot;: 540,
&quot;careerBB&quot;: 168 
},
{
 &quot;playerID&quot;: &quot;suttodo01&quot;,
&quot;fullname&quot;: &quot;Don Sutton&quot;,
&quot;year&quot;: 1969,
&quot;careerWIN&quot;: 51,
&quot;careerHR&quot;: 68,
&quot;careerSO&quot;: 757,
&quot;careerBB&quot;: 259 
},
{
 &quot;playerID&quot;: &quot;suttodo01&quot;,
&quot;fullname&quot;: &quot;Don Sutton&quot;,
&quot;year&quot;: 1970,
&quot;careerWIN&quot;: 66,
&quot;careerHR&quot;: 106,
&quot;careerSO&quot;: 958,
&quot;careerBB&quot;: 337 
},
{
 &quot;playerID&quot;: &quot;suttodo01&quot;,
&quot;fullname&quot;: &quot;Don Sutton&quot;,
&quot;year&quot;: 1971,
&quot;careerWIN&quot;: 83,
&quot;careerHR&quot;: 116,
&quot;careerSO&quot;: 1152,
&quot;careerBB&quot;: 392 
},
{
 &quot;playerID&quot;: &quot;suttodo01&quot;,
&quot;fullname&quot;: &quot;Don Sutton&quot;,
&quot;year&quot;: 1972,
&quot;careerWIN&quot;: 102,
&quot;careerHR&quot;: 129,
&quot;careerSO&quot;: 1359,
&quot;careerBB&quot;: 455 
},
{
 &quot;playerID&quot;: &quot;suttodo01&quot;,
&quot;fullname&quot;: &quot;Don Sutton&quot;,
&quot;year&quot;: 1973,
&quot;careerWIN&quot;: 120,
&quot;careerHR&quot;: 147,
&quot;careerSO&quot;: 1559,
&quot;careerBB&quot;: 511 
},
{
 &quot;playerID&quot;: &quot;suttodo01&quot;,
&quot;fullname&quot;: &quot;Don Sutton&quot;,
&quot;year&quot;: 1974,
&quot;careerWIN&quot;: 139,
&quot;careerHR&quot;: 170,
&quot;careerSO&quot;: 1738,
&quot;careerBB&quot;: 591 
},
{
 &quot;playerID&quot;: &quot;suttodo01&quot;,
&quot;fullname&quot;: &quot;Don Sutton&quot;,
&quot;year&quot;: 1975,
&quot;careerWIN&quot;: 155,
&quot;careerHR&quot;: 187,
&quot;careerSO&quot;: 1913,
&quot;careerBB&quot;: 653 
},
{
 &quot;playerID&quot;: &quot;suttodo01&quot;,
&quot;fullname&quot;: &quot;Don Sutton&quot;,
&quot;year&quot;: 1976,
&quot;careerWIN&quot;: 176,
&quot;careerHR&quot;: 209,
&quot;careerSO&quot;: 2074,
&quot;careerBB&quot;: 735 
},
{
 &quot;playerID&quot;: &quot;suttodo01&quot;,
&quot;fullname&quot;: &quot;Don Sutton&quot;,
&quot;year&quot;: 1977,
&quot;careerWIN&quot;: 190,
&quot;careerHR&quot;: 232,
&quot;careerSO&quot;: 2224,
&quot;careerBB&quot;: 804 
},
{
 &quot;playerID&quot;: &quot;suttodo01&quot;,
&quot;fullname&quot;: &quot;Don Sutton&quot;,
&quot;year&quot;: 1978,
&quot;careerWIN&quot;: 205,
&quot;careerHR&quot;: 261,
&quot;careerSO&quot;: 2378,
&quot;careerBB&quot;: 858 
},
{
 &quot;playerID&quot;: &quot;suttodo01&quot;,
&quot;fullname&quot;: &quot;Don Sutton&quot;,
&quot;year&quot;: 1979,
&quot;careerWIN&quot;: 217,
&quot;careerHR&quot;: 282,
&quot;careerSO&quot;: 2524,
&quot;careerBB&quot;: 919 
},
{
 &quot;playerID&quot;: &quot;suttodo01&quot;,
&quot;fullname&quot;: &quot;Don Sutton&quot;,
&quot;year&quot;: 1980,
&quot;careerWIN&quot;: 230,
&quot;careerHR&quot;: 302,
&quot;careerSO&quot;: 2652,
&quot;careerBB&quot;: 966 
},
{
 &quot;playerID&quot;: &quot;suttodo01&quot;,
&quot;fullname&quot;: &quot;Don Sutton&quot;,
&quot;year&quot;: 1981,
&quot;careerWIN&quot;: 241,
&quot;careerHR&quot;: 308,
&quot;careerSO&quot;: 2756,
&quot;careerBB&quot;: 995 
},
{
 &quot;playerID&quot;: &quot;suttodo01&quot;,
&quot;fullname&quot;: &quot;Don Sutton&quot;,
&quot;year&quot;: 1982,
&quot;careerWIN&quot;: 258,
&quot;careerHR&quot;: 326,
&quot;careerSO&quot;: 2931,
&quot;careerBB&quot;: 1059 
},
{
 &quot;playerID&quot;: &quot;suttodo01&quot;,
&quot;fullname&quot;: &quot;Don Sutton&quot;,
&quot;year&quot;: 1983,
&quot;careerWIN&quot;: 266,
&quot;careerHR&quot;: 347,
&quot;careerSO&quot;: 3065,
&quot;careerBB&quot;: 1113 
},
{
 &quot;playerID&quot;: &quot;suttodo01&quot;,
&quot;fullname&quot;: &quot;Don Sutton&quot;,
&quot;year&quot;: 1984,
&quot;careerWIN&quot;: 280,
&quot;careerHR&quot;: 371,
&quot;careerSO&quot;: 3208,
&quot;careerBB&quot;: 1164 
},
{
 &quot;playerID&quot;: &quot;suttodo01&quot;,
&quot;fullname&quot;: &quot;Don Sutton&quot;,
&quot;year&quot;: 1985,
&quot;careerWIN&quot;: 295,
&quot;careerHR&quot;: 396,
&quot;careerSO&quot;: 3315,
&quot;careerBB&quot;: 1223 
},
{
 &quot;playerID&quot;: &quot;suttodo01&quot;,
&quot;fullname&quot;: &quot;Don Sutton&quot;,
&quot;year&quot;: 1986,
&quot;careerWIN&quot;: 310,
&quot;careerHR&quot;: 427,
&quot;careerSO&quot;: 3431,
&quot;careerBB&quot;: 1272 
},
{
 &quot;playerID&quot;: &quot;suttodo01&quot;,
&quot;fullname&quot;: &quot;Don Sutton&quot;,
&quot;year&quot;: 1987,
&quot;careerWIN&quot;: 321,
&quot;careerHR&quot;: 465,
&quot;careerSO&quot;: 3530,
&quot;careerBB&quot;: 1313 
},
{
 &quot;playerID&quot;: &quot;suttodo01&quot;,
&quot;fullname&quot;: &quot;Don Sutton&quot;,
&quot;year&quot;: 1988,
&quot;careerWIN&quot;: 324,
&quot;careerHR&quot;: 472,
&quot;careerSO&quot;: 3574,
&quot;careerBB&quot;: 1343 
},
{
 &quot;playerID&quot;: &quot;welchmi01&quot;,
&quot;fullname&quot;: &quot;Mickey Welch&quot;,
&quot;year&quot;: 1880,
&quot;careerWIN&quot;: 34,
&quot;careerHR&quot;: 7,
&quot;careerSO&quot;: 123,
&quot;careerBB&quot;: 80 
},
{
 &quot;playerID&quot;: &quot;welchmi01&quot;,
&quot;fullname&quot;: &quot;Mickey Welch&quot;,
&quot;year&quot;: 1881,
&quot;careerWIN&quot;: 55,
&quot;careerHR&quot;: 14,
&quot;careerSO&quot;: 227,
&quot;careerBB&quot;: 158 
},
{
 &quot;playerID&quot;: &quot;welchmi01&quot;,
&quot;fullname&quot;: &quot;Mickey Welch&quot;,
&quot;year&quot;: 1882,
&quot;careerWIN&quot;: 69,
&quot;careerHR&quot;: 21,
&quot;careerSO&quot;: 280,
&quot;careerBB&quot;: 220 
},
{
 &quot;playerID&quot;: &quot;welchmi01&quot;,
&quot;fullname&quot;: &quot;Mickey Welch&quot;,
&quot;year&quot;: 1883,
&quot;careerWIN&quot;: 94,
&quot;careerHR&quot;: 32,
&quot;careerSO&quot;: 424,
&quot;careerBB&quot;: 286 
},
{
 &quot;playerID&quot;: &quot;welchmi01&quot;,
&quot;fullname&quot;: &quot;Mickey Welch&quot;,
&quot;year&quot;: 1884,
&quot;careerWIN&quot;: 133,
&quot;careerHR&quot;: 44,
&quot;careerSO&quot;: 769,
&quot;careerBB&quot;: 432 
},
{
 &quot;playerID&quot;: &quot;welchmi01&quot;,
&quot;fullname&quot;: &quot;Mickey Welch&quot;,
&quot;year&quot;: 1885,
&quot;careerWIN&quot;: 177,
&quot;careerHR&quot;: 48,
&quot;careerSO&quot;: 1027,
&quot;careerBB&quot;: 563 
},
{
 &quot;playerID&quot;: &quot;welchmi01&quot;,
&quot;fullname&quot;: &quot;Mickey Welch&quot;,
&quot;year&quot;: 1886,
&quot;careerWIN&quot;: 210,
&quot;careerHR&quot;: 61,
&quot;careerSO&quot;: 1299,
&quot;careerBB&quot;: 726 
},
{
 &quot;playerID&quot;: &quot;welchmi01&quot;,
&quot;fullname&quot;: &quot;Mickey Welch&quot;,
&quot;year&quot;: 1887,
&quot;careerWIN&quot;: 232,
&quot;careerHR&quot;: 68,
&quot;careerSO&quot;: 1414,
&quot;careerBB&quot;: 817 
},
{
 &quot;playerID&quot;: &quot;welchmi01&quot;,
&quot;fullname&quot;: &quot;Mickey Welch&quot;,
&quot;year&quot;: 1888,
&quot;careerWIN&quot;: 258,
&quot;careerHR&quot;: 80,
&quot;careerSO&quot;: 1581,
&quot;careerBB&quot;: 925 
},
{
 &quot;playerID&quot;: &quot;welchmi01&quot;,
&quot;fullname&quot;: &quot;Mickey Welch&quot;,
&quot;year&quot;: 1889,
&quot;careerWIN&quot;: 285,
&quot;careerHR&quot;: 94,
&quot;careerSO&quot;: 1706,
&quot;careerBB&quot;: 1074 
},
{
 &quot;playerID&quot;: &quot;welchmi01&quot;,
&quot;fullname&quot;: &quot;Mickey Welch&quot;,
&quot;year&quot;: 1890,
&quot;careerWIN&quot;: 302,
&quot;careerHR&quot;: 99,
&quot;careerSO&quot;: 1803,
&quot;careerBB&quot;: 1196 
},
{
 &quot;playerID&quot;: &quot;welchmi01&quot;,
&quot;fullname&quot;: &quot;Mickey Welch&quot;,
&quot;year&quot;: 1891,
&quot;careerWIN&quot;: 307,
&quot;careerHR&quot;: 106,
&quot;careerSO&quot;: 1849,
&quot;careerBB&quot;: 1293 
},
{
 &quot;playerID&quot;: &quot;welchmi01&quot;,
&quot;fullname&quot;: &quot;Mickey Welch&quot;,
&quot;year&quot;: 1892,
&quot;careerWIN&quot;: 307,
&quot;careerHR&quot;: 106,
&quot;careerSO&quot;: 1850,
&quot;careerBB&quot;: 1297 
},
{
 &quot;playerID&quot;: &quot;weyhigu01&quot;,
&quot;fullname&quot;: &quot;Gus Weyhing&quot;,
&quot;year&quot;: 1887,
&quot;careerWIN&quot;: 26,
&quot;careerHR&quot;: 12,
&quot;careerSO&quot;: 193,
&quot;careerBB&quot;: 167 
},
{
 &quot;playerID&quot;: &quot;weyhigu01&quot;,
&quot;fullname&quot;: &quot;Gus Weyhing&quot;,
&quot;year&quot;: 1888,
&quot;careerWIN&quot;: 54,
&quot;careerHR&quot;: 16,
&quot;careerSO&quot;: 397,
&quot;careerBB&quot;: 278 
},
{
 &quot;playerID&quot;: &quot;weyhigu01&quot;,
&quot;fullname&quot;: &quot;Gus Weyhing&quot;,
&quot;year&quot;: 1889,
&quot;careerWIN&quot;: 84,
&quot;careerHR&quot;: 31,
&quot;careerSO&quot;: 610,
&quot;careerBB&quot;: 490 
},
{
 &quot;playerID&quot;: &quot;weyhigu01&quot;,
&quot;fullname&quot;: &quot;Gus Weyhing&quot;,
&quot;year&quot;: 1890,
&quot;careerWIN&quot;: 114,
&quot;careerHR&quot;: 41,
&quot;careerSO&quot;: 787,
&quot;careerBB&quot;: 669 
},
{
 &quot;playerID&quot;: &quot;weyhigu01&quot;,
&quot;fullname&quot;: &quot;Gus Weyhing&quot;,
&quot;year&quot;: 1891,
&quot;careerWIN&quot;: 145,
&quot;careerHR&quot;: 53,
&quot;careerSO&quot;: 1006,
&quot;careerBB&quot;: 830 
},
{
 &quot;playerID&quot;: &quot;weyhigu01&quot;,
&quot;fullname&quot;: &quot;Gus Weyhing&quot;,
&quot;year&quot;: 1892,
&quot;careerWIN&quot;: 177,
&quot;careerHR&quot;: 62,
&quot;careerSO&quot;: 1208,
&quot;careerBB&quot;: 998 
},
{
 &quot;playerID&quot;: &quot;weyhigu01&quot;,
&quot;fullname&quot;: &quot;Gus Weyhing&quot;,
&quot;year&quot;: 1893,
&quot;careerWIN&quot;: 200,
&quot;careerHR&quot;: 72,
&quot;careerSO&quot;: 1309,
&quot;careerBB&quot;: 1143 
},
{
 &quot;playerID&quot;: &quot;weyhigu01&quot;,
&quot;fullname&quot;: &quot;Gus Weyhing&quot;,
&quot;year&quot;: 1894,
&quot;careerWIN&quot;: 216,
&quot;careerHR&quot;: 84,
&quot;careerSO&quot;: 1390,
&quot;careerBB&quot;: 1259 
},
{
 &quot;playerID&quot;: &quot;weyhigu01&quot;,
&quot;fullname&quot;: &quot;Gus Weyhing&quot;,
&quot;year&quot;: 1895,
&quot;careerWIN&quot;: 224,
&quot;careerHR&quot;: 93,
&quot;careerSO&quot;: 1451,
&quot;careerBB&quot;: 1343 
},
{
 &quot;playerID&quot;: &quot;weyhigu01&quot;,
&quot;fullname&quot;: &quot;Gus Weyhing&quot;,
&quot;year&quot;: 1896,
&quot;careerWIN&quot;: 226,
&quot;careerHR&quot;: 99,
&quot;careerSO&quot;: 1460,
&quot;careerBB&quot;: 1358 
},
{
 &quot;playerID&quot;: &quot;weyhigu01&quot;,
&quot;fullname&quot;: &quot;Gus Weyhing&quot;,
&quot;year&quot;: 1898,
&quot;careerWIN&quot;: 241,
&quot;careerHR&quot;: 109,
&quot;careerSO&quot;: 1552,
&quot;careerBB&quot;: 1442 
},
{
 &quot;playerID&quot;: &quot;weyhigu01&quot;,
&quot;fullname&quot;: &quot;Gus Weyhing&quot;,
&quot;year&quot;: 1899,
&quot;careerWIN&quot;: 258,
&quot;careerHR&quot;: 117,
&quot;careerSO&quot;: 1648,
&quot;careerBB&quot;: 1518 
},
{
 &quot;playerID&quot;: &quot;weyhigu01&quot;,
&quot;fullname&quot;: &quot;Gus Weyhing&quot;,
&quot;year&quot;: 1900,
&quot;careerWIN&quot;: 264,
&quot;careerHR&quot;: 120,
&quot;careerSO&quot;: 1662,
&quot;careerBB&quot;: 1559 
},
{
 &quot;playerID&quot;: &quot;weyhigu01&quot;,
&quot;fullname&quot;: &quot;Gus Weyhing&quot;,
&quot;year&quot;: 1901,
&quot;careerWIN&quot;: 264,
&quot;careerHR&quot;: 120,
&quot;careerSO&quot;: 1665,
&quot;careerBB&quot;: 1566 
},
{
 &quot;playerID&quot;: &quot;wynnea01&quot;,
&quot;fullname&quot;: &quot;Early Wynn&quot;,
&quot;year&quot;: 1939,
&quot;careerWIN&quot;: 0,
&quot;careerHR&quot;: 0,
&quot;careerSO&quot;: 1,
&quot;careerBB&quot;: 10 
},
{
 &quot;playerID&quot;: &quot;wynnea01&quot;,
&quot;fullname&quot;: &quot;Early Wynn&quot;,
&quot;year&quot;: 1941,
&quot;careerWIN&quot;: 3,
&quot;careerHR&quot;: 1,
&quot;careerSO&quot;: 16,
&quot;careerBB&quot;: 20 
},
{
 &quot;playerID&quot;: &quot;wynnea01&quot;,
&quot;fullname&quot;: &quot;Early Wynn&quot;,
&quot;year&quot;: 1942,
&quot;careerWIN&quot;: 13,
&quot;careerHR&quot;: 7,
&quot;careerSO&quot;: 74,
&quot;careerBB&quot;: 93 
},
{
 &quot;playerID&quot;: &quot;wynnea01&quot;,
&quot;fullname&quot;: &quot;Early Wynn&quot;,
&quot;year&quot;: 1943,
&quot;careerWIN&quot;: 31,
&quot;careerHR&quot;: 22,
&quot;careerSO&quot;: 163,
&quot;careerBB&quot;: 176 
},
{
 &quot;playerID&quot;: &quot;wynnea01&quot;,
&quot;fullname&quot;: &quot;Early Wynn&quot;,
&quot;year&quot;: 1944,
&quot;careerWIN&quot;: 39,
&quot;careerHR&quot;: 25,
&quot;careerSO&quot;: 228,
&quot;careerBB&quot;: 243 
},
{
 &quot;playerID&quot;: &quot;wynnea01&quot;,
&quot;fullname&quot;: &quot;Early Wynn&quot;,
&quot;year&quot;: 1946,
&quot;careerWIN&quot;: 47,
&quot;careerHR&quot;: 33,
&quot;careerSO&quot;: 264,
&quot;careerBB&quot;: 276 
},
{
 &quot;playerID&quot;: &quot;wynnea01&quot;,
&quot;fullname&quot;: &quot;Early Wynn&quot;,
&quot;year&quot;: 1947,
&quot;careerWIN&quot;: 64,
&quot;careerHR&quot;: 46,
&quot;careerSO&quot;: 337,
&quot;careerBB&quot;: 366 
},
{
 &quot;playerID&quot;: &quot;wynnea01&quot;,
&quot;fullname&quot;: &quot;Early Wynn&quot;,
&quot;year&quot;: 1948,
&quot;careerWIN&quot;: 72,
&quot;careerHR&quot;: 64,
&quot;careerSO&quot;: 386,
&quot;careerBB&quot;: 460 
},
{
 &quot;playerID&quot;: &quot;wynnea01&quot;,
&quot;fullname&quot;: &quot;Early Wynn&quot;,
&quot;year&quot;: 1949,
&quot;careerWIN&quot;: 83,
&quot;careerHR&quot;: 72,
&quot;careerSO&quot;: 448,
&quot;careerBB&quot;: 517 
},
{
 &quot;playerID&quot;: &quot;wynnea01&quot;,
&quot;fullname&quot;: &quot;Early Wynn&quot;,
&quot;year&quot;: 1950,
&quot;careerWIN&quot;: 101,
&quot;careerHR&quot;: 92,
&quot;careerSO&quot;: 591,
&quot;careerBB&quot;: 618 
},
{
 &quot;playerID&quot;: &quot;wynnea01&quot;,
&quot;fullname&quot;: &quot;Early Wynn&quot;,
&quot;year&quot;: 1951,
&quot;careerWIN&quot;: 121,
&quot;careerHR&quot;: 110,
&quot;careerSO&quot;: 724,
&quot;careerBB&quot;: 725 
},
{
 &quot;playerID&quot;: &quot;wynnea01&quot;,
&quot;fullname&quot;: &quot;Early Wynn&quot;,
&quot;year&quot;: 1952,
&quot;careerWIN&quot;: 144,
&quot;careerHR&quot;: 133,
&quot;careerSO&quot;: 877,
&quot;careerBB&quot;: 857 
},
{
 &quot;playerID&quot;: &quot;wynnea01&quot;,
&quot;fullname&quot;: &quot;Early Wynn&quot;,
&quot;year&quot;: 1953,
&quot;careerWIN&quot;: 161,
&quot;careerHR&quot;: 152,
&quot;careerSO&quot;: 1015,
&quot;careerBB&quot;: 964 
},
{
 &quot;playerID&quot;: &quot;wynnea01&quot;,
&quot;fullname&quot;: &quot;Early Wynn&quot;,
&quot;year&quot;: 1954,
&quot;careerWIN&quot;: 184,
&quot;careerHR&quot;: 173,
&quot;careerSO&quot;: 1170,
&quot;careerBB&quot;: 1047 
},
{
 &quot;playerID&quot;: &quot;wynnea01&quot;,
&quot;fullname&quot;: &quot;Early Wynn&quot;,
&quot;year&quot;: 1955,
&quot;careerWIN&quot;: 201,
&quot;careerHR&quot;: 192,
&quot;careerSO&quot;: 1292,
&quot;careerBB&quot;: 1127 
},
{
 &quot;playerID&quot;: &quot;wynnea01&quot;,
&quot;fullname&quot;: &quot;Early Wynn&quot;,
&quot;year&quot;: 1956,
&quot;careerWIN&quot;: 221,
&quot;careerHR&quot;: 211,
&quot;careerSO&quot;: 1450,
&quot;careerBB&quot;: 1218 
},
{
 &quot;playerID&quot;: &quot;wynnea01&quot;,
&quot;fullname&quot;: &quot;Early Wynn&quot;,
&quot;year&quot;: 1957,
&quot;careerWIN&quot;: 235,
&quot;careerHR&quot;: 243,
&quot;careerSO&quot;: 1634,
&quot;careerBB&quot;: 1322 
},
{
 &quot;playerID&quot;: &quot;wynnea01&quot;,
&quot;fullname&quot;: &quot;Early Wynn&quot;,
&quot;year&quot;: 1958,
&quot;careerWIN&quot;: 249,
&quot;careerHR&quot;: 270,
&quot;careerSO&quot;: 1813,
&quot;careerBB&quot;: 1426 
},
{
 &quot;playerID&quot;: &quot;wynnea01&quot;,
&quot;fullname&quot;: &quot;Early Wynn&quot;,
&quot;year&quot;: 1959,
&quot;careerWIN&quot;: 271,
&quot;careerHR&quot;: 290,
&quot;careerSO&quot;: 1992,
&quot;careerBB&quot;: 1545 
},
{
 &quot;playerID&quot;: &quot;wynnea01&quot;,
&quot;fullname&quot;: &quot;Early Wynn&quot;,
&quot;year&quot;: 1960,
&quot;careerWIN&quot;: 284,
&quot;careerHR&quot;: 310,
&quot;careerSO&quot;: 2150,
&quot;careerBB&quot;: 1657 
},
{
 &quot;playerID&quot;: &quot;wynnea01&quot;,
&quot;fullname&quot;: &quot;Early Wynn&quot;,
&quot;year&quot;: 1961,
&quot;careerWIN&quot;: 292,
&quot;careerHR&quot;: 321,
&quot;careerSO&quot;: 2214,
&quot;careerBB&quot;: 1704 
},
{
 &quot;playerID&quot;: &quot;wynnea01&quot;,
&quot;fullname&quot;: &quot;Early Wynn&quot;,
&quot;year&quot;: 1962,
&quot;careerWIN&quot;: 299,
&quot;careerHR&quot;: 336,
&quot;careerSO&quot;: 2305,
&quot;careerBB&quot;: 1760 
},
{
 &quot;playerID&quot;: &quot;wynnea01&quot;,
&quot;fullname&quot;: &quot;Early Wynn&quot;,
&quot;year&quot;: 1963,
&quot;careerWIN&quot;: 300,
&quot;careerHR&quot;: 338,
&quot;careerSO&quot;: 2334,
&quot;careerBB&quot;: 1775 
},
{
 &quot;playerID&quot;: &quot;youngcy01&quot;,
&quot;fullname&quot;: &quot;Cy Young&quot;,
&quot;year&quot;: 1890,
&quot;careerWIN&quot;: 9,
&quot;careerHR&quot;: 6,
&quot;careerSO&quot;: 39,
&quot;careerBB&quot;: 30 
},
{
 &quot;playerID&quot;: &quot;youngcy01&quot;,
&quot;fullname&quot;: &quot;Cy Young&quot;,
&quot;year&quot;: 1891,
&quot;careerWIN&quot;: 36,
&quot;careerHR&quot;: 10,
&quot;careerSO&quot;: 186,
&quot;careerBB&quot;: 170 
},
{
 &quot;playerID&quot;: &quot;youngcy01&quot;,
&quot;fullname&quot;: &quot;Cy Young&quot;,
&quot;year&quot;: 1892,
&quot;careerWIN&quot;: 72,
&quot;careerHR&quot;: 18,
&quot;careerSO&quot;: 354,
&quot;careerBB&quot;: 288 
},
{
 &quot;playerID&quot;: &quot;youngcy01&quot;,
&quot;fullname&quot;: &quot;Cy Young&quot;,
&quot;year&quot;: 1893,
&quot;careerWIN&quot;: 106,
&quot;careerHR&quot;: 28,
&quot;careerSO&quot;: 456,
&quot;careerBB&quot;: 391 
},
{
 &quot;playerID&quot;: &quot;youngcy01&quot;,
&quot;fullname&quot;: &quot;Cy Young&quot;,
&quot;year&quot;: 1894,
&quot;careerWIN&quot;: 132,
&quot;careerHR&quot;: 47,
&quot;careerSO&quot;: 564,
&quot;careerBB&quot;: 497 
},
{
 &quot;playerID&quot;: &quot;youngcy01&quot;,
&quot;fullname&quot;: &quot;Cy Young&quot;,
&quot;year&quot;: 1895,
&quot;careerWIN&quot;: 167,
&quot;careerHR&quot;: 57,
&quot;careerSO&quot;: 685,
&quot;careerBB&quot;: 572 
},
{
 &quot;playerID&quot;: &quot;youngcy01&quot;,
&quot;fullname&quot;: &quot;Cy Young&quot;,
&quot;year&quot;: 1896,
&quot;careerWIN&quot;: 195,
&quot;careerHR&quot;: 64,
&quot;careerSO&quot;: 825,
&quot;careerBB&quot;: 634 
},
{
 &quot;playerID&quot;: &quot;youngcy01&quot;,
&quot;fullname&quot;: &quot;Cy Young&quot;,
&quot;year&quot;: 1897,
&quot;careerWIN&quot;: 216,
&quot;careerHR&quot;: 71,
&quot;careerSO&quot;: 913,
&quot;careerBB&quot;: 683 
},
{
 &quot;playerID&quot;: &quot;youngcy01&quot;,
&quot;fullname&quot;: &quot;Cy Young&quot;,
&quot;year&quot;: 1898,
&quot;careerWIN&quot;: 241,
&quot;careerHR&quot;: 77,
&quot;careerSO&quot;: 1014,
&quot;careerBB&quot;: 724 
},
{
 &quot;playerID&quot;: &quot;youngcy01&quot;,
&quot;fullname&quot;: &quot;Cy Young&quot;,
&quot;year&quot;: 1899,
&quot;careerWIN&quot;: 267,
&quot;careerHR&quot;: 87,
&quot;careerSO&quot;: 1125,
&quot;careerBB&quot;: 768 
},
{
 &quot;playerID&quot;: &quot;youngcy01&quot;,
&quot;fullname&quot;: &quot;Cy Young&quot;,
&quot;year&quot;: 1900,
&quot;careerWIN&quot;: 286,
&quot;careerHR&quot;: 94,
&quot;careerSO&quot;: 1240,
&quot;careerBB&quot;: 804 
},
{
 &quot;playerID&quot;: &quot;youngcy01&quot;,
&quot;fullname&quot;: &quot;Cy Young&quot;,
&quot;year&quot;: 1901,
&quot;careerWIN&quot;: 319,
&quot;careerHR&quot;: 100,
&quot;careerSO&quot;: 1398,
&quot;careerBB&quot;: 841 
},
{
 &quot;playerID&quot;: &quot;youngcy01&quot;,
&quot;fullname&quot;: &quot;Cy Young&quot;,
&quot;year&quot;: 1902,
&quot;careerWIN&quot;: 351,
&quot;careerHR&quot;: 106,
&quot;careerSO&quot;: 1558,
&quot;careerBB&quot;: 894 
},
{
 &quot;playerID&quot;: &quot;youngcy01&quot;,
&quot;fullname&quot;: &quot;Cy Young&quot;,
&quot;year&quot;: 1903,
&quot;careerWIN&quot;: 379,
&quot;careerHR&quot;: 112,
&quot;careerSO&quot;: 1734,
&quot;careerBB&quot;: 931 
},
{
 &quot;playerID&quot;: &quot;youngcy01&quot;,
&quot;fullname&quot;: &quot;Cy Young&quot;,
&quot;year&quot;: 1904,
&quot;careerWIN&quot;: 405,
&quot;careerHR&quot;: 118,
&quot;careerSO&quot;: 1934,
&quot;careerBB&quot;: 960 
},
{
 &quot;playerID&quot;: &quot;youngcy01&quot;,
&quot;fullname&quot;: &quot;Cy Young&quot;,
&quot;year&quot;: 1905,
&quot;careerWIN&quot;: 423,
&quot;careerHR&quot;: 121,
&quot;careerSO&quot;: 2144,
&quot;careerBB&quot;: 990 
},
{
 &quot;playerID&quot;: &quot;youngcy01&quot;,
&quot;fullname&quot;: &quot;Cy Young&quot;,
&quot;year&quot;: 1906,
&quot;careerWIN&quot;: 436,
&quot;careerHR&quot;: 124,
&quot;careerSO&quot;: 2284,
&quot;careerBB&quot;: 1015 
},
{
 &quot;playerID&quot;: &quot;youngcy01&quot;,
&quot;fullname&quot;: &quot;Cy Young&quot;,
&quot;year&quot;: 1907,
&quot;careerWIN&quot;: 457,
&quot;careerHR&quot;: 127,
&quot;careerSO&quot;: 2431,
&quot;careerBB&quot;: 1066 
},
{
 &quot;playerID&quot;: &quot;youngcy01&quot;,
&quot;fullname&quot;: &quot;Cy Young&quot;,
&quot;year&quot;: 1908,
&quot;careerWIN&quot;: 478,
&quot;careerHR&quot;: 128,
&quot;careerSO&quot;: 2581,
&quot;careerBB&quot;: 1103 
},
{
 &quot;playerID&quot;: &quot;youngcy01&quot;,
&quot;fullname&quot;: &quot;Cy Young&quot;,
&quot;year&quot;: 1909,
&quot;careerWIN&quot;: 497,
&quot;careerHR&quot;: 132,
&quot;careerSO&quot;: 2690,
&quot;careerBB&quot;: 1162 
},
{
 &quot;playerID&quot;: &quot;youngcy01&quot;,
&quot;fullname&quot;: &quot;Cy Young&quot;,
&quot;year&quot;: 1910,
&quot;careerWIN&quot;: 504,
&quot;careerHR&quot;: 132,
&quot;careerSO&quot;: 2748,
&quot;careerBB&quot;: 1189 
},
{
 &quot;playerID&quot;: &quot;youngcy01&quot;,
&quot;fullname&quot;: &quot;Cy Young&quot;,
&quot;year&quot;: 1911,
&quot;careerWIN&quot;: 511,
&quot;careerHR&quot;: 138,
&quot;careerSO&quot;: 2803,
&quot;careerBB&quot;: 1217 
} 
]
  
      if(!(opts.type===&quot;pieChart&quot; || opts.type===&quot;sparklinePlus&quot;)) {
        var data = d3.nest()
          .key(function(d){
            //return opts.group === undefined ? &#039;main&#039; : d[opts.group]
            //instead of main would think a better default is opts.x
            return opts.group === undefined ? opts.y : d[opts.group];
          })
          .entries(data);
      }
      
      if (opts.disabled != undefined){
        data.map(function(d, i){
          d.disabled = opts.disabled[i]
        })
      }
      
      nv.addGraph(function() {
        var chart = nv.models[opts.type]()
          .x(function(d) { return d[opts.x] })
          .y(function(d) { return d[opts.y] })
          .width(opts.width)
          .height(opts.height)
         
        
          
        

        
        
        
      
       d3.select(&quot;#&quot; + opts.id)
        .append(&#039;svg&#039;)
        .datum(data)
        .transition().duration(500)
        .call(chart);

       nv.utils.windowResize(chart.update);
       return chart;
      });
    };
&lt;/script&gt;
    
  &lt;/body&gt;
&lt;/html&gt;
' scrolling='no' seamless class='rChart 
nvd3
 '
id=iframe-
chart91833840063d
></iframe>
<style>iframe.rChart{ width: 100%; height: 400px;}</style>


