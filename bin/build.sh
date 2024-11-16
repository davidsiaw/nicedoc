bundle exec weaver build $@
rm -rf build/css
cp -r images build/images
cp -r css build/css
cp build/weaver/css/*.css build/css
cp -r build/weaver/font-awesome build/font-awesome
mkdir build/js
cp build/weaver/js/*.js build/js
rm -rf build/weaver
