#!/bin/sh
##################################

PROBE_MAC_FILE=/proc/mac_probe_info
POST_DATA_FILE=/tmp/.probe_post_data.txt
COUNT_FILE=/etc/.probe_post_data_counter
URL=""
CHECK_INTERVAL=10
DEVICE_ID=""

#
# 
#
get_date_to_post_data_file()
{
#  i=0
#  while [ $i -lt $1 ]
#  do
   echo "" > $POST_DATA_FILE
   time=$(date +'%Y-%m-%d %H:%M:%S')
   mact=$(cat $PROBE_MAC_FILE | grep -v 00:00:00:00:00:00 | awk '{print $1,$2" t"}')

   echo -e "${mact//t/$time}" >> $POST_DATA_FILE

#    sleep 1
#    i=$(($i +1))
#  done
}

set_device_id()
{
   DEVICE_ID=$(ifconfig|grep -e eth0|sed -n "1p"|awk '{print $NF}'|tr -d ":")
}

make_json_data()                                                       
{                                                                      
  tmp=/tmp/.probe_post_data.txt.tmp                                    
  cat $POST_DATA_FILE | tr -d "[" | tr -d "]" | awk  '!a[$2]++' | grep -v "^$" > $tmp 
  
  old=$(cat $COUNT_FILE)
  deta=$(cat $tmp | wc -l)
  new=$(($old+$deta))
  echo $new > $COUNT_FILE
  
  json_data="{\"id\":\"$DEVICE_ID\",\"count\":$new,\"data\":["                                                                               
  json_tmp=""                                                                                                                 
  json_tmp2=""                                                                                                                
  while read line;do json_tmp=$(echo $line | awk '{print  "{\"time\":\""$3,$4"\",\"rssi\":",$1",""\"mac\":","\""$2"\"},"}'); \
                     json_tmp2="$json_tmp2$json_tmp";json_tmp="";done < $tmp
 json_data="$json_data$json_tmp2"                                      
 json_data="${json_data%,}]}"                            
 rm -f $tmp                                              
 echo "$json_data"  > $POST_DATA_FILE                    
}                                                  
                                               
#                                              
# Parameter description                                                                                                       
# $(1) the url will be post data to                                                                                           
#                                                                                                                             
post_data_to_server()                                                       
{                                                                      
  curl --connetc-timeout 30 -m 30 -d "$(cat $POST_DATA_FILE)" $1   &> /dev/null                
#  echo "f3: $(cat $POST_DATA_FILE)"                                   
} 

get_url_and_checkInterval()                                                                                                   
{                                                                                                                             
  URL="$(uci get probe_data_post_conf.@post_conf[0].url)"                                                                     
  CHECK_INTERVAL=$(uci get probe_data_post_conf.@post_conf[0].checkInterval)                                                  
}                                                                                                                             
                                                                                                                              
#                                                                                                                             
# Parameter description                                                                                                       
# $(1) CheckInterval.                                                                                                         
# $(2) the url will be post data to                                                                                           
#                                                                                                                             
main_loop()                                                                                                                   
{                                                                                                                             
  echo "CheckInterval: $1"                                                  
  echo "TheUrl: $2" 
  if [ -z $1 ]                                                              
  then                                                                      
    echo "CheckInterval is NULL, Parameter ERROR! exit(1)"                  
    exit 1                                                
  fi                                                      
  if [ -z $2 ]                                            
  then                                                                                                                        
    echo "Url is NULL, Parameter ERROR! exit(2)"                                                                              
    exit 2                                                                                                                    
  fi
  while [ true ]                                                            
  do                                                                        
    get_date_to_post_data_file                                           
    make_json_data 
    post_data_to_server $2                                
    rm -rf  $POST_DATA_FILE
    sleep $1
  done                                                                                                                        
}                                                                                                                             

set_device_id
get_url_and_checkInterval                                                   
main_loop $CHECK_INTERVAL  $URL   

