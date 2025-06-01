apt-get update
apt-get install -y apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

docker --version

docker swarm init --advertise-addr IP-MANAGER
он выдаст команду для присоединения workers - запустить на воркерах

docker swarm join --token _token_ IP-MANAGER:PORT

docker node ls
IMG