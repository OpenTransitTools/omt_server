#
# this script will update GL's config.json file
#
# WHAT/HOW:
#  there is a 'frontPage' config in GL's config.json ... setting that to server.txt
#  doing this will then see GL echo back thet file as the GL home page (e.g., rather 
#  than the style viewer).
#
# WHY:
#  this script will put each server's $HOSTNAME as the content in server.txt.
#  with GL effectively echo'ing the HOSTNAME, we can use these names in a BLUE->GREEN deployment.
#  echoing the raw sever name will identify what servers are running in production.
#
DIR=`dirname $0`
OMT_DIR=$DIR/..

SVR_NAME=server.txt
SVR_FILE=$OMT_DIR/$SVR_NAME
CFG_FILE=$OMT_DIR/config.json

# step 1: output $HOSTNAME into the server.txt file
echo $HOSTNAME > $SVR_FILE

# step 2: change GL's config.json to point to new server file
sed -i -- "s/\"frontPage\": true/\"frontPage\": \"$SVR_NAME\"/g" $CFG_FILE
