#!/bin/bash



while true ; do

  echo -n "$(date +"%T.%3N") - "

  curl -s https://techspot.cloud/deployment | tee -a curl.output ;

  echo >> curl.output

  percentage=$(bc -l <<<$(tail -20 curl.output | grep -c 'blue')/20*100 | sed -n 's#\([0-9]*\.[0-9][0-9]\).*#\1#p')

  echo " - precentage: " ${percentage}

done


