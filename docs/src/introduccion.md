# Introducción

## Descripción del Proyecto

Este proyecto tiene como objetivo realizar el despliegue y configuración integral de un servidor de aplicaciones funcional, capaz de ejecutar y exponer una API backend a través de HTTP, aplicando criterios de modularidad, seguridad y escalabilidad.

## Aplicación TicTacToe

La aplicación utilizada es **TicTacToe API**, una API REST del clásico juego de tres en raya desarrollada con Flask y Flask-RESTX. Esta API proporciona endpoints para:

- Registro y gestión de dispositivos
- Creación y gestión de partidas
- Realización de movimientos en el tablero
- Consulta de estadísticas de jugadores

## Objetivos del Proyecto

El desarrollo se ha llevado a cabo en **cuatro fases**:

1. **Preparación del entorno de ejecución**: Configuración local de la aplicación
2. **Instalación del servidor de aplicaciones**: Contenedorización con Docker y Gunicorn
3. **Configuración básica del servidor**: Despliegue con Docker Compose
4. **Configuración avanzada**: Múltiples instancias con balanceador de carga y sticky sessions

## Estructura de la Documentación

Esta memoria técnica documenta todo el proceso de despliegue, incluyendo:

- Descripción del entorno y herramientas utilizadas
- Comandos ejecutados durante cada fase
- Configuraciones del servidor de aplicaciones
- Evidencias mediante capturas de pantalla
- Reflexión sobre el proceso y mejoras futuras

