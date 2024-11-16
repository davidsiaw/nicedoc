
rm -rf build
git clone git@github.com:davidsiaw/nicedoc build
cd build
git checkout gh-pages
cd ..
mv build/.git gitbak
rm -rf build
mkdir -p build/weaver
sleep 2
docker run --rm -v $PWD/pages:/app/pages -v $PWD/css:/app/css -v $PWD/build:/app/build davidsiaw/nicedoc bundle exec weaver build
rm build/css
cp -r images build/images
cp -r css build/css
mv gitbak build/.git
cp build/weaver/css/*.css build/css
cp -r build/weaver/font-awesome build/font-awesome
mkdir build/js
cp build/weaver/js/*.js build/js
rm -rf build/weaver
cd build
echo nicedoc.astrobunny.net > CNAME
git add .
git commit -m "update"
git push
cd ..
