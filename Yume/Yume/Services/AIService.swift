import Foundation

protocol AIServiceProtocol {
    func decode(dream: Dream) async throws -> String
}

struct AIServiceFactory {
    static func make(model: AIModel) -> AIServiceProtocol {
        switch model {
        case .claude:
            return ClaudeAIService()
        case .gpt:
            return GPTAIService()
        case .gemini:
            return GeminiAIService()
        }
    }
}
