##
## will copy the gl/data (mbtiles junk) over to servers
##
BDIR=`dirname $0`
. $BDIR/bolt-base.sh
. $BDIR/../base.sh


# step 1: loop thru machines
for m in $MACHINES
do
  echo "restarting gl tileserver on $m"

  # step 2: nuke the existing GL stuff
  bolt command run "update.sh; cd $OMT_DIR; ./scripts/nuke.sh ALL" --targets $m

  # step 3: restart GL
  bolt command run "cd $OMT_DIR/gl; run-nohup.sh" --targets $m
done
