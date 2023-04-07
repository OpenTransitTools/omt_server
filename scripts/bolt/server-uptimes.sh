##
## will copy the gl/data (mbtiles junk) over to servers
##
BDIR=`dirname $0`
. $BDIR/bolt-base.sh

echo "uptime of the GL servers (docker instances):"; echo; echo;
for s in $SERVERS
do
  echo "$s -> docker ps"
  echo "==========================="
  bolt command run "docker ps" --targets $s
  echo; echo;
done
echo
