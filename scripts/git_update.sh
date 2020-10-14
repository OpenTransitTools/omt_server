git pull
git submodule init
git submodule update

# create data directory for tiles
DATA=openmaptiles/data
if [ ! -d $DATA ]; then
  mkdir $DATA
  if [ ! -d $DATA ]; then
    mkdir ../$DATA
  fi
fi

