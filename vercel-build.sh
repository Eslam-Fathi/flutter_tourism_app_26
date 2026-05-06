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

# 4. Create .env from Vercel Environment Variables
echo "Creating .env file..."
cat << EOF > .env
SUPABASE_URL=$SUPABASE_URL
SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
API_BASE_URL=$API_BASE_URL
GEMINI_API_KEY=$GEMINI_API_KEY
EOF

# 5. Get dependencies
flutter pub get

# 6. Build Web Release
flutter build web --release --base-href /

# 7. Verify output
echo "Build complete. Contents of build/web:"
ls -F build/web
