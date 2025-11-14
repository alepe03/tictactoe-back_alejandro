# Fase 2: Instalación del Servidor de Aplicaciones

## Objetivo

Instalar un servidor o entorno de ejecución adecuado para la aplicación en un contenedor Docker, justificando la elección del entorno y documentando el proceso de instalación.

## Justificación de la Elección

### Gunicorn como Servidor WSGI

Elegimos **Gunicorn** como servidor WSGI de producción por las siguientes razones:

1. **Servidor de producción:** Diseñado específicamente para ejecutar aplicaciones Python en producción
2. **Múltiples workers:** Permite manejar múltiples peticiones concurrentes de forma eficiente
3. **Estabilidad:** Ampliamente usado y probado en producción
4. **Compatibilidad:** Totalmente compatible con Flask y otras aplicaciones WSGI
5. **Configuración sencilla:** Fácil de configurar y personalizar según las necesidades

### Docker como Contenedorización

Elegimos **Docker** por las siguientes razones:

1. **Reproducibilidad:** Garantiza que la aplicación funcione igual en cualquier entorno
2. **Aislamiento:** Evita conflictos con otras aplicaciones o dependencias del sistema
3. **Escalabilidad:** Facilita el despliegue de múltiples instancias
4. **Portabilidad:** Fácil de desplegar en diferentes plataformas (Linux, macOS, Windows)
5. **Gestión de dependencias:** Simplifica la gestión de dependencias del sistema

### Imagen Base Python 3.12-slim

Elegimos **python:3.12-slim** como imagen base porque:

- **Ligera:** Versión optimizada que ocupa menos espacio
- **Actual:** Versión moderna de Python con mejor rendimiento
- **Estable:** Versión estable y probada

## Proceso de Instalación

### 1. Verificación de Docker

Primero verificamos que Docker está instalado y funcionando:

```bash
docker --version
docker compose version
```

**Resultado:**
```
Docker version 28.4.0, build d8eb465
Docker Compose version v2.39.4-desktop.1
```

![Versiones de Docker y Docker Compose](images/Captura%20de%20pantalla%202025-11-14%20a%20las%2010.58.49.png)

### 2. Construcción de la Imagen Docker

Construimos la imagen Docker con el siguiente comando:

```bash
docker build -t tictactoe-api:latest .
```

El Dockerfile realiza las siguientes operaciones:

1. **Imagen base:** `FROM python:3.12-slim`
2. **Instalación de uv:** `RUN pip install --no-cache-dir uv`
3. **Copia de dependencias:** `COPY pyproject.toml uv.lock ./`
4. **Instalación de dependencias:** `RUN uv sync --frozen`
5. **Copia del código:** `COPY . .`
6. **Exposición del puerto:** `EXPOSE 8000`
7. **Comando de inicio:** `CMD ["uv", "run", "gunicorn", "--bind", "0.0.0.0:8000", "--workers", "2", "--timeout", "120", "--access-logfile", "-", "--error-logfile", "-", "wsgi:app"]`

**Parámetros de Gunicorn:**
- `--bind 0.0.0.0:8000`: Escucha en todas las interfaces en el puerto 8000
- `--workers 2`: Dos workers para manejar múltiples peticiones
- `--timeout 120`: Timeout de 120 segundos
- `--access-logfile -`: Logs de acceso a stdout
- `--error-logfile -`: Logs de error a stderr
- `wsgi:app`: Módulo wsgi, aplicación app

**Resultado del build:**
```
[+] Building 5.4s (12/12) FINISHED
 => [1/6] FROM docker.io/library/python:3.12-slim
 => [2/6] WORKDIR /app
 => [3/6] RUN pip install --no-cache-dir uv
 => [4/6] COPY pyproject.toml uv.lock ./
 => [5/6] RUN uv sync --frozen
 => [6/6] COPY . .
 => exporting to image
Successfully built tictactoe-api:latest
```

![Proceso de construcción de la imagen Docker](images/Captura%20de%20pantalla%202025-11-14%20a%20las%2010.59.03.png)

### 3. Verificación de la Imagen

Verificamos que la imagen se creó correctamente:

```bash
docker images | grep tictactoe
```

**Resultado:**
```
tictactoe-api   latest   8257c3cb36d8   10 seconds ago   313MB
```

La imagen tiene un tamaño de 313MB y contiene toda la aplicación con sus dependencias.

![Imagen Docker creada correctamente](images/Captura%20de%20pantalla%202025-11-14%20a%20las%2010.59.03.png)

### 4. Prueba de la Imagen (Opcional)

Realizamos una prueba rápida para verificar que la imagen funciona correctamente:

```bash
docker run --rm -p 8000:8000 tictactoe-api:latest
```

**Resultado:** Gunicorn se inicia correctamente:

```
[2025-11-14 10:58:17 +0000] [10] [INFO] Starting gunicorn 23.0.0
[2025-11-14 10:58:17 +0000] [10] [INFO] Listening at: http://0.0.0.0:8000 (10)
[2025-11-14 10:58:17 +0000] [10] [INFO] Using worker: sync
[2025-11-14 10:58:17 +0000] [11] [INFO] Booting worker with pid: 11
[2025-11-14 10:58:17 +0000] [12] [INFO] Booting worker with pid: 12
```

Verificamos que responde correctamente:

```bash
curl http://localhost:8000/
```

**Resultado:** La API responde correctamente con el HTML de Swagger UI.

![Gunicorn iniciándose correctamente](images/Captura%20de%20pantalla%202025-11-14%20a%20las%2010.59.03.png)

## Configuración del Dockerfile

El Dockerfile utilizado tiene la siguiente estructura:

```dockerfile
FROM python:3.12-slim
WORKDIR /app
RUN pip install --no-cache-dir uv
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen
COPY . .
EXPOSE 8000
CMD ["uv", "run", "gunicorn", "--bind", "0.0.0.0:8000", "--workers", "2", "--timeout", "120", "--access-logfile", "-", "--error-logfile", "-", "wsgi:app"]
```

### Explicación de las Capas

1. **Capa 1:** Imagen base Python 3.12-slim
2. **Capa 2:** Directorio de trabajo `/app`
3. **Capa 3:** Instalación de `uv`
4. **Capa 4:** Copia de archivos de dependencias
5. **Capa 5:** Instalación de dependencias (esta capa se cachea si no cambian las dependencias)
6. **Capa 6:** Copia del código de la aplicación

Esta estructura optimiza el uso de la caché de Docker, permitiendo reconstruir más rápido cuando solo cambia el código.

## Resultados de la Fase 2

✅ **Docker instalado y funcionando:** Docker y Docker Compose están correctamente instalados  
✅ **Imagen construida correctamente:** La imagen Docker se construyó sin errores  
✅ **Gunicorn configurado:** El servidor WSGI está correctamente configurado  
✅ **Verificación exitosa:** La imagen funciona correctamente y la API responde

## Evidencias

- Captura de las versiones de Docker y Docker Compose
- Captura del proceso de construcción de la imagen Docker
- Captura de la imagen creada (`docker images`)
- Captura de Gunicorn iniciándose correctamente
- Captura de la API respondiendo desde el contenedor

