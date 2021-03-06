DIR=`dirname $0`
. $DIR/base.sh

rm -rf $GL_DATA_BKUP_DIR
cp -r $GL_DATA_DIR $GL_DATA_BKUP_DIR > /dev/null 2>&1
