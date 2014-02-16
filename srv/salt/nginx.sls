# Install all compile dependencies
checkinstall:
  pkg.installed:
    - name: checkinstall

libpcre3:
  pkg.installed:
    - name: libpcre3

libpcre3-dev:
  pkg.installed:
    - name: libpcre3-dev

zlib1g:
  pkg.installed:
    - name: zlib1g

zlib1g-dbg:
  pkg.installed:
    - name: zlib1g-dbg

zlib1g-dev:
  pkg.installed:
    - name: zlib1g-dev

# Compile and install Nginx
/root/nginx-compile.sh:
  cmd.run:
    - name: /root/nginx-compile.sh
    - unless: test -f /srv/salt/config/nginx/src/nginx_1.5.10-1_amd64.deb
    - require:
      - file: /root/nginx-compile.sh
  file.managed:
    - source: salt://config/nginx/compile.sh
    - owner: root
    - group: root
    - mode: 755

/etc/init.d/nginx:
  file.managed:
    - source: salt://config/nginx/init.d/nginx
    - user: root
    - group: root
    - mode: 755

nginx:
  pkg.installed:
    - sources: 
      - nginx: salt://config/nginx/src/nginx_1.5.10-1_amd64.deb
  service.running:
    - watch:
      - file: /etc/nginx/nginx.conf
      - file.directory: /etc/nginx/conf
      - file.directory: /etc/nginx/conf.d
      - file.directory: /etc/nginx/sites-enabled
    - require:
      - file: /etc/init.d/nginx
      - file.directory: /etc/nginx/conf.d
      - file.directory: /etc/nginx/conf
      - file.directory: /etc/nginx/conf.d
      - file.directory: /etc/nginx/sites-enabled
      - pkg: nginx 

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://config/nginx/nginx.conf
    - user: www-data
    - group: www-data
    - mode: 644

/etc/nginx/mime.types:
  file.managed:
    - source: salt://config/nginx/mime.types
    - user: www-data
    - group: www-data
    - mode: 644
    - require_in:
      - service: nginx

nginx-conf:
  file.recurse:
    - name: /etc/nginx/conf
    - user: www-data
    - group: www-data
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True
    - source: salt://config/nginx/conf
    - include_empty: True
    - require_in:
      - service: nginx

nginx-conf.d:
  file.recurse:
    - name: /etc/nginx/conf.d
    - user: www-data
    - group: www-data
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True
    - source: salt://config/nginx/conf.d
    - include_empty: True
    - require_in:
      - service: nginx

nginx-sites-enabled:
  file.recurse:
    - name: /etc/nginx/sites-enabled
    - user: www-data
    - group: www-data
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True
    - source: salt://config/nginx/sites-enabled
    - include_empty: True
    - require_in:
      - service: nginx

/var/log/nginx/error.log:
  file.managed:
    - user: www-data
    - group: www-data
    - mode: 644
    - makedirs: True

/var/cache/nginx/client_temp:
  file.directory:
    - user: www-data
    - group: www-data
    - mode: 755
    - makedirs: True