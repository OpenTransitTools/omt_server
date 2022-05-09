BDIR=`dirname $0`
. $BDIR/servers.sh

if [[ $1 == 'ALL' ]]
then
  MACHINES=$SERVERS
elif [[ $1 == 'PROD' ]]
then
  MACHINES="$BLUES_PD $GREENS_PD"
elif [[ $1 == 'STAG' ]]
then
  MACHINES="$BLUES_ST $GREENS_ST"
else
  MPD=`$BDIR/getBlueGreenOpposites.sh`
  MST=`$BDIR/getBlueGreenOpposites.sh tiles-st.trimet.org`
  MACHINES="$MPD $MST"
fi

#MACHINES=${1:-$MACHINES}
