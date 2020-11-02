##
## pull latest omt_server code (including styles, config, etc...), 
## then restart the GL server
## this script will also work well for restarting with new .mbtiles data
##

DIR=`dirname $0`
cd $DIR/../gl/
$DIR/nuke.sh ALL
mv ./config.json ./jnk
git pull
if [ -f ./config.json ]; then
  rm ./jnk
else
  mv ./jnk ./config.json
fi
$DIR/gen_hostname_txt.sh
./run-nohup.sh
