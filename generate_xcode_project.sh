#!/bin/bash

# Script de génération du projet Xcode pour Yume
# Usage: ./generate_xcode_project.sh

echo "🌙 Génération du projet Xcode Yume..."

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_NAME="Yume"
BUNDLE_ID="com.amandinerobillard.Yume"

# Vérifier que nous sommes dans le bon dossier
if [ ! -f "$PROJECT_DIR/README.md" ]; then
    echo "❌ Erreur: Exécutez ce script depuis le dossier racine du projet Yume"
    exit 1
fi

# Créer le projet Xcode via xcodegen si disponible
if command -v xcodegen &> /dev/null; then
    echo "✅ xcodegen détecté, génération automatique..."
    
    # Créer le fichier project.yml pour xcodegen
    cat > "$PROJECT_DIR/project.yml" << EOF
name: $PROJECT_NAME
options:
  bundleIdPrefix: com.amandinerobillard
  deploymentTarget:
    iOS: "17.0"
targets:
  $PROJECT_NAME:
    type: application
    platform: iOS
    deploymentTarget: "17.0"
    sources:
      - path: .
        excludes:
          - "*.md"
          - "*.sh"
          - "*.yml"
          - ".git"
    settings:
      PRODUCT_BUNDLE_IDENTIFIER: $BUNDLE_ID
      INFOPLIST_FILE: Info.plist
      DEVELOPMENT_TEAM: ""
      CODE_SIGN_STYLE: Automatic
      SWIFT_VERSION: "5.9"
    scheme:
      testTargets: []
EOF
    
    # Générer le projet
    xcodegen generate
    
    if [ $? -eq 0 ]; then
        echo "✅ Projet Xcode généré avec succès!"
        echo "📂 Ouvrez: $PROJECT_NAME.xcodeproj"
    else
        echo "❌ Erreur lors de la génération"
        exit 1
    fi
else
    echo "⚠️  xcodegen non installé"
    echo ""
    echo "Pour installer xcodegen:"
    echo "  brew install xcodegen"
    echo ""
    echo "Ou créez le projet manuellement dans Xcode:"
    echo "  1. Ouvrez Xcode"
    echo "  2. File → New → Project"
    echo "  3. iOS → App"
    echo "  4. Product Name: $PROJECT_NAME"
    echo "  5. Organization Identifier: com.amandinerobillard"
    echo "  6. Interface: SwiftUI"
    echo "  7. Language: Swift"
    echo "  8. Cochez 'Use SwiftData'"
    echo ""
    echo "Puis importez tous les fichiers .swift du dossier"
fi

# Créer Info.plist si absent
if [ ! -f "$PROJECT_DIR/Info.plist" ]; then
    echo "📝 Création de Info.plist..."
    cat > "$PROJECT_DIR/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>UILaunchScreen</key>
    <dict>
        <key>UIColorName</key>
        <string>background</string>
    </dict>
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
    </array>
    <key>UIUserInterfaceStyle</key>
    <string>Dark</string>
</dict>
</plist>
EOF
    echo "✅ Info.plist créé"
fi

echo ""
echo "🎉 Configuration terminée!"
echo ""
echo "Prochaines étapes:"
echo "  1. Ouvrez $PROJECT_NAME.xcodeproj dans Xcode"
echo "  2. Sélectionnez un simulateur iOS 17+"
echo "  3. Product → Build (Cmd+B)"
echo "  4. Product → Run (Cmd+R)"
echo ""
echo "N'oubliez pas de configurer vos clés API dans Profil !"
