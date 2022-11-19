# istio
istio poc for balance and canary and green deploy.

##6 - Configurações e preparação do cluster de kubernetes.
#Setup Istio
curl -L https://istio.io/downloadIstio | sh -
cd istio-1.14.1
istioctl install --set profile=default -y --set meshConfig.accessLogFile=/dev/stdout --set meshConfig.defaultConfig.tracing.sampling
kubectl label namespace default istio-injection=enabled
#Prometheus
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.14/samples/addons/prometheus.yaml
#Grafana
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.14/samples/addons/grafana.yaml
#Kiali
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.14/samples/addons/kiali.yaml

##7 - Preparação do Vault e Istio.
#Instalação do Virtual Gateway do Istio.
kubectl apply -f ./projeto_test2_using_same_istiogw/gateway.yaml
#Instalação do Virtual Service do Istio.
kubectl apply -f ./projeto_test2_using_same_istiogw/virtual-service.yaml
#Instalação Vault
kubectl apply -f ./projeto_test2_using_same_istiogw/secrets-es.yml
kubectl apply -f ./projeto_test2_using_same_istiogw/secret-store.yml

##8 - CI
#Instalação do Jenkins
sudo apt install openjdk-8-jdk -y
sudo apt install openjdk-11-jdk -y
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc &gt; /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list &gt; /dev/null
sudo apt update
sudo apt install jenkins -y
sudo systemctl status jenkins
sudo ufw allow 8080
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
Setup.

plugins:
CloudBees AWS Credentials
Amazon ECR
Docker Pipeline
GitHub

Adicionar aws credenciais
aws e github
Instalar docker-ce
sudo apt install apt-transport-https curl gnupg-agent ca-certificates software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt install docker-ce docker-ce-cli containerd.io -y
sudo usermod -aG docker $USER
newgrp docker
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl restart docker
sudo usermod -aG docker jenkins
newgrp docker
echo "jenkins ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/jenkins

Create job 







#plugin
github
beesaws credentials
ecr



#Criar o SonarQube SAST




