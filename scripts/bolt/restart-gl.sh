##
## will copy the gl/data (mbtiles junk) over to servers
##
BDIR=`dirname $0`
. $BDIR/bolt-base.sh
. $BDIR/../base.sh

MACHINE=${1:-$DEF_MACHINE}
echo $MACHINE

INFO=">>step A: kill OMT on server $MACHINE"
echo; echo $INFO
bolt command run "cd $OMT_DIR; ./scripts/nuke.sh ALL" --targets $MACHINE

echo ">>step B: restarting gl tileserver on $MACHINE"
bolt command run "cd $OMT_DIR; ./scripts/gen_hostname_txt.sh" --targets $MACHINE
bolt command run "cd $OMT_DIR/gl/; ./run-nohup.sh" --targets $MACHINE
sleep 3
echo
bolt command run "docker ps" --targets $MACHINE
