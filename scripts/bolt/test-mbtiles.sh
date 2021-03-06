##
## will copy the gl/data (mbtiles junk) over to servers
##
BDIR=`dirname $0`
. $BDIR/bolt-base.sh
. $BDIR/../base.sh

# step 0: clear out tmp
rm -rf /tmp/* > /dev/null 2>&1 


function curl_test() {
  cmd="curl $1 > /tmp/$2"
  echo $cmd
  eval $cmd > /dev/null 2>&1

  size=`ls -ltr /tmp/$2 | awk -F" " '{ print $5 }'`
  if [[ $size -gt 300000 ]]
  then
    echo "/tmp/$2 looks GOOD at size $size"
  else
    echo "/tmp/$2 seems SMALL at $size" 
  fi
}


# step 1: loop thru machines
for m in $MACHINES
do
  echo "testing GL on $m"

  # step 2: backup existing data dir 
  TM_MAP_URL="http://$m:8080/styles/trimet/13/1304/2930@6x.png"
  TM_SAT_URL="http://$m:8080/styles/trimet-satellite/16/10435/23440@6x.png"

  # step 3: scp copy data dir to server
  curl_test $TM_MAP_URL $m-map.png
  curl_test $TM_SAT_URL $m-sat.png

  echo ""
done
