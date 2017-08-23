# http://programmingflow.com/2016/11/24/setting-up-your-own-private-and-secure-chat.html

root :
======
	passwd
	apt-get update
	apt-get upgrade
	adduser ADMIN
	usermod -aG sudo ADMIN
	nano /etc/profile.d/00-aliases.sh
	# Ajouter à la fin :
	#
	#	alias ll='ls -lAh --time-style=long-iso'


ADMIN :
=======
	sudo nano /etc/ssh/sshd_config
		=> PermitRootLogin no
		
	sudo service ssh restart

	Installation docker :
	=====================
		sudo apt-get install apt-transport-https dirmngr																			# Pre-requisite
		sudo echo 'deb https://apt.dockerproject.org/repo debian-stretch main' >> /etc/apt/sources.list								# Add Docker Repository
		sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D		# Obtain docker's repository signature and updated package index
		sudo apt-get update
		sudo apt-get install docker docker-engine docker-compose
		sudo adduser dockeruser
		sudo usermod -aG docker dockeruser

	Installation certbot :
	======================
		# https://certbot.eff.org/#debianstretch-other
		sudo apt-get install certbot
		sudo certbot certonly --standalone -d radiopochard.com -d www.radiopochard.com
	
	Installation mattermost :
	=========================
		# https://github.com/mattermost/mattermost-docker/
		sudo apt-get install git

	
## ==> avec quel user ? user "devmattermost" ?
	git clone https://github.com/mattermost/mattermost-docker.git
	cd mattermost-docker
	docker-compose build

	docker-compose up -d
	docker-compose stop

	Configuration SSL :
	===================
		sudo cp /etc/letsencrypt/live/radiopochard.com/cert.pem /home/dockeruser/mattermost-docker/volumes/web/cert/cert.pem
		sudo cp /etc/letsencrypt/live/radiopochard.com/privkey.pem /home/dockeruser/mattermost-docker/volumes/web/cert/key-no-password.pem

		nano docker-compose.yml
		# Ajouter à la fin, dans la section "web" :
		#
		#  environment:
		#    - MATTERMOST_ENABLE_SSL=true
		#    - PLATFORM_PORT_80_TCP_PORT=80
		
		docker-compose build --no-cache
		docker-compose up -d
		docker-compose stop
		