#!/bin/sh

export CONFIGS_FILE=/app/configs/kubernetes-microservice-example-configs;
export SECRETS_FILE=/app/secrets/kubernetes-microservice-example-secrets;

# prepare environment
if [ -f "$CONFIGS_FILE" ];
then
  tr -d '\015' < "$CONFIGS_FILE" > /tmp/configs.lf
  . /tmp/configs.lf  
  rm /tmp/configs.lf
else
  echo 'Config file "$CONFIGS_FILE" was not found from Secret Manager';
fi;


if [ -f "$SECRETS_FILE" ];
then
  tr -d '\015' < "$SECRETS_FILE" > /tmp/secrets.lf
  . /tmp/secrets.lf
  rm /tmp/secrets.lf
else
  echo 'Secret file "$SECRETS_FILE" was not found from Secret Manager';
fi;

if [ "$1" = "start" ]; then
  # starting node application
  exec node index.js
else
  # executing command supressed in the command line
  exec "$@"
fi;
