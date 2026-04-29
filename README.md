# DJ MOLINS — Landing Page
## Despliegue con Docker + Portainer + Cloudflare Zero Trust

```
Internet → Cloudflare (HTTPS/WAF) → cloudflared tunnel → contenedor djmolins:8080
```

---

## Archivos del proyecto

```
djmolins/
├── Dockerfile           # Imagen self-contained (nginx:alpine + sitio)
├── docker-compose.yml   # Stack para Portainer
├── nginx.conf           # Config de Nginx dentro del contenedor
├── index.html           # Landing page completa
└── README.md            # Este archivo
```

---

## Opción A — Portainer (recomendado)

### 1. Sube los archivos al servidor Proxmox

```bash
scp -r ./djmolins/ usuario@IP-PROXMOX:/opt/stacks/djmolins/
```

### 2. Construye la imagen en el servidor

```bash
cd /opt/stacks/djmolins
docker build -t djmolins:latest .
```

### 3. Despliega el stack desde Portainer

- Abre Portainer → **Stacks** → **Add stack**
- Nombre: `djmolins`
- Selecciona **Upload** y sube el `docker-compose.yml`  
  *(o pega su contenido en el editor web)*
- Clic en **Deploy the stack**

El contenedor quedará corriendo y escuchando en `127.0.0.1:8080` del host.

---

## Opción B — Línea de comandos directa

```bash
cd /opt/stacks/djmolins
docker compose up -d --build
```

---

## Configurar Cloudflare Zero Trust Tunnel

### Si cloudflared corre como servicio del sistema (host)

En el dashboard de Cloudflare Zero Trust:

```
Networks → Tunnels → tu túnel → Edit → Public Hostnames → Add
```

| Campo     | Valor           |
|-----------|-----------------|
| Subdomain | (vacío o www)   |
| Domain    | molins.cl       |
| Type      | HTTP            |
| URL       | localhost:8080  |

### Si cloudflared corre como contenedor Docker en la misma red

Agrega `cloudflared` al `docker-compose.yml` y usa como URL:

```
djmolins:8080
```

Y en el tunnel configura:
```
Type : HTTP
URL  : djmolins:8080
```

---

## Comandos útiles

```bash
# Ver estado del contenedor
docker ps | grep djmolins

# Ver logs en tiempo real
docker logs -f djmolins

# Reiniciar el contenedor
docker restart djmolins

# Actualizar el sitio (después de editar index.html)
docker build -t djmolins:latest .
docker compose up -d --build
```

---

## Actualizar el sitio

1. Edita `index.html` con tus cambios
2. Reconstruye e reinicia:

```bash
docker compose up -d --build
```

No se pierde downtime significativo — Docker levanta el nuevo contenedor antes de bajar el viejo.

---

## Personalización pendiente

Antes de desplegar, reemplaza en `index.html`:

| Placeholder      | Reemplazar con          |
|------------------|-------------------------|
| `56912345678`    | Tu número de WhatsApp   |
| `contacto@molins.cl` | Tu correo real      |
