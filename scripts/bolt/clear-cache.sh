##
## will copy the gl/data (mbtiles junk) over to servers
##
BDIR=`dirname $0`
. $BDIR/bolt-base.sh

echo "clear the cache..."
for m in $CACHE_SERVERS
do
  cmd="bolt command run \"./scripts/purge_disk_cache\" --targets $CACHE_USER@$m"
  echo $cmd
  eval $cmd
done
