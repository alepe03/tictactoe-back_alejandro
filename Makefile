# Makefile para facilitar los comandos del proyecto

.PHONY: help install test run dev build up down logs clean

help:
	@echo "Comandos disponibles:"
	@echo "  make install    - Instalar dependencias"
	@echo "  make test       - Ejecutar tests"
	@echo "  make run        - Ejecutar aplicación en desarrollo"
	@echo "  make dev        - Ejecutar aplicación en desarrollo (alias)"
	@echo "  make build      - Construir imagen Docker"
	@echo "  make up         - Iniciar contenedores (fase 3)"
	@echo "  make up-advanced - Iniciar contenedores (fase 4 con nginx)"
	@echo "  make down       - Detener contenedores"
	@echo "  make logs       - Ver logs de los contenedores"
	@echo "  make clean      - Limpiar contenedores e imágenes"

install:
	uv sync

test:
	uv run pytest -v

run dev:
	uv run python main.py

build:
	docker-compose build

up:
	docker-compose up -d

up-advanced:
	docker-compose -f docker-compose.advanced.yml up -d

down:
	docker-compose down
	docker-compose -f docker-compose.advanced.yml down

logs:
	docker-compose logs -f

clean:
	docker-compose down -v
	docker-compose -f docker-compose.advanced.yml down -v
	docker system prune -f

