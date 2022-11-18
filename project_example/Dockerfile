#Ver versão do alpine ou mudar para outro cara.
FROM node:14.17.5
LABEL maintainer="mberthos"

COPY . /opt/application
WORKDIR /opt/application

RUN npm ci --production

RUN chown node /opt/application
USER node

ENTRYPOINT ["./entrypoint.sh"]
CMD ["start"]