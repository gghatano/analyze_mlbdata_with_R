## Introduction

Download the data of batting result of MLB from retrosheet.org and transform to CSV file for easy handling.

Raw retrosheet-data is difficult to handle. 
By using the parsing software: cwevent, well-featured .csv data is generated. 
To obtain this software, download it through the following website:
http://chadwick.sourceforge.net/doc/index.html, 
or untar chadwick-0.6.3.tar.gz in this directory.

### How to use

#### 1. Build the parsing software: cwevent.

Execute the following commands.

```bash
tar -zxvf chadwick-0.6.3.tar.gz
cd chadwick-0.6.3
./configure
make
sudo make install 
```

#### 2. Download the data of specified season 

Execute the download_battingdata.sh with the year as the argument.

Ex. If you want to get the 2010 data, execute the following command:

```bash
# chmod u+x download_battingdata
./download_battingdata.sh 2010
``` 
※ if the command does not work, please check the "Notes" section. 

The output "all2010.csv" includes all the batting results of 2010 MLB season.

#### 3. Set the Colnames

If you execute the command above, you can obtain all2010.csv, which include
the data table about all the event in all the game in MLB 2010 season.

The meaning of the column is shown in names.csv. 
When you use the data, please combine names.csv and all2010.csv. 
The following is the example code of R.

```r
library(data.table)
data = fread("all2010.csv")
names = fread("names.csv", header = FALSE)

setnames(data, unlist(names))
```


#### 4. How to Analyze
The explanation of the data-table is shown in the following web site:
http://chadwick.sourceforge.net/doc/cwevent.html

Some example of analysis are published in the blog site: 

http://gg-hogehoge.hatenablog.com/entry/2013/12/16/002254

In this case, I calculate the scoring rate in the "super-chance" with R.
By using the all2013.csv and extracting the situation that runners on the third base with 0 or 1 out, 
the situation which I call "super chance" because the team can get score easily.

--------------------------------------------------------------


### ※Notes

Make sure that /usr/local/lib is in your LD_LIBRARY_PATH

Precisely how you do this depends on your shell,

First, check whether the LD_LIBRARY_PATH is not set (it usually isn't these days):

```bash
echo $LD_LIBRARY_PATH
```

If it is unset and you're running bash then:

```bash
export LD_LIBRARY_PATH=/usr/local/lib
```

reference:
http://sourceforge.net/p/chadwick/mailman/chadwick-users/
