FROM nginx:alpine
 
RUN apk add --no-cache curl && \
    rm /etc/nginx/conf.d/default.conf
 
COPY nginx.conf /etc/nginx/conf.d/djmolins.conf
COPY index.html /usr/share/nginx/html/index.html
 
EXPOSE 8080
 
CMD ["nginx", "-g", "daemon off;"]
