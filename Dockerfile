# You should always specify a full version here to ensure all of your developers
# are running the same version of Node.
FROM node:wheezy

# install supervisor
RUN apt-get update && apt-get install -y supervisor

# WORKDIR /usr/
# copy supervisord.conf file
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# install serve, to serve the dapp
RUN npm install -g serve

# Copy feathers repro and install
WORKDIR /usr/

# Copy all local files into the image.
RUN git clone https://github.com/Giveth/feathers-giveth.git

WORKDIR /usr/feathers-giveth/
RUN npm install

# Copy dapp build repro
WORKDIR /usr/
RUN git clone https://github.com/Giveth/giveth-dapp.git

WORKDIR /usr/giveth-dapp/

# Copy env
COPY .env.local .

# Copy vendor js files for offline usage
COPY /vendor/ .

# Overwrite index.html with custom index.html for offline usage

RUN npm install
RUN npm run build

# Tell Docker about the port we'll run on.
# CMD serve /usr/giveth-dapp/build -s -p 3010

CMD ["/usr/bin/supervisord", "-n", "--configuration", "/etc/supervisor/conf.d/supervisord.conf"]

EXPOSE 3010 
EXPOSE 3030 
EXPOSE 8546