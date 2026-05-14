#!/usr/bin/env bash
set -euo pipefail

# Build and run the Docker image locally for production simulation.
# Usage: ./docker_test.sh

IMAGE="wwu-schedule:local"
CONTAINER="wwu-schedule-test"


echo "==> Building image ($IMAGE) with ENVIRONMENT=production ..."
docker build \
  --build-arg ENVIRONMENT=production \
  -t "$IMAGE" \
  "$(dirname "$0")"

# Remove any previous test container
docker rm -f "$CONTAINER" 2>/dev/null || true

echo ""
echo "==> Starting container (http://localhost:8080) ..."
echo "    Press Ctrl+C to stop."
echo ""

docker run --rm \
  --name "$CONTAINER" \
  -p 8080:80 \
  -e ENVIRONMENT=production \
  "$IMAGE"
