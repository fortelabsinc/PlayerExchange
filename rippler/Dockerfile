FROM node:12-alpine
LABEL maintainer="Chris Jimison <cjimison@forte.io>"
ADD . / rippler/
RUN (apk add python alpine-sdk)
RUN (cd rippler/; npm cache clean --force;)
RUN (cd rippler/; npm install;)
RUN (cd rippler/; npm rebuild;)
WORKDIR rippler
EXPOSE 3000 3000
CMD ["npm", "run", "start"]