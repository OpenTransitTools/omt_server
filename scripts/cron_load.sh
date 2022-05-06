#
# cron_load.sh
#
# script does the following:
#  1. load.sh to populate new data into OMT
#  2. if the OSM meta (stats) data is are different, then will:
#   - bolt_reload.sh  -- sub-process to deploy new *.mbtiles server to remote (staging / production) servers via 'bolt'
#   - bolt_restart.sh -- sub-process to restart remote servers after new *.mbtiles are deployed there
#   - bolt_clear.sh   -- test that tileserver-gl is up and responding on remote servers, then clear file (tile) cache
#
DIR=`dirname $0`
. $DIR/base.sh

cd XXXXXXX TODO
set reload = /scripts/load.sh

if $reload
  NOW=$( date '+%F @ %H:%M:%S' ) 
  echo "step 2: deploy this *.mbtiles into the GREEN/BLUE system not in production ($NOW)"
  cd $OMT_DIR
  ./scripts/bolt/deploy.sh
fi
