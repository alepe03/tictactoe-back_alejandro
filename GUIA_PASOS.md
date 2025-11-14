# Guía Paso a Paso - Despliegue TicTacToe API

Esta guía te indica exactamente qué hacer en cada fase para completar el proyecto de despliegue.

---

## 📋 **FASE 1: Preparación del Entorno de Ejecución**

### Objetivo
Verificar que la aplicación funciona correctamente en local antes de contenedorizarla.

### Pasos a seguir:

1. **Instalar dependencias:**
   ```bash
   uv sync
   ```
   *Captura: Muestra la salida del comando con las dependencias instaladas*

2. **Ejecutar los tests:**
   ```bash
   uv run pytest -v
   ```
   *Captura: Muestra todos los tests pasando correctamente*

3. **Ejecutar la aplicación en modo desarrollo:**
   ```bash
   uv run python main.py
   ```
   *Captura: Muestra el servidor Flask iniciándose en `http://127.0.0.1:5001`*
   
   **NOTA:** En macOS, el puerto 5000 está ocupado por AirPlay. Por eso usamos el puerto 5001.

4. **Probar endpoints básicos - ELEGIR UNA OPCION:**

   **OPCIÓN A: Usar Swagger UI (RECOMENDADO para capturas)**
   
   - Abre `http://localhost:5001/` en tu navegador
   - Verás la documentación interactiva de la API
   - Expande `POST /devices` y haz clic en "Try it out"
   - Puedes usar `{"alias": "MiDispositivo"}` o simplemente `{}` (dejar vacío)
   - Haz clic en "Execute" y verás la respuesta con el `device_id`
   - Prueba también `GET /devices` para listar los dispositivos
   *Captura: Swagger UI mostrando la prueba del endpoint y la respuesta JSON*
   
   **OPCIÓN B: Usar Postman**
   
   - Crea una petición POST a `http://localhost:5001/devices`
   - Headers: `Content-Type: application/json`
   - Body (raw JSON): `{"alias": "Dispositivo1"}` (puedes cambiar el alias)
   - Envía la petición y verás la respuesta con el `device_id`
   *Captura: Postman con la petición y respuesta*
   
   **OPCIÓN C: Usar curl (terminal)**
   
   ```bash
   # Registrar un dispositivo (puedes cambiar el alias o dejarlo vacío)
   curl -X POST http://localhost:5001/devices \
     -H "Content-Type: application/json" \
     -d '{"alias": "Dispositivo1"}'
   ```
   *Captura: Respuesta JSON con `device_id` en la terminal*
   
   ```bash
   # Listar dispositivos
   curl http://localhost:5001/devices
   ```
   *Captura: Lista de dispositivos conectados*
   
   **NOTA:** El campo `alias` es OPCIONAL. Puedes:
   - Usar cualquier nombre: `{"alias": "MiDispositivo"}`
   - O dejarlo vacío: `{}` o no enviarlo
   - Si no envías alias, se generará uno automáticamente

---

## 🐳 **FASE 2: Instalación del Servidor de Aplicaciones (Docker + Gunicorn)**

### Objetivo
Contenedorizar la aplicación con Docker usando Gunicorn como servidor WSGI.

### Justificación de la elección:
- **Gunicorn**: Servidor WSGI de producción para Flask, maneja múltiples workers, estable y eficiente
- **Docker**: Aislamiento completo, reproducibilidad, fácil despliegue
- **Python 3.12-slim**: Imagen ligera y optimizada

### Pasos a seguir:

1. **Verificar que Docker está instalado:**
   ```bash
   docker --version
   docker-compose --version
   ```
   *Captura: Versiones de Docker y Docker Compose*

2. **Construir la imagen Docker:**
   ```bash
   docker build -t tictactoe-api:latest .
   ```
   *Captura: Proceso de construcción de la imagen (muestra las capas)*

3. **Verificar que la imagen se creó:**
   ```bash
   docker images | grep tictactoe
   ```
   *Captura: Lista de imágenes mostrando `tictactoe-api`*

4. **Ejecutar un contenedor de prueba (opcional, para verificar):**
   ```bash
   docker run --rm -p 8000:8000 tictactoe-api:latest
   ```
   *Captura: Logs del contenedor mostrando Gunicorn iniciándose*
   
   En otra terminal, probar:
   ```bash
   curl http://localhost:8000/
   ```
   *Captura: Respuesta de la API desde el contenedor*
   
   Detener con `Ctrl+C`

---

## ⚙️ **FASE 3: Configuración Básica del Servidor**

### Objetivo
Configurar Docker Compose para ejecutar la API en `localhost:3000`.

### Pasos a seguir:

1. **Iniciar el servicio con Docker Compose:**
   ```bash
   docker-compose up -d
   ```
   *Captura: Contenedores iniciándose*

2. **Verificar que el contenedor está corriendo:**
   ```bash
   docker-compose ps
   ```
   *Captura: Estado de los contenedores (Status: Up)*

3. **Ver los logs del contenedor:**
   ```bash
   docker-compose logs -f tictactoe-api
   ```
   *Captura: Logs de Gunicorn mostrando workers iniciados*
   
   Salir con `Ctrl+C`

4. **Probar la API en `localhost:3000`:**
   
   **Health check básico:**
   ```bash
   curl http://localhost:3000/
   ```
   *Captura: Respuesta JSON o HTML de la API*
   
   **Registrar un dispositivo:**
   ```bash
   curl -X POST http://localhost:3000/devices \
     -H "Content-Type: application/json" \
     -d '{"alias": "TestDevice"}'
   ```
   *Captura: Respuesta con `device_id`*
   
   **Listar dispositivos:**
   ```bash
   curl http://localhost:3000/devices
   ```
   *Captura: Lista de dispositivos*
   
   **Acceder a Swagger UI:**
   - Abre `http://localhost:3000/` en el navegador
   *Captura: Swagger UI funcionando en localhost:3000*

5. **Verificar con Postman o herramienta similar (opcional pero recomendado):**
   - Importa los endpoints
   - Prueba varios endpoints
   *Captura: Postman con peticiones exitosas*

6. **Detener los contenedores:**
   ```bash
   docker-compose down
   ```
   *Captura: Contenedores deteniéndose*

---

## 🚀 **FASE 4: Configuración Avanzada (Máxima Calificación)**

### Objetivo
Configurar dominio local `tictactoe.local:4000` con múltiples instancias y sticky sessions.

### Pasos a seguir:

1. **Configurar el dominio local en `/etc/hosts` (macOS/Linux):**
   
   ```bash
   sudo nano /etc/hosts
   ```
   
   Añade esta línea:
   ```
   127.0.0.1   tictactoe.local api.local
   ```
   
   Guarda y cierra (`Ctrl+X`, luego `Y`, luego `Enter`)
   
   Verificar:
   ```bash
   cat /etc/hosts | grep tictactoe
   ```
   *Captura: Línea añadida en `/etc/hosts`*

2. **Iniciar los servicios con la configuración avanzada:**
   ```bash
   docker-compose -f docker-compose.advanced.yml up -d
   ```
   *Captura: Múltiples contenedores iniciándose (3 instancias de API + nginx)*

3. **Verificar todos los contenedores están corriendo:**
   ```bash
   docker-compose -f docker-compose.advanced.yml ps
   ```
   *Captura: Estado de todos los contenedores (4 en total: 3 API + 1 nginx)*

4. **Ver logs de nginx:**
   ```bash
   docker-compose -f docker-compose.advanced.yml logs nginx
   ```
   *Captura: Logs de nginx sin errores*

5. **Ver logs de una instancia de API:**
   ```bash
   docker-compose -f docker-compose.advanced.yml logs tictactoe-api-1
   ```
   *Captura: Logs de Gunicorn funcionando*

6. **Probar el dominio local:**
   
   ```bash
   curl http://tictactoe.local:4000/
   ```
   *Captura: Respuesta de la API a través de nginx*
   
   **Registrar dispositivo:**
   ```bash
   curl -X POST http://tictactoe.local:4000/devices \
     -H "Content-Type: application/json" \
     -d '{"alias": "Cliente1"}'
   ```
   *Captura: Respuesta con `device_id`*
   
   Guarda el `device_id` recibido

7. **Verificar sticky sessions (cliente siempre va al mismo contenedor):**
   
   **Hacer varias peticiones desde la misma IP:**
   ```bash
   # Repite esta petición varias veces (5-10 veces)
   curl http://tictactoe.local:4000/devices
   ```
   
   **Verificar en los logs de nginx que siempre va al mismo backend:**
   ```bash
   docker-compose -f docker-compose.advanced.yml logs nginx | grep "upstream:"
   ```
   *Captura: Logs mostrando que las peticiones del mismo cliente van siempre al mismo upstream (ej: `upstream: 172.x.x.x:8000`)*
   
   Nota: Deberías ver que todas las peticiones van al mismo servidor backend (tictactoe-api-1, tictactoe-api-2 o tictactoe-api-3) cuando provienen de la misma IP.

8. **Probar con múltiples clientes simulados (opcional pero recomendado):**
   
   Puedes usar herramientas como `ab` (Apache Bench) o hacer peticiones desde diferentes terminales:
   
   ```bash
   # Terminal 1 (simula cliente 1)
   while true; do curl -s http://tictactoe.local:4000/devices > /dev/null; sleep 1; done
   
   # Terminal 2 (simula cliente 2)
   while true; do curl -s http://tictactoe.local:4000/devices > /dev/null; sleep 1; done
   ```
   
   Luego verifica los logs:
   ```bash
   docker-compose -f docker-compose.advanced.yml logs nginx | tail -20
   ```
   *Captura: Logs mostrando diferentes IPs siendo enrutadas a diferentes backends (sticky sessions funcionando)*

9. **Verificar en el navegador:**
   - Abre `http://tictactoe.local:4000/` en tu navegador
   - Verifica que Swagger UI carga correctamente
   *Captura: Swagger UI funcionando con el dominio personalizado*

10. **Limpiar cuando termines:**
    ```bash
    docker-compose -f docker-compose.advanced.yml down
    ```

---

## 📝 **Resumen de Comandos Importantes**

```bash
# Desarrollo local
uv sync                          # Instalar dependencias
uv run pytest                   # Ejecutar tests
uv run python main.py           # Ejecutar en desarrollo

# Docker - Fase 2 y 3
docker build -t tictactoe-api . # Construir imagen
docker-compose up -d            # Iniciar (fase 3)
docker-compose down             # Detener
docker-compose logs -f          # Ver logs

# Docker - Fase 4
docker-compose -f docker-compose.advanced.yml up -d    # Iniciar configuración avanzada
docker-compose -f docker-compose.advanced.yml down     # Detener
docker-compose -f docker-compose.advanced.yml ps       # Ver estado
docker-compose -f docker-compose.advanced.yml logs nginx  # Ver logs de nginx

# Pruebas con curl
curl http://localhost:3000/                           # Fase 3
curl http://tictactoe.local:4000/                     # Fase 4
curl -X POST http://localhost:3000/devices -H "Content-Type: application/json" -d '{"alias": "Test"}'
```

---

## 🎯 **Checklist de Capturas Necesarias**

- [ ] Fase 1: Tests pasando
- [ ] Fase 1: API corriendo en local (Flask dev server)
- [ ] Fase 1: Pruebas con curl funcionando
- [ ] Fase 1: Swagger UI en localhost:5000
- [ ] Fase 2: Construcción de imagen Docker
- [ ] Fase 2: Imagen creada (`docker images`)
- [ ] Fase 3: Contenedores corriendo (`docker-compose ps`)
- [ ] Fase 3: API funcionando en localhost:3000 (curl)
- [ ] Fase 3: Swagger UI en localhost:3000
- [ ] Fase 4: Configuración en `/etc/hosts`
- [ ] Fase 4: Todos los contenedores corriendo (4 contenedores)
- [ ] Fase 4: API funcionando en tictactoe.local:4000
- [ ] Fase 4: Logs de nginx mostrando sticky sessions
- [ ] Fase 4: Swagger UI en tictactoe.local:4000

---

¡Buena suerte con tu proyecto! 🚀

