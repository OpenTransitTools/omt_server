##
## will copy the gl/data (mbtiles junk) over to servers
##
BDIR=`dirname $0`
. $BDIR/bolt-base.sh
. $BDIR/../base.sh

size=`ls -ltr $MBTILES_PATH | awk -F" " '{ print $5 }'`
if [[ $size -gt 10000000 ]]
then
  $BDIR/copy-mbtiles.sh $*
  $BDIR/restart-gl.sh $*
  sleep 15
  $BDIR/test-mbtiles.sh $*
else
  echo "$MBTILES_PATH is too small at $size to copy over to $m"
fi
