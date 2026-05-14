import Foundation
import Combine

@MainActor
final class ProfilViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var anthropicKey: String = ""
    @Published var openaiKey: String = ""
    @Published var geminiKey: String = ""
    @Published var preferredModel: AIModel = .claude
    @Published var notificationsEnabled: Bool = false
    @Published var reminderTime: Date = Calendar.current.date(from: DateComponents(hour: 7, minute: 0)) ?? Date()
    
    @Published var showAnthropicKey: Bool = false
    @Published var showOpenAIKey: Bool = false
    @Published var showGeminiKey: Bool = false
    
    private let keychainManager = KeychainManager.shared
    
    init() {
        loadUserData()
        loadAPIKeys()
    }
    
    func loadUserData() {
        firstName = UserDefaults.standard.string(forKey: "userName") ?? ""
        if let modelRaw = UserDefaults.standard.string(forKey: "preferredModel"),
           let model = AIModel(rawValue: modelRaw) {
            preferredModel = model
        }
        notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        
        // Load reminder time
        if let savedTime = UserDefaults.standard.object(forKey: "reminderTime") as? Date {
            reminderTime = savedTime
        } else {
            reminderTime = Calendar.current.date(from: DateComponents(hour: 7, minute: 0)) ?? Date()
        }
    }
    
    func loadAPIKeys() {
        anthropicKey = (try? keychainManager.retrieve(for: "anthropic_api_key")) ?? ""
        openaiKey = (try? keychainManager.retrieve(for: "openai_api_key")) ?? ""
        geminiKey = (try? keychainManager.retrieve(for: "gemini_api_key")) ?? ""
    }
    
    func saveUserData() {
        UserDefaults.standard.set(firstName, forKey: "userName")
        UserDefaults.standard.set(preferredModel.rawValue, forKey: "preferredModel")
        UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled")
        UserDefaults.standard.set(reminderTime, forKey: "reminderTime")
    }
    
    func saveAPIKeys() {
        // Anthropic
        if !anthropicKey.isEmpty {
            try? keychainManager.save(anthropicKey, for: "anthropic_api_key")
        } else {
            try? keychainManager.delete(for: "anthropic_api_key")
        }
        
        // OpenAI
        if !openaiKey.isEmpty {
            try? keychainManager.save(openaiKey, for: "openai_api_key")
        } else {
            try? keychainManager.delete(for: "openai_api_key")
        }
        
        // Gemini
        if !geminiKey.isEmpty {
            try? keychainManager.save(geminiKey, for: "gemini_api_key")
        } else {
            try? keychainManager.delete(for: "gemini_api_key")
        }
    }
    
    func isKeyConfigured(_ model: AIModel) -> Bool {
        let keyName: String
        switch model {
        case .claude: keyName = "anthropic_api_key"
        case .gpt: keyName = "openai_api_key"
        case .gemini: keyName = "gemini_api_key"
        }
        return keychainManager.exists(for: keyName)
    }
}
