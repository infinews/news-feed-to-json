FROM ubuntu

LABEL org.opencontainers.image.source=https://github.com/infinews/feed-to-json
LABEL org.opencontainers.image.description="Feedmachine docker image"
LABEL org.opencontainers.image.licenses=MIT

RUN  apt-get update &&  apt-get install -y ca-certificates curl gnupg && install -m 0755 -d /etc/apt/keyrings && (curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc;curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key |  gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg) &&  chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
ENV NODE_MAJOR 20
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" |  tee /etc/apt/sources.list.d/nodesource.list
RUN apt-get update && (apt-get install -y --no-install-recommends curl nodejs docker-compose-plugin socat  build-essential  jq bash git 2>&1|grep -v "Get:") && (apt-get clean all ||true) && which jq && which git && which curl  
RUN npm install -g express
COPY . /app
WORKDIR /app
RUN npm install
RUN npm audit fix
CMD npm start
