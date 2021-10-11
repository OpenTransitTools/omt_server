DIR=`dirname $0`

rm -rf $DIR/../gl/data
rm -rf $DIR/../gl/data-bkup
rm -rf $DIR/../openmaptiles/build
rm -rf $DIR/../openmaptiles/cache
rm -rf $DIR/../openmaptiles/data

$DIR/nuke.sh ALL
