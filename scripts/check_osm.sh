#
# check_osm.sh
#
# will look at OSM file and determine if the tiles should
# be updated...
#

OSM_FILE=or-wa.osm.pbf
OSM_URL="http://maps6.trimet.org/pelias/$OSM_FILE"
curl $OSM_URL > ~/$OSM_FILE


function check_osm() {
    # returns true if the old and new gtfs files don't match
    ret_val=0
    trans_dir=$1
    tmp_dir=$trans_dir/tmp

    DF=`diff $trans_dir/feed_info.txt $tmp_dir/feed_info.txt`
    if [ -z "$DF"  ]; then
        echo "feeds match ... not reloading"
        ret_val=0
    else
        echo "feeds DO NOT match ... diff of feed_info: $DF"
        ret_val=1
    fi
    return $ret_val
}


