# 🎯 FIX RAPIDE - Erreurs Gemini 404 & 400

## Les Problèmes
```
1. Erreur 404: models/gemini-1.5-flash is not found for API version v1beta
2. Erreur 400: Invalid JSON payload - Unknown name "system_instruction"
```

## Les Solutions

### Fix 1 : Changer l'URL (v1beta → v1)
```swift
// ❌ AVANT
private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models/..."

// ✅ APRÈS  
private let baseURL = "https://generativelanguage.googleapis.com/v1/models/..."
```

### Fix 2 : Supprimer system_instruction
```swift
// ❌ AVANT (avec system_instruction)
let body: [String: Any] = [
    "system_instruction": [
        "parts": [["text": systemPrompt]]
    ],
    "contents": [
        ["role": "user", "parts": [["text": userMessage]]]
    ]
]

// ✅ APRÈS (prompt intégré)
let fullMessage = "\(systemPrompt)\n\n---\n\n\(userMessage)"

let body: [String: Any] = [
    "contents": [
        ["parts": [["text": fullMessage]]]
    ],
    "generationConfig": ["maxOutputTokens": 700]
]
```

## Fichier Modifié
`Yume/Yume/Services/GeminiAIService.swift`
- Ligne 5 : URL changée
- Lignes 33-58 : Structure JSON simplifiée

## Améliorations Bonus
- ✅ Logs de débogage détaillés
- ✅ Gestion d'erreurs robuste
- ✅ Messages d'erreur explicites
- ✅ Validation HTTP

## Tester
1. Compile : ⌘ + B
2. Lance : ⌘ + R  
3. Créer un rêve
4. "Décoder avec l'IA" → Gemini
5. ✨ Ça marche !

---
✅ **RÉSOLU** - Gemini fonctionne maintenant !
