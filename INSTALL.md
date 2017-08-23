# Installation de la machine hôte :

## Avec root :
    passwd
    apt-get update
    apt-get upgrade
    adduser ADMIN
    usermod -aG sudo ADMIN

Empecher le login SSH avec root :

	sudo nano /etc/ssh/sshd_config
        # Modifier :
        #
		# PermitRootLogin no
		
	sudo service ssh restart
    
Ajouter des alias de commande :
    
    nano /etc/profile.d/00-aliases.sh
        # Ajouter à la fin :
        #
        #	alias ll='ls -lAh --time-style=long-iso'


# http://programmingflow.com/2016/11/24/setting-up-your-own-private-and-secure-chat.html


## Avec ADMIN :

Installation docker :

    # Pre-requisite
    sudo apt-get install apt-transport-https dirmngr
    # Add Docker Repository
    sudo echo 'deb https://apt.dockerproject.org/repo debian-stretch main' >> /etc/apt/sources.list
	# Obtain docker's repository signature and updated package index
	sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
	
    sudo apt-get update
	sudo apt-get install docker docker-engine docker-compose
	sudo apt-get install git
	sudo adduser DOCKERUSER
	sudo usermod -aG docker DOCKERUSER

Installation certbot :

	# https://certbot.eff.org/#debianstretch-other
	sudo apt-get install certbot
	sudo certbot certonly --standalone -d radiopochard.com -d www.radiopochard.com
	
Mattermost : **avec quel user ? user "devmattermost" ?**

	git clone https://github.com/aurelien35/mattermost-docker
	cd mattermost-docker
	docker-compose build

	docker-compose up -d
	docker-compose stop

Configuration SSL :

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
		