##
## will copy the gl/data (mbtiles junk) over to servers
##
DEPDIR=`dirname $0`
. $DEPDIR/base.sh

servers=${*:-"foo"}


function bkup_mbtiles() {
  bolt command run "update.sh; cd $OMT_DIR; ./scripts/mbtiles/backup.sh" --targets $1
}


function scp_mbtiles() {
  cmd="scp -r $GL_DATA_DIR $1:$GL_DATA_DIR"
  echo $cmd
  eval $cmd
}


function restart_gl() {
  echo restart GL $1
}


function test_gl() {
  echo test GL $1
}


size=`ls -ltr $MBTILES_PATH | awk -F" " '{ print $5 }'`
if [[ $size -gt 10000000 ]]
then
  for s in $servers
  do
    bkup_mbtiles $s
    scp_mbtiles $s
    restart_gl $s
    test_gl $s
  done
else
  echo "$MBTILES_PATH is too small at $size to copy over to $m"
fi
