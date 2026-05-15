# Résumé - Export/Import de Données (v2.0)

## 🎯 Objectif
Permettre aux utilisateurs d'exporter et d'importer leurs rêves **avec les émotions** pour faciliter le changement de téléphone ou la sauvegarde des données.

## 📁 Fichiers créés

### 1. **Services/DataExportImportService.swift**
Service responsable de l'export et l'import des données.

**Fonctionnalités:**
- `exportData()` - Exporte tous les rêves + émotions en JSON
- `importData()` - Importe les rêves depuis JSON avec validation des émotions
- `getExportFileURL()` - Génère une URL avec timestamp pour le fichier d'export
- Évite les doublons lors de l'import (vérification par ID)
- **Valide les émotions** pour éviter les corruptions de données

**Format d'export (v2.0):**
```json
{
  "dreams": [{...}],
  "emotions": ["Joie", "Peur", "Sérénité", "Tristesse", "Liberté", "Émerveillement"],
  "exportDate": "2026-05-15T...",
  "version": "2.0"
}
```

## 🔄 Fichiers modifiés

### 2. **Screens/Profil/ProfilViewModel.swift**
**Ajouts:**
- `@Published` variables: `showExportAlert`, `showImportAlert`, `exportMessage`, `importMessage`, `dreams`, `shareItems`, `showShareSheet`, `showFileImporter`
- `modelContext` pour accéder aux données locales
- `loadDreams()` - Charge tous les rêves depuis la base de données
- `exportDreams()` - Exporte les rêves + émotions et prépare le Share Sheet natif iOS
- `importFromFile(url:)` - Importe depuis un fichier sélectionné

**Messages améliorés:**
- Affichage emoji de succès ✅
- Spécification que les émotions sont incluses

**Supprimés:**
- `importDreams()` - Remplacé par `importFromFile(url:)`
- `importFromPasteboard()` - Remplacé par le File Picker
- Import UIKit (pas besoin de UIPasteboard)

### 3. **Screens/Profil/ProfilView.swift**
**Ajouts:**
- Imports: `SwiftData`, `UIKit`, `UniformTypeIdentifiers`
- `@Environment(\.modelContext)` pour accéder au contexte SwiftData
- Nouvelle section "Données" en bas de l'écran (après "Notifications")
- Deux boutons:
  1. **"Exporter les rêves"** - Bouton gradient violet → Share Sheet natif iOS
  2. **"Importer les rêves"** - Bouton gradient bleu → File Picker natif iOS
- `.sheet(isPresented:content:)` - Share Sheet pour les exports
- `.fileImporter(isPresented:allowedContentTypes:onCompletion:)` - File Picker pour JSON
- `ShareSheet` struct - UIViewControllerRepresentable pour UIActivityViewController
- Deux `alert()` pour afficher les messages de succès/erreur

## 📍 Localisation dans l'UI
Les boutons d'export/import se trouvent:
- Onglet: **Profil**
- Section: **"Données"** (tout en bas, après "Notifications")
- 2 boutons avec icônes, titre et description

## ✨ Fonctionnalités principales

### Export (Share Sheet natif iOS)
1. Appuyer sur "Exporter les rêves"
2. Les données incluent:
   - ✅ Tous les rêves
   - ✅ Toutes les émotions disponibles
   - ✅ Les informations complètes de chaque rêve
3. **Share Sheet s'ouvre** avec options natives iOS:
   - Sauvegarder dans Fichiers
   - Envoyer par Mail
   - Partager sur iCloud Drive
   - AirDrop vers un autre appareil
   - Autres applications
4. Message de confirmation avec le nombre de rêves + version 2.0

### Import (File Picker natif iOS)
1. Appuyer sur "Importer les rêves"
2. **File Picker s'ouvre** permettant de sélectionner:
   - Un fichier JSON depuis Fichiers
   - Un email avec pièce jointe JSON
   - Un fichier depuis le cloud
3. Validation automatique:
   - ✅ Vérification des IDs (pas de doublons)
   - ✅ Validation des émotions (seulement les émotions valides)
   - ✅ Création de nouveaux rêves
4. Message de confirmation avec le nombre importés

## 🔒 Sécurité
- ✅ Les données restent toujours locales
- ✅ Les clés API ne sont PAS exportées (stockées en Keychain)
- ✅ Pas de doublons lors de l'import
- ✅ Validation des émotions pour éviter la corruption
- ✅ Utilisateur contrôle complètement ses données

## 🆕 Nouveautés v2.0
- **Émotions incluses dans l'export** - Les tags ne buggent plus
- **Validation des émotions à l'import** - Protection contre la corruption
- **Version numérotée** - Support des anciennes versions (1.0)
- **Meilleurs messages** - Avec emoji et clarté

## 📋 Points d'intégration
1. `DataExportImportService` - Service autonome et réutilisable avec enum Emotion intégré
2. `ProfilViewModel` - Gère la logique d'export/import avec Share Sheet et File Picker
3. `ProfilView` - Interface utilisateur dans le profil + SwiftData + UIActivityViewController
4. SwiftData `ModelContext` - Accès à la base de données

## 🧪 Test recommandé
1. Créer quelques rêves avec différentes émotions
2. Aller dans Profil
3. Exporter les rêves → Share Sheet devrait s'ouvrir
4. Choisir "Fichiers" ou "Mail" pour sauvegarder
5. Importer les rêves → File Picker devrait s'ouvrir
6. Sélectionner le fichier JSON
7. Vérifier que les rêves et émotions sont correctes

## 📚 Documentation complète
Voir: `EXPORT_IMPORT_GUIDE.md`

## 🚀 Améliorations futures possibles
- [ ] Intégration avec iCloud Drive Drive (CloudKit)
- [ ] Chiffrement des données exportées
- [ ] Sélection des rêves à exporter (par date, par émotion, etc.)
- [ ] Comparaison avant import (afficher les doublons)
- [ ] Migration automatique v1.0 → v2.0
- [ ] Historique des imports/exports
