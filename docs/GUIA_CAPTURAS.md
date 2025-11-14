# Guía para Añadir Capturas

Esta guía indica exactamente dónde añadir cada captura en los archivos markdown.

## Pasos para Añadir Capturas

1. **Guarda todas las capturas** en `docs/src/images/` con los nombres indicados
2. **Abre el archivo markdown** correspondiente
3. **Busca el lugar** indicado (busca por "TODO: Captura" o la sección correspondiente)
4. **Añade la línea** con la referencia a la imagen: `![Descripción](images/nombre-archivo.png)`

## Capturas por Fase

### Fase 1: Preparación del Entorno (`fase1.md`)

#### 1. Instalación de dependencias
**Ubicación:** Después de "### 1. Instalación de Dependencias"  
**Nombre archivo:** `fase1-uv-sync.png`  
**Línea a añadir:**
```markdown
![Instalación de dependencias con uv sync](images/fase1-uv-sync.png)
```

#### 2. Tests pasando
**Ubicación:** Después de "### 2. Ejecución de Tests"  
**Nombre archivo:** `fase1-tests.png`  
**Línea a añadir:**
```markdown
![Tests ejecutándose y pasando correctamente](images/fase1-tests.png)
```

#### 3. Flask corriendo en desarrollo
**Ubicación:** Después de "### 3. Ejecución de la Aplicación"  
**Nombre archivo:** `fase1-flask-dev.png`  
**Línea a añadir:**
```markdown
![Flask corriendo en modo desarrollo](images/fase1-flask-dev.png)
```

#### 4. Swagger UI
**Ubicación:** Después de "#### 4.1. Acceso a Swagger UI"  
**Nombre archivo:** `fase1-swagger.png`  
**Línea a añadir:**
```markdown
![Swagger UI funcionando en localhost:5001](images/fase1-swagger.png)
```

#### 5. POST /devices
**Ubicación:** Después de "#### 4.2. Registro de un Dispositivo"  
**Nombre archivo:** `fase1-post-devices.png`  
**Línea a añadir:**
```markdown
![Registro de dispositivo desde Swagger UI](images/fase1-post-devices.png)
```

#### 6. GET /devices
**Ubicación:** Después de "#### 4.3. Listado de Dispositivos"  
**Nombre archivo:** `fase1-get-devices.png`  
**Línea a añadir:**
```markdown
![Listado de dispositivos desde Swagger UI](images/fase1-get-devices.png)
```

### Fase 2: Instalación del Servidor (`fase2.md`)

#### 1. Versiones de Docker
**Ubicación:** Después de "### 1. Verificación de Docker"  
**Nombre archivo:** `fase2-docker-version.png`  
**Línea a añadir:**
```markdown
![Versiones de Docker y Docker Compose](images/fase2-docker-version.png)
```

#### 2. Construcción de imagen
**Ubicación:** Después de "### 2. Construcción de la Imagen Docker"  
**Nombre archivo:** `fase2-docker-build.png`  
**Línea a añadir:**
```markdown
![Proceso de construcción de la imagen Docker](images/fase2-docker-build.png)
```

#### 3. Imagen creada
**Ubicación:** Después de "### 3. Verificación de la Imagen"  
**Nombre archivo:** `fase2-imagen-creada.png`  
**Línea a añadir:**
```markdown
![Imagen Docker creada correctamente](images/fase2-imagen-creada.png)
```

#### 4. Gunicorn iniciándose
**Ubicación:** Después de "### 4. Prueba de la Imagen"  
**Nombre archivo:** `fase2-gunicorn-logs.png`  
**Línea a añadir:**
```markdown
![Gunicorn iniciándose correctamente](images/fase2-gunicorn-logs.png)
```

### Fase 3: Configuración Básica (`fase3.md`)

#### 1. Contenedores corriendo
**Ubicación:** Después de "### 3. Verificación del Estado"  
**Nombre archivo:** `fase3-compose-ps.png`  
**Línea a añadir:**
```markdown
![Contenedores corriendo con Docker Compose](images/fase3-compose-ps.png)
```

#### 2. Logs de Gunicorn
**Ubicación:** Después de "### 4. Verificación de Logs"  
**Nombre archivo:** `fase3-gunicorn-logs.png`  
**Línea a añadir:**
```markdown
![Logs de Gunicorn con workers iniciados](images/fase3-gunicorn-logs.png)
```

#### 3. Swagger UI en localhost:3000
**Ubicación:** Después de "### 1. Acceso a Swagger UI"  
**Nombre archivo:** `fase3-swagger.png`  
**Línea a añadir:**
```markdown
![Swagger UI funcionando en localhost:3000](images/fase3-swagger.png)
```

#### 4. POST /devices (server: gunicorn)
**Ubicación:** Después de "#### 2.1. Registro de Dispositivo"  
**Nombre archivo:** `fase3-post-devices.png`  
**Línea a añadir:**
```markdown
![POST /devices ejecutado mostrando server: gunicorn](images/fase3-post-devices.png)
```

#### 5. GET /devices (server: gunicorn)
**Ubicación:** Después de "#### 2.2. Listado de Dispositivos"  
**Nombre archivo:** `fase3-get-devices.png`  
**Línea a añadir:**
```markdown
![GET /devices ejecutado mostrando server: gunicorn](images/fase3-get-devices.png)
```

### Fase 4: Configuración Avanzada (`fase4.md`)

#### 1. Configuración en /etc/hosts
**Ubicación:** Después de "### 1. Configuración del Dominio Local"  
**Nombre archivo:** `fase4-hosts.png`  
**Línea a añadir:**
```markdown
![Configuración del dominio local en /etc/hosts](images/fase4-hosts.png)
```

#### 2. 4 contenedores corriendo
**Ubicación:** Después de "### 3. Verificación del Estado"  
**Nombre archivo:** `fase4-4-contenedores.png`  
**Línea a añadir:**
```markdown
![4 contenedores corriendo (3 API + 1 Nginx)](images/fase4-4-contenedores.png)
```

#### 3. Gunicorn en todas las instancias
**Ubicación:** Después de "### 4. Verificación de Logs"  
**Nombre archivo:** `fase4-gunicorn-todas.png`  
**Línea a añadir:**
```markdown
![Logs mostrando Gunicorn en las 3 instancias](images/fase4-gunicorn-todas.png)
```

#### 4. Swagger UI en tictactoe.local:4000
**Ubicación:** Después de "### 1. Acceso a Swagger UI"  
**Nombre archivo:** `fase4-swagger.png`  
**Línea a añadir:**
```markdown
![Swagger UI funcionando en tictactoe.local:4000](images/fase4-swagger.png)
```

#### 5. POST /devices (server: nginx)
**Ubicación:** Después de "#### 2.1. Registro de Dispositivo"  
**Nombre archivo:** `fase4-post-devices.png`  
**Línea a añadir:**
```markdown
![POST /devices ejecutado mostrando server: nginx/1.29.3](images/fase4-post-devices.png)
```

#### 6. GET /devices (server: nginx)
**Ubicación:** Después de "#### 2.2. Listado de Dispositivos"  
**Nombre archivo:** `fase4-get-devices.png`  
**Línea a añadir:**
```markdown
![GET /devices ejecutado mostrando server: nginx/1.29.3](images/fase4-get-devices.png)
```

#### 7. Sticky sessions funcionando
**Ubicación:** Después de "### 3. Verificación de Sticky Sessions"  
**Nombre archivo:** `fase4-sticky-sessions.png`  
**Línea a añadir:**
```markdown
![Logs de Nginx mostrando sticky sessions (mismo upstream)](images/fase4-sticky-sessions.png)
```

## Ejemplo Completo

En `fase1.md`, después de la sección "### 1. Instalación de Dependencias", añade:

```markdown
### 1. Instalación de Dependencias

Primeramente, instalamos todas las dependencias necesarias utilizando `uv`:

```bash
uv sync
```

![Instalación de dependencias con uv sync](images/fase1-uv-sync.png)

Este comando:
- Crea un entorno virtual en `.venv`
...
```

## Notas Importantes

1. **Nombres de archivos:** Usa nombres descriptivos y consistentes
2. **Formato:** Las capturas pueden ser `.png`, `.jpg`, o `.jpeg`
3. **Tamaño:** Intenta que las capturas no sean demasiado grandes (comprimir si es necesario)
4. **Calidad:** Asegúrate de que el texto en las capturas sea legible

## Verificar que Funciona

Después de añadir las capturas:

```bash
cd docs
mdbook build
mdbook serve
```

Abre `http://localhost:3000` y verifica que todas las imágenes se muestran correctamente.

