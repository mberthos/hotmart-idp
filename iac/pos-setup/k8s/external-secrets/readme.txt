Setup :
https://external-secrets.github.io/kubernetes-external-secrets/
kubernetes-external-secrets:8.5.5
- helm install external-secrets external-secrets/external-secrets  -n external-secrets --create-namespace

- Replace values from file secrets-dev.yml

Create project on Argo

