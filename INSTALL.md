# TODO :
	Faire un dockerfile pour lancer un serveur nginx :
		- avec configuration embarquée : le fichier de configuration avec le SSL et les différents virtual host est embarqué à la création de l'image
		- avec certificats SSL embarqués
		- un script genere les certificats nécessaires puis lance le build du docker
		
		=> comment modifier la configuration de nginx sans devoir le relancer ?
		https://blog.docker.com/2015/04/tips-for-deploying-nginx-official-image-with-docker/
		https://stackoverflow.com/questions/13525465/when-to-restart-and-not-reload-nginx
		https://github.com/jwilder/nginx-proxy/issues/377
		http://jasonwilder.com/blog/2014/03/25/automated-nginx-reverse-proxy-for-docker/
		http://blog.tobiasforkel.de/en/2016/08/18/reload-nginx-inside-docker-container/
		
	Faire un docker-compose.yml pour lancer une instance de mattermost :
		- prend le nom de l'instance dans l'environnement
		- lance l'image de bdd
		- lance l'image de l'application
		- monte des volumes à partir du nom de l'instance









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
		