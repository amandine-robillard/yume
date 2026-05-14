import Foundation
import SwiftData
import Combine

@MainActor
class DreamDetailViewModel: ObservableObject {
    @Published var isLoadingAI = false
    @Published var aiError: String?
    @Published var showAIModelPicker = false
    
    var dream: Dream?
    var modelContext: ModelContext?
    
    func requestAIAnalysis(model: AIModel) async {
        guard let dream = dream, let modelContext = modelContext else { return }
        
        isLoadingAI = true
        aiError = nil
        
        do {
            let service = AIServiceFactory.make(model: model)
            let analysis = try await service.decode(dream: dream)
            
            // Update dream with analysis
            dream.aiAnalysis = analysis
            dream.aiModel = model.rawValue
            
            try modelContext.save()
            isLoadingAI = false
        } catch {
            aiError = "Erreur: \(error.localizedDescription)"
            isLoadingAI = false
        }
    }
    
    func requestNewAnalysis() async {
        guard let dream = dream, let modelContext = modelContext else { return }
        guard let model = dream.aiModel, let aiModel = AIModel(rawValue: model) else { return }
        await requestAIAnalysis(model: aiModel)
    }
}
