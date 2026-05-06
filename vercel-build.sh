#!/bin/bash
set -e

# 1. Clone Flutter if it doesn't exist
if [ ! -d "flutter" ]; then
  echo "Installing Flutter..."
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
fi

# 2. Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# 3. Enable Web support
flutter config --enable-web

# 4. Create a dummy .env if it doesn't exist (required by pubspec.yaml)
if [ ! -f ".env" ]; then
  echo "Creating dummy .env file..."
  touch .env
fi

# 5. Get dependencies
flutter pub get

# 6. Build Web Release
flutter build web --release --base-href /

# 7. Verify output
echo "Build complete. Contents of build/web:"
ls -F build/web
