STDIR=`dirname $0`

cd $STDIR/../

# take down OMT
docker-compose down
docker system prune -a -f
mv out.txt out.old

# restart OMT
cmd="docker-compose up -d tileserver-gl >> out.txt 2>&1"
echo "cd $PWD; $cmd"
eval $cmd
sleep 10
