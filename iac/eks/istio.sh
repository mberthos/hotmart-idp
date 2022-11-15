

## Istio install 
## curl -L https://istio.io/downloadIstio | sh -
## export PATH="$PATH:/Users/paulo.whyte/app/istio-1.11.2/bin"
## https://k8slens.dev/

istioctl install --set profile=default -y --set meshConfig.accessLogFile=/dev/stdout

## Prometheus  istioctl d prometheus
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.10/samples/addons/prometheus.yaml

## Grafana   istioctl d grafana
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.10/samples/addons/grafana.yaml

## Kiali   istioctl d kiali
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.10/samples/addons/kiali.yaml

kubectl get svc -n istio-system
kubectl get pod  -n istio-system
kubectl get hpa  -n istio-system

## kubectl get gw  public-gateway -n staging -o yaml

## cert-manager

## kubectl certificate -A

## Istio sidecar no serviço (deployment)
spec:
  selector:
    matchLabels:
    metadata:
      labels:
        sidecar.istio.io/inject: "true"

##  Istio sidecar no namespace
kubectl label namespace <default> istio-injection=enabled


kubectl create ns mberthos
# kubectl delete ns mberthos
kubectl label namespace mberthos istio-injection=enabled

## Virtual Gateway

kubectl get gw <name>  -o yaml


## Virtual Service
kubectl get vs <name>  -o yaml


kubectl apply -f <yml>
kubectl delete -f <yml>

kubectl get nodes --selector disktype=ssd
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    env: test
spec:
  containers:
  - name: nginx
    image: nginx
    imagePullPolicy: IfNotPresent
  nodeSelector:
    Zone: dmz
EoF