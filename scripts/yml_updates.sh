#
# update the openmaptiles/data/*yml files to
# specified MAX_ZOOM & BBOX (env vars w/ defaults below)
#

DIR=`dirname $0`
FILES=$DIR/../openmaptiles/data/*yml
MAX_ZOOM=${MAX_ZOOM:=16}
BBOX=${BBOX:="-124.0,44.0,-121.0,46.0"}

echo $MAX_ZOOM $BBOX

for f in `ls $FILES`
do

    # make change(s) to the openmaptiles/.env file via 'sed'
    SED_CHG_ZOOM="s/MAX_ZOOM.*/MAX_ZOOM: ${MAX_ZOOM}/"
    RZOOM="cat $f | sed '$SED_CHG_ZOOM' > $f.tmp"
    
    SED_CHG_BBOX="s/BBOX.*/BBOX: ${BBOX}/"
    RBBOX="cat $f.tmp | sed '$SED_CHG_BBOX' > $f.tmp2"

    echo $RZOOM
    eval $RZOOM

    echo $RBBOX
    eval $RBBOX

    if [ -s $f.tmp2 ]
    then
	mv $f.tmp2 $f
	rm $f.tmp
    fi

done
