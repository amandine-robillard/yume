# 🤖 Modèles Gemini - Guide de Compatibilité

## 📋 Problème des Noms de Modèles

Les modèles Gemini ont des noms différents selon la version de l'API utilisée.

---

## ✅ Modèles Disponibles dans l'API v1

### 1. `gemini-pro` ✅ **RECOMMANDÉ**
- **Status** : Stable et disponible
- **Type** : Modèle généraliste de haute qualité
- **Usage** : Génération de texte, analyse, conversations
- **Limite de tokens** : ~30k tokens d'entrée
- **Vitesse** : Rapide
- **URL** : `.../v1/models/gemini-pro:generateContent`

### 2. `gemini-pro-vision`
- **Status** : Disponible
- **Type** : Modèle multimodal (texte + images)
- **Usage** : Analyse d'images avec du texte
- **Note** : Non nécessaire pour Yume (texte uniquement)

---

## ❌ Modèles NON Disponibles dans l'API v1

### `gemini-1.5-flash` ❌
```
Error 404: "models/gemini-1.5-flash is not found for API version v1"
```
- Disponible uniquement dans v1beta ou v2
- Plus récent mais pas dans l'API stable

### `gemini-1.5-flash-latest` ❌
```
Error 404: "models/gemini-1.5-flash-latest is not found for API version v1"
```
- Alias du modèle ci-dessus
- Même problème de compatibilité

### `gemini-1.5-pro` ❌
- Disponible uniquement dans v1beta
- Version plus puissante mais pas stable

### `gemini-2.0-flash` ❌
- Version très récente / expérimentale
- Pas encore dans l'API stable

---

## 🎯 Configuration pour Yume

### ✅ Configuration Actuelle (Fonctionnelle)

```swift
private let baseURL = "https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent"
```

**Pourquoi `gemini-pro` ?**
- ✅ Disponible dans l'API v1 (stable)
- ✅ Performances excellentes pour l'analyse de texte
- ✅ Pas de problème de compatibilité
- ✅ Documentation complète
- ✅ Support à long terme garanti

---

## 🔄 Alternatives Futures

Si vous voulez utiliser des modèles plus récents (1.5-flash, etc.), vous devrez :

### Option A : Utiliser l'API v1beta
```swift
private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent"
```

**Avec system_instruction supporté** :
```swift
let body: [String: Any] = [
    "system_instruction": [
        "parts": [["text": systemPrompt]]
    ],
    "contents": [
        ["role": "user", "parts": [["text": userMessage]]]
    ]
]
```

⚠️ **Risques** :
- API beta = peut changer sans préavis
- Moins stable
- Peut avoir des bugs

### Option B : Attendre la disponibilité en v1
- Surveiller les annonces de Google
- Migrer quand le modèle sera disponible

---

## 📊 Comparaison des Modèles

| Modèle | API v1 | API v1beta | Qualité | Vitesse |
|--------|--------|------------|---------|---------|
| **gemini-pro** | ✅ | ✅ | ⭐⭐⭐⭐ | ⚡⚡⚡ |
| gemini-pro-vision | ✅ | ✅ | ⭐⭐⭐⭐ | ⚡⚡ |
| gemini-1.5-flash | ❌ | ✅ | ⭐⭐⭐⭐ | ⚡⚡⚡⚡ |
| gemini-1.5-pro | ❌ | ✅ | ⭐⭐⭐⭐⭐ | ⚡⚡ |

---

## 💡 Recommandation Finale

**Pour Yume** : Rester avec `gemini-pro` dans l'API v1

**Raisons** :
1. ✅ **Stabilité** : API v1 = production-ready
2. ✅ **Performance** : Largement suffisant pour analyser des rêves
3. ✅ **Fiabilité** : Pas de surprises ou changements inattendus
4. ✅ **Support** : Documentation officielle complète
5. ✅ **Coût** : Même tarification que les autres modèles

**Test effectué** : ✅ Build réussi avec `gemini-pro`

---

## 🔗 Ressources

- **Liste des modèles v1** : https://ai.google.dev/api/rest/v1/models/list
- **Documentation gemini-pro** : https://ai.google.dev/models/gemini
- **Tarification** : https://ai.google.dev/pricing

---

**Conclusion** : `gemini-pro` est le meilleur choix pour Yume actuellement. ✅
