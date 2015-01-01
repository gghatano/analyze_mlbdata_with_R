年俸データ確認
===

[年俸データ](https://github.com/gghatano/analyze_mlbdata_with_R/tree/master/scraped_data/salary/salary.txt)作ってみました. 

```r
library(dplyr)
library(data.table)
```

ランキング作ります. 

```r
dat = fread("salary.txt")
dat %>% setnames(c("TEAM", "YEAR", "NUMBER", "NAME", "SALARY"))
dat = dat %>% mutate(SALARY = as.integer(SALARY))
head(dat)
```

```
##        TEAM YEAR NUMBER     NAME SALARY
## 1: baystars 2006     11   山口俊    870
## 2: baystars 2006     12 吉川輝昭   1350
## 3: baystars 2006     13 那須野巧   1300
## 4: baystars 2006     15 高宮和也   1500
## 5: baystars 2006     16 川村丈夫   7700
## 6: baystars 2006     17 加藤武治   5500
```

## 個人年俸ランキング

```r
dat %>% arrange(desc(SALARY)) %>% head(10)
```

```
##         TEAM YEAR NUMBER       NAME SALARY
##  1:   giants 2003     13 ペタジーニ  72000
##  2:   giants 2004     13 ペタジーニ  72000
##  3:   giants 2007     33     李承燁  65000
##  4: yokohama 2005     22 佐々木主浩  65000
##  5:   giants 2002     55   松井秀喜  61000
##  6:  dragons 2007     44   T.ウッズ  60000
##  7:  dragons 2008     44   T.ウッズ  60000
##  8:   giants 2008     33     李承燁  60000
##  9:   giants 2009     33     李承燁  60000
## 10:   giants 2010     33     李承燁  60000
```


## 生涯年俸ランキング

```r
dat %>% 
  group_by(NAME) %>% 
  dplyr::summarise(SALARY = sum(SALARY)) %>% 
  arrange(desc(SALARY)) %>% head(20)
```

```
##          NAME SALARY
## 1    金本知憲 470240
## 2    清原和博 445880
## 3    岩瀬仁紀 440500
## 4  小笠原道大 436600
## 5    高橋由伸 385100
## 6    松中信彦 362405
## 7    工藤公康 352160
## 8  阿部慎之助 343400
## 9    和田一浩 334230
## 10   谷繁元信 308590
## 11   カブレラ 308000
## 12   三浦大輔 301950
## 13     李承燁 301000
## 14   城島健司 300750
## 15   前田智徳 294140
## 16   杉内俊哉 281300
## 17   古田敦也 272920
## 18   西口文也 270720
## 19   立浪和義 268800
## 20     江藤智 256440
```

## チーム年俸総額ランキング

```r
dat %>%
  group_by(TEAM, YEAR) %>%
  dplyr::summarise(SALARY = sum(SALARY)) %>% 
  group_by(add=FALSE) %>% 
  arrange(desc(SALARY)) %>% head(20)
```

```
##       TEAM YEAR SALARY
## 1   giants 2010 488725
## 2   giants 2009 456140
## 3   giants 2003 449880
## 4   giants 2001 437194
## 5   giants 2007 423326
## 6   giants 2014 416875
## 7   giants 2006 408130
## 8   giants 2002 406172
## 9   tigers 2009 395860
## 10  giants 2013 395630
## 11 dragons 2007 395390
## 12  giants 2000 384542
## 13 dragons 2005 379980
## 14  giants 2011 375300
## 15  tigers 2007 371190
## 16   hawks 2011 368530
## 17  giants 2012 367440
## 18   hawks 2005 364550
## 19 dragons 2011 343245
## 20 dragons 2012 337810
```

## 感想
巨人やべえ

