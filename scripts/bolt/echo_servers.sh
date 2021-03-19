##
## will copy the gl/data (mbtiles junk) over to servers
##
BDIR=`dirname $0`
. $BDIR/bolt-base.sh

echo "these are the target servers:"
for m in $MACHINES
do
  echo "  $m"
done

echo
echo "and these are the http/apache/cache servers: $CACHE_SERVERS"
echo
