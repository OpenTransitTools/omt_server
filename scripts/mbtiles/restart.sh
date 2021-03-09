DIR=`dirname $0`
. $DIR/../base.sh

# restart GL
if [ -d $GL_DATA_DIR ]
then
  $DIR/../nuke.sh ALL
  cd $GL_DIR
  ./run-nohup.sh
  sleep 30
fi

# test / scp copy data dir to server
TM_MAP_URL="http://localhost:8080/styles/trimet/13/1304/2930@6x.png"
TM_SAT_URL="http://localhost:8080/styles/trimet-satellite/16/10435/23440@6x.png"
curl_test $TM_MAP_URL localhost-map.png
curl_test $TM_SAT_URL localhost-sat.png
