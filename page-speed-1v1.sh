#!/bin/bash
if [[ "$USER" != 'root' ]]; then
	echo "Sorry, you need to run this as root"
	exit
fi
RELEASE_CDN=`lsb_release -sr`
apt-get update
apt-get -y --force-yes  install dpkg-dev build-essential zlib1g-dev libpcre3 libpcre3-dev unzip
if [[ "$RELEASE_CDN" = '14.04' ]]; then
echo "deb http://nginx.org/packages/ubuntu/ trusty nginx" >> /etc/apt/sources.list.d/nginx.list
echo "deb-src http://nginx.org/packages/ubuntu/ trusty nginx" >> /etc/apt/sources.list.d/nginx.list
        exit
fi
if [[ "$RELEASE_CDN" = '15.10' ]]; then
echo "deb http://nginx.org/packages/mainline/ubuntu/ wily nginx" >> /etc/apt/sources.list.d/nginx.list
echo "deb http://nginx.org/packages/mainline/ubuntu/ wily nginx" >> /etc/apt/sources.list.d/nginx.list
        exit
fi

wget -q "http://nginx.org/packages/keys/nginx_signing.key" -O-| sudo apt-key add -

apt-get update

mkdir -p ~/new/nginx_source/
cd ~/new/nginx_source/
apt-get -y --force-yes source nginx
apt-get -y --force-yes build-dep nginx

mkdir -p ~/new/ngx_pagespeed/
cd ~/new/ngx_pagespeed/

wget --no-check-certificate https://github.com/pagespeed/ngx_pagespeed/archive/master.zip
unzip master.zip
cd ngx_pagespeed-master/
echo '#!/bin/bash' >> bush.sh
grep wget config > bush.sh
sed -i 's/echo "     $ w/w/' bush.sh
sed -i 's/gz"/gz/' bush.sh
bash bush.sh
tar -xzf *.tar.gz

cd ~/new/nginx_source/nginx-*/debian/
sed -i '22 a --add-module=../../ngx_pagespeed/ngx_pagespeed-master \\' rules
if [[ "$RELEASE_CDN" = '14.04' ]]; then
sed -i '61 a --add-module=../../ngx_pagespeed/ngx_pagespeed-master \\' rules
       exit
fi

if [[ "$RELEASE_CDN" = '15.10' ]]; then
sed -i '65 a --add-module=../../ngx_pagespeed/ngx_pagespeed-master \' rules
sed -i '58 a --with-cc-opt=" -D_GLIBCXX_USE_CXX11_ABI=0" \' rules
sed -i '101 a --with-cc-opt=" -D_GLIBCXX_USE_CXX11_ABI=0" \' rules
       exit
fi
cd ~/new/nginx_source/nginx-*/
dpkg-buildpackage -b
cd ~/new/nginx_source/
dpkg -i nginx_*amd64.deb
nginx -V
mkdir -p /var/ngx_pagespeed_cache
chown -R www-data:www-data /var/ngx_pagespeed_cache
cd /etc/nginx/
sed -i '30ipagespeed on;' nginx.conf
sed -i '31ipagespeed FileCachePath /var/ngx_pagespeed_cache;' nginx.conf
service nginx restart
curl -I -p http://localhost|grep X-Page-Speed
exit