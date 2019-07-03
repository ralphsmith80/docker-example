# Add build process to Dockerfile
FROM node:10.15 as build-deps
WORKDIR /usr/src/app
COPY package.json package-lock.json ./
RUN npm ci
COPY . ./
RUN npm run build

# Add production environment to the SAME Dockerfile
ENV API_HOST=192.168.232.17
ENV API_PORT=3001
FROM nginx:1.12-alpine
# FROM nginx:1.13.8-alpine-perl
COPY ./nginx/proxy.conf /etc/nginx/proxy.conf
COPY ./nginx/gzip.conf /etc/nginx/gzip.conf
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=build-deps /usr/src/app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

# Build the image!
# docker build . -t cb/docker-example

# Run it locally to test it works!
# docker run -p 8080:80 cb/docker-example

# Start reverse proxy server on host
# npx http-server --gzip --proxy http://localhost:3001? -p 3001

# # list container
# docker ps -aq
# # stop all containers
# docker stop $(docker ps -aq)
# # remove all containers
# docker rm $(docker ps -aq)
# # remove all images
# docker rmi $(docker images -q)


# FROM nginx:1.12-alpine
# RUN ls /usr/share/nginx/html

# FROM openresty/openresty:1.15.8.1-alpine
# # RUN cat /etc/nginx/conf.d/default.conf
# RUN cat /usr/local/openresty/nginx/conf/nginx.conf

# docker run -p 8080:80 -e API_HOST='192.168.232.17' cb/docker-example