# Étape 1 : Choisir l'image de base
FROM ruby:3.2.2

# Étape 2 : Installer les dépendances système
RUN apt-get update -qq && \
    apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Étape 3 : Définir le répertoire de travail
WORKDIR /app

# Étape 4 : Copier les fichiers de gems
COPY Gemfile Gemfile.lock ./

# Étape 5 : Installer les gems
RUN bundle install

# Étape 6 : Copier tout le code de l'application
COPY . .

# Étape 7 : Exposer le port 3000
EXPOSE 3000

# Étape 8 : Script de démarrage
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Étape 9 : Commande par défaut
CMD ["rails", "server", "-b", "0.0.0.0"]