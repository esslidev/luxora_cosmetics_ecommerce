# Luxora Cosmetics E-commerce

Welcome to the Luxora Cosmetics E-commerce repository! This project is built using Ali Salem Essouiah Custom Flutter System. It leverages powerful libraries and tools including BLoC, GetIt, Beamer, Retrofit, and build_runner, among others.

## Project Structure

The project consists of two main folders:

- **`front-end`**: Contains the code for the Flutter cross-platform (mobile/web) application.
- **`back-end`**: Contains the backend code for a simple REST API using Node.js, Express, TypeScript, and Prisma.

## Getting Started

These instructions will help you set up the project on your local machine for development and testing purposes.

## Features

- Multi device an OS support ("Android","IOS","Window","Linux","Web").
- Screen responsivity and adaptivity support.
- High and native performance(in the release mode).
- Safe and secure connection between server and the client.
- Advanced routing.
- High-end animation.
- Multi theme support with real time switching.
- Multi language support with real time switching.
- Multi font family support for every language.
- And much more...

### Prerequisites

Before you begin, ensure you have the following software installed on your system:

1. [Docker](https://www.docker.com/).
2. [Node.js](https://nodejs.org/en/download/).
   - You can use nvm (Node Version Manager) to easily switch between different Node versions.
3. [Flutter SDK](https://flutter.dev/docs/get-started/install)
4. A text editor or IDE (e.g., Visual Studio Code).
5. [Git command-line tools (git)](https://git-scm.com/downloads)

### How to test the project

1. Install Docker
2. Build a Docker compose
3. Run Docker compose
4. enter your localhost:
   - Port 3003 >> for the frontend
   - Port 4003 >> for the backend
   - Port 5555 >> for the prisma studio

## Common Docker Commands

1. Build a docker compose:
   - `docker-compose build`
2. Run Docker Compose:
   - `docker-compose up [OPTIONS]`
3. Run Docker Compose with specifying project name and detached mode:
   - `docker-compose -p meal-planner up -d`
4. Stop Docker Compose containers:
   - `docker-compose down`
5. List networks:
   - `docker network ls`
6. List running containers:
   - `docker ps`
7. Listing All Containers (Including Exited/Stopped)
   - `docker ps -a`

## Common Flutter Commands

1. Build android,ios,web ...etc flutter folders:
   - `flutter create .`
2. Build android,ios,web ...etc flutter folders:
   - `flutter create .`
3. Build for Android, iOS, Web, etc.:
   - `flutter build <platform>`
4. Launch app with custom configs:
   - `code --launch-config [NAME CONFIG]`
5. Build the web release:
   - `flutter build web --release`
6. Run the web app in release mode:
   - `flutter run -d chrome --release`
7. get packges.
   - `flutter pub get`

# Most used commands

docker container exec -it flutter-ecommerce-librairie-alfia-backend bash
flutter pub run build_runner build
flutter build web --release
npx prisma migrate dev
docker-compose up --build -d

# Additional commands for the project

docker-compose logs # View logs from the Docker containers
docker-compose down # Stop and remove containers, networks, images, and volumes
flutter pub get # Get dependencies for the Flutter project
flutter run # Run the Flutter application in debug mode
flutter analyze # Analyze the Flutter project for potential issues
flutter test # Run tests for the Flutter application
npx prisma generate # Generate Prisma client based on the schema
npx prisma migrate deploy # Deploy the latest migrations to the database
