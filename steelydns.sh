#!/bin/bash

if [ $# -ne 1 ]; then
	echo ""
	echo "Usage: $0 -run | -install | -update"
	echo "-run     : Runs the docker"
	echo "-install : Installs the docker"
	echo "-update  : Updates Github repository"
	echo "-test    : Tests the docker container"
	echo ""
	exit 1
fi

if [ "`which docker-compose`" = "" ]; then
	sudo apt-get install -y docker-compose
fi

if [ "$1" = "-install" ]; then
	#NAME=steelydns
	#VERSION=sandbox
	#docker kill ${NAME}
	#docker rm ${NAME}
	#docker rmi -f exesdotnet/${NAME}:${VERSION}
	#docker build --force-rm -t exesdotnet/${NAME}:${VERSION} .
	#docker run -d -p 2053:2053/tcp -p 2053:2053/udp --name ${NAME} exesdotnet/${NAME}:${VERSION}

	#docker build -t exesdotnet/steelydns .
	docker pull exesdotnet/steelydns

	#docker-compose up

elif [ "$1" = "-run" ]; then
	sudo docker run -p 2053:2053/udp -p 2053:2053/tcp -d exesdotnet/steelydns

elif [ "$1" = "-update" ]; then
	cd ~
	rm -Rf ~/steelydns
	git clone https://github.com/exesdotnet/steelydns.git
	sudo chmod ugo+x ~/steelydns/steelydns.sh
	exit 0

elif [ "$1" = "-test" ]; then
	CID=`docker ps -a | grep "exesdotnet/steelydns" | awk '{print $1}'`
	docker top $CID
	docker inspect --format='' $CID
	docker history exesdotnet/steelydns
	docker logs $CID
	docker diff $CID

	host resolver1.opendns.com "127.0.1.1#2053"
	host resolver2.opendns.com "127.0.2.1#2053"

else
	echo ""
fi

