# Guía para Subir el Proyecto a GitHub

## Pasos para Subir el Proyecto

### 1. Crear el Repositorio en GitHub

1. Ve a [GitHub.com](https://github.com)
2. Haz clic en el botón **"+"** (arriba a la derecha) → **"New repository"**
3. Configura el repositorio:
   - **Repository name:** `tictactoe-back` (o el nombre que prefieras)
   - **Description:** "API TicTacToe con despliegue en Docker y Nginx"
   - **Visibility:** Private o Public (tu elección)
   - **NO marques** "Initialize this repository with a README" (ya tenemos archivos)
   - Haz clic en **"Create repository"**

### 2. Inicializar Git en tu Proyecto Local

Ejecuta estos comandos en tu terminal:

```bash
cd "/Users/alejandro/2ºDAWs/DPL/tictactoe-back"

# Inicializar repositorio git
git init

# Añadir todos los archivos
git add .

# Hacer el primer commit
git commit -m "Initial commit: API TicTacToe con despliegue completo

- Fase 1: Preparación del entorno local
- Fase 2: Contenedorización con Docker y Gunicorn
- Fase 3: Configuración básica con Docker Compose
- Fase 4: Configuración avanzada con Nginx y sticky sessions
- Documentación técnica completa con mdBook"
```

### 3. Conectar con GitHub y Subir

Después de crear el repositorio en GitHub, verás las instrucciones. Ejecuta estos comandos:

```bash
# Añadir el remoto (reemplaza USERNAME con tu usuario de GitHub)
git remote add origin https://github.com/USERNAME/tictactoe-back.git

# O si prefieres usar SSH (si tienes configuradas las claves):
# git remote add origin git@github.com:USERNAME/tictactoe-back.git

# Cambiar a la rama main (si es necesario)
git branch -M main

# Subir el código
git push -u origin main
```

### 4. Verificar que se Subió Correctamente

1. Ve a tu repositorio en GitHub: `https://github.com/USERNAME/tictactoe-back`
2. Verifica que todos los archivos están presentes
3. La documentación en `docs/` estará disponible para ver el código fuente

## Notas Importantes

### Qué se Sube

- ✅ Todo el código fuente
- ✅ Archivos de configuración (Dockerfile, docker-compose, nginx)
- ✅ Documentación en `docs/src/` (markdown)
- ✅ Capturas de pantalla en `docs/src/images/`
- ✅ Archivos de configuración de mdBook

### Qué NO se Sube (gracias a .gitignore)

- ❌ `__pycache__/`
- ❌ `.venv/` o `venv/`
- ❌ `docs/book/` (documentación generada - se puede regenerar)
- ❌ `.pytest_cache/`
- ❌ Archivos temporales

### Documentación en GitHub

GitHub mostrará automáticamente:
- Los archivos markdown en `docs/src/`
- Las imágenes en `docs/src/images/`
- El código fuente

Si quieres que la documentación HTML también esté disponible, puedes:
1. Generarla: `cd docs && mdbook build`
2. Subirla creando una rama `gh-pages` o usando GitHub Pages

## Comandos Rápidos Resumen

```bash
# 1. Inicializar
git init
git add .
git commit -m "Initial commit"

# 2. Conectar con GitHub (reemplaza USERNAME)
git remote add origin https://github.com/USERNAME/tictactoe-back.git

# 3. Subir
git branch -M main
git push -u origin main
```

## Publicar Documentación con GitHub Pages (Opcional)

Si quieres que la documentación HTML esté accesible en GitHub Pages:

```bash
cd docs
mdbook build

# Subir la carpeta book a la rama gh-pages
git checkout --orphan gh-pages
git rm -rf .
cp -r book/* .
git add .
git commit -m "Add documentation"
git push origin gh-pages
```

Luego activa GitHub Pages en la configuración del repositorio.

---

¡Buena suerte con tu entrega! 🚀

