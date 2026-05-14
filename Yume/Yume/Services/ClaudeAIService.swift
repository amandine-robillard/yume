import Foundation

struct ClaudeAIService: AIServiceProtocol {
    private let apiKeyKeychain = "anthropic_api_key"
    private let baseURL = "https://api.anthropic.com/v1/messages"
    
    func decode(dream: Dream) async throws -> String {
        let apiKey = try KeychainManager.shared.retrieve(for: apiKeyKeychain)
        
        let systemPrompt = """
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
"""
        
        let emotionsText = dream.emotions.isEmpty ? "" : "Émotions ressenties : \(dream.emotions.joined(separator: ", "))\n"
        let dreamType = dream.type.rawValue
        
        let userMessage = """
Rêve : \(dream.content)
\(emotionsText)Type : \(dreamType)
"""
        
        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "claude-sonnet-4-20250514",
            "max_tokens": 700,
            "system": systemPrompt,
            "messages": [
                [
                    "role": "user",
                    "content": userMessage
                ]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let response = try JSONDecoder().decode(ClaudeResponse.self, from: data)
        return response.content[0].text
    }
}

private struct ClaudeResponse: Decodable {
    let content: [ContentBlock]
    
    struct ContentBlock: Decodable {
        let text: String
    }
}
