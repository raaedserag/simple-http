FROM node:18.12.1-alpine
WORKDIR /usr/http-app

ARG dynamic_node_env
ENV NODE_ENV=$dynamic_node_env
COPY . .
RUN npm ci

EXPOSE 8080
ENTRYPOINT ["npm"]
CMD ["start"]
