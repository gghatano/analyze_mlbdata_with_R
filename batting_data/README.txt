### Introduction

Download the data of batting result of MLB from retrosheet.org and transform to CSV file for easy handling.

Raw retrosheet-data is difficult to handle. 
By using the parsing software: cwevent, 
well-featured .csv data is generated. 
To obtain this software, download it the following website:
http://chadwick.sourceforge.net/doc/index.html, 
or untar chadwick-0.6.3.tar.gz 

### How to use

1. Build the parsing software.

Execute the following commands.
----------------------------------------
tar -xvf chadwick-0.6.3.tar.gz
cd chadwick-0.6.3
./configure
make
make install 
----------------------------------------


2. Download the data of specified season 

Execute the download_battingdata.sh with the year as the argument.

Ex. If you want to get the 2010 data, execute the following command:

----------------------------------------
./download_battingdata.sh 2010
----------------------------------------

The output: all2010.csv includes all the batting results of 2010 MLB season.

3. How to Analyze
The explanation of the data-table is shown in the following web site:
http://chadwick.sourceforge.net/doc/cwevent.html

Some example of analysis are published in the blog site: 

http://gg-hogehoge.hatenablog.com/entry/2013/12/16/002254

In this case, I calculate the scoring rate in the "super-chance" with R.
By using the all2013.csv and extracting the situation that runners on the third base with 0 or 1 out, 
the situation which I call "super chance" because the team can get score easily.

