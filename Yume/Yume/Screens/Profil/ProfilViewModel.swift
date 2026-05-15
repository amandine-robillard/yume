import Foundation
import Combine
import SwiftData

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
    
    @Published var showExportAlert: Bool = false
    @Published var showImportAlert: Bool = false
    @Published var exportMessage: String = ""
    @Published var importMessage: String = ""
    @Published var dreams: [Dream] = []
    @Published var shareItems: [Any] = []
    @Published var showShareSheet: Bool = false
    @Published var showFileImporter: Bool = false
    @Published var showImportOptions: Bool = false
    @Published var importFileURL: URL?
    @Published var showDeleteConfirmation: Bool = false
    @Published var deleteMessage: String = ""
    @Published var showDeleteAlert: Bool = false
    
    private let keychainManager = KeychainManager.shared
    private let exportImportService = DataExportImportService.shared
    private let customEmotionService = CustomEmotionService.shared
    
    var modelContext: ModelContext?
    
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
    
    // MARK: - Export/Import Methods
    
    func loadDreams(from modelContext: ModelContext) {
        self.modelContext = modelContext
        do {
            let descriptor = FetchDescriptor<Dream>(sortBy: [SortDescriptor(\.date, order: .reverse)])
            dreams = try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching dreams: \(error)")
            dreams = []
        }
    }
    
    func exportDreams() {
        guard let modelContext = modelContext else {
            exportMessage = "Erreur: contexte non disponible"
            showExportAlert = true
            return
        }
        
        do {
            let exportData = try exportImportService.exportData(dreams: dreams, modelContext: modelContext)
            let fileURL = exportImportService.getExportFileURL()
            try exportData.write(to: fileURL)
            
            // Préparer le partage avec Share Sheet natif iOS
            shareItems = [fileURL]
            showShareSheet = true
            
            // Compter les émotions personnalisées
            let customEmotions = CustomEmotionService.shared.getCustomEmotions().count
            var message = "Export réussi! ✅\n\(dreams.count) rêve(s)"
            if customEmotions > 0 {
                message += "\n\(customEmotions) émotion(s) personnalisée(s)"
            }
            exportMessage = message
        } catch {
            exportMessage = "Erreur lors de l'export: \(error.localizedDescription)"
            showExportAlert = true
        }
    }
    
    func importFromFile(url: URL) {
        // Stocker l'URL et afficher le dialogue d'options
        importFileURL = url
        showImportOptions = true
    }
    
    func performImport(replaceExisting: Bool) {
        guard let url = importFileURL else {
            importMessage = "Erreur: URL du fichier non disponible"
            showImportAlert = true
            return
        }
        
        guard let modelContext = modelContext else {
            importMessage = "Erreur: contexte non disponible"
            showImportAlert = true
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let result = try exportImportService.importData(from: data, modelContext: modelContext, replaceExisting: replaceExisting)
            
            // Recharger les rêves
            do {
                let descriptor = FetchDescriptor<Dream>(sortBy: [SortDescriptor(\.date, order: .reverse)])
                dreams = try modelContext.fetch(descriptor)
                
                var message = "Import réussi! ✅\n"
                message += "\(result.dreamsImported) rêve(s) importé(s)"
                if result.customEmotionsImported > 0 {
                    message += "\n\(result.customEmotionsImported) émotion(s) personnalisée(s)"
                }
                if replaceExisting {
                    message += "\n\nDonnées existantes remplacées"
                }
                importMessage = message
            } catch {
                importMessage = "Import réussi! ✅\n\(result.dreamsImported) rêve(s) importés\n\nMais impossible de recharger la liste"
            }
        } catch {
            importMessage = "Erreur lors de l'import: \(error.localizedDescription)"
        }
        
        showImportAlert = true
        importFileURL = nil
    }
    
    func deleteAllData() {
        guard let modelContext = modelContext else {
            deleteMessage = "Erreur: contexte non disponible"
            showDeleteAlert = true
            return
        }
        
        do {
            // Supprimer toutes les émotions personnalisées EN PREMIER
            customEmotionService.clearCustomEmotions()
            
            // Supprimer tous les rêves
            let descriptor = FetchDescriptor<Dream>()
            let allDreams = try modelContext.fetch(descriptor)
            for dream in allDreams {
                modelContext.delete(dream)
            }
            
            // Sauvegarder les changements
            try modelContext.save()
            
            // Recharger la liste (qui sera vide)
            do {
                let descriptor = FetchDescriptor<Dream>(sortBy: [SortDescriptor(\.date, order: .reverse)])
                dreams = try modelContext.fetch(descriptor)
            } catch {
                dreams = []
            }
            
            deleteMessage = "Toutes les données ont été supprimées avec succès! ✅"
            showDeleteAlert = true
        } catch {
            deleteMessage = "Erreur lors de la suppression: \(error.localizedDescription)"
            showDeleteAlert = true
        }
    }
}
