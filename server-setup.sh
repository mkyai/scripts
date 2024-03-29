#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
echo "Welcome to the server setup and configuration script"

echo "Updating the system..."
sudo apt-get update -y

sudo apt-get upgrade -y

echo "Installing necessary packages..."
sudo apt-get install -y git unzip nginx postgresql postgresql-contrib redis-server

echo "Installing Node.js..."
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash 
source ~/.bashrc
nvm install node
echo "Default Node.js version set to : $(node -v)"

echo "Installing PM2..."
npm install pm2 -g

sudo snap install --classic certbot

echo "Do you want to install Docker? (y/n)"
read docker
if [ "$docker" = "y" ]; then
    echo "Installing Docker..."
    sudo snap install docker
    echo "Docker installed successfully"
else
    echo "Docker installation skipped"
fi

echo "Configuring Nginx..."
sudo systemctl start nginx
sudo systemctl enable nginx
sudo ufw allow 'Nginx Full'

echo "Do you want to configure Nginx for a new website? (y/n)"
read nginx

if [ "$nginx" = "y" ]; then
    echo "Configuring Nginx for a new website..."
    echo "Enter your domain name (e.g. example.com):"
    read domain
    sudo touch /etc/nginx/sites-available/api
    sudo echo "server {
        server_name domain_name.com;
        location / {
            proxy_pass http://localhost:3000;
            proxy_http_version 1.1;
            proxy_set_header Upgrade \$http_upgrade;
            proxy_set_header Connection \"upgrade\";
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        }
    }" > /etc/nginx/sites-available/api

    sudo sed -i "s/domain_name.com/$domain/" /etc/nginx/sites-available/api

    sudo ln -s /etc/nginx/sites-available/api /etc/nginx/sites-enabled/api
    
    sudo systemctl reload nginx
    echo "Nginx configured successfully for $domain"
else
    echo "Nginx configuration skipped"
fi

echo "Starting PostgreSQL..."
sudo systemctl start postgresql
sudo systemctl enable postgresql
echo "Do you want to configure PostgreSQL? (y/n)"
read postgres

if [ "$postgres" = "y" ]; then
    echo "Configuring PostgreSQL..."
    read -p "Enter Database Name: " dbname
    read -p "Enter Database User: " dbuser
    read -p "Enter Database Password: " dbpass
    echo

    if [ -z "$dbname" ]; then
        CREATE_DB="CREATE DATABASE $dbname;"
        sudo  -i -u postgres psql -c "$CREATE_DB"
        echo "Database with name $dbname created successfully"
    fi

    if [ -z "$dbuser" ]; then
        CREATE_USER="CREATE USER $dbuser WITH ENCRYPTED PASSWORD '$dbpass';"
        GRANT_PRIVILEGES="GRANT ALL PRIVILEGES ON DATABASE $dbname TO $dbuser;"
        sudo  -i -u postgres psql -c "$CREATE_USER"
        sudo  -i -u postgres psql -c "$GRANT_PRIVILEGES"
        echo "User with name $dbuser created successfully"
    fi

    sudo systemctl restart postgresql
    echo "PostgreSQL configured successfully"
else
    echo "PostgreSQL configuration skipped"
fi

echo "Starting Redis..."
sudo systemctl start redis
sudo systemctl enable redis
echo "Redis started successfully"

echo "Do you want to configure Redis password? (y/n)"
read redis_pass

if [ "$redis_pass" = "y" ]; then
    echo "Enter Redis password:"
    read password
    if [ -z "$password" ]; then
        sudo sed -i "s/# requirepass foobared/requirepass $password/" /etc/redis/redis.conf
        sudo systemctl restart redis
        echo "Redis configured successfully with password"
    fi
else
    echo "Redis configuration skipped"
fi

echo "Do you want to configure Certbot? (y/n)"
read certbot

if [ "$certbot" = "y" ]; then
    echo "Configuring Certbot..."
    echo "Enter your email address:"
    read email
    echo "Enter your domain name (e.g. example.com):"
    read domain
    sudo certbot --nginx -d $domain -m $email --agree-tos
    echo "Certbot configured successfully"
else
    echo "Certbot configuration skipped"
fi

echo "Do you want to install auto-deployment server? (y/n)"
read auto_deploy

mkdir -p /home/ubuntu/api

if [ "$auto_deploy" = "y" ]; then
    echo "Installing auto-deployment server..."
    mkdir -p /home/ubuntu/deploy
    cd /home/ubuntu/deploy
    git clone https://github.com/mkyai/auto-deploy.git .
    npm install
    touch .env
    chmod +x pre.sh
    chmod +x slack.sh

    echo "Enter logtail key"
    read logtail
    if [ -n "$logtail" ]; then
        echo -e "\LOGTAIL_KEY=\"$logtail\"" | sudo tee -a .env
    fi

    echo "Enter deployment secret"
    read deployment_secret
    if [ -n "$deployment_secret" ]; then
        echo -e "\DEPLOYMENT_SECRET=\"$deployment_secret\"" | sudo tee -a .env
    fi

    echo "Enter slack chanel for updates"
    read slack_channel
    if [ -n "$slack_channel" ]; then
        echo -e "\SLACK_CHANNEL=\"$slack_channel\"" | sudo tee -a .env
    fi

    echo "Enter slack token"
    read slack_token
    if [ -n "$slack_token" ]; then
        echo -e "\SLACK_TOKEN=\"$slack_token\"" | sudo tee -a .env
    fi

    pm2 start index.js
    pm2 save

    else
        echo "Auto-deployment server installation skipped"
fi

echo "Setup and configuration completed successfully"
echo "Exiting..."
exit 0
