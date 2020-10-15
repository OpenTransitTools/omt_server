#
# check_osm.sh
#
# will download the OSM meta file, compare it against a cached version, and if 
# different, download the new OSM data...
#
SERVER="http://maps6.trimet.org"
OSM_META_FILE="or-wa.osm-stats"
OSM_FILE="or-wa-carto.osm.pbf"
OSM_META_URL="$SERVER/pelias/$OSM_META_FILE"
OSM_DATA_URL="$SERVER/pelias/$OSM_FILE"
DATA_DIR=~/omt_server/openmaptiles/data


function update_osm_data() {
  old_osm_dir="$DATA_DIR/../old/"

  # step 1: move old OSM data aside
  if [ ! -d $DATA_DIR ]; then
    mkdir -p $DATA_DIR
  else
    rm -rf $old_osm_dir
    mkdir -p $old_osm_dir
    mv $DATA_DIR/$OSM_META_FILE $old_osm_dir
    mv $DATA_DIR/$OSM_FILE $old_osm_dir
    mv $DATA_DIR/*mbtiles $old_osm_dir
  fi

  # step 2: grab new data
  curl $OSM_META_URL > $DATA_DIR/$OSM_META_FILE
  curl $OSM_DATA_URL > $DATA_DIR/$OSM_FILE
}


function check_osm_meta_data() {
  # returns true if the old and new gtfs files don't match
  ret_val=0

  if [ -d $DATA_DIR ]; then

    # step 1: grab meta data into tmp dir
    tmp_dir="$DATA_DIR/tmp"
    rm -rf $tmp_dir
    mkdir $tmp_dir
    curl $OSM_META_URL > $tmp_dir/$OSM_META_FILE

    # step 2: compare new meta data vs. old  
    DF=`diff $DATA_DIR/$OSM_META_FILE $tmp_dir/$OSM_META_FILE`
    if [ -z "$DF"  ]; then
	echo "OSM data match ... not reloading"
	ret_val=0
    else
	echo "OSM (meta) data DOES NOT match (eg: $DF)"
        mv $tmp_dir/$OSM_META_FILE $DATA_DIR
	ret_val=1
    fi
    #rm -rf $tmp_dir
  fi

  return $ret_val
}

# update data 
new=check_osm_meta_data
echo $new
if [ $new != 1 ]; then
  update_osm_data
fi
