# Entorno y Herramientas

## Descripción del Entorno

El despliegue se ha realizado en un entorno macOS (darwin 25.0.0) utilizando contenedores Docker para garantizar la reproducibilidad y aislamiento de la aplicación.

## Herramientas Utilizadas

### Gestión de Paquetes y Entorno

- **Python 3.12+**: Lenguaje de programación de la aplicación
- **uv**: Gestor de paquetes Python moderno y rápido ([Documentación](https://docs.astral.sh/uv/getting-started/features/))
  - Ventajas: Velocidad, gestión de entornos virtuales, compatibilidad con pip

### Framework y Servidores

- **Flask 3.1.2**: Framework web ligero para Python ([Documentación](https://flask.palletsprojects.com/en/stable/))
  - Ventajas: Simple, flexible, extensible
- **Flask-RESTX 1.3.2**: Extensión para crear APIs REST con documentación Swagger automática
- **Gunicorn 23.0.0**: Servidor WSGI de producción para Flask
  - Ventajas: Estable, maneja múltiples workers, eficiente en producción

### Testing

- **pytest 8.4.2**: Framework de testing para Python ([Documentación](https://docs.pytest.org/en/stable/))
- **pytest-flask 1.3.0**: Extensión de pytest para aplicaciones Flask

### Contenedores y Orquestación

- **Docker**: Contenedores para aislamiento y reproducibilidad
  - Ventajas: Aislamiento completo, reproducibilidad, fácil despliegue
- **Docker Compose v2.39.4**: Orquestación de múltiples contenedores
  - Ventajas: Definición de servicios, redes y volúmenes en un solo archivo

### Proxy Reverso y Balanceador

- **Nginx 1.29.3**: Servidor web y proxy reverso
  - Ventajas: Alto rendimiento, balanceo de carga, sticky sessions con ip_hash

### Documentación

- **Swagger UI**: Interfaz interactiva para documentación de APIs ([Documentación](https://swagger.io/tools/swagger-ui/))
  - Integrado automáticamente por Flask-RESTX

## Justificación de las Elecciones

### ¿Por qué Gunicorn?

- **Servidor WSGI de producción**: Diseñado específicamente para aplicaciones Python en producción
- **Múltiples workers**: Permite manejar varias peticiones concurrentes
- **Estabilidad**: Ampliamente usado y probado en producción
- **Configuración sencilla**: Fácil de configurar y personalizar

### ¿Por qué Docker?

- **Reproducibilidad**: Garantiza que la aplicación funcione igual en cualquier entorno
- **Aislamiento**: Evita conflictos con otras aplicaciones o dependencias del sistema
- **Escalabilidad**: Facilita el despliegue de múltiples instancias
- **Portabilidad**: Fácil de desplegar en diferentes plataformas

### ¿Por qué Nginx como Proxy Reverso?

- **Alto rendimiento**: Muy eficiente en el manejo de peticiones
- **Balanceo de carga**: Distribuye las peticiones entre múltiples instancias
- **Sticky sessions**: Implementación sencilla con `ip_hash` para garantizar consistencia
- **Configuración flexible**: Permite personalizar headers, timeouts, etc.

## Versiones Específicas

```bash
Docker version 28.4.0
Docker Compose version v2.39.4-desktop.1
Python 3.13.7
Gunicorn 23.0.0
Nginx 1.29.3
Flask 3.1.2
Flask-RESTX 1.3.2
```

## Estructura del Proyecto

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
└── Makefile                  # Comandos útiles
```

