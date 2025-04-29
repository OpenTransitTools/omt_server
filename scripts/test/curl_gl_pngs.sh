##
## will copy the gl/data (mbtiles junk) over to servers
##
CDIR=`dirname $0`
. $CDIR/../base.sh

MACHINE=${1:-$DEF_MACHINE}

# step 1: create urls to machine specific version of GL
TM_MAP_URL="http://$MACHINE:8080/styles/trimet/13/1304/2930@4x.png"
TM_SAT_URL="http://$MACHINE:8080/styles/trimet-satellite/16/10435/23440@4x.png"

# step 2: call tests
echo "testing GL on $MACHINE"
curl_test $TM_MAP_URL $MACHINE-map.png; map=$?
curl_test $TM_SAT_URL $MACHINE-sat.png; sat=$?

if [ $map == 1 ] && [ $sat == 1 ]; then
  exit 1
else
  exit 0
fi
