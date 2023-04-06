DIR=`dirname $0`

$DIR/nuke.sh
$DIR/gen_hostname_txt.sh
sleep 2
$DIR/start_gl_nohup.sh


