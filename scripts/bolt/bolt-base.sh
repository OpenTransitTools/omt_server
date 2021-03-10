BDIR=`dirname $0`


if [[ $1 == 'ALL' ]]
then
  . $BDIR/servers.sh
  MACHINES=$SERVERS
elif [[ $1 == 'PROD' ]]
then
  . $BDIR/servers.sh
  MACHINES="$BLUES_PD $GREENS_PD"
elif [[ $1 == 'STAG' ]]
then
  . $BDIR/servers.sh
  MACHINES="$BLUES_ST $GREENS_ST"
else
  MPD=`$BDIR/getBlueGreenOpposites.sh`
  MST=`$BDIR/getBlueGreenOpposites.sh tiles-st.trimet.org`
  MACHINES="$MPD $MST"
fi
