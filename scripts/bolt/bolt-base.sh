BDIR=`dirname $0`

if [[ $1 == 'ALL' ]]
then
  . $BDIR/servers.sh
  MACHINES=$SERVERS
else
  MPD=`$BDIR/getBlueGreenOpposites.sh`
  MST=`$BDIR/getBlueGreenOpposites.sh tiles-st.trimet.org`
  MACHINES="$MPD $MST"
  MACHINES="$MST" # TODO: remove me
fi
