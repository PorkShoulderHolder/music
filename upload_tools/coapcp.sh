file_contents=$(cat $2)   
data=$3:::$file_contents
echo "$data" | coap post coap://$1:3000/v1/f/cp  

