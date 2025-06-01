#
# seed.sh
#
# script does the following:
#
SDIR=`dirname $0`
. $SDIR/base.sh

cd $SDIR

# Vector Tiles:
#  https://tiles.trimet.org/data/or-wa_/14/2609/5861.pbf
#  https://tiles.trimet.org/data/or-wa/14/2609/5861.pbf
# ...
# 
#styles="trimet-satellite-routes rtp "
styles="trimet trimet-satellite"

for s in $styles
do
  # do these once per seed
  # note: the 512 url is one that the ws-st.trimet.org views use (here for demo purposes)
  # example: python -m seed.exe -st -f 1 -t 12 -r 10 -s trimet-satellite -b -c
  python -m seed.exe -st -f 1 -t 12 -r 10 -s $s -b  $*
  python -m seed.exe -st -f 1 -t 12 -r 10 -s $s/512 $*

  # do these for every point we'll be seeding
  python -m seed.exe -st -f 13 -t 20 -r 5 -s $s -b $*
done

cd -
