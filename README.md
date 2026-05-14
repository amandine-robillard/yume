# Yume - Dream Journal App

Une application de journal de rêves en SwiftUI avec intégration IA (Claude, GPT, Gemini).

## 📱 Fonctionnalités

- **Journal de rêves** : Enregistrez vos rêves (souvenus ou oubliés), marquez-les comme lucides
- **Émotions** : Associez des émotions à chaque rêve
- **Calendrier** : Visualisez vos rêves sur un calendrier mensuel avec codes couleur
- **Décodage IA** : Analysez vos rêves avec Claude, GPT ou Gemini
- **Statistiques** : Graphiques et stats sur vos rêves (lucidité, émotions, évolution)
- **Profil** : Gestion des clés API, modèle préféré, rappels quotidiens

## 🎨 Design

- **Thème sombre** avec glassmorphisme
- **Navy profond** (#0A0E1A) + cartes (#12172B)
- **Accents violets** : #7B5EA7, #A78BFA
- **SF Pro Rounded**
- **Codes couleur** : Gris (oublié) / Violet (rêve) / Violet clair (lucide)

## 🛠️ Configuration du projet Xcode

### 1. Créer le projet Xcode

1. Ouvrez Xcode
2. Créez un nouveau projet : **App** (iOS)
3. **Product Name** : Yume
4. **Organization Identifier** : com.yourname (remplacez)
5. **Interface** : SwiftUI
6. **Language** : Swift
7. **Storage** : None (on utilise SwiftData manuellement)
8. Cochez **"Use SwiftData"** si disponible
9. Sauvegardez dans : `/Users/amandinerobillard/Documents/developpement/yume/`

### 2. Organiser les fichiers

**Supprimez** les fichiers auto-générés :
- `ContentView.swift` (on a le nôtre)
- `Item.swift` (si présent)

**Structure finale** dans Xcode :
```
Yume/
├── YumeApp.swift
├── ContentView.swift
├── Models/
│   ├── Dream.swift
│   ├── Emotion.swift
│   └── AIModel.swift
├── Design/
│   ├── AppTheme.swift
│   └── GlassmorphismStyle.swift
├── Services/
│   ├── KeychainManager.swift
│   ├── AIService.swift
│   ├── ClaudeAIService.swift
│   ├── GPTAIService.swift
│   ├── GeminiAIService.swift
│   └── DreamRepository.swift
├── Components/
│   ├── CalendarView.swift
│   ├── DreamCard.swift
│   ├── GlassCard.swift
│   ├── TabBar.swift
│   └── AIModelPickerSheet.swift
├── Screens/
│   ├── Accueil/
│   │   ├── AccueilView.swift
│   │   └── AccueilViewModel.swift
│   ├── DreamEntry/
│   │   ├── DreamEntryView.swift
│   │   └── DreamEntryViewModel.swift
│   ├── DreamDetail/
│   │   ├── DreamDetailView.swift
│   │   ├── DreamDetailViewModel.swift
│   │   └── DreamEditView.swift
│   ├── Dreams/
│   │   ├── DreamsListView.swift
│   │   └── DreamsListViewModel.swift
│   ├── Statistiques/
│   │   ├── StatistiquesView.swift
│   │   └── StatistiquesViewModel.swift
│   └── Profil/
│       ├── ProfilView.swift
│       └── ProfilViewModel.swift
```

**Faites glisser** tous les fichiers du dossier dans Xcode en respectant cette structure.

### 3. Configuration du projet

#### Target Settings
1. Sélectionnez le projet **Yume** dans le navigateur
2. Target **Yume** → General
3. **Minimum Deployments** : iOS 17.0
4. **Supported Destinations** : iPhone only

#### Info.plist
Ajoutez ces clés (clic droit sur Info → Open As → Source Code) :

```xml
<key>UILaunchScreen</key>
<dict>
    <key>UIColorName</key>
    <string>background</string>
</dict>
<key>UISupportedInterfaceOrientations</key>
<array>
    <string>UIInterfaceOrientationPortrait</string>
</array>
```

#### Capacités
1. Target → **Signing & Capabilities**
2. Ajoutez **"Keychain Sharing"** (pour stocker les clés API)
3. Keychain Groups : `$(AppIdentifierPrefix)com.yourname.Yume`

### 4. Compilation

1. Sélectionnez un simulateur iPhone (iOS 17+) ou votre device
2. **Product → Build** (Cmd+B)
3. Corrigez les erreurs éventuelles (imports manquants, etc.)
4. **Product → Run** (Cmd+R)

## 🔑 Configuration des clés API

### Anthropic (Claude)
1. Allez sur https://console.anthropic.com/
2. Créez une clé API
3. Dans l'app → Profil → collez la clé

### OpenAI (GPT)
1. Allez sur https://platform.openai.com/api-keys
2. Créez une clé API
3. Dans l'app → Profil → collez la clé

### Google (Gemini)
1. Allez sur https://aistudio.google.com/apikey
2. Créez une clé API
3. Dans l'app → Profil → collez la clé

## 📝 Utilisation

1. **Accueil** : Visualisez vos stats et rêves récents
2. **+ Noter un rêve** : 
   - "Tu te souviens ?" → Oui/Non
   - Si Non : sauvegarde automatique en "Rêve oublié"
   - Si Oui : formulaire complet (titre, date, récit, lucide, émotions)
3. **Rêves** : Liste filtrable (Tous/Lucides/Oubliés)
4. **Statistiques** : Graphiques et évolution
5. **Profil** : Clés API, modèle préféré, rappels

## ⚠️ Prérequis

- **macOS** 13+ avec Xcode 15+
- **iOS 17+** (simulateur ou device)
- Clés API (optionnel mais recommandé pour le décodage IA)

## 🚫 Limitations

- **Pas de backend** : données stockées localement (SwiftData)
- **Pas de sync** entre appareils
- **Pas de distribution** : usage personnel uniquement
- **Pas d'onboarding** : l'app démarre directement sur Accueil

## 🧪 Tests

Pour tester sans clés API :
1. Créez quelques rêves manuellement
2. Les fonctions non-IA (calendrier, stats, liste) fonctionnent sans clé
3. Le bouton "Décoder avec l'IA" affichera "Non configurée" si pas de clé

## 📄 Licence

Usage personnel uniquement. Pas de distribution sur l'App Store.

---

**Bon développement ! 🌙✨**

