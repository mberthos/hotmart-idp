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

##8 - 




