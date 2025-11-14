# Fase 3: Configuración Básica del Servidor

## Objetivo

Configurar el servidor para ejecutar la API TicTacToe y exponerla en `localhost:3000`, verificando el correcto funcionamiento de los endpoints.

## Configuración con Docker Compose

### Archivo docker-compose.yml

Creamos un archivo `docker-compose.yml` para simplificar el despliegue:

```yaml
services:
  tictactoe-api:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: tictactoe-api
    ports:
      - "3000:8000"  # Puerto host:puerto contenedor
    environment:
      - FLASK_ENV=production
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "python", "-c", "import urllib.request; urllib.request.urlopen('http://localhost:8000/')"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
```

**Configuración explicada:**
- **build:** Construye la imagen desde el Dockerfile actual
- **container_name:** Nombre del contenedor
- **ports:** Mapea el puerto 3000 del host al puerto 8000 del contenedor
- **environment:** Variable de entorno para modo producción
- **restart:** Reinicia automáticamente el contenedor si falla
- **healthcheck:** Verifica periódicamente que la API está respondiendo

## Proceso de Despliegue

### 1. Construcción de la Imagen

```bash
docker compose build
```

Esto construye la imagen utilizando el Dockerfile y las dependencias especificadas.

### 2. Inicio del Servicio

```bash
docker compose up -d
```

El flag `-d` ejecuta el contenedor en modo detached (en segundo plano).

**Resultado:**
```
[+] Running 2/2
 ✔ Network tictactoe-back_default  Created    0.0s 
 ✔ Container tictactoe-api         Started    0.3s
```

### 3. Verificación del Estado

Verificamos que el contenedor está corriendo:

```bash
docker compose ps
```

**Resultado:**
```
NAME              IMAGE                            COMMAND                  STATUS          PORTS
tictactoe-api     tictactoe-back-tictactoe-api     "uv run gunicorn --b…"   Up (healthy)    0.0.0.0:3000->8000/tcp
```

![Contenedores corriendo con Docker Compose](images/Captura%20de%20pantalla%202025-11-14%20a%20las%2011.05.10.png)

El contenedor está en estado `Up (healthy)`, indicando que:
- El contenedor está corriendo
- El healthcheck está pasando correctamente
- Gunicorn está funcionando correctamente

### 4. Verificación de Logs

Revisamos los logs para confirmar que Gunicorn se inició correctamente:

```bash
docker compose logs tictactoe-api
```

**Resultado:**
```
tictactoe-api  | [2025-11-14 11:02:01 +0000] [10] [INFO] Starting gunicorn 23.0.0
tictactoe-api  | [2025-11-14 11:02:01 +0000] [10] [INFO] Listening at: http://0.0.0.0:8000 (10)
tictactoe-api  | [2025-11-14 11:02:01 +0000] [10] [INFO] Using worker: sync
tictactoe-api  | [2025-11-14 11:02:01 +0000] [11] [INFO] Booting worker with pid: 11
tictactoe-api  | [2025-11-14 11:02:01 +0000] [12] [INFO] Booting worker with pid: 12
```

Esto confirma que:
- Gunicorn 23.0.0 se inició correctamente
- Está escuchando en el puerto 8000 dentro del contenedor
- Tiene 2 workers activos (pid 11 y 12)

![Logs de Gunicorn con workers iniciados](images/Captura%20de%20pantalla%202025-11-14%20a%20las%2011.05.10.png)

## Verificación de Funcionamiento

### 1. Acceso a Swagger UI

Abrimos el navegador en `http://localhost:3000/` y verificamos que Swagger UI carga correctamente.

![Swagger UI funcionando en localhost:3000](images/Captura%20de%20pantalla%202025-11-14%20a%20las%2011.07.36.png)

### 2. Prueba de Endpoints

#### 2.1. Registro de Dispositivo

Ejecutamos `POST /devices` desde Swagger UI:

- **Request:**
```json
{
  "alias": "Juan"
}
```

- **Respuesta:**
```json
{
  "device_id": "47dabe4c-8473-4f67-85d1-9f262a3d2433"
}
```

- **Código:** `201 Created`
- **Server:** `gunicorn` (confirmando que está usando Gunicorn, no Flask dev server)

![POST /devices ejecutado mostrando server: gunicorn](images/Captura%20de%20pantalla%202025-11-14%20a%20las%2011.07.36.png)

#### 2.2. Listado de Dispositivos

Ejecutamos `GET /devices`:

- **Respuesta:**
```json
{
  "connected_devices": [
    "47dabe4c-8473-4f67-85d1-9f262a3d2433",
    "8cd4b2e2-6c21-4493-877d-97f283884ff8"
  ]
}
```

- **Código:** `200 OK`
- **Server:** `gunicorn`

![GET /devices ejecutado mostrando server: gunicorn](images/Captura%20de%20pantalla%202025-11-14%20a%20las%2011.10.00.png)

### 3. Pruebas con curl

También realizamos pruebas con curl desde la terminal:

```bash
curl http://localhost:3000/
```

**Resultado:** Respuesta HTML de Swagger UI correcta.

```bash
curl -X POST http://localhost:3000/devices \
  -H "Content-Type: application/json" \
  -d '{"alias": "TestDevice"}'
```

**Resultado:** `{"device_id": "..."}` con código `201 Created`.

## Comparación: Desarrollo vs Producción

### Modo Desarrollo (Fase 1)
- **Servidor:** Flask desarrollo server (Werkzeug)
- **Puerto:** 5001
- **Workers:** 1 (single-threaded)
- **Características:** Debug mode, auto-reload

### Modo Producción (Fase 3)
- **Servidor:** Gunicorn (WSGI server)
- **Puerto:** 3000 (mapeado desde 8000 del contenedor)
- **Workers:** 2 (multi-process)
- **Características:** Optimizado para producción, sin debug mode

## Resultados de la Fase 3

✅ **Servidor configurado correctamente:** Docker Compose desplegado sin errores  
✅ **Gunicorn funcionando:** El servidor WSGI está corriendo con 2 workers  
✅ **API accesible:** La API responde correctamente en `http://localhost:3000`  
✅ **Swagger UI funcionando:** La documentación interactiva está accesible  
✅ **Endpoints verificados:** Los endpoints principales funcionan correctamente  
✅ **Healthcheck pasando:** El contenedor está marcado como healthy

## Evidencias

- Captura de `docker compose ps` mostrando el contenedor corriendo
- Captura de los logs de Gunicorn mostrando workers iniciados
- Captura de Swagger UI funcionando en `http://localhost:3000/`
- Captura de `POST /devices` ejecutado desde Swagger UI con respuesta exitosa
- Captura de `GET /devices` mostrando dispositivos conectados
- Captura de respuesta HTTP mostrando `server: gunicorn`

## Comandos Útiles

```bash
# Iniciar servicios
docker compose up -d

# Ver logs
docker compose logs -f tictactoe-api

# Ver estado
docker compose ps

# Detener servicios
docker compose down

# Reconstruir imagen
docker compose build --no-cache
```

