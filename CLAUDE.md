# Schedule Management Project Documentation

This file provides comprehensive documentation for AI assistants and developers working on the Schedule Management application.

## Project Overview

The Schedule Management application is a Flutter-based Single-Page Application for managing course schedules and academic calendars. It uses a simplified architecture compared to other department applications, with a bulletin module for schedule announcements.

**Key Features:**

- Course schedule management
- Academic calendar management
- Schedule announcements (bulletin)
- Flutter web UI
- Dart scraper that generates the schedule data
- Nginx static file serving
- Docker containerization

**Key Technologies:**

- Frontend: Flutter (web)
- Backend: Dart (scraper loop, no HTTP framework - see "Development Workflow" below)
- Bulletin: Static schedule data
- Deployment: Docker, Dokku
- CI/CD: GitLab CI/CD

## Repository Structure

This is a **simplified 3-component project** with bulletin module:

```text
schedule/
├── client/                    # Flutter web UI
│   ├── lib/                   # Dart source code
│   ├── web/                   # Web assets
│   ├── test/                  # Tests
│   └── pubspec.yaml
│
├── server/                    # Dart scraper - polls classopen.wallawalla.edu on a loop
│   ├── bin/
│   │   └── server.dart        # Entry point
│   ├── lib/                   # Scraping/parsing logic
│   ├── test/
│   └── pubspec.yaml
│
├── bulletin/                  # PDF-to-text extraction (Python, run manually - see below)
│   └── main.py
│
├── nginx/
│   └── nginx.conf             # Static file serving
│
├── Dockerfile                 # Multi-stage build
├── supervisord.conf           # Process management
├── .dockerignore              # Build optimization
├── .gitlab-ci.yml             # CI/CD
├── README.md
└── CLAUDE.md                  # This file
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

`server/bin/server.dart` is not an HTTP server - it's a scraper loop.
It polls `classopen.wallawalla.edu` every 5 minutes, converts the result to CSV, and writes `class_data.csv`/`date_time.txt` directly into the client's static assets (`../client/assets/` in development, or `/usr/share/nginx/html/assets/` when `ENVIRONMENT` is `production` or `staging`).
The Flutter client fetches those two files as plain static assets - there is no live API call between client and server at runtime.
There's no `--port` flag; `PORT` is not read anywhere.

**Scraper (writes into `client/assets/`):**

```bash
cd server && dart run bin/server.dart
```

**Web Client (port 8081):**

```bash
cd client && flutter run -d chrome --web-port 8081
```

**Direct Access:** Visit `http://localhost:8081` (no reverse proxy needed)

**Bulletin PDF extraction** (`bulletin/main.py`, run manually, not part of the Dart build): extracts text from a hardcoded local PDF path into `bulletin.txt` (gitignored), which `server bin/server.dart --bulletin <path>` then consumes in a separate one-off mode.
This is not currently generalized for any developer to run - see the script before relying on it.

## Docker Deployment

```bash
docker build -t schedule:latest .
docker run -p 80:80 -e ENVIRONMENT=production schedule:latest
```

## CI/CD Pipeline

- Consolidated test jobs (format, analyze, test)
- Super-linter validation
- Docker build on tags
- Deployment via tag release

## Key Differences

- **No common package:** Schedule uses simpler shared models
- **No live API:** the server is a scraper that writes CSV/txt directly into the client's static assets; the client fetches them as static files, not via HTTP API calls
- **No login/SSO:** unlike single-sign-on/guidebook/homepage/budget, schedule has no authentication
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
