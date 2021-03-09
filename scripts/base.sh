DIR=`dirname $0`

# couple variables that can changed based on install 
MBTILES_FILE=${MBTILES_FILE:="or-wa.mbtiles"}
OMT_DIR=${OMT_DIR:="$HOME/omt_server"}

# openmaptiles (build area) mbtiles 
OMT_DATA_DIR="$OMT_DIR/openmaptiles/data"
OMT_MBTILES_PATH="$OMT_DATA_DIR/tiles.mbtiles"

# gl mbtiles paths
GL_DIR="$OMT_DIR/gl"
GL_DATA_DIR="$GL_DIR/data"
GL_DATA_BKUP_DIR="$GL_DIR/data-bkup"

MBTILES_PATH="$GL_DATA_DIR/$MBTILES_FILE"


##
## curl a couple of image files from gl, and them chekc their side
##
function curl_test() {
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

