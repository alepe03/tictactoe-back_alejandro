# Imagen base de Python
FROM python:3.12-slim

# Etiquetas informativas
LABEL maintainer="TicTacToe API"
LABEL description="Servidor WSGI para API TicTacToe con Gunicorn"

# Establecer directorio de trabajo
WORKDIR /app

# Instalar uv para gestión de dependencias
RUN pip install --no-cache-dir uv

# Copiar archivos de dependencias
COPY pyproject.toml uv.lock ./

# Instalar dependencias del sistema y de la aplicación
RUN uv sync --frozen

# Copiar el código de la aplicación
COPY . .

# Exponer puerto 8000 (por defecto de Gunicorn)
EXPOSE 8000

# Comando para ejecutar Gunicorn
# --bind 0.0.0.0:8000: Escucha en todas las interfaces
# --workers 2: Dos workers para manejar múltiples peticiones
# --timeout 120: Timeout de 120 segundos
# --access-logfile -: Logs de acceso a stdout
# --error-logfile -: Logs de error a stderr
# wsgi:app: Módulo wsgi, aplicación app
CMD ["uv", "run", "gunicorn", "--bind", "0.0.0.0:8000", "--workers", "2", "--timeout", "120", "--access-logfile", "-", "--error-logfile", "-", "wsgi:app"]

