sh build.sh
docker run --rm -ti \
	-v $PWD:$PWD \
	--workdir=$PWD \
	-u $UID:$GID \
	-e BUNDLE_PATH="$PWD/.bundler" \
	-e BUNDLE_DISABLE_SHARED_GEMS=true \
	-e HOME=$PWD \
	-p 4567:4567 \
	nicedoc \
	bundle exec weaver
