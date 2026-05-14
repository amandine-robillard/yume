import Foundation

enum AIModel: String, CaseIterable {
    case claude = "Claude"
    case gpt = "GPT"
    case gemini = "Gemini"
    
    var version: String {
        switch self {
        case .claude:
            return "claude-sonnet-4-20250514"
        case .gpt:
            return "gpt-4o"
        case .gemini:
            return "gemini-2.0-flash"
        }
    }
    
    var provider: String {
        switch self {
        case .claude:
            return "Anthropic"
        case .gpt:
            return "OpenAI"
        case .gemini:
            return "Google"
        }
    }
}
