REPO_NAME=$1
NAMESPACE=$2
ENVIRONMENT=$3

if [ -z "$REPO_NAME" ];
then
    echo "Usage: add_application.sh <repo_name> <namespace> <environment>"
    exit 1
fi;

if [ -z "$NAMESPACE" ];
then
    echo "Usage: add_application.sh <repo_name> <namespace> <environment>"
    exit 1
fi;

if [ -z "$ENVIRONMENT" ];
then
    echo "Usage: add_application.sh <repo_name> <namespace> <environment>"
    exit 1
fi;


CLUSTER_FILE_PATH=./templates/clusters/$ENVIRONMENT.txt

if [ ! -f "$CLUSTER_FILE_PATH" ];
then
    echo "Cluster file not found: $CLUSTER_FILE_PATH"
    exit 1
fi;

CLUSTER=$(sed '1!d' $CLUSTER_FILE_PATH)
K8S_MANIFESTS_REPO=$(sed '2!d' $CLUSTER_FILE_PATH)
CONFIG_FOLDER=$(sed '3!d' $CLUSTER_FILE_PATH)
FILE_PATH=$CONFIG_FOLDER/$REPO_NAME.yaml

kubectl patch --local --type merge -f ./templates/application.yaml -p '{ "metadata": { "name": "'$REPO_NAME'-'$ENVIRONMENT'", "namespace": "argocd" }, "spec": { "source": { "path": "./'$REPO_NAME'/", "repoURL": "'$K8S_MANIFESTS_REPO'" } , "destination": { "name": "'$CLUSTER'", "namespace": "'$NAMESPACE'" } } }' -o yaml > $FILE_PATH
echo "File generated: $FILE_PATH"
