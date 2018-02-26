#!/bin/bash

if [ $# -ne 1 ]; then
	echo ""
	echo "Usage: $0 -run | -stop | -install | -update"
	echo "-run     : Runs the docker"
	echo "-stop    : Stops the docker"
	echo "-install : Installs the docker"
	echo "-update  : Updates Github repository"
	echo "-edit    : Edits your configuration files"
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

if [ "$1" = "-stop" ]; then
	CID=`docker container ls -a | grep "exesdotnet/steelydns" | awk '{print $1}'`
	[ "$CID" == "" ] && exit 1;
	docker stop $CID
	sleep 3
	docker kill $CID

elif [ "$1" = "-update" ]; then
	cd ~
	rm -Rf ~/steelydns
	git clone https://github.com/exesdotnet/steelydns.git
	sudo chmod ugo+x ~/steelydns/steelydns.sh
	exit 0

elif [ "$1" = "-edit" ]; then
	CID=`docker container ls -a | grep "exesdotnet/steelydns" | awk '{print $1}'`
	[ "$CID" == "" ] && exit 1;

	docker logs $CID
	docker top $CID

	VolP=`docker inspect $CID | grep -e Source -e volumes | awk '{print $2}' | cut -d'"' -f2`
	echo $VolP | xargs sudo ls -la

	sudo nano $VolP/dnscrypt-proxy.toml
	sudo nano $VolP/dnsmasq.conf
	sudo nano $VolP/extra_hosts

elif [ "$1" = "-test" ]; then
	docker history exesdotnet/steelydns

	CID=`docker ps -a | grep "exesdotnet/steelydns" | awk '{print $1}'`
	if [ "$CID" != "" ]; then
		docker top $CID
		docker inspect --format='' $CID
		docker logs $CID
		docker diff $CID
		docker exec $CID ls -la
	fi

	host resolver1.opendns.com "127.0.1.1#2053"
	host resolver2.opendns.com "127.0.2.1#2053"

	#docker exec -t -i $CID /bin/bash
	#docker run --rm -it --entrypoint=/bin/bash "exesdotnet/steelydns"

else
	echo ""
fi
