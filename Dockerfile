# Utilisez une version de Python comme base
ARG PYTHON_VERSION=3.12-slim-bullseye
FROM python:${PYTHON_VERSION}

# Créez un environnement virtuel
RUN python -m venv /opt/venv

# Ajoutez le chemin de l'environnement virtuel au PATH
ENV PATH="/opt/venv/bin:$PATH"

# Mettez à jour pip
RUN pip install --upgrade pip

# Configurez les variables d'environnement Python
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Installez les dépendances système nécessaires
RUN apt-get update && apt-get install -y \
    # pour PostgreSQL
    libpq-dev \ 
    # pour Pillow 
    libjpeg-dev \ 
    # pour CairoSVG 
    libcairo2 \ 
    # pour compiler des paquets Python 
    gcc \  
    && rm -rf /var/lib/apt/lists/*

# Créez un répertoire pour le code du projet
RUN mkdir -p /code
WORKDIR /code

# Copiez le fichier des dépendances
COPY requirements.txt /tmp/requirements.txt

# Installez les dépendances Python
RUN pip install --no-cache-dir -r /tmp/requirements.txt
RUN pip install gunicorn

# Copiez le code source dans le conteneur
COPY . /code

# Ajoutez un argument pour définir le nom du projet Django
ARG PROJ_NAME="appapi"

# Créez un script bash pour lancer le projet
RUN printf "#!/bin/bash\n" > ./entrypoint.sh && \
    printf "RUN_PORT=\"\${PORT:-8000}\"\n\n" >> ./entrypoint.sh && \
    printf "python manage.py migrate --no-input\n" >> ./entrypoint.sh && \
    printf "gunicorn ${PROJ_NAME}.wsgi:application --bind \"0.0.0.0:\$RUN_PORT\"\n" >> ./entrypoint.sh

# Rendez le script exécutable
RUN chmod +x ./entrypoint.sh

# Nettoyez le cache APT pour réduire la taille de l'image
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Définissez le script comme commande par défaut
CMD ["./entrypoint.sh"]
