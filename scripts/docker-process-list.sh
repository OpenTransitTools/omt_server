for c in $(docker ps -q)
do
  echo
  ps="docker exec -it $c ps -aux"
  echo $ps
  eval $ps

  insp="docker inspect $c"
  echo
  echo "docker exec -it $c kill -9 <pid>"
  echo "$insp"
  eval "$insp | grep -i restartcount"
  echo
done
