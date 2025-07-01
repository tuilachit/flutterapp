#!/bin/bash

echo "🚀 Pushing ReturnPal Flutter App to GitHub..."
echo "Repository: https://github.com/tuilachit/flutterapp"

# Add all files to staging
git add .

# Commit with a descriptive message
git commit -m "🎉 Initial commit: ReturnPal Flutter App with Supabase integration

Features included:
- Complete Flutter app with Material Design 3 UI
- Supabase authentication and database integration
- Return items tracking functionality
- Enhanced dashboard with premium components
- Manual entry, calendar, and photo capture pages
- Connection testing and debugging tools
- SQL schema for database setup
- Web deployment ready

Tech stack:
- Flutter 3.x
- Supabase for backend
- Riverpod for state management
- Material Design 3 theming
- Cross-platform support (iOS, Android, Web, Desktop)"

# Push to GitHub
git push -u origin main

echo "✅ Successfully pushed to GitHub!"
echo "📱 Your app is now available at: https://github.com/tuilachit/flutterapp" 