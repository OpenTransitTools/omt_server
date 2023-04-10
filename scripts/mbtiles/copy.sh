DIR=`dirname $0`
. $DIR/../base.sh

size=`ls -ltr $OMT_MBTILES_PATH | awk -F" " '{ print $5 }'`
if [[ $size -gt $MIN_FILE_SIZE ]]
then
  echo "BKUP->COPY"
  $DIR/backup.sh
  cp -r $OMT_DATA_DIR $GL_DIR/
  mv $GL_DATA_DIR/tiles.mbtiles $MBTILES_PATH
  echo "NEW $MBTILES_PATH file is in place ... go ahead and run gl/run-nohup.sh"
else
  echo "ERROR: $OMT_MBTILES_PATH is too small ($size) ... won't copy to $GL_DATA_DIR"
fi
