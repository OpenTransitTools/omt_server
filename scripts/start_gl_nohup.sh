DIR=`dirname $0`
cd $DIR/../gl/
tmux new-session -d -s my_session 'run.sh >> out.txt 2>&1'
