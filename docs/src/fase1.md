# Fase 1: Preparación del Entorno de Ejecución

## Objetivo

Preparar la aplicación TicTacToe con toda su estructura de proyecto, verificar su correcto funcionamiento en local y comprobar que la API responde adecuadamente a las peticiones básicas.

## Pasos Realizados

### 1. Instalación de Dependencias

Primeramente, instalamos todas las dependencias necesarias utilizando `uv`:

```bash
uv sync
```

Este comando:
- Crea un entorno virtual en `.venv`
- Resuelve las dependencias del proyecto
- Instala los paquetes necesarios (Flask, Flask-RESTX, Gunicorn, pytest, etc.)

**Resultado:** Se instalaron 22 paquetes correctamente, incluyendo:
- `flask==3.1.2`
- `flask-restx==1.3.2`
- `gunicorn==23.0.0`
- `pytest==8.4.2`
- Y otras dependencias relacionadas

![Instalación de dependencias con uv sync](images/Captura%20de%20pantalla%202025-11-14%20a%20las%2010.44.00.png)

### 2. Ejecución de Tests

Para verificar que la aplicación funciona correctamente, ejecutamos los tests:

```bash
uv run pytest -v
```

**Resultado:** Todos los tests pasaron correctamente:

```
test_register_device PASSED [ 8%]
test_unregister_device PASSED [16%]
test_list_devices PASSED [25%]
test_create_match PASSED [33%]
test_make_move_and_turn_change PASSED [41%]
test_invalid_turn PASSED [50%]
test_cell_occupied PASSED [58%]
test_sync_game PASSED [66%]
test_device_status_connected PASSED [75%]
test_device_status_disconnected PASSED [83%]
test_device_stats_global PASSED [91%]
test_full_game_flow_x_wins PASSED [100%]

======================== 12 passed in 0.70s ========================
```

Esto confirma que la aplicación funciona correctamente y todos los endpoints están implementados como se espera.

![Tests ejecutándose y pasando correctamente](images/Captura%20de%20pantalla%202025-11-14%20a%20las%2010.44.29.png)

### 3. Ejecución de la Aplicación en Modo Desarrollo

Ejecutamos la aplicación en modo desarrollo:

```bash
uv run python main.py
```

**Nota importante:** En macOS, el puerto 5000 está ocupado por AirPlay (sistema de Apple), por lo que modificamos la aplicación para usar el puerto 5001.

**Resultado:** La aplicación Flask se inicia correctamente:

```
 * Serving Flask app 'main'
 * Debug mode: on
 * Running on http://127.0.0.1:5001
```

La API queda accesible en `http://localhost:5001`

![Flask corriendo en modo desarrollo](images/Captura%20de%20pantalla%202025-11-14%20a%20las%2010.57.20.png)

### 4. Prueba de Endpoints Básicos

Probamos los endpoints utilizando Swagger UI, la interfaz de documentación interactiva integrada.

#### 4.1. Acceso a Swagger UI

Abrimos el navegador en `http://localhost:5001/` y verificamos que Swagger UI carga correctamente, mostrando toda la documentación de la API.

![Swagger UI funcionando en localhost:5001](images/Captura%20de%20pantalla%202025-11-14%20a%20las%2010.53.42.png)

#### 4.2. Registro de un Dispositivo

Mediante Swagger UI, ejecutamos el endpoint `POST /devices`:

- **Request body:**
```json
{
  "Alejandro": "Dispositivo1"
}
```

- **Respuesta:**
```json
{
  "device_id": "af526220-99fd-4905-8f00-d04e9751aa12"
}
```

- **Código de estado:** `201 Created`
- **Server:** `Werkzeug/3.1.3 Python/3.13.7` (servidor de desarrollo Flask)

Esto confirma que el endpoint funciona correctamente y asigna un identificador único a cada dispositivo.

![Registro de dispositivo desde Swagger UI](images/Captura%20de%20pantalla%202025-11-14%20a%20las%2010.54.17.png)

#### 4.3. Listado de Dispositivos

Ejecutamos el endpoint `GET /devices` para listar todos los dispositivos conectados:

- **Respuesta:**
```json
{
  "connected_devices": [
    "cc8c0daf-4f9e-47fc-919f-5a16e20fe1f5",
    "af526220-99fd-4905-8f00-d04e9751aa12"
  ]
}
```

- **Código de estado:** `200 OK`

Esto confirma que la gestión de dispositivos funciona correctamente.

![Listado de dispositivos desde Swagger UI](images/Captura%20de%20pantalla%202025-11-14%20a%20las%2010.54.17.png)

## Resultados de la Fase 1

✅ **Estructura completa del proyecto:** Todos los archivos necesarios están presentes  
✅ **Dependencias instaladas:** Todas las dependencias se instalaron correctamente  
✅ **Tests pasando:** Los 12 tests pasan sin errores  
✅ **API funcionando en local:** La aplicación Flask se ejecuta correctamente en el puerto 5001  
✅ **Swagger UI accesible:** La documentación interactiva está disponible y funcional  
✅ **Endpoints verificados:** Los endpoints básicos responden correctamente

## Evidencias

- Captura de la instalación de dependencias con `uv sync`
- Captura de todos los tests pasando correctamente
- Captura de la aplicación Flask corriendo en modo desarrollo
- Captura de Swagger UI funcionando en `http://localhost:5001/`
- Captura de registro de dispositivo (`POST /devices`) con respuesta exitosa
- Captura de listado de dispositivos (`GET /devices`) mostrando dispositivos conectados

