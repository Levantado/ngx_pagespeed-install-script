#!/bin/bash
if [[ "$USER" != 'root' ]]; then
	echo "Sorry, you need to run this as root"
	exit
fi

apt-get -y --force-yes  install dpkg-dev build-essential zlib1g-dev libpcre3 libpcre3-dev unzip

echo "deb http://nginx.org/packages/ubuntu/ trusty nginx" >> /etc/apt/sources.list.d/nginx.list

echo "deb-src http://nginx.org/packages/ubuntu/ trusty nginx" >> /etc/apt/sources.list.d/nginx.list

wget -q "http://nginx.org/packages/keys/nginx_signing.key" -O-| sudo apt-key add -

apt-get update

mkdir -p ~/new/nginx_source/
cd ~/new/nginx_source/
apt-get -y --force-yes source nginx
apt-get -y --force-yes build-dep nginx

mkdir -p ~/new/ngx_pagespeed/
cd ~/new/ngx_pagespeed/
ngx_version=1.9.32.6
wget https://github.com/pagespeed/ngx_pagespeed/archive/release-${ngx_version}-beta.zip
unzip release-${ngx_version}-beta.zip
cd ngx_pagespeed-release-${ngx_version}-beta/
wget --no-check-certificate https://dl.google.com/dl/page-speed/psol/${ngx_version}.tar.gz
tar -xzf ${ngx_version}.tar.gz
cd ~/new/nginx_source/nginx-1.8.0/debian/
sed -i '22 a --add-module=../../ngx_pagespeed/ngx_pagespeed-release-1.9.32.6-beta \\' rules
sed -i '61 a --add-module=../../ngx_pagespeed/ngx_pagespeed-release-1.9.32.6-beta \\' rules
cd ~/new/nginx_source/nginx-1.8.0/
dpkg-buildpackage -b
cd ~/new/nginx_source/
dpkg -i nginx_1.8.0-1~trusty_amd64.deb
nginx -V
mkdir -p /var/ngx_pagespeed_cache
chown -R www-data:www-data /var/ngx_pagespeed_cache
cd /etc/nginx/
sed -i '30ipagespeed on;' nginx.conf
sed -i '31ipagespeed FileCachePath /var/ngx_pagespeed_cache;' nginx.conf
service nginx restart
curl -I -p http://localhost|grep X-Page-Speed