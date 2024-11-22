sh build.sh
docker run --rm -ti \
	-p 4567:4567 \
	-v $PWD/source:/app/source \
	-v $PWD/images:/app/images \
	-v $PWD/pages:/app/pages \
	-e HOME=/app \
	davidsiaw/nicedoc \
	$@
