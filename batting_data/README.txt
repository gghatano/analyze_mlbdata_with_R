

### Introduction

Download the data of batting result of MLB from retrosheet.org and transform to CSV file for easy handling.

Raw retrosheet-data is difficult to handle. 
By using the parsing software: cwevent, 
well-featured .csv data is generated. 
This software can be obtained from the following website.
http://chadwick.sourceforge.net/doc/index.html


### How to use

1. Build the parsing software.

----------------------------------------
tar -xvf chadwick-0.6.3.tar.gz
cd chadwick-0.6.3
./configure
make
make install 
----------------------------------------


2. Download the data of specified season 

Execute the download_battingdata passing the year you want to analyze as the argument.

Ex. if you want to get the 2010 data, execute the following command:
----------------------------------------
./download_battingdata 2010
----------------------------------------

The output all2010.csv include all the batting result of 2010 MLB season.

3. How to Analyze
The expanation of the table is shown in the following web site:
http://chadwick.sourceforge.net/doc/cwevent.html

Some example of analysis was published in the blog site: 

http://gg-hogehoge.hatenablog.com/entry/2013/12/16/002254

In this case, I calculate the scoring rate in the "super-chance" with R.
By using the all2013.csv and extracting the situation that runners on the third base with 0 or 1 out, 
the situation which I call "super chance" because the team can get score easily.



