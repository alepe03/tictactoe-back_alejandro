# Fase 4: Configuración Avanzada

## Objetivo

Configurar el servidor para responder en un dominio local personalizado (`tictactoe.local:4000`) con múltiples instancias de la API que respondan al mismo dominio, garantizando que un mismo cliente sea atendido siempre por el mismo contenedor mediante sticky sessions.

## Arquitectura

La configuración avanzada utiliza:

- **3 instancias de la API:** Para distribuir la carga
- **Nginx como proxy reverso:** Para balancear las peticiones
- **Sticky sessions (ip_hash):** Para garantizar consistencia cliente-contenedor
- **Dominio local personalizado:** `tictactoe.local:4000`

```
Cliente → Nginx (puerto 4000) → [API-1, API-2, API-3] (puerto 8000)
         (balanceo con ip_hash)
```

## Configuración

### 1. Configuración del Dominio Local

Añadimos el dominio local en `/etc/hosts`:

```bash
sudo nano /etc/hosts
```

Añadimos la línea:
```
127.0.0.1   tictactoe.local api.local
```

**Verificación:**
```bash
cat /etc/hosts | grep tictactoe
```

**Resultado:** `127.0.0.1 tictactoe.local`

![Configuración del dominio local en /etc/hosts](images/Captura%20de%20pantalla%202025-11-14%20a%20las%2011.20.04.png)

### 2. Docker Compose Avanzado

Creamos `docker-compose.advanced.yml` con 3 instancias de la API y Nginx:

```yaml
services:
  tictactoe-api-1:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: tictactoe-api-1
    expose:
      - "8000"
    environment:
      - FLASK_ENV=production
      - INSTANCE_ID=1
    restart: unless-stopped
    networks:
      - tictactoe-network

  tictactoe-api-2:
    # ... configuración similar

  tictactoe-api-3:
    # ... configuración similar

  nginx:
    image: nginx:alpine
    container_name: tictactoe-nginx
    ports:
      - "4000:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./nginx-sticky.conf:/etc/nginx/conf.d/default.conf:ro
    depends_on:
      - tictactoe-api-1
      - tictactoe-api-2
      - tictactoe-api-3
    restart: unless-stopped
    networks:
      - tictactoe-network

networks:
  tictactoe-network:
    driver: bridge
```

**Características importantes:**
- Las instancias de API solo exponen el puerto 8000 internamente (no al host)
- Nginx expone el puerto 4000 al host y actúa como proxy
- Todas las instancias están en la misma red Docker

### 3. Configuración de Nginx con Sticky Sessions

#### nginx-sticky.conf

```nginx
upstream tictactoe_backend {
    # Sticky session basado en IP del cliente
    ip_hash;
    
    server tictactoe-api-1:8000;
    server tictactoe-api-2:8000;
    server tictactoe-api-3:8000;
}

server {
    listen 80;
    server_name tictactoe.local api.local *.local;

    access_log /var/log/nginx/tictactoe-access.log main;

    location / {
        proxy_pass http://tictactoe_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        # ... más headers
    }
}
```

**Características:**
- **ip_hash:** Garantiza que peticiones de la misma IP vayan siempre al mismo backend
- **Logs con upstream:** Los logs incluyen información del backend que atendió la petición

## Proceso de Despliegue

### 1. Reconstrucción de Imágenes

Para asegurar que todas las instancias usan Gunicorn, reconstruimos sin caché:

```bash
docker compose -f docker-compose.advanced.yml build --no-cache
```

**Resultado:** Las 3 imágenes se construyeron correctamente.

### 2. Inicio de Servicios

```bash
docker compose -f docker-compose.advanced.yml up -d
```

**Resultado:**
```
[+] Running 5/5
 ✔ Network tictactoe-back_tictactoe-network  Created    0.0s
 ✔ Container tictactoe-api-1                 Started    0.3s
 ✔ Container tictactoe-api-2                 Started    0.3s
 ✔ Container tictactoe-api-3                 Started    0.3s
 ✔ Container tictactoe-nginx                 Started    0.3s
```

![Reconstrucción de imágenes sin caché](images/Captura%20de%20pantalla%202025-11-14%20a%20las%2011.20.04.png)

### 3. Verificación del Estado

```bash
docker compose -f docker-compose.advanced.yml ps
```

**Resultado:**
```
NAME              IMAGE                            COMMAND                  STATUS          PORTS
tictactoe-api-1   tictactoe-back-tictactoe-api-1   "uv run gunicorn --b…"   Up             8000/tcp
tictactoe-api-2   tictactoe-back-tictactoe-api-2   "uv run gunicorn --b…"   Up             8000/tcp
tictactoe-api-3   tictactoe-back-tictactoe-api-3   "uv run gunicorn --b…"   Up             8000/tcp
tictactoe-nginx   nginx:alpine                     "/docker-entrypoint.…"   Up             0.0.0.0:4000->80/tcp
```

**Observaciones importantes:**
- ✅ Las 3 instancias de API están corriendo
- ✅ Todas usan Gunicorn (`"uv run gunicorn --b…"`)
- ✅ Nginx está corriendo y expone el puerto 4000

![4 contenedores corriendo (3 API + 1 Nginx)](images/Captura%20de%20pantalla%202025-11-14%20a%20las%2011.20.34.png)

### 4. Verificación de Logs

Verificamos que todas las instancias iniciaron Gunicorn correctamente:

```bash
docker compose -f docker-compose.advanced.yml logs tictactoe-api-1 | grep -i gunicorn
docker compose -f docker-compose.advanced.yml logs tictactoe-api-2 | grep -i gunicorn
docker compose -f docker-compose.advanced.yml logs tictactoe-api-3 | grep -i gunicorn
```

**Resultado:**
```
tictactoe-api-1  | [2025-11-14 11:18:42 +0000] [10] [INFO] Starting gunicorn 23.0.0
tictactoe-api-2  | [2025-11-14 11:18:42 +0000] [9] [INFO] Starting gunicorn 23.0.0
tictactoe-api-3  | [2025-11-14 11:18:42 +0000] [10] [INFO] Starting gunicorn 23.0.0
```

Todas las instancias están usando Gunicorn correctamente.

![Logs mostrando Gunicorn en las 3 instancias](images/Captura%20de%20pantalla%202025-11-14%20a%20las%2011.20.34.png)

## Verificación de Funcionamiento

### 1. Acceso a Swagger UI

Abrimos el navegador en `http://tictactoe.local:4000/` y verificamos que Swagger UI carga correctamente.

**Características observadas:**
- URL en el navegador: `tictactoe.local:4000`
- Swagger UI carga completamente
- Todos los endpoints están documentados

![Swagger UI funcionando en tictactoe.local:4000](images/Captura%20de%20pantalla%202025-11-14%20a%20las%2011.23.38.png)

### 2. Prueba de Endpoints

#### 2.1. Registro de Dispositivo

Ejecutamos `POST /devices` desde Swagger UI:

- **Request:**
```json
{
  "alias": "dispositivo3"
}
```

- **Respuesta:**
```json
{
  "device_id": "9c8ffc83-2f0d-4333-ad98-a27e51fedf76"
}
```

- **Código:** `201 Created`
- **Server:** `nginx/1.29.3` (confirmando que Nginx está actuando como proxy)

![POST /devices ejecutado mostrando server: nginx/1.29.3](images/Captura%20de%20pantalla%202025-11-14%20a%20las%2011.23.50.png)

#### 2.2. Listado de Dispositivos

Ejecutamos `GET /devices`:

- **Respuesta:**
```json
{
  "connected_devices": [
    "9c8ffc83-2f0d-4333-ad98-a27e51fedf76"
  ]
}
```

- **Código:** `200 OK`
- **Server:** `nginx/1.29.3`

![GET /devices ejecutado mostrando server: nginx/1.29.3](images/Captura%20de%20pantalla%202025-11-14%20a%20las%2011.23.50.png)

### 3. Verificación de Sticky Sessions

Para verificar que sticky sessions funciona correctamente, realizamos múltiples peticiones y verificamos los logs de Nginx:

```bash
# Realizamos 5 peticiones
curl http://tictactoe.local:4000/devices
curl http://tictactoe.local:4000/devices
curl http://tictactoe.local:4000/devices
curl http://tictactoe.local:4000/devices
curl http://tictactoe.local:4000/devices
```

Luego verificamos los logs de Nginx:

```bash
docker compose -f docker-compose.advanced.yml exec nginx cat /var/log/nginx/tictactoe-access.log | grep "upstream:"
```

**Resultado:**
```
151.101.0.223 - - [14/Nov/2025:11:25:38 +0000] "GET /devices HTTP/1.1" 200 144 "-" "curl/8.7.1" "-" upstream: 172.25.0.3:8000
151.101.0.223 - - [14/Nov/2025:11:25:44 +0000] "GET /devices HTTP/1.1" 200 64 "-" "curl/8.7.1" "-" upstream: 172.25.0.3:8000
151.101.0.223 - - [14/Nov/2025:11:25:51 +0000] "GET /devices HTTP/1.1" 200 64 "-" "curl/8.7.1" "-" upstream: 172.25.0.3:8000
151.101.0.223 - - [14/Nov/2025:11:25:59 +0000] "GET /devices HTTP/1.1" 200 64 "-" "curl/8.7.1" "-" upstream: 172.25.0.3:8000
151.101.0.223 - - [14/Nov/2025:11:26:05 +0000] "GET /devices HTTP/1.1" 200 144 "-" "curl/8.7.1" "-" upstream: 172.25.0.3:8000
```

**Análisis crítico:**
- ✅ Todas las peticiones van al mismo upstream: `172.25.0.3:8000`
- ✅ El cliente (IP `151.101.0.223`) siempre es enrutado al mismo backend
- ✅ Esto confirma que sticky sessions funciona correctamente

**Nota:** Aunque las respuestas pueden variar (diferentes dispositivos en cada instancia debido al estado en memoria), el hecho de que todas las peticiones vayan al mismo upstream garantiza consistencia para el mismo cliente.

![Logs de Nginx mostrando sticky sessions (mismo upstream)](images/Captura%20de%20pantalla%202025-11-14%20a%20las%2011.27.18.png)

## Funcionamiento de Sticky Sessions

### ¿Cómo funciona ip_hash?

1. Nginx calcula un hash basado en la IP del cliente
2. Este hash determina qué backend atenderá la petición
3. Todas las peticiones de la misma IP van siempre al mismo backend
4. Esto garantiza consistencia para aplicaciones con estado en memoria

### Ventajas

- **Consistencia:** El mismo cliente siempre ve el mismo estado
- **Simplicidad:** No requiere cookies ni sesiones explícitas
- **Rendimiento:** Balanceo de carga eficiente

### Limitaciones

- Solo funciona con IPs únicas (múltiples usuarios detrás de NAT compartirían el mismo backend)
- Si un backend cae, las peticiones de ese hash se redistribuyen (puede causar pérdida de estado)

## Comparación: Fase 3 vs Fase 4

| Característica | Fase 3 | Fase 4 |
|----------------|--------|--------|
| Instancias | 1 | 3 |
| Balanceador | No | Sí (Nginx) |
| Dominio | localhost:3000 | tictactoe.local:4000 |
| Sticky Sessions | No aplica | Sí (ip_hash) |
| Escalabilidad | Limitada | Alta |
| Alta Disponibilidad | No | Parcial (3 instancias) |

## Resultados de la Fase 4

✅ **Dominio local configurado:** `tictactoe.local:4000` funciona correctamente  
✅ **Múltiples instancias desplegadas:** 3 instancias de la API corriendo  
✅ **Nginx funcionando:** Proxy reverso operativo y balanceando carga  
✅ **Gunicorn en todas las instancias:** Todas usan el servidor WSGI de producción  
✅ **Sticky sessions verificadas:** Todas las peticiones del mismo cliente van al mismo backend  
✅ **API accesible:** Swagger UI funciona correctamente con el dominio personalizado

## Evidencias

- Captura de configuración en `/etc/hosts`
- Captura de `docker compose ps` mostrando 4 contenedores corriendo
- Captura de logs de Gunicorn en las 3 instancias
- Captura de Swagger UI funcionando en `http://tictactoe.local:4000/`
- Captura de `POST /devices` ejecutado desde Swagger UI mostrando `server: nginx/1.29.3`
- Captura de `GET /devices` ejecutado desde Swagger UI
- Captura de logs de Nginx mostrando que todas las peticiones van al mismo upstream (`172.25.0.3:8000`)

## Comandos Útiles

```bash
# Iniciar servicios
docker compose -f docker-compose.advanced.yml up -d

# Ver estado de todos los contenedores
docker compose -f docker-compose.advanced.yml ps

# Ver logs de Nginx
docker compose -f docker-compose.advanced.yml logs nginx

# Ver logs de una instancia específica
docker compose -f docker-compose.advanced.yml logs tictactoe-api-1

# Verificar sticky sessions
docker compose -f docker-compose.advanced.yml exec nginx cat /var/log/nginx/tictactoe-access.log | grep "upstream:"

# Detener servicios
docker compose -f docker-compose.advanced.yml down

# Reconstruir sin caché
docker compose -f docker-compose.advanced.yml build --no-cache
```

