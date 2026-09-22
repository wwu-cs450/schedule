# Schedule Management Project Documentation

This file provides comprehensive documentation for AI assistants and developers working on the Schedule Management application.

## Project Overview

The Schedule Management application is a Flutter-based Single-Page Application for managing course schedules and academic calendars. It uses a simplified architecture compared to other department applications, with a bulletin module for schedule announcements.

**Key Features:**
- Course schedule management
- Academic calendar management
- Schedule announcements (bulletin)
- Flutter web UI
- Dart API server
- Nginx reverse proxy
- Docker containerization

**Key Technologies:**
- Frontend: Flutter (web)
- Backend: Dart (Shelf framework)
- Bulletin: Static schedule data
- Deployment: Docker, Dokku
- CI/CD: GitLab CI/CD

## Repository Structure

This is a **simplified 3-component project** with bulletin module:

```
schedule/
├── client/                    # Flutter web UI
│   ├── lib/                   # Dart source code
│   ├── web/                   # Web assets
│   ├── test/                  # Tests
│   └── pubspec.yaml
│
├── server/                    # Dart Shelf API server
│   ├── bin/
│   │   └── server.dart        # Entry point
│   ├── lib/                   # Schedule logic
│   ├── test/
│   └── pubspec.yaml
│
├── bulletin/                  # Schedule announcements/data
│   └── (static schedule content)
│
├── nginx/
│   └── nginx.conf             # Routing config
│
├── Dockerfile                 # Multi-stage build
├── supervisord.conf           # Process management
├── .dockerignore              # Build optimization
├── .gitlab-ci.yml             # CI/CD
├── README.md
├── CLAUDE.md                  # This file
└── docs/
```

## Development Setup

### Prerequisites
- Dart SDK (3.x+)
- Flutter SDK (3.x+)
- Git
- Docker (optional)

### Clone and Setup
```bash
git clone ssh://gitlab.cs.wallawalla.edu:2222/wwu/schedule.git
cd schedule

cd client && flutter pub get && cd ..
cd server && dart pub get && cd ..
```

## Running Tests and Linting

```bash
# Server
cd server && dart pub get && dart format . && dart analyze && dart test

# Client
cd client && flutter pub get && dart format . && flutter analyze && flutter test

# Full validation
dart format . --set-exit-if-changed
```

## Development Workflow

**API Server (port 8082):**
```bash
cd server && dart run bin/server.dart --port=8082
```

**Web Client (port 8081):**
```bash
cd client && flutter run -d chrome --web-port 8081
```

**Direct Access:** Visit `http://localhost:8081` (no reverse proxy needed)

## Docker Deployment

```bash
docker build -t schedule:latest .
docker run -p 80:80 -e PUBLIC_URL=https://schedule.cs.wallawalla.edu schedule:latest
```

## CI/CD Pipeline

- Consolidated test jobs (format, analyze, test)
- Super-linter validation
- Docker build on tags
- Deployment via tag release

## Key Differences

- **No common package:** Schedule uses simpler shared models
- **No reverse proxy:** Direct client-server communication
- **Bulletin module:** Static schedule data and announcements
- **Simplified:** Fewer components than homepage/budget

## For AI Assistants

1. Simpler structure - only client and server
2. Test both components independently
3. Ensure Docker builds successfully
4. Note: No shared common package - models may be duplicated
5. Bulletin module is static content
6. No reverse proxy needed for development

---

For more complex projects with shared code, see single-sign-on or homepage CLAUDE.md files.
