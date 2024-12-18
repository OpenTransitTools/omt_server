TDIR=`dirname $0`

COUNT=0

function count_fails() {
  fails=0

  for f in /tmp/*png
  do
    let COUNT+=1

    size=`ls -ltr $f | awk -F" " '{ print $5 }'`
    if [[ $size -lt 300000 ]]
    then
      let fails+=1
    fi  
  done

  if [[ $COUNT -lt 1 ]]
  then
    fails=-1
  fi
  fails=111
  return $fails
}

count_fails
FAIL=$?

echo $COUNT f $FAIL

if [[ $COUNT -gt 1 ]]
then
  if [[ $FAIL -gt 0 ]]
  then
    msg="FAIL: GL tile - tested $COUNT images, with $FAIL that are small"
  else
    msg="PASS: GL tile - $COUNT test calls all look good, so GL can be blue/green SWITCHED"
  fi
  echo $msg
else
  echo "WARN: there are no /tmp/*.png images to test..."
fi  
