helm repo add datadog https://helm.datadoghq.com
helm repo update
helm install datadog-agent -f values.yaml --set datadog.site='us3.datadoghq.com' --set datadog.apiKey='b47c8814fca7c457c6b589bd415d1b14' datadog/datadog --namespace datadog
