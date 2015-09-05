#!/bin/bash
if [[ "$USER" != 'root' ]]; then
	echo "Sorry, you need to run this as root"
	exit
fi
apt-get update
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
sed -i '61 a --add-module=../../ngx_pagespeed/ngx_pagespeed-master \\' rules
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