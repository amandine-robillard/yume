# 🤖 Documentation API IA - Yume

## Vue d'ensemble

Yume intègre 3 modèles d'IA pour le décodage des rêves :
- **Claude** (Anthropic) - claude-sonnet-4-20250514
- **GPT** (OpenAI) - gpt-4o
- **Gemini** (Google) - gemini-2.0-flash

Tous utilisent le **même prompt système** pour garantir une cohérence dans les réponses.

---

## 📝 Prompt Système (identique pour les 3 modèles)

```
Tu es un guide onirique bienveillant, versé dans la psychologie jungienne,
le symbolisme universel et les traditions du rêve lucide.
Lorsqu'on te soumet un rêve, tu procèdes en trois temps :

1. 🌙 ATMOSPHÈRE — En 2-3 phrases, décris l'énergie générale et le ton
   émotionnel du rêve, comme si tu peignais une aquarelle de ce monde intérieur.

2. 🔮 SYMBOLES CLÉS — Identifie 2 à 4 symboles ou scènes marquantes.
   Pour chacun, donne une interprétation archétypale courte (1-2 phrases),
   en tenant compte des émotions associées si elles sont fournies.

3. ✨ PISTE DE RÉFLEXION — Propose une question ouverte ou une invitation
   douce à explorer ce que ce rêve pourrait révéler sur la vie intérieure
   du rêveur. Ne donne pas de réponse, seulement une porte entrouverte.

Ton style : poétique mais ancré, chaleureux, jamais anxiogène.
Longueur totale : 250 à 350 mots. Langue : français.
```

---

## 📨 Format du Message Utilisateur

```
Rêve : [dream.content]
Émotions ressenties : [dream.emotions joined by ", "] (omis si vide)
Type : [Rêve lucide / Rêve ordinaire]
```

**Exemple** :
```
Rêve : Je me suis retrouvé sur une montagne, le ciel était dégagé et je pouvais voir toute la vallée. J'ai réalisé que je rêvais et j'ai décidé de m'envoler.
Émotions ressenties : Liberté, Joie, Émerveillement
Type : Rêve lucide
```

---

## 🔌 Implémentations par Provider

### 1. Claude (Anthropic)

**Endpoint** : `https://api.anthropic.com/v1/messages`

**Headers** :
```
x-api-key: [API_KEY]
anthropic-version: 2023-06-01
Content-Type: application/json
```

**Body** :
```json
{
  "model": "claude-sonnet-4-20250514",
  "max_tokens": 700,
  "system": "<system_prompt>",
  "messages": [
    {
      "role": "user",
      "content": "<user_message>"
    }
  ]
}
```

**Response** :
```json
{
  "content": [
    {
      "text": "🌙 ATMOSPHÈRE..."
    }
  ]
}
```

**Parsing** : `response.content[0].text`

---

### 2. GPT (OpenAI)

**Endpoint** : `https://api.openai.com/v1/chat/completions`

**Headers** :
```
Authorization: Bearer [API_KEY]
Content-Type: application/json
```

**Body** :
```json
{
  "model": "gpt-4o",
  "max_tokens": 700,
  "messages": [
    {
      "role": "system",
      "content": "<system_prompt>"
    },
    {
      "role": "user",
      "content": "<user_message>"
    }
  ]
}
```

**Response** :
```json
{
  "choices": [
    {
      "message": {
        "content": "🌙 ATMOSPHÈRE..."
      }
    }
  ]
}
```

**Parsing** : `response.choices[0].message.content`

---

### 3. Gemini (Google)

**Endpoint** : `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=[API_KEY]`

**Headers** :
```
Content-Type: application/json
```

**Body** :
```json
{
  "system_instruction": {
    "parts": [
      {
        "text": "<system_prompt>"
      }
    ]
  },
  "contents": [
    {
      "role": "user",
      "parts": [
        {
          "text": "<user_message>"
        }
      ]
    }
  ],
  "generationConfig": {
    "maxOutputTokens": 700
  }
}
```

**Response** :
```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "🌙 ATMOSPHÈRE..."
          }
        ]
      }
    }
  ]
}
```

**Parsing** : `response.candidates[0].content.parts[0].text`

---

## 🔐 Gestion des Clés API

### Stockage (Keychain)
```swift
// Sauvegarder
try KeychainManager.shared.save(apiKey, for: "anthropic_api_key")
try KeychainManager.shared.save(apiKey, for: "openai_api_key")
try KeychainManager.shared.save(apiKey, for: "gemini_api_key")

// Récupérer
let key = try KeychainManager.shared.retrieve(for: "anthropic_api_key")

// Vérifier existence
let exists = KeychainManager.shared.exists(for: "anthropic_api_key")
```

### Namespace
Toutes les clés sont préfixées par `yume.` dans le Keychain.

---

## 🔄 Flux d'Utilisation

1. **Utilisateur tape "Décoder avec l'IA"** dans DreamDetailView
2. **AIModelPickerSheet s'affiche** avec les 3 modèles
3. **Vérification** : clé API configurée ? 
   - ✅ Oui → Bouton actif
   - ❌ Non → Bouton grisé + badge rouge
4. **Sélection d'un modèle** → dismiss sheet
5. **Loading state** : skeleton animation
6. **Appel API** via AIServiceFactory.make(model).decode(dream)
7. **Success** :
   - Sauvegarder `dream.aiAnalysis` et `dream.aiModel`
   - Afficher dans une carte violette
8. **Error** :
   - Afficher message d'erreur
   - Bouton "Réessayer"

---

## 🎯 Exemple de Réponse IA

```markdown
🌙 ATMOSPHÈRE
Ce rêve baigne dans une lumière cristalline, portée par l'énergie de l'éveil conscient. L'atmosphère y est vaste et légère, comme une aquarelle où le bleu du ciel se fond dans la joie pure de découvrir son propre pouvoir.

🔮 SYMBOLES CLÉS
La montagne représente l'élévation intérieure, ce désir d'atteindre des sommets spirituels. Le vol lucide symbolise la maîtrise consciente de sa propre réalité psychique, un pont entre contrôle et abandon. La vallée en contrebas incarne le regard panoramique sur sa vie, la prise de hauteur qui permet de voir plus loin.

✨ PISTE DE RÉFLEXION
Quel aspect de ta vie appelle à plus de légèreté et de liberté consciente ? Où pourrais-tu t'élever au-dessus des préoccupations quotidiennes pour retrouver cette perspective claire ?
```

---

## 🧪 Tests

### Mock Response (pour développement sans clés)
```swift
struct MockAIService: AIServiceProtocol {
    func decode(dream: Dream) async throws -> String {
        try await Task.sleep(for: .seconds(2)) // Simuler réseau
        return """
🌙 ATMOSPHÈRE
Réponse de test pour le développement.

🔮 SYMBOLES CLÉS
Ceci est un mock pour tester l'UI sans consommer d'API.

✨ PISTE DE RÉFLEXION
Configurez une vraie clé API pour des analyses authentiques.
"""
    }
}
```

### Ajouter au Factory
```swift
static func make(model: AIModel, useMock: Bool = false) -> AIServiceProtocol {
    if useMock {
        return MockAIService()
    }
    // ... reste du code
}
```

---

## 💰 Coûts Estimés

### Claude (Anthropic)
- Input : ~$3 / 1M tokens
- Output : ~$15 / 1M tokens
- **1 rêve** ≈ 200 tokens input + 350 tokens output = **$0.006**

### GPT-4o (OpenAI)
- Input : ~$2.50 / 1M tokens
- Output : ~$10 / 1M tokens
- **1 rêve** ≈ 200 tokens input + 350 tokens output = **$0.004**

### Gemini 2.0 Flash (Google)
- **Gratuit** jusqu'à 15 RPM
- Au-delà : ~$0.075 / 1M tokens
- **1 rêve** ≈ **$0.000** (dans la limite gratuite)

**Recommandation** : Commencez par Gemini pour tester gratuitement.

---

## 🚨 Gestion d'Erreurs

### Erreurs possibles
1. **Clé API manquante** → Redirect vers Profil
2. **Clé invalide** (401) → "Clé API invalide"
3. **Rate limit** (429) → "Trop de requêtes, réessayez plus tard"
4. **Réseau** → "Erreur réseau, vérifiez votre connexion"
5. **Serveur** (500) → "Erreur serveur, réessayez"

### Implémentation
```swift
do {
    let analysis = try await service.decode(dream: dream)
    // Success
} catch KeychainManager.KeychainError.itemNotFound {
    aiError = "Clé API non configurée"
} catch {
    aiError = "Erreur: \(error.localizedDescription)"
}
```

---

**Configuration complète ! 🚀**
