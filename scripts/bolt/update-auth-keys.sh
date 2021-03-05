##
## will remotely update and restart the GL server from omt_server project
##
BDIR=`dirname $0`
. $BDIR/bolt-base.sh

for m in $MACHINES
do
  echo $m
  bolt command run 'cd ~/server-config/; git pull; cp ./home/authorized_keys ~/.ssh/' --targets $m
done
