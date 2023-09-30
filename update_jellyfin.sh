if [ $1 ]; then
	wget -O metainfo_update.sh http://docker.xiaoya.pro/metainfo_update.sh
	wget -O jellyfin.config.zip http://docker.xiaoya.pro/jellyfin.config.zip
	current_dir=$(echo $PWD)
	mkdir -p $1/xiaoya
	docker stop jellyfin
	docker rm jellyfin
	docker run -d --name jellyfin --net=host --device /dev/dri:/dev/dri --privileged -v /volume1/docker/xiaoya:/data -v $1/tmp:/temp --volume $1/config:/config  --volume $1/cache:/cache  --mount type=bind,source=$1/xiaoya,target=/media --restart=unless-stopped jellyfin/jellyfin:latest
	docker cp metainfo_update.sh jellyfin:/update.sh
	docker exec -i jellyfin chmod 755 /update.sh
	docker exec -i jellyfin apt update 2>1 1>/dev/null
	docker exec -i jellyfin apt install wget unzip 2>1 1>/dev/null
	cd $1/config
        unzip -q -n $current_dir/jellyfin.config.zip
	cd $current_dir
	rm metainfo_update.sh
	rm jellyfin.config.zip
fi	
