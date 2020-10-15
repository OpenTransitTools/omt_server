DIR=`dirname $0`
cd $DIR/../gl/
cmd="tmux new-session -d -s my_session 'run.sh >> out.txt 2>&1'"
echo "cd $PWD; $cmd"
eval $cmd
