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
