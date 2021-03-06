##
## will copy the gl/data (mbtiles junk) over to servers
##
BDIR=`dirname $0`
. $BDIR/bolt-base.sh
. $BDIR/../base.sh


# step 1: validate *.mbtiles ... proper size, etc...
size=`ls -ltr $MBTILES_PATH | awk -F" " '{ print $5 }'`
if [[ $size -gt 10000000 ]]
then
  for m in $MACHINES
  do
    echo "copying $MBTILES_PATH over to $m"

    # step 2: backup existing data dir 
    bolt command run "update.sh; cd $OMT_DIR; ./scripts/backup_mbtiles.sh" --targets $m

    # step 3: scp copy data dir to server
    scp -r $GL_DATA_DIR $m:$GL_DATA_DIR
  done
else
  echo "$MBTILES_PATH is too small at $size to copy over to $m"
fi
