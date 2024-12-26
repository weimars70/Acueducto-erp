#!/bin/bash

# Crear archivo README.md y añadir texto
echo "# Acueducto-erp" >> README.md

# Inicializar repositorio Git
git init

# Agregar README.md al área de preparación
git add .

# Hacer el primer commit
git commit -m "first commit"

# Cambiar la rama principal a "main"
git branch -M main

# Agregar el repositorio remoto
git remote add origin https://github.com/weimars70/Acueducto-erp.git

# Hacer push al repositorio remoto
git push 
