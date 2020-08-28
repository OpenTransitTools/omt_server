#
# compare data/*config*.yml with last.config (something saved off last time data was loaded)
# will help determine if a new build is necessary
# 
RET_VAL=0

if [ -f data/last.config ]
then
  # make new config file
  rm data/*config*.yml
  make generate-dc-config > /dev/null

  # diff files
  diff data/*.yml data/last.config > /dev/null
  DIFF=$?

  if [ $DIFF -eq 1 ]
  then
    #echo $DIFF
    RET_VAL=1
  fi
else
  RET_VAL=1
fi

return $RET_VAL
