DIR=`dirname $0`
$DIR/git_update.sh
cd $DIR/../openmaptiles/

$DIR/nuke.sh

# start docker containers
make start-maputnik
make start-postserve
sleep 2
echo
docker ps
echo
echo open http://localhost:8088
