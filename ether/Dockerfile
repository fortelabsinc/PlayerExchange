FROM node:12-alpine
LABEL maintainer="Chris Jimison <cjimison@forte.io>"
ADD . / ether/
RUN (apk add python alpine-sdk)
RUN (cd ether/; npm cache clean --force;)
RUN (cd ether/; npm install;)
RUN (cd ether/; npm rebuild;)
WORKDIR ether
EXPOSE 3001 3001
CMD ["npm", "run", "start"]