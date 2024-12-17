DIR=`dirname $0`

# variables that can changed based on install
MIN_FILE_SIZE=${MIN_FILE_SIZE:=10000000}
MBTILES_FILE=${MBTILES_FILE:="or-wa.mbtiles"}
OMT_DIR=${OMT_DIR:="$HOME/omt_server"}

OSM_SERVER=${OSM_SERVER:="http://maps6.trimet.org"}

OSM_PBF_SIZE=$MIN_FILE_SIZE
OSM_META_FILE="or-wa.osm-stats"
OSM_FILE="or-wa-carto.osm.pbf"
OSM_META_URL="$OSM_SERVER/pelias/$OSM_META_FILE"
OSM_DATA_URL="$OSM_SERVER/pelias/$OSM_FILE"


# openmaptiles (build area) mbtiles 
OMT_DATA_DIR="$OMT_DIR/openmaptiles/data"
OMT_MBTILES_PATH="$OMT_DATA_DIR/tiles.mbtiles"

# gl mbtiles paths
GL_DATA_DIR="$OMT_DIR/data"
GL_DATA_BKUP_DIR="$GL_DATA_DIR/data-bkup"
GL_MBTILES_PATH="$GL_DATA_DIR/$MBTILES_FILE"
MBTILES_PATH=$GL_MBTILES_PATH

##
## curl a couple of image files from gl, and them check their size
##
function curl_test() {
  rm -f /tmp/$2
  cmd="curl $1 > /tmp/$2"
  echo $cmd
  eval $cmd > /dev/null 2>&1

  size=`ls -ltr /tmp/$2 | awk -F" " '{ print $5 }'`
  if [[ $size -gt 300000 ]]
  then
    echo "/tmp/$2 looks GOOD at size $size"
  else
    echo "/tmp/$2 seems SMALL at $size" 
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
