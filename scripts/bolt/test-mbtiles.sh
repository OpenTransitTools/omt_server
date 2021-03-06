##
## will copy the gl/data (mbtiles junk) over to servers
##
BDIR=`dirname $0`
. $BDIR/bolt-base.sh
. $BDIR/../base.sh


# step 1: loop thru machines
for m in $MACHINES
do
  echo "testing GL on $m"

  # step 2: backup existing data dir 
  TM_URL="http://$m:8080/styles/trimet/16/20873/46882@6x.jpg"
  TM_SAT_URL="http://$m:8080/styles/trimet-satellite/16/20873/46882@6x.jpg

  # step 3: scp copy data dir to server
  scp -r $GL_DATA_DIR $m:$GL_DATA_DIR
done

size=`ls -ltr $MBTILES_PATH | awk -F" " '{ print $5 }'`
if [[ $size -gt 10000000 ]]
then
else
  echo "$MBTILES_PATH is too small at $size to copy over to $m"
fi
