#
# NOTES:
#
# to run in background (eg, nohup): tmux new-session -d -s my_session 'run.sh >> out.txt 2>&1'
# extra logging: grab continaer id via docker ps -a and then run docker logs <container_id>
#
# public_url does not work as expected.  It appears to just allow you to have an alternate path to override static resources.
#  - https://github.com/maptiler/tileserver-gl/issues/477
# See options for more details: https://tileserver.readthedocs.io/en/latest/usage.html#default-preview-style-and-configuration
#
# There may be useful things to do with the --mbtiles and --config flags
# This can be adapted to docker-compose, but we can work on that later.
#
# CHANGES:
#  Sep 20 (Frank): replaced --rm param with --restart=always to keep this puppy running.
#  Feb 21 (Frank): changed -p 8080:80 to 8080:8080, as v3.1.x no longer has to use port w/in the container, and now running port 80 (inside the container)  w/out root access is a non-starter.
#
# https://hub.docker.com/r/maptiler/tileserver-gl
#
TS="maptiler/tileserver-gl" # latest
TS="maptiler/tileserver-gl:v4.4.1"
docker run --restart=always -it -v $(pwd):/data -p 8080:8080 -e "NODE_ENV=dev" $TS --verbose

# start maputnik editor 
if [[ $1 == *'MAP'* || $1 == *'ED'* ]]; then
  echo "Starting Maputnik..."
  docker run --rm -u $(id -u):$(id -g) --name maputnik_editor -d -p 8088:8888 maputnik/editor
fi
