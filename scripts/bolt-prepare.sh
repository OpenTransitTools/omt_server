DIR=`dirname $0`
PROD=`$DIR/push_data/getBlueGreenOpposites.sh`
STAG=`$DIR/push_data/getBlueGreenOpposites.sh ws-st.trimet.org`
MACHINES="$PROD $STAG"

# DEBUG - for m in $MACHINES; do echo $m; done; exit
# MACHINES="$STAG"
# MACHINES=rj-dv-mapgeo02
# DEBUG - for m in $MACHINES; do echo $m;   bolt command run 'cd pelias.adapter; restart_wrapper.sh' --targets $m;  done; exit


for m in $MACHINES
do
  echo $m

  # step 1: update code (2nd call should show all was updated / nothing pending)
  bolt command run 'ls -l ~/' --targets $m

done
