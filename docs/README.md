# Documentación del Proyecto TicTacToe API

Esta carpeta contiene la documentación técnica del proyecto generada con mdBook.

## Estructura

```
docs/
├── book.toml              # Configuración de mdBook
├── src/
│   ├── SUMMARY.md        # Índice de la documentación
│   ├── introduccion.md   # Introducción al proyecto
│   ├── entorno.md        # Descripción del entorno y herramientas
│   ├── fase1.md          # Fase 1: Preparación del entorno
│   ├── fase2.md          # Fase 2: Instalación del servidor
│   ├── fase3.md          # Fase 3: Configuración básica
│   ├── fase4.md          # Fase 4: Configuración avanzada
│   └── reflexion.md      # Reflexión final
└── src/images/           # Capturas de pantalla (añadir aquí)
```

## Instalación de mdBook

Para generar la documentación, necesitas instalar mdBook:

### macOS
```bash
brew install mdbook
```

### Linux
```bash
cargo install mdbook
```

O desde el repositorio oficial:
```bash
curl -L https://github.com/rust-lang/mdBook/releases/latest/download/mdbook-x86_64-unknown-linux-gnu.tar.gz | tar xz
sudo mv mdbook /usr/local/bin/
```

### Windows
Descarga desde: https://github.com/rust-lang/mdBook/releases

## Añadir Capturas de Pantalla

1. Guarda todas tus capturas en la carpeta `docs/src/images/`
2. Nombra las capturas de forma descriptiva:
   - `fase1-tests.png`
   - `fase1-swagger-localhost.png`
   - `fase2-docker-build.png`
   - `fase2-imagen-creada.png`
   - `fase3-contenedores.png`
   - `fase3-swagger-localhost3000.png`
   - `fase4-4-contenedores.png`
   - `fase4-swagger-tictactoe-local.png`
   - `fase4-sticky-sessions.png`
   - etc.

3. Añade las referencias a las imágenes en los archivos `.md` correspondientes:

```markdown
![Descripción de la captura](images/nombre-archivo.png)
```

## Construir la Documentación

Desde la carpeta `docs/`:

```bash
cd docs
mdbook build
```

Esto generará la documentación HTML en `docs/book/`

## Servir la Documentación Localmente

Para previsualizar la documentación mientras trabajas:

```bash
cd docs
mdbook serve
```

Esto iniciará un servidor local en `http://localhost:3000` donde puedes ver la documentación.

## Estructura de Capturas Recomendada

### Fase 1
- `fase1-uv-sync.png` - Instalación de dependencias
- `fase1-tests.png` - Tests pasando
- `fase1-flask-dev.png` - Flask corriendo en desarrollo
- `fase1-swagger.png` - Swagger UI en localhost:5001
- `fase1-post-devices.png` - POST /devices desde Swagger
- `fase1-get-devices.png` - GET /devices desde Swagger

### Fase 2
- `fase2-docker-version.png` - Versiones de Docker
- `fase2-docker-build.png` - Construcción de imagen
- `fase2-imagen-creada.png` - Imagen creada
- `fase2-gunicorn-logs.png` - Gunicorn iniciándose

### Fase 3
- `fase3-compose-ps.png` - Contenedores corriendo
- `fase3-gunicorn-logs.png` - Logs de Gunicorn
- `fase3-swagger.png` - Swagger UI en localhost:3000
- `fase3-post-devices.png` - POST /devices (server: gunicorn)
- `fase3-get-devices.png` - GET /devices (server: gunicorn)

### Fase 4
- `fase4-hosts.png` - Configuración en /etc/hosts
- `fase4-4-contenedores.png` - 4 contenedores corriendo
- `fase4-gunicorn-todas.png` - Gunicorn en las 3 instancias
- `fase4-swagger.png` - Swagger UI en tictactoe.local:4000
- `fase4-post-devices.png` - POST /devices (server: nginx)
- `fase4-sticky-sessions.png` - Logs mostrando sticky sessions

## Generar Documentación Final

Una vez añadidas todas las capturas:

```bash
cd docs
mdbook build
```

La documentación estará lista en `docs/book/` y puedes:
- Abrir `docs/book/index.html` en el navegador
- O subirla a un servidor web
- O comprimirla para entregarla

