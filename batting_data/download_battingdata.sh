### download_battingdata.sh

# make urls
url1="http://www.retrosheet.org/events/"
year=$1
url2="eve.zip"

url_ful=$url1$year$url2

# download the raw data from retrosheet.org
wget $url_ful

# unzip
unzip $year"eve.zip"

# make the datafile.csv
csv_name="all"$year".csv"
touch $csv_name

# parse and transform the raw data by using cwevent
cw_option=" -y "$year" -f 0-96 "$year"*.EV*"  
echo $cw_option
cwevent $cw_option > $csv_name

# removing the needless data
rm *$year".ROS"
rm $year*".EV"*
rm "TEAM"*
rm $year"eve.zip"
