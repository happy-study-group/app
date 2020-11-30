FROM mhart/alpine-node:10.21.0

RUN mkdir -p /home/app
WORKDIR /home/app
COPY . /home/app
RUN npm i
RUN npm run build

EXPOSE 3000

CMD [ "sh", "-c", "npm run start" ]