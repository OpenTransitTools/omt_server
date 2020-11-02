BDIR=`dirname $0`

if [[ $1 == 'ALL' ]]
then
  . $BDIR/servers.sh
  MACHINES=$SERVERS
else
  MACHINES=`$BDIR/getBlueGreenOpposites.sh`
fi
