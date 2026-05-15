import Foundation
import SwiftData

@MainActor
class DataExportImportService {
    static let shared = DataExportImportService()
    private let customEmotionService = CustomEmotionService.shared
    
    private init() {}
    
    // MARK: - Export
    
    /// Exporte tous les rêves et les émotions personnalisées (pas les émotions par défaut)
    func exportData(dreams: [Dream], modelContext: ModelContext) throws -> Data {
        let customEmotions = Array(customEmotionService.getCustomEmotions())
        
        let exportData = ExportData(
            dreams: dreams.map { DreamExportModel($0) },
            customEmotions: customEmotions,
            exportDate: Date(),
            version: "2.1"
        )
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        return try encoder.encode(exportData)
    }
    
    /// Crée une URL locale pour sauvegarder le fichier d'export
    func getExportFileURL() -> URL {
        let fileName = "yume_export_\(ISO8601DateFormatter().string(from: Date())).json"
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return documentsDirectory.appendingPathComponent(fileName)
        }
        return FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
    }
    
    // MARK: - Import
    
    /// Importe les rêves depuis une donnée JSON (option de fusion ou remplacement)
    func importData(from data: Data, modelContext: ModelContext, replaceExisting: Bool = false) throws -> ImportResult {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let exportData = try decoder.decode(ExportData.self, from: data)
        
        var importedCount = 0
        
        // Gérer le remplacement des données existantes
        if replaceExisting {
            // Supprimer tous les rêves existants
            let descriptor = FetchDescriptor<Dream>()
            let existingDreams = try modelContext.fetch(descriptor)
            for dream in existingDreams {
                modelContext.delete(dream)
            }
        }
        
        // Importer les rêves
        for dreamModel in exportData.dreams {
            // Vérifier si le rêve existe déjà (par ID)
            let descriptor = FetchDescriptor<Dream>(
                predicate: #Predicate { $0.id == dreamModel.id }
            )
            
            let existingDreams = try modelContext.fetch(descriptor)
            
            if existingDreams.isEmpty {
                // Créer un nouveau rêve avec les émotions valides
                let validEmotions = dreamModel.emotions.filter { emotion in
                    Emotion.allCases.map { $0.rawValue }.contains(emotion) ||
                    CustomEmotionService.shared.getCustomEmotions().contains(emotion)
                }
                
                let dream = Dream(
                    id: dreamModel.id,
                    title: dreamModel.title,
                    date: dreamModel.date,
                    content: dreamModel.content,
                    isRemembered: dreamModel.isRemembered,
                    isLucid: dreamModel.isLucid,
                    dreamType: DreamType(rawValue: dreamModel.dreamType) ?? .normal,
                    emotions: validEmotions,
                    aiAnalysis: dreamModel.aiAnalysis,
                    aiModel: dreamModel.aiModel
                )
                modelContext.insert(dream)
                importedCount += 1
            }
        }
        
        // Importer les émotions personnalisées
        if !exportData.customEmotions.isEmpty {
            customEmotionService.addCustomEmotions(exportData.customEmotions)
        }
        
        try modelContext.save()
        return ImportResult(dreamsImported: importedCount, customEmotionsImported: exportData.customEmotions.count)
    }
}

// MARK: - Data Models

struct ExportData: Codable {
    let dreams: [DreamExportModel]
    let customEmotions: [String]
    let exportDate: Date
    let version: String
}

struct DreamExportModel: Codable {
    let id: UUID
    let title: String
    let date: Date
    let content: String
    let isRemembered: Bool
    let isLucid: Bool
    let dreamType: String
    let emotions: [String]
    let aiAnalysis: String?
    let aiModel: String?
    
    init(_ dream: Dream) {
        self.id = dream.id
        self.title = dream.title
        self.date = dream.date
        self.content = dream.content
        self.isRemembered = dream.isRemembered
        self.isLucid = dream.isLucid
        self.dreamType = dream.dreamType
        self.emotions = dream.emotions
        self.aiAnalysis = dream.aiAnalysis
        self.aiModel = dream.aiModel
    }
}

struct ImportResult {
    let dreamsImported: Int
    let customEmotionsImported: Int
}
