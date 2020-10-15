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
  bolt command run update.sh --targets $m

  # step 2: update
  bolt command run 'update.sh; cd tm-pelias; scripts/reload_new_data.sh' --targets $m

  # step 3: update, re-buildout & restart Pelias wrapper
  bolt command run 'cd pelias.adapter; restart_wrapper.sh' --targets $m

  # step 4: test and (deploy) report
  # run pelias & wrapper tests on these servers
  # either switch Citrix to new production on success or send emails to report to switch
done
