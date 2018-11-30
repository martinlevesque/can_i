docker rm -f $(docker ps | grep can_i | awk '{print $1}')

docker run -it --env-file=.env  -v $(pwd):/opt/app can_i bash build-and-run.sh

docker ps | grep can_i
