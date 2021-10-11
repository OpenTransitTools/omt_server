DIR=`dirname $0`

rm -f  $DIR/../cron_load.txt
rm -f  $DIR/../gl/data/*
rm -rf $DIR/../gl/data-bkup

rm -rf $DIR/../openmaptiles/build
rm -rf $DIR/../openmaptiles/cache
rm -rf $DIR/../openmaptiles/data

# reset openmaptiles
cd $DIR/../openmaptiles/
git reset --hard HEAD
cd -

$DIR/nuke.sh ALL
