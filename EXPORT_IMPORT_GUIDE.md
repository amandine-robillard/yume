# Export/Import de Données - Yume

## Vue d'ensemble
Cette fonctionnalité permet d'exporter et d'importer tous vos rêves **avec les émotions associées**. Elle est utile pour:
- **Changer de téléphone** - Transférer tous vos rêves et émotions facilement
- **Sauvegarder** - Créer une copie de sécurité de vos données
- **Partage sécurisé** - Exporter vos données au format JSON où vous le souhaitez

## Localisation
L'interface se trouve dans l'onglet **Profil**, en bas de l'écran, dans la section **"Données"**.

## Fonctionnalités

### 1. Exporter les rêves
**Bouton:** "Exporter les rêves"

L'export:
- Crée un fichier JSON contenant tous vos rêves
- **Inclut toutes les émotions** (pour éviter les bugs sur les tags)
- Inclut toutes les informations: titre, contenu, date, type, émotions, analyses IA
- Ouvre le **Share Sheet natif iOS** qui vous permet de:
  - Sauvegarder dans Fichiers
  - Envoyer par Mail
  - Partager sur iCloud Drive
  - AirDrop vers un autre appareil
  - Utiliser d'autres applications

**Format du fichier:**
```json
{
  "dreams": [
    {
      "id": "UUID",
      "title": "Titre du rêve",
      "date": "2026-05-15T10:30:00Z",
      "content": "Contenu du rêve",
      "isRemembered": true,
      "isLucid": false,
      "dreamType": "Rêve",
      "emotions": ["Joie", "Surprise"],
      "aiAnalysis": "...",
      "aiModel": "Claude 3.5 Sonnet"
    }
  ],
  "emotions": ["Joie", "Peur", "Sérénité", "Tristesse", "Liberté", "Émerveillement"],
  "exportDate": "2026-05-15T10:30:00Z",
  "version": "2.0"
}
```

### 2. Importer les rêves
**Bouton:** "Importer les rêves"

L'import:
- Ouvre le **sélecteur de fichiers natif iOS**
- Vous pouvez choisir un fichier JSON depuis:
  - Fichiers (iCloud Drive, stockage local, etc.)
  - Mail (les pièces jointes JSON)
  - Cloud Drive (Google Drive, Dropbox, OneDrive, etc.)
- **Valide les émotions** pour s'assurer qu'elles existent
- Importe uniquement les nouveaux rêves (évite les doublons par ID)
- Ajoute les rêves à votre base de données locale
- Affiche le nombre de rêves importés

## Procédure complète : Changer de téléphone

### Sur l'ancien téléphone:
1. Ouvrez l'app **Yume**
2. Allez à l'onglet **Profil**
3. Faites défiler jusqu'à la section **"Données"**
4. Appuyez sur **"Exporter les rêves"**
5. Choisissez où sauvegarder:
   - **Fichiers** - Pour accéder ultérieurement
   - **Mail** - Pour vous envoyer le fichier
   - **iCloud Drive** - Pour avoir un cloud backup
   - **AirDrop** - Pour un transfert direct vers un autre appareil
   - Autre application de votre choix

### Sur le nouveau téléphone:
1. Installez **Yume**
2. Ouvrez l'app
3. Allez à l'onglet **Profil**
4. Faites défiler jusqu'à la section **"Données"**
5. Appuyez sur **"Importer les rêves"**
6. Sélectionnez le fichier JSON:
   - Depuis Fichiers
   - Depuis Mail (pièce jointe)
   - Depuis votre cloud favori
7. Confirmez l'import
8. Tous vos rêves et émotions sont maintenant sur votre nouveau téléphone! ✅

## Points importants

✅ **Flexibilité:**
- Utilisez le système de fichiers iOS natif
- Sauvegardez où vous le souhaitez
- Partagez facilement via vos applications préférées

✅ **Sécurité:**
- Les données restent toujours locales sur votre appareil
- Les clés API ne sont PAS exportées (elles sont stockées dans Keychain)
- Vous contrôlez complètement qui accède à vos données

✅ **Émotions:**
- Toutes les émotions disponibles sont exportées avec les rêves
- Les émotions sont validées lors de l'import (pas de corruption de données)
- Les tags sur vos rêves resteront intacts

✅ **Évite les doublons:**
- Si un rêve avec le même ID existe déjà, il n'est pas importé deux fois
- Vous pouvez importer le même fichier plusieurs fois sans crainte

⚠️ **Important:**
- L'export inclut TOUS vos rêves
- Les clés API sont stockées séparément et doivent être re-configurées sur le nouveau téléphone
- Pour une sécurité maximale, n'envoyez pas vos données exportées à d'autres personnes
- Les fichiers d'export ont l'extension `.json` pour faciliter l'identification

## Dépannage

**"Erreur lors de la sélection du fichier"**
- Assurez-vous que le fichier est au format JSON
- Vérifiez que vous avez les droits d'accès au dossier

**"Erreur lors de l'import: données invalides"**
- Vérifiez que le JSON est valide
- Assurez-vous d'avoir copié la bonne version du fichier d'export
- Vérifiez que la version du fichier est compatible (version 1.0 ou 2.0)

**"0 rêve(s) importé(s)"**
- Tous les rêves du fichier existent déjà dans votre base de données
- C'est normal si vous importez le même fichier plusieurs fois

**Les émotions ne sont pas correctes après l'import**
- Les émotions invalides sont filtrées automatiquement
- Seules les émotions reconnues sont importées
- C'est une protection contre la corruption de données

## Format d'export compatible

Le service exporte au format JSON standardisé. Vous pouvez:
- Editer manuellement le fichier JSON si vous le souhaitez
- L'importer sur un autre appareil iOS avec Yume
- Le stocker comme sauvegarde
- Le partager (avec prudence) avec d'autres utilisateurs Yume

### Versions supportées:
- **1.0** - Rêves sans émotions explicites (conversion automatique)
- **2.0** - Rêves + émotions (recommandé)
