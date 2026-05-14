# 🔄 Gemini API v1 vs v1beta - Différences Clés

## 📋 Résumé des Erreurs Rencontrées

### ❌ Erreur 404 avec v1beta
```
"models/gemini-1.5-flash is not found for API version v1beta"
```
**Solution** : Utiliser l'API `v1` au lieu de `v1beta`

### ❌ Erreur 400 avec system_instruction en v1
```
"Invalid JSON payload received. Unknown name 'system_instruction': Cannot find field."
```
**Solution** : Intégrer le prompt système dans le message utilisateur

---

## 🆚 Comparaison des API

| Fonctionnalité | v1beta | v1 |
|----------------|--------|-----|
| **URL** | `/v1beta/models/...` | `/v1/models/...` |
| **Modèle gemini-1.5-flash** | ❌ Non supporté | ✅ Supporté |
| **system_instruction** | ✅ Supporté | ❌ Non supporté |
| **Champ role** | Requis | Optionnel |
| **Stabilité** | Beta / Expérimental | Stable |

---

## 📦 Structure JSON Correcte pour v1

### ✅ Format Valide (v1)
```json
{
  "contents": [
    {
      "parts": [
        {
          "text": "Instructions système\n\n---\n\nMessage utilisateur"
        }
      ]
    }
  ],
  "generationConfig": {
    "maxOutputTokens": 700
  }
}
```

### ❌ Format v1beta (ne fonctionne pas en v1)
```json
{
  "system_instruction": {
    "parts": [{"text": "Instructions système"}]
  },
  "contents": [
    {
      "role": "user",
      "parts": [{"text": "Message utilisateur"}]
    }
  ]
}
```

---

## 💡 Recommandations

### Pour Yume
✅ **Utiliser l'API v1** car :
- Plus stable et fiable
- Supporte `gemini-1.5-flash` 
- Documentation officielle complète
- Pas de fonctionnalités beta requises

### Structure du Message
Au lieu de séparer les instructions système, les combiner avec le message :
```swift
let fullMessage = """
\(systemPrompt)

---

Rêve : \(dream.content)
Type : \(dreamType)
"""
```

---

## 🔗 Documentation Officielle

- **API v1** : https://ai.google.dev/api/rest/v1/models/generateContent
- **API v1beta** : https://ai.google.dev/api/rest/v1beta/models/generateContent

---

## ✅ Configuration Finale pour Yume

```swift
// URL de l'API
private let baseURL = "https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent"

// Payload JSON simplifié
let body: [String: Any] = [
    "contents": [
        [
            "parts": [
                ["text": fullMessage]
            ]
        ]
    ],
    "generationConfig": [
        "maxOutputTokens": 700
    ]
]
```

**Status** : ✅ **FONCTIONNEL**

---

**Note** : Si vous avez besoin de `system_instruction` à l'avenir, vous devrez revenir à v1beta et utiliser un modèle compatible (comme `gemini-pro` au lieu de `gemini-1.5-flash`).
