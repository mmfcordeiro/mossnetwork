#!/bin/sh

for OUTPUT in $(find ../ -name index.html | grep "2017" )
do
	nodes=`cat $OUTPUT | grep "HREF\|ALIGN" | grep -v How | sed -e 's/<[^>]*>//g' | sed -e 's/([^)]*)//g' | awk 'NR%3{printf $0 " ";next;}1' | tr -s ' ' | sed -e 's/\/ / /g' | grep 1718 | awk '{print $1 " " $3 " " $2 " " $3;}' | sed 's/ / |/2' | tr '|' '\n' | awk '{a[$1]+=$2}END{for (i in a){print i,a[i]}}' | sort -n -r -k2 | awk '{print "    {\"id\": \"" $1 "\", \"total\":" $2 "},"}'`
 	edges=`cat $OUTPUT | grep "HREF\|ALIGN" | grep -v How | sed -e 's/<[^a>/!][^ >][^>]*>//g;s/<\/[^a  >][^>]*>//g' -e 's/<A HREF="/ /g' -e 's/">/ /g' | awk 'NR%3{printf $0 " ";next;}1' | tr -s ' ' | sed -e 's/\/ / /g' | awk '{print "{\"source\": \"" $2 "\", \"target\" : \"" $5 "\", \"value\": " $7 ", \"url\": \""$1"\", \"sp\": \""$3"\" , \"tp\": \""$6"\" },";}' | grep 1718`

 	header="{ \"nodes\": ["
 	data1=`echo $nodes | sed 's/.$//'` 	
  	middle="],\"links\": ["
 	data2=`echo $edges | sed 's/.$//'`
 	footer="] }"

 	echo $header$data1$middle$data2$footer > `echo $OUTPUT | sed 's/index.html/index.json/'` 	

done
