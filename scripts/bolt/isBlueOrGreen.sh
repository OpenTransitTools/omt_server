##
## check the GL tile servers to determine which of the BLUE or GREEN service is running
##
## the home page should echo the hostname of the server ala "rj-st-mapapp01"
## so this script is grepping for that value, and comparing against known BLUE / GREEN host lists
##
## :return: either BLUE, GREEN or UNKNOWN
##
## Frank Purcell - October 2020
##
DIR=`dirname $0`
. ${DIR}/servers.sh

DOMAIN="trimet.org"
MACHINE=${1:-"tiles-st.$DOMAIN"}
DEBUG=${2:-"FALSE"}

URL="https://${MACHINE}"
DOC=`curl -s $URL`;
hostname=$DOC;

if [[ $DEBUG == "FALSE" ]]; then
    echo "url: $URL"
    echo "doc: $DOC"
    echo "hostname: $hostname"
fi


# check for GREEN servers -- exit if seen
for n in $GREENS
do
    if [[ $hostname == $n* ]]
    then
	echo GREEN
	exit
    fi
done

# check for BLUE servers -- exit if seen
for n in $BLUES
do
    if [[ $hostname == $n* ]]
    then
	echo BLUE
	exit
    fi
done

echo UNKNOWN
