DIR=`dirname $0`

COUNT=0
FAIL=0

for f in /tmp/*png
do
  let COUNT+=1

  size=`ls -ltr $f | awk -F" " '{ print $5 }'`
  if [[ $size -lt 300000 ]]
  then
    let FAIL+=1
  fi  

done

if [[ $COUNT -gt 1 ]]
then
  if [[ $FAIL -gt 0 ]]
  then
    msg="FAIL: GL tile - tested $COUNT images, with $FAIL that are small"
  else
    msg="PASS: GL tile - $COUNT test calls all look good, so GL can be blue/green SWITCHED"
  fi
  $DIR/chat_bot.sh "Tile Server Load\n- - -\n$msg"
else
  echo "WARN: there are no /tmp/*.png images to test..."
fi  
