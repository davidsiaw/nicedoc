
rm -rf build
git clone git@github.com:davidsiaw/nicedoc build
cd build
git checkout gh-pages
cd ..
mv build/.git gitbak
rm -rf build
mkdir -p build/weaver
sleep 2
docker run --rm -v $PWD/pages:/app/pages -v $PWD/build:/app/build davidsiaw/nicedoc sh bin/build.sh
mv gitbak build/.git
cd build
echo nicedoc.astrobunny.net > CNAME
git add .
git commit -m "update"
git push
cd ..
