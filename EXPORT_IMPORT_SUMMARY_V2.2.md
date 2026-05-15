# Résumé - Export/Import de Données (v2.2)

## 🎯 Objectif
Permettre aux utilisateurs d'exporter et d'importer leurs rêves **avec les émotions personnalisées** pour faciliter le changement de téléphone ou la sauvegarde des données. Offrir une option flexible lors de l'import (fusion ou remplacement).

## 📁 Fichiers créés

### 1. **Services/DataExportImportService.swift**
Service responsable de l'export et l'import des données.

**Fonctionnalités:**
- `exportData()` - Exporte tous les rêves + émotions personnalisées en JSON
- `importData(replaceExisting:)` - Importe les rêves depuis JSON avec option de fusion/remplacement
- `getExportFileURL()` - Génère une URL avec timestamp pour le fichier d'export
- Évite les doublons lors de l'import (vérification par ID)
- Valide les émotions (personnalisées + défaut)
- Retourne un `ImportResult` avec détails de l'import

**Format d'export (v2.2):**
```json
{
  "dreams": [{...}],
  "customEmotions": ["Panique", "Excitation"],
  "exportDate": "2026-05-15T...",
  "version": "2.2"
}
```

### 2. **Services/CustomEmotionService.swift** (NEW)
Service pour gérer les émotions personnalisées ajoutées par l'utilisateur.

**Fonctionnalités:**
- Stockage des émotions personnalisées (UserDefaults)
- Filtre automatiquement les émotions par défaut
- `getCustomEmotions()` - Récupère les émotions perso
- `addCustomEmotion()` - Ajoute une émotion personnalisée
- `removeCustomEmotion()` - Supprime une émotion personnalisée
- `addCustomEmotions()` - Ajoute plusieurs émotions
- `setCustomEmotions()` - Remplace toutes les émotions perso
- `clearCustomEmotions()` - Efface toutes les émotions perso

## 🔄 Fichiers modifiés

### 3. **Screens/Profil/ProfilViewModel.swift**
**Ajouts:**
- Import: `CustomEmotionService`
- `@Published` variables: `showImportOptions`, `importFileURL`
- `importFromFile(url:)` - Sauvegarde l'URL et affiche le dialogue d'options
- `performImport(replaceExisting:)` - Effectue l'import avec l'option choisie

**Modifications:**
- `exportDreams()` - Affiche le nombre d'émotions personnalisées
- Messages améliorés avec détails de l'import

### 4. **Screens/Profil/ProfilView.swift**
**Ajouts:**
- `.confirmationDialog()` - Dialogue pour choisir l'option d'import:
  - "Mixer avec les données existantes" (défaut)
  - "Remplacer toutes les données" (destructeur)
  - "Annuler"

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
   - ✅ **Seulement les émotions personnalisées** (pas les 6 émotions par défaut)
   - ✅ Les informations complètes de chaque rêve
3. **Share Sheet s'ouvre** avec options natives iOS:
   - Sauvegarder dans Fichiers
   - Envoyer par Mail
   - Partager sur iCloud Drive
   - AirDrop vers un autre appareil
   - Autres applications
4. Message de confirmation avec le nombre de rêves + émotions perso

### Import (File Picker + Dialogue d'options)
1. Appuyer sur "Importer les rêves"
2. **File Picker s'ouvre** permettant de sélectionner le fichier JSON
3. **Dialogue d'options apparaît:**
   - 🔄 "Mixer avec les données existantes" - Conserve les rêves existants + ajoute les nouveaux
   - ⚠️ "Remplacer toutes les données" - Supprime tous les rêves et les remplace par ceux du fichier
   - ❌ "Annuler" - Annule l'import
4. Validation automatique:
   - ✅ Vérification des IDs (pas de doublons en mode fusion)
   - ✅ Validation des émotions (défaut + personnalisées)
   - ✅ Création de nouveaux rêves
   - ✅ Import des émotions personnalisées
5. Message de confirmation avec détails de l'import

## 🔒 Sécurité & Émotions

✅ **Émotions personnalisées:**
- **Émotions par défaut (NON exportées):** Joie, Peur, Sérénité, Tristesse, Liberté, Émerveillement
- **Émotions personnalisées (EXPORTÉES):** Uniquement celles ajoutées par l'utilisateur
- Filtre automatique lors de l'import
- Protection contre la corruption de données

✅ **Fusion vs Remplacement:**
- **Fusion (défaut):** Conserve les rêves existants + importe les nouveaux (pas de doublons)
- **Remplacement:** Efface tous les rêves + importe les nouveaux
- L'utilisateur choisit l'option à chaque import

✅ **Sécurité générale:**
- Les données restent toujours locales sur votre appareil
- Les clés API ne sont PAS exportées (stockées en Keychain)
- Vous contrôlez complètement qui accède à vos données

## 🆕 Nouveautés v2.2
- **Émotions personnalisées uniquement** - Plus léger et plus flexible
- **Dialogue d'options d'import** - Fusion ou remplacement à volonté
- **CustomEmotionService** - Gestion complète des émotions perso
- **ImportResult** - Détails de l'import (rêves + émotions)

## 📋 Points d'intégration
1. `CustomEmotionService` - Gestion des émotions personnalisées (UserDefaults)
2. `DataExportImportService` - Export/import avec options flexibles
3. `ProfilViewModel` - Logique d'export/import avec dialogue
4. `ProfilView` - Interface utilisateur + Dialogue de confirmation
5. SwiftData `ModelContext` - Accès à la base de données

## 🧪 Test recommandé
1. Créer quelques rêves avec émotions personnalisées
2. Exporter les rêves → Vérifier que seules les émotions perso sont exportées
3. Importer les rêves:
   - Tester "Mixer" - Les rêves existants sont conservés
   - Tester "Remplacer" - Les anciens rêves sont supprimés
4. Vérifier que les émotions et rêves sont corrects

## 📚 Documentation complète
Voir: `EXPORT_IMPORT_GUIDE.md`

## 🚀 Améliorations futures possibles
- [ ] Intégration avec iCloud Drive (CloudKit)
- [ ] Chiffrement des données exportées
- [ ] Sélection des rêves à exporter (par date, par émotion)
- [ ] Comparaison avant import (afficher les doublons)
- [ ] Historique des imports/exports
- [ ] Synchronisation automatique entre appareils
