DIR=`dirname $0`
FILE=$DIR/../openmaptiles/.env

# bkup file
mv $FILE $FILE.orig

# make change(s) to the openmaptiles/.env file via 'sed'
cat $FILE.orig | sed 's/MAX_ZOOM=7/MAX_ZOOM=15/g' > $FILE
