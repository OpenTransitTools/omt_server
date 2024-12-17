STDIR=`dirname $0`
cd $STDIR/../
docker-compose down
cmd="tmux new-session -d -s gl_session 'docker-compose up tileserver-gl >> out.txt 2>&1'"
echo "cd $PWD; $cmd"
eval $cmd
