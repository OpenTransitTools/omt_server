##
## will copy the gl/data (mbtiles junk) over to servers
##
BDIR=`dirname $0`
. $BDIR/bolt-base.sh

TEST=${1:-"1"}

echo "uptime of the GL servers (docker instances):"; echo; echo;
for s in $SERVERS
do
  echo "$s -> docker ps"
  echo "==========================="
  if [ $TEST != "test" ]; then
    bolt command run "docker ps" --targets $s
  fi
  if [ $TEST == 1 ] || [ $TEST == "TRUE" ] || [ $TEST == "test" ]; then
    $BDIR/test-gl.sh $s
  fi
  echo; echo;
done
echo
