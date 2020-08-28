DIR=`dirname $0`
FILE=$DIR/../openmaptiles/.env
MAX_ZOOM=${MAX_ZOOM:=16}

# bkup file
#mv $FILE $FILE.orig

# make change(s) to the openmaptiles/.env file via 'sed'
SED_CHG_ZOOM="s/MAX_ZOOM=7/MAX_ZOOM=${MAX_ZOOM}/g"
echo "sed $SED_CHG_ZOOM > $FILE"
cat $FILE.orig | sed $SED_CHG_ZOOM > $FILE
