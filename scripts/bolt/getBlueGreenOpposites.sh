DIR=`dirname $0`
. ${DIR}/servers.sh

DIR=$(cd `dirname $0` && pwd)
MACHINE=${1:-"tiles-st.trimet.org"}
DEBUG=${2:-"FALSE"}
COLOR=`$DIR/isBlueOrGreen.sh $MACHINE $DEBUG`
HEAD=${MACHINE%%[-.]*}  # eg the 'tiles' from tile-st.trimet.org or tiles.trimet.org

if [[ $DEBUG == "TRUE" ]]; then
    echo "head:  $HEAD"
    echo "color: $COLOR"
    echo "machine: $MACHINE"
fi


##
## the BLUES and GREENS list will have both dev/stage/production servers in the list
## so this method will filter the list based on what servers are being interrogated
##
function filter() {
    CLZ=""

    for svr in $1
    do
        if [[ $MACHINE == "$HEAD."* && $svr == *"-pd-"* ]]; then
            CLZ+="$svr "
        elif [[ $MACHINE == "$HEAD-st."* && $svr == *"-st-"* ]]; then
            CLZ+="$svr "
        elif [[ $MACHINE == "$HEAD-dv."* && $svr == *"-dv-"* ]]; then
            CLZ+="$svr "
        fi
    done
    echo $CLZ
}

## debug output...
if [[ $DEBUG != "FALSE" ]]; then
    echo $COLOR
    filter "$BLUES"
    filter "$GREENS"
fi

## if GREEN (or BLUE) is in production, then return the list of BLUE (or GREEN) server(s), 
## which signifies to a loader script what servers can update since not in production
if [[ $COLOR == "GREEN" ]]; then
    filter "$BLUES"
elif [[ $COLOR == "BLUE" ]]; then
    filter "$GREENS"
else
    echo "ERROR_NO_SERVERS"
fi
