DIR=`dirname $0`
. $DIR/../base.sh

size=`ls -ltr $GL_MBTILES_PATH | awk -F" " '{ print $5 }'`
if [[ $size -gt $MIN_FILE_SIZE ]]
then
  echo "BKUP"
  rm -rf $GL_DATA_BKUP_DIR
  mv $GL_DATA_DIR $GL_DATA_BKUP_DIR > /dev/null 2>&1
fi
