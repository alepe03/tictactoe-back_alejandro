# Comandos Rápidos - Guía de Ejecución

Esta guía contiene todos los comandos necesarios para ejecutar el proyecto en cada fase.

---

## 📋 FASE 1: Ejecución Local (Desarrollo)

### Instalar dependencias
```bash
cd "/Users/alejandro/2ºDAWs/DPL/tictactoe-back"
uv sync
```

### Ejecutar tests
```bash
uv run pytest -v
```

### Ejecutar la API en modo desarrollo
```bash
uv run python main.py
```
**Accede a:** `http://localhost:5001/` (Swagger UI)

### Detener
Presiona `Ctrl+C` en la terminal

---

## 🐳 FASE 2: Construir Imagen Docker

```bash
cd "/Users/alejandro/2ºDAWs/DPL/tictactoe-back"
docker build -t tictactoe-api:latest .
```

### Verificar imagen creada
```bash
docker images | grep tictactoe
```

---

## ⚙️ FASE 3: Configuración Básica (Docker Compose)

### Construir e iniciar
```bash
cd "/Users/alejandro/2ºDAWs/DPL/tictactoe-back"
docker compose up -d
```

### Verificar que está corriendo
```bash
docker compose ps
```

### Ver logs
```bash
docker compose logs -f tictactoe-api
```
(Salir con `Ctrl+C`)

### Acceder a la API
**URL:** `http://localhost:3000/` (Swagger UI)

### Probar con curl
```bash
# Health check
curl http://localhost:3000/

# Registrar dispositivo
curl -X POST http://localhost:3000/devices \
  -H "Content-Type: application/json" \
  -d '{"alias": "TestDevice"}'

# Listar dispositivos
curl http://localhost:3000/devices
```

### Detener
```bash
docker compose down
```

---

## 🚀 FASE 4: Configuración Avanzada (Múltiples Instancias + Nginx)

### Verificar dominio local (si no está configurado)
```bash
cat /etc/hosts | grep tictactoe
```

Si no aparece, añadir:
```bash
sudo nano /etc/hosts
# Añadir: 127.0.0.1   tictactoe.local api.local
```

### Construir e iniciar (3 API + Nginx)
```bash
cd "/Users/alejandro/2ºDAWs/DPL/tictactoe-back"
docker compose -f docker-compose.advanced.yml build --no-cache
docker compose -f docker-compose.advanced.yml up -d
```

### Verificar todos los contenedores
```bash
docker compose -f docker-compose.advanced.yml ps
```
**Deberías ver 4 contenedores:** 3 API + 1 Nginx

### Verificar que todas usan Gunicorn
```bash
docker compose -f docker-compose.advanced.yml logs tictactoe-api-1 | grep -i gunicorn
docker compose -f docker-compose.advanced.yml logs tictactoe-api-2 | grep -i gunicorn
docker compose -f docker-compose.advanced.yml logs tictactoe-api-3 | grep -i gunicorn
```

### Acceder a la API
**URL:** `http://tictactoe.local:4000/` (Swagger UI)

### Probar con curl
```bash
# Health check
curl http://tictactoe.local:4000/

# Registrar dispositivo
curl -X POST http://tictactoe.local:4000/devices \
  -H "Content-Type: application/json" \
  -d '{"alias": "Cliente1"}'

# Listar dispositivos
curl http://tictactoe.local:4000/devices
```

### Verificar Sticky Sessions
```bash
# Hacer varias peticiones
curl http://tictactoe.local:4000/devices
curl http://tictactoe.local:4000/devices
curl http://tictactoe.local:4000/devices

# Ver logs de nginx mostrando que siempre va al mismo upstream
docker compose -f docker-compose.advanced.yml exec nginx cat /var/log/nginx/tictactoe-access.log | grep "upstream:"
```

**Resultado esperado:** Todas las peticiones deberían mostrar el mismo `upstream: 172.x.x.x:8000`

### Detener
```bash
docker compose -f docker-compose.advanced.yml down
```

---

## 📚 Ver Documentación Local

### Generar documentación
```bash
cd "/Users/alejandro/2ºDAWs/DPL/tictactoe-back/docs"
mdbook build
```

### Ver documentación en el navegador
```bash
# Opción 1: Servidor local con auto-recarga
mdbook serve

# Opción 2: Abrir directamente
open docs/book/index.html
```

---

## 🔧 Comandos Útiles

### Ver logs de todos los contenedores
```bash
# Fase 3
docker compose logs -f

# Fase 4
docker compose -f docker-compose.advanced.yml logs -f
```

### Ver logs de un contenedor específico
```bash
# Fase 3
docker compose logs tictactoe-api

# Fase 4
docker compose -f docker-compose.advanced.yml logs nginx
docker compose -f docker-compose.advanced.yml logs tictactoe-api-1
```

### Reiniciar un contenedor
```bash
# Fase 3
docker compose restart tictactoe-api

# Fase 4
docker compose -f docker-compose.advanced.yml restart nginx
```

### Limpiar todo (detener y eliminar contenedores)
```bash
# Fase 3
docker compose down -v

# Fase 4
docker compose -f docker-compose.advanced.yml down -v
```

### Ver imágenes Docker
```bash
docker images | grep tictactoe
```

### Ver contenedores corriendo
```bash
docker ps
```

---

## 🎯 Demo Rápida para el Profesor

### Demostración completa en 5 minutos:

1. **Fase 1 - Local:**
   ```bash
   uv run pytest -v
   uv run python main.py
   # Abrir http://localhost:5001/ en navegador
   ```

2. **Fase 3 - Docker básico:**
   ```bash
   docker compose up -d
   docker compose ps
   # Abrir http://localhost:3000/ en navegador
   curl http://localhost:3000/devices
   ```

3. **Fase 4 - Avanzado:**
   ```bash
   docker compose -f docker-compose.advanced.yml up -d
   docker compose -f docker-compose.advanced.yml ps
   # Abrir http://tictactoe.local:4000/ en navegador
   # Verificar sticky sessions
   docker compose -f docker-compose.advanced.yml exec nginx cat /var/log/nginx/tictactoe-access.log | grep "upstream:"
   ```

---

## ⚠️ Problemas Comunes

### Puerto 5000 ocupado en macOS
- Solución: Ya está configurado para usar puerto 5001

### Error al iniciar contenedores
- Verificar que Docker Desktop está corriendo
- Ejecutar: `docker compose down` y luego `docker compose up -d`

### Dominio tictactoe.local no funciona
- Verificar `/etc/hosts`: `cat /etc/hosts | grep tictactoe`
- Si no está: `sudo nano /etc/hosts` y añadir `127.0.0.1 tictactoe.local`

### Sticky sessions no se ve en logs
- Reiniciar nginx: `docker compose -f docker-compose.advanced.yml restart nginx`
- Hacer varias peticiones primero
- Ver logs: `docker compose -f docker-compose.advanced.yml exec nginx cat /var/log/nginx/tictactoe-access.log | grep "upstream:"`

---

## 📝 Checklist para la Demo

- [ ] Docker Desktop corriendo
- [ ] Fase 1: Tests pasando
- [ ] Fase 1: API en localhost:5001 funcionando
- [ ] Fase 3: Contenedor corriendo en localhost:3000
- [ ] Fase 3: Swagger UI accesible
- [ ] Fase 4: 4 contenedores corriendo
- [ ] Fase 4: Swagger UI en tictactoe.local:4000
- [ ] Fase 4: Sticky sessions verificadas en logs

