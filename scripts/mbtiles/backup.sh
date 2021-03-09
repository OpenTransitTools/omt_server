DIR=`dirname $0`
. $DIR/../base.sh

if [ -d $GL_DATA_DIR ]
then
  echo "BKUP"
  rm -rf $GL_DATA_BKUP_DIR
  mv $GL_DATA_DIR $GL_DATA_BKUP_DIR > /dev/null 2>&1
fi
