BDIR=`dirname $0`
. $BDIR/bolt-base.sh

for m in $MACHINES
do
  echo $m

  # step 1: update code (2nd call should show all was updated / nothing pending)
  bolt command run 'ls -l ~/' --targets $m
done
