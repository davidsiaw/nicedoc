sh build.sh
docker run --rm -ti \
	-p 4567:4567 \
	-v $PWD/source:/app/source \
	-v $PWD/pages:/app/pages \
	-u $UID:$GID \
	-e HOME=/app \
	davidsiaw/nicedoc \
	$@
