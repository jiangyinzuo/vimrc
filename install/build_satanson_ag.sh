if [ -x "$(command -v apt)" ]; then
	sudo apt-get install -y automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev
elif [ -x "$(command -v yum)" ]; then
	yum -y install pkgconfig automake gcc zlib-devel pcre-devel xz-devel
fi

pushd build
rm -r the_silver_searcher
git clone --depth=1 https://github.com/satanson/the_silver_searcher
cd the_silver_searcher
./build.sh
sudo make install
popd
