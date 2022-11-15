helm repo add argo https://argoproj.github.io/argo-helm

helm install -f ./values.yml --debug -n argocd argocd-ha argo/argo-cd --version 4.9.7