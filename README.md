
<h2>How to Install nginx and google pagespeed on Ubuntu 14.04, 15.05, 16.04</h2>

<h3>What is it:</h3>

<blockquote>
<p><strong>Nginx</strong> is an HTTP and reverse proxy server, a mail proxy server, and a generic TCP proxy server, originally written by Igor Sysoev. For a long time, it has been running on many heavily loaded Russian sites including Yandex, Mail.Ru, VK, and Rambler. According to Netcraft, nginx served or proxied 22.61% busiest sites in August 2015. Here are some of the success stories: Netflix, Wordpress.com, FastMail.FM.</p>

<p><em><strong>Ngxpagespeed</strong> speeds up your site and reduces page load time by automatically applying web performance best practices to pages and associated assets (CSS, JavaScript, images) without requiring you to modify your existing content or workflow. Features include:</em></p>

<p><em>• Image optimization: stripping meta-data, dynamic resizing, recompression</em></p>

<p><em>• CSS &amp; JavaScript minification, concatenation, inlining, and outlining</em></p>

<p><em>• Small resource inlining</em></p>

<p><em>• Deferring image and JavaScript loading</em></p>

<p><em>• HTML rewriting</em></p>

<p><em>• Cache lifetime extension</em></p>

<p><em>• and more</em></p>
</blockquote>

<h3>Prerequisites</h3>

<ul>
	<li>Ubuntu 12.04, 14.04, 16.04</li>
	<li>root privileges</li>
	<li>few knowledge using vim</li>
</ul>

<h3><strong>Step 1 Install some Debian package development tools and library</strong></h3>

<pre><code>sudo apt-get install dpkg-dev build-essential zlib1g-dev libpcre3 libpcre3-dev unzip
</code></pre>

<h3><strong>Step 2 Adding nginx repo</strong></h3>

<pre><code>sudo nano /etc/apt/sources.list.d/nginx.list
</code></pre>

<p>Paste in two string </p>

<p>For 12.04:</p>

<pre><code>deb http://nginx.org/packages/ubuntu/ precise nginx
deb-src http://nginx.org/packages/ubuntu/ precise nginx
</code></pre>

<p>For 14.04:</p>

<pre><code>deb http://nginx.org/packages/ubuntu/ trusty nginx 
deb-src http://nginx.org/packages/ubuntu/ trusty nginx
</code></pre>

<p>For 16.04:</p>

<pre><code>deb http://nginx.org/packages/ubuntu/ xenial nginx 
deb-src http://nginx.org/packages/ubuntu/ xenial nginx
</code></pre>
After that update
<pre><code> sudo apt-get update</code></pre>
<p>Command stop and show strings like that:</p>

<p><em><strong>GPG error: http://nginx.org &lt;name package&gt; Release: The following signatures couldn&#39;t be verified because the public key is not available: NOPUBKEY ABF5BD8xxxxxxx</strong></em></p>

<p>Don&#39;t worry add this key</p>

<p>￼</p>

<pre><code>wget -q &quot;http://nginx.org/packages/keys/nginx_signing.key&quot; -O-| sudo apt-key add -
</code></pre>

<p>repeat</p>

<pre><code>sudo apt-get update
</code></pre>

<h3><strong>Step 3 Installing with use Automated Installer</strong></h3>

<p>It’s simple like never before, just run.</p>

<pre><code>bash &lt;(curl -f -L -sS https://ngxpagespeed.com/install) \
     --nginx-version latest
</code></pre>

<p>They ask you start for every major step. And finish.</p>

<figure><img src="%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202016-11-12%20%D0%B2%200.51.53.png"/></figure>

<p>Step 1 you may skip, installer detect missing dependencies.</p>

<h3><strong>Step 4 Initial script</strong></h3>

<p><a href="http://kbeezie.com/debian-ubuntu-nginx-init-script/">http://kbeezie.com/debian-ubuntu-nginx-init-script/</a></p>

<p>On this page default initial script for control NGINX</p>

<p>You may create that script yourself.</p>

<pre><code>sudo nano /etc/init.d/nginx
</code></pre>

<p>Paste script and change path to installing package.</p>

<p>After Step 3 your package local in /usr/local/nginx/</p>

<p>Or paste that</p>

<pre><code>#! /bin/sh
 
### BEGIN INIT INFO
# Provides:          nginx
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts the nginx web server
# Description:       starts nginx using start-stop-daemon
### END INIT INFO
 
PATH=/usr/local/nginx:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/usr/local/nginx/sbin/nginx
NAME=nginx
DESC=nginx
 
test -x $DAEMON || exit 0
 
# Include nginx defaults if available
if [ -f /etc/default/nginx ] ; then
        . /etc/default/nginx
fi
 
set -e
 
case &quot;$1&quot; in
  start)
        echo -n &quot;Starting $DESC: &quot;
        start-stop-daemon --start --quiet --pidfile /usr/local/nginx/logs/$NAME.pid \
                --exec $DAEMON -- $DAEMON_OPTS
        echo &quot;$NAME.&quot;
        ;;
  stop)
        echo -n &quot;Stopping $DESC: &quot;
        start-stop-daemon --stop --quiet --pidfile /usr/local/nginx/logs/$NAME.pid \
                --exec $DAEMON
        echo &quot;$NAME.&quot;
        ;;
  restart|force-reload)
        echo -n &quot;Restarting $DESC: &quot;
        start-stop-daemon --stop --quiet --pidfile \
                /usr/local/nginx/logs/$NAME.pid --exec $DAEMON
        sleep 1
        start-stop-daemon --start --quiet --pidfile \
                /usr/local/nginx/logs/$NAME.pid --exec $DAEMON -- $DAEMON_OPTS
        echo &quot;$NAME.&quot;
        ;;
  reload)
      echo -n &quot;Reloading $DESC configuration: &quot;
      start-stop-daemon --stop --signal HUP --quiet --pidfile /usr/local/nginx/logs/$NAME.pid \
          --exec $DAEMON
      echo &quot;$NAME.&quot;
      ;;
  *)
        N=/etc/init.d/$NAME
        echo &quot;Usage: $N {start|stop|restart|force-reload}&quot; &gt;&amp;2
        exit 1
        ;;
esac
 
exit 0</code></pre>
</code></pre>

<p>Now run this command to give your script executable permissions.</p>

<pre><code>sudo chmod +x /etc/init.d/nginx
</code></pre>

<h3><strong>Step 5 using</strong></h3>

<p>for start use:</p>

<pre><code>sudo /etc/init.d/nginx start
</code></pre>

<p>for stop:</p>

<pre><code>sudo /etc/init.d/nginx stop
</code></pre>

<p>for restart:</p>

<pre><code>sudo /etc/init.d/nginx  restart
</code></pre>

<p>for reload:</p>

<pre><code>sudo /etc/init.d/nginx reload
</code></pre>

<h3><strong>Step 6 check and configure</strong></h3>

<p>Now our NGINX must run and need see that real, if you not blocking 80 port you can just enter to your server ip, or</p>

<pre><code>curl -I -p http://localhost
</code></pre>

<figure><img src="%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202016-11-12%20%D0%B2%201.49.17.png"/></figure>

<p>Ok, NGINX start, but we need NGX-pagespeed.</p>

<blockquote>
<blockquote>
<p>PageSpeed Configuration</p>
</blockquote>

<p>Enabling the Module</p>

<p>In Nginx the configuration typically should go in your nginx.conf which for source installs defaults to being in:</p>

<p>/usr/local/nginx/conf/</p>

<p>In Apache PageSpeed is enabled automatically when you install the module while in Nginx you need to add several lines to your nginx.conf. In every server block where PageSpeed is enabled add</p>
</blockquote>

<p>Ok that we know what do next paste in every block nginx.conf code</p>

<pre><code>sudo nano /usr/local/nginx/conf/nginx.conf
</code></pre>

<p>Paste this code:</p>

<pre><code>pagespeed on;

# Needs to exist and be writable by nginx.  Use tmpfs for best performance.
pagespeed FileCachePath /var/ngx_pagespeed_cache;

# Ensure requests for pagespeed optimized resources go to the pagespeed handler
# and no extraneous headers get set.
location ~ &quot;\.pagespeed\.([a-z]\.)?[a-z]{2}\.[^.]{10}\.[^.]+&quot; {
  add_header &quot;&quot; &quot;&quot;;
}
location ~ &quot;^/pagespeed_static/&quot; { }
location ~ &quot;^/ngx_pagespeed_beacon$&quot; { }
</code></pre>

<p>Save and restart reload nginx</p>

<pre><code>sudo /etc/init.d/nginx reload
</code></pre>

<p>Now use curl</p>

<pre><code>curl -I -p http://localhost
</code></pre>

<figure><img src="%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202016-11-12%20%D0%B2%201.57.35.png"/></figure>

<p>It’s ALL. No need scripts any more. </p>
<p>P.S. for configure like wanna you - go here :</p>

<p><a href="https://developers.google.com/speed/pagespeed/module/configuration">https://developers.google.com/speed/pagespeed/module/configuration</a></p>

