for c in $(docker ps -q)
do
  echo
  ps="docker exec -it $c ps -aux"
  echo $ps
  eval $ps
  echo
  echo "docker exec -it $c kill -9 <pid>"
  echo
done
