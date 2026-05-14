import Foundation

struct GeminiAIService: AIServiceProtocol {
    private let apiKeyKeychain = "gemini_api_key"
    private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent"
    
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
        
        // Combine system prompt and user message for v1 API
        let fullMessage = """
\(systemPrompt)

---

Rêve : \(dream.content)
\(emotionsText)Type : \(dreamType)
"""
        
        var request = URLRequest(url: URL(string: "\(baseURL)?key=\(apiKey)")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
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
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        // Debug: Print request body
        if let bodyData = request.httpBody,
           let bodyString = String(data: bodyData, encoding: .utf8) {
            print("🔍 Gemini Request Body: \(bodyString)")
        }
        
        let (data, httpResponse) = try await URLSession.shared.data(for: request)
        
        // Check HTTP status code
        if let httpResponse = httpResponse as? HTTPURLResponse {
            guard (200...299).contains(httpResponse.statusCode) else {
                // Try to parse error message
                if let errorString = String(data: data, encoding: .utf8) {
                    print("❌ Gemini API Error Response: \(errorString)")
                    throw NSError(domain: "GeminiAIService", code: httpResponse.statusCode,
                                userInfo: [NSLocalizedDescriptionKey: "Erreur API Gemini (\(httpResponse.statusCode)). Vérifiez votre clé API."])
                }
                throw NSError(domain: "GeminiAIService", code: httpResponse.statusCode,
                            userInfo: [NSLocalizedDescriptionKey: "Erreur API Gemini (\(httpResponse.statusCode))"])
            }
        }
        
        // Debug: Print raw response
        if let jsonString = String(data: data, encoding: .utf8) {
            print("🔍 Gemini Raw Response: \(jsonString)")
        }
        
        // Decode response
        do {
            let response = try JSONDecoder().decode(GeminiResponse.self, from: data)
            
            // Check for API error
            if let error = response.error {
                let errorMsg = error.message ?? "Erreur inconnue"
                print("❌ Gemini API Error: \(errorMsg)")
                throw NSError(domain: "GeminiAIService", code: error.code ?? -1,
                            userInfo: [NSLocalizedDescriptionKey: "Erreur Gemini: \(errorMsg)"])
            }
            
            // Validate response structure
            guard let candidates = response.candidates, !candidates.isEmpty else {
                throw NSError(domain: "GeminiAIService", code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "Aucune réponse de l'API Gemini"])
            }
            
            guard let content = candidates[0].content,
                  let parts = content.parts, !parts.isEmpty else {
                throw NSError(domain: "GeminiAIService", code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "Réponse vide de l'API Gemini"])
            }
            
            guard let text = parts[0].text, !text.isEmpty else {
                throw NSError(domain: "GeminiAIService", code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "Texte vide dans la réponse Gemini"])
            }
            
            return text
        } catch let error as NSError where error.domain == "GeminiAIService" {
            // Re-throw our custom errors
            throw error
        } catch {
            print("❌ Gemini Decoding Error: \(error)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📄 Raw response: \(jsonString)")
            }
            throw NSError(domain: "GeminiAIService", code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Impossible de décoder la réponse de Gemini. Vérifiez les logs."])
        }
    }
}

private struct GeminiResponse: Decodable {
    let candidates: [Candidate]?
    let error: GeminiError?
    
    struct Candidate: Decodable {
        let content: Content?
        let finishReason: String?
        
        struct Content: Decodable {
            let parts: [Part]?
            let role: String?
            
            struct Part: Decodable {
                let text: String?
            }
        }
    }
    
    struct GeminiError: Decodable {
        let code: Int?
        let message: String?
        let status: String?
    }
}
