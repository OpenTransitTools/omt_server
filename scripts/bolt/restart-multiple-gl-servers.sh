##
## will copy the gl/data (mbtiles junk) over to servers
##
BDIR=`dirname $0`
. $BDIR/bolt-base.sh
. $BDIR/../base.sh


# step 1: loop thru machines
RE_STARTING=$MACHINES
RE_STARTING=$PRODUCTION
RE_STARTING=$STAGING

echo "restarting GL on these machines: $RE_STARTING"
for m in $RE_STARTING
do
  $BDIR/restart-gl.sh $m
done
