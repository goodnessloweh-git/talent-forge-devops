FROM nginx:alpine-version

COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80
