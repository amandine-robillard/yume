# 🚀 Guide de Démarrage Rapide - Yume

## Option 1 : Création Manuelle dans Xcode (Recommandé)

### Étape 1 : Créer le projet

1. **Ouvrez Xcode**
2. **File → New → Project**
3. Sélectionnez **iOS → App**
4. Configuration :
   - **Product Name** : `Yume`
   - **Team** : (votre compte Apple)
   - **Organization Identifier** : `com.amandinerobillard` (ou votre propre identifiant)
   - **Interface** : **SwiftUI**
   - **Language** : **Swift**
   - **Storage** : Cochez **"Use SwiftData"**
   - **Include Tests** : Décochez (optionnel)
5. **Sauvegardez dans** : `/Users/amandinerobillard/Documents/developpement/yume/`
6. Choisissez **"Don't create Git repository"** si demandé (on a déjà un repo)

### Étape 2 : Supprimer les fichiers auto-générés

Dans le navigateur Xcode, **supprimez** :
- ❌ `ContentView.swift` (auto-généré)
- ❌ `Item.swift` (si présent)

### Étape 3 : Importer les fichiers

**Faites glisser** les dossiers suivants dans Xcode (depuis le Finder) :
- ✅ `YumeApp.swift`
- ✅ `ContentView.swift`
- ✅ `Models/`
- ✅ `Design/`
- ✅ `Services/`
- ✅ `Components/`
- ✅ `Screens/`

**Important** : Cochez **"Copy items if needed"** et **"Create groups"**

### Étape 4 : Configuration du Target

1. Sélectionnez **Yume** (projet) dans le navigateur
2. Allez dans **Yume (Target) → General**
3. **Minimum Deployments** : `iOS 17.0`
4. **Supported Destinations** : Cochez uniquement **iPhone**

### Étape 5 : Info.plist

1. Dans le navigateur, faites glisser `Info.plist` dans le projet
2. Ou créez-le : File → New → File → Property List → `Info.plist`
3. Copiez le contenu depuis le fichier `Info.plist` du repo

### Étape 6 : Build & Run

1. Sélectionnez un **simulateur iPhone** (iOS 17+)
2. **Product → Build** (⌘ + B)
3. Corrigez les erreurs éventuelles
4. **Product → Run** (⌘ + R)

---

## Option 2 : Avec xcodegen (Automatique)

### Prérequis

```bash
brew install xcodegen
```

### Génération

```bash
cd /Users/amandinerobillard/Documents/developpement/yume/
./generate_xcode_project.sh
```

### Ouverture

```bash
open Yume.xcodeproj
```

---

## 🔧 Résolution de Problèmes

### Erreur : "Cannot find 'Dream' in scope"

→ Vérifiez que tous les fichiers `.swift` sont bien dans le Target :
1. Sélectionnez un fichier dans le navigateur
2. **File Inspector** (à droite)
3. Cochez **Yume** dans "Target Membership"

### Erreur : "SwiftData not found"

→ Deployment Target iOS 17.0+ requis :
1. Projet → General → Minimum Deployments → iOS 17.0

### Erreur : Keychain access

→ Ajoutez la capability :
1. Target → Signing & Capabilities
2. **+ Capability** → **Keychain Sharing**

### L'app crash au lancement

→ Vérifiez que `YumeApp.swift` contient bien `@main` et importe `SwiftData`

---

## 🎨 Premier Lancement

1. L'app s'ouvre sur **Accueil**
2. Tapez **+ Noter un rêve** pour créer votre premier rêve
3. Allez dans **Profil** pour configurer vos clés API (optionnel)
4. Explorez **Statistiques** et **Rêves** pour voir vos données

---

## 📦 Structure Finale dans Xcode

```
Yume/
├── 📁 Models
│   ├── Dream.swift
│   ├── Emotion.swift
│   └── AIModel.swift
├── 📁 Design
│   ├── AppTheme.swift
│   └── GlassmorphismStyle.swift
├── 📁 Services
│   ├── KeychainManager.swift
│   ├── AIService.swift
│   ├── ClaudeAIService.swift
│   ├── GPTAIService.swift
│   ├── GeminiAIService.swift
│   └── DreamRepository.swift
├── 📁 Components
│   ├── CalendarView.swift
│   ├── DreamCard.swift
│   ├── GlassCard.swift
│   ├── TabBar.swift
│   └── AIModelPickerSheet.swift
├── 📁 Screens
│   ├── 📁 Accueil
│   │   ├── AccueilView.swift
│   │   └── AccueilViewModel.swift
│   ├── 📁 DreamEntry
│   │   ├── DreamEntryView.swift
│   │   └── DreamEntryViewModel.swift
│   ├── 📁 DreamDetail
│   │   ├── DreamDetailView.swift
│   │   ├── DreamDetailViewModel.swift
│   │   └── DreamEditView.swift
│   ├── 📁 Dreams
│   │   ├── DreamsListView.swift
│   │   └── DreamsListViewModel.swift
│   ├── 📁 Statistiques
│   │   ├── StatistiquesView.swift
│   │   └── StatistiquesViewModel.swift
│   └── 📁 Profil
│       ├── ProfilView.swift
│       └── ProfilViewModel.swift
├── YumeApp.swift
├── ContentView.swift
└── Info.plist
```

---

**Prêt à rêver ! 🌙✨**
