"""
WSGI entry point para producción con Gunicorn.
Este archivo permite ejecutar la aplicación Flask en modo producción.
"""
from main import app

if __name__ == "__main__":
    app.run()

