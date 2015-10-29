FROM node:0.12

RUN \
    apt-get update && apt-get install git -yq && \
    npm install -g grunt-cli

ENV GHOST_VERSION 0.7.1-custom
ENV GHOST_DIR /var/www/ghost

RUN \
    mkdir -p ${GHOST_DIR} && cd ${GHOST_DIR} && \
    git clone https://github.com/velimir0xff/Ghost.git ./ && \
    git checkout ${GHOST_VERSION}

RUN \
    cd ${GHOST_DIR} && \
    npm cache clean && npm install && \
    grunt init && grunt prod

COPY ghost-s3-storage-index.js ${GHOST_DIR}/content/storage/ghost-s3/index.js

RUN \
    cd ${GHOST_DIR}/content/storage/ghost-s3 && \
    npm install --save ghost-s3-storage

ENV NODE_ENV development
WORKDIR ${GHOST_DIR}

CMD ["npm", "start"]

EXPOSE 2368
