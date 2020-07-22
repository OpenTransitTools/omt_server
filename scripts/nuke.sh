DIR=`dirname $0`

cd $DIR/../openmaptiles/

echo kill & down containers 
docker kill $(docker ps -aq)
docker-compose down
wait;

if [[ $1 == 'ALL' ]]
then
    echo REMOVE all containers
    echo
    docker ps --all --quiet --no-trunc --filter "status=exited" | xargs --no-run-if-empty docker rm
    docker images --quiet --filter "dangling=true" | xargs --no-run-if-empty docker rmi
    docker rm $(docker ps -a -q)
    docker rmi $(docker images -q)
    docker volume ls | awk '{print $2}' | xargs docker volume rm

    echo
    echo
    docker ps
    echo
    echo
    docker images
    echo
    echo
    docker volume ls
    echo
    echo
fi
