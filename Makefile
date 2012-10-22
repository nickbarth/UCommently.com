server:
	thin start

prod_start:
	cp ./conf/ucommentlycom_nginx.conf /etc/nginx/conf.d/
	service nginx reload
	mkdir ./logs/ 2>/dev/null; true
	mkdir -p public/assets/javascripts/; true
	mkdir -p public/assets/stylesheets/; true
	rake assets:compile; true
	thin start -S /tmp/UCommently.com.sock -l ./logs/server.log -P ./logs/pid.log -e production -s 1

prod_stop:
	rm logs/* 2>/dev/null; true

prod_restart: prod_stop prod_start

default: server
