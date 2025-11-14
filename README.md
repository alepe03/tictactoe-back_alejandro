# TicTacToe API Backend

API REST del juego de TicTacToe (tres en raya) desarrollada con Flask y Flask-RESTX.

## 📋 Prerrequisitos

- Python 3.12+
- `uv` (gestor de paquetes Python): [Instalación de uv](https://docs.astral.sh/uv/getting-started/installation/)
- Docker y Docker Compose (para despliegue en contenedores)

## 🚀 Instalación y Ejecución Local

### Instalar dependencias
```bash
uv sync
```

### Ejecutar la aplicación en modo desarrollo
```bash
uv run python main.py
```

La API estará disponible en `http://localhost:5001`

**Nota:** En macOS, el puerto 5000 está ocupado por AirPlay. Por eso usamos el puerto 5001.

### Ejecutar tests
```bash
uv run pytest
```

### Documentación interactiva (Swagger UI)
Accede a `http://localhost:5000/` en tu navegador para ver la documentación interactiva de la API.

## 🐳 Despliegue con Docker

### Fase 3: Configuración Básica

Ejecuta la API en un contenedor Docker accesible en `localhost:3000`:

```bash
# Construir la imagen
docker-compose build

# Iniciar el servicio
docker-compose up -d

# Ver logs
docker-compose logs -f

# Detener el servicio
docker-compose down
```

La API estará disponible en `http://localhost:3000`

### Fase 4: Configuración Avanzada (Múltiples Instancias + Nginx)

Ejecuta múltiples instancias de la API con Nginx como proxy reverso y sticky sessions:

```bash
# Configurar dominio local en /etc/hosts (requiere sudo)
echo "127.0.0.1   tictactoe.local api.local" | sudo tee -a /etc/hosts

# Iniciar servicios
docker-compose -f docker-compose.advanced.yml up -d

# Ver logs de nginx
docker-compose -f docker-compose.advanced.yml logs nginx

# Ver estado de todos los contenedores
docker-compose -f docker-compose.advanced.yml ps

# Detener servicios
docker-compose -f docker-compose.advanced.yml down
```

La API estará disponible en `http://tictactoe.local:4000`

**Características:**
- 3 instancias de la API (balanceo de carga)
- Nginx como proxy reverso
- Sticky sessions (ip_hash) para garantizar que un cliente siempre use la misma instancia

## 📁 Estructura del Proyecto

```
tictactoe-back/
├── main.py                    # Aplicación Flask principal
├── wsgi.py                    # Entry point para Gunicorn
├── test_main.py              # Tests con pytest
├── pyproject.toml            # Configuración de dependencias (uv)
├── Dockerfile                # Imagen Docker para producción
├── docker-compose.yml        # Configuración básica (Fase 3)
├── docker-compose.advanced.yml  # Configuración avanzada (Fase 4)
├── nginx.conf                # Configuración base de Nginx
├── nginx-sticky.conf         # Configuración de Nginx con sticky sessions
├── Makefile                  # Comandos útiles
└── GUIA_PASOS.md            # Guía detallada paso a paso
```

## 🔧 Tecnologías Utilizadas

- **Flask**: Framework web
- **Flask-RESTX**: Extensión para APIs REST con documentación Swagger
- **Gunicorn**: Servidor WSGI para producción
- **pytest**: Framework de testing
- **Docker**: Contenedores para despliegue
- **Nginx**: Proxy reverso y balanceador de carga
- **uv**: Gestor de paquetes Python moderno y rápido

## 📖 Documentación

Para más detalles sobre cómo completar cada fase del proyecto, consulta `GUIA_PASOS.md`.

## 📝 Endpoints Principales

- `POST /devices` - Registrar un nuevo dispositivo
- `GET /devices` - Listar dispositivos conectados
- `GET /devices/<device_id>/info` - Información de un dispositivo
- `POST /matches` - Crear una nueva partida
- `GET /matches/<match_id>` - Estado de una partida
- `POST /matches/<match_id>/moves` - Realizar un movimiento

Ver documentación completa en Swagger UI (`http://localhost:5001/` en desarrollo o `http://localhost:3000/` en Docker)