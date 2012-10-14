server:
	thin start

prod_start:
	thin start -S /tmp/UCommently.com.sock -l ./logs/server.log -P ./logs/pid.log -e production -s 1

prod_stop:
	rm logs/*

prod_restart: prod_stop server_prod

default: server
