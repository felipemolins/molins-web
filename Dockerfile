FROM nginx:alpine

# Eliminar config default de nginx
RUN rm /etc/nginx/conf.d/default.conf

# Copiar configuración personalizada
COPY nginx.conf /etc/nginx/conf.d/djmolins.conf

# Copiar el sitio
COPY index.html /usr/share/nginx/html/index.html

# Puerto interno (Cloudflare Tunnel apuntará aquí)
EXPOSE 8080

# Nginx en foreground para Docker
CMD ["nginx", "-g", "daemon off;"]
