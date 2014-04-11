url1="http://www.retrosheet.org/events/"
year=$1
url2="eve.zip"
url_ful=$url1$year$url2

wget $url_ful

unzip $year"eve.zip"

csv_name="all"$year".csv"
touch $csv_name

cw_option=" -y "$year" -f 0-96 "$year"*.EV*"  
echo $cw_option

cwevent $cw_option > $csv_name

rm *$year".ROS"
rm $year*".EV"*
rm "TEAM"*
rm $year"eve.zip"
