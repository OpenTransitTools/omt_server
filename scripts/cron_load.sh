#
# cron_load.sh
#
# script does the following:
#  1. download the OSM meta file (stats) and compare it against a cached version from the last time the tiles were built
#  2. if the OSM meta (stats) data is are different, then will:
#   - download new OSM data 
#   - call import.sh  -- sub-process to rebuild *.mbtiles here in test, and validate that it's good
#   - bolt_reload.sh  -- sub-process to deploy new *.mbtiles server to remote (staging / production) servers via 'bolt'
#   - bolt_restart.sh -- sub-process to restart remote servers after new *.mbtiles are deployed there
#   - bolt_clear.sh   -- test that tileserver-gl is up and responding on remote servers, then clear file (tile) cache
#
DIR=`dirname $0`
. $DIR/base.sh


function update_osm_data() {

  # step 1: move old OSM data aside
  if [ ! -d $OMT_DATA_DIR ]; then
    mkdir -p $OMT_DATA_DIR
  else
    old_osm_dir="$OMT_DIR/old/"

    rm -rf /tmp/old
    mv $old_osm_dir /tmp/
    rm -rf $old_osm_dir
    mkdir -p $old_osm_dir
    mv $OMT_DATA_DIR/$OSM_META_FILE $old_osm_dir
    mv $OMT_DATA_DIR/$OSM_FILE $old_osm_dir
    mv $OMT_DATA_DIR/*mbtiles $old_osm_dir
  fi

  # step 2: grab new data
  curl $OSM_META_URL > $OMT_DATA_DIR/$OSM_META_FILE
  curl $OSM_DATA_URL > $OMT_DATA_DIR/$OSM_FILE

  # step 3: check new OSM data for size, etc... if not valid, revert back to old stuff
  size=`ls -ltr $OMT_DATA_DIR/$OSM_FILE | awk -F" " '{ print $5 }'`
  if [[ $size -lt 10000000 ]]
  then
    echo "$OMT_DATA_DIR/$OSM_FILE is wayyy too small at $size"
    exit
  fi
}


#
# returns true if the old and new gtfs files don't match
#
function check_osm_meta_data() {
  # set to true ... no data dir
  ret_val=1

  if [ -d $OMT_DATA_DIR ]; then

    # step 1: grab meta data into tmp dir
    tmp_dir="$OMT_DATA_DIR/tmp"
    rm -rf $tmp_dir
    mkdir $tmp_dir
    curl $OSM_META_URL > $tmp_dir/$OSM_META_FILE

    # step 1b: make sure we have existing meta file to compare
    if [ ! -f $OMT_DATA_DIR/$OSM_META_FILE ]; then
      echo "NEW" > $OMT_DATA_DIR/$OSM_META_FILE
    fi
    
    # step 2: compare new meta data vs. old  
    DF=`diff $OMT_DATA_DIR/$OSM_META_FILE $tmp_dir/$OSM_META_FILE`
    if [ -z "$DF"  ]; then
	echo "OSM data match ... not reloading"
	ret_val=0
    else
	echo "OSM (meta) data DOES NOT match (eg: $DF)"
	ret_val=1
    fi
    rm -rf $tmp_dir
  fi

  return $ret_val
}


# main: update data 
rm -rf /tmp/*

cd $OMT_DIR
./scripts/git_update.sh

check_osm_meta_data
new=$?
if [ $new == 1 ]; then
  echo "step A: blow away existing GL / OMT Docker and data"
  $DIR/nuke.sh ALL

  echo "step B: load and create *.mbtiles in openmaptiles/data dir"
  update_osm_data

  cd $OMT_DIR
  ./scripts/import.sh

  echo "step C: restart and test GL with this new *.mbtiles file"
  cd $OMT_DIR
  ./scripts/mbtiles/copy.sh
  ./scripts/mbtiles/restart.sh
 
  echo "step D: deploy this *.mbtiles into the GREEN/BLUE system not in production"
  cd $OMT_DIR
  ./scripts/bolt/deploy.sh

  echo "step E: test... "
  cd $OMT_DIR
  ./scripts/test_
fi
