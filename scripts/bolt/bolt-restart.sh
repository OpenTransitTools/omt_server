##
## will remotely update and restart the GL server from omt_server project
##
BDIR=`dirname $0`
. $BDIR/bolt-base.sh

for m in $MACHINES
do
  echo $m

  # step 1: update code (2nd call should show all was updated / nothing pending)
  bolt command run '~/omt_server/scripts/omt_update.sh' --targets $m
  sleep 60

  # step 2: check that GL docker is running 
  bolt command run 'docker ps' --targets $m

  # step 3: check that GL docker is running 
  #TODO: grab a static image ... make sure it's valid and of size
  #sleep 30
  #curl $m:8080/
done
