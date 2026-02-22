# Task Manager API

[![CI](https://github.com/giresse21/task-manager-api/actions/workflows/ci.yml/badge.svg)](https://github.com/giresse21/task-manager-api/actions/workflows/ci.yml)

API REST complète pour gestion de projets et tâches avec authentification JWT.

## 🚀 Technologies

- **Ruby** 3.2.2
- **Rails** 8.1.2  
- **PostgreSQL** 16
- **RSpec** (48 tests)
- **JWT** Authentication
- **GitHub Actions** CI/CD

## ✨ Fonctionnalités

- ✅ Authentification JWT sécurisée
- ✅ CRUD complet Projects
- ✅ CRUD complet Tasks
- ✅ Relations User → Projects → Tasks
- ✅ Validations complètes
- ✅ Tests automatisés (48 tests)
- ✅ CI/CD avec GitHub Actions
- ✅ Code coverage > 90%

## 📊 Architecture
```
User
  ├── has_many Projects
  └── has_many Tasks

Project
  ├── belongs_to User
  └── has_many Tasks

Task
  ├── belongs_to User
  └── belongs_to Project
```

## 🛠️ Installation

### Prérequis

- Ruby 3.2.2
- PostgreSQL 16
- Bundler

### Setup
```bash
# Clone le repository
git clone https://github.com/giresse21/task-manager-api.git
cd task-manager-api

# Installer les dépendances
bundle install

# Créer et préparer la base de données
rails db:create
rails db:migrate

# Lancer les tests
bundle exec rspec

# Démarrer le serveur
rails server
```

L'API sera accessible sur `http://localhost:3000`


## 🐳 Installation avec Docker (Recommandé)

### Prérequis

- Docker Desktop
- Docker Compose

### Lancement
```bash
# Cloner le repository
git clone https://github.com/giresse21/task-manager-api.git
cd task-manager-api

# Démarrer l'application
docker-compose up --build

# L'application sera accessible sur http://localhost:3000
```

### Commandes Docker utiles
```bash
# Démarrer les services
docker-compose up

# Arrêter les services
docker-compose down

# Voir les logs
docker-compose logs -f

# Exécuter les tests
docker-compose exec web bundle exec rspec

# Ouvrir la console Rails
docker-compose exec web rails console

# Exécuter les migrations
docker-compose exec web rails db:migrate
```

### Ports

- API : http://localhost:3000
- PostgreSQL : localhost:5432

## 🔑 API Endpoints

### Authentification

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| POST | `/api/v1/signup` | Créer un compte |
| POST | `/api/v1/login` | Se connecter |
| GET | `/api/v1/me` | Profil utilisateur (nécessite token) |

### Projects

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| GET | `/api/v1/projects` | Liste des projets |
| POST | `/api/v1/projects` | Créer un projet |
| GET | `/api/v1/projects/:id` | Détails d'un projet |
| PUT | `/api/v1/projects/:id` | Modifier un projet |
| DELETE | `/api/v1/projects/:id` | Supprimer un projet |

### Tasks

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| GET | `/api/v1/projects/:project_id/tasks` | Tâches d'un projet |
| POST | `/api/v1/projects/:project_id/tasks` | Créer une tâche |
| GET | `/api/v1/tasks/:id` | Détails d'une tâche |
| PUT | `/api/v1/tasks/:id` | Modifier une tâche |
| PATCH | `/api/v1/tasks/:id/toggle` | Toggle complétée |
| DELETE | `/api/v1/tasks/:id` | Supprimer une tâche |

## 📝 Exemples d'utilisation

### Signup
```bash
curl -X POST http://localhost:3000/api/v1/signup \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123",
    "password_confirmation": "password123"
  }'
```

**Réponse :**
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com"
  }
}
```

### Créer un projet
```bash
curl -X POST http://localhost:3000/api/v1/projects \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "project": {
      "name": "Mon Projet",
      "description": "Description du projet",
      "color": "#FF5733"
    }
  }'
```

### Créer une tâche
```bash
curl -X POST http://localhost:3000/api/v1/projects/1/tasks \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "task": {
      "title": "Ma première tâche",
      "description": "Description",
      "priority": "high",
      "due_date": "2026-03-01"
    }
  }'
```

## 🧪 Tests
```bash
# Lancer tous les tests
bundle exec rspec

# Lancer un fichier spécifique
bundle exec rspec spec/models/user_spec.rb

# Avec détails
bundle exec rspec --format documentation
```

**Couverture des tests :**
- ✅ Modèles (validations, relations)
- ✅ API endpoints (success & error cases)
- ✅ Authentification JWT
- ✅ Authorization

## 🔒 Sécurité

- Mots de passe cryptés avec `bcrypt`
- Authentification JWT
- CORS configuré
- Strong parameters
- Validation des entrées
- Tests de sécurité avec Brakeman

## 📦 Structure du projet
```
task_manager_api/
├── app/
│   ├── controllers/
│   │   ├── application_controller.rb
│   │   ├── concerns/
│   │   │   └── json_web_token.rb
│   │   └── api/v1/
│   │       ├── auth_controller.rb
│   │       ├── projects_controller.rb
│   │       └── tasks_controller.rb
│   └── models/
│       ├── user.rb
│       ├── project.rb
│       └── task.rb
├── config/
│   ├── database.yml
│   └── routes.rb
├── spec/
│   ├── models/
│   └── requests/
└── .github/
    └── workflows/
        └── ci.yml
```

## 🚀 Déploiement

Le projet est configuré avec GitHub Actions pour l'intégration continue. Chaque push déclenche automatiquement :

1. ✅ Installation de Ruby et PostgreSQL
2. ✅ Installation des dépendances
3. ✅ Création de la base de données
4. ✅ Exécution des 48 tests
5. ✅ Audit de sécurité avec Brakeman

## 📄 Licence

MIT

## 👤 Auteur

**Giresse Ayefou**
- GitHub: [@giresse21](https://github.com/giresse21)
- Email: giresseayef@gmail.com

## 🙏 Acknowledgments

Projet créé pour démontrer la maîtrise de :
- Ruby on Rails
- Architecture REST
- TDD (Test-Driven Development)
- CI/CD
- Best practices backend