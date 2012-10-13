server:
	thin start

server_prod:
	thin start -S /tmp/YouTubeApp.com.sock -l ./logs/server.log -P ./logs/pid.log -e production -s 1

default: server
