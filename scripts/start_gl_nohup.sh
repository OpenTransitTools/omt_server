STDIR=`dirname $0`

cd $STDIR/../

PRUNE=${1:-"YES"}


# take down OMT
docker-compose down
mv out.txt out.old
if [ "$PRUNE" == "YES" ]; then
  docker system prune -a -f
fi

# restart OMT
cmd="docker-compose up -d tileserver-gl >> out.txt 2>&1"
echo "cd $PWD; $cmd"
eval $cmd
sleep 10
