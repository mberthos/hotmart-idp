
#setup:
https://istio-release.storage.googleapis.com/charts
istioctl install --set profile=default -y --set meshConfig.accessLogFile=/dev/stdout

istioctl install -f wise-ingress.yaml --set meshConfig.accessLogFile=/dev/stdout
