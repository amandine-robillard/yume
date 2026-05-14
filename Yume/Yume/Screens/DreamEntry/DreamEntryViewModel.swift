import Foundation
import SwiftData
import Combine

@MainActor
class DreamEntryViewModel: ObservableObject {
    @Published var isRemembered: Bool?
    @Published var title: String = ""
    @Published var date: Date = Date()
    @Published var content: String = ""
    @Published var isLucid: Bool = false
    @Published var selectedEmotions: Set<String> = []
    @Published var customEmotions: [String] = []
    @Published var newEmotionText: String = ""
    @Published var showAddEmotion: Bool = false
    
    init() {
        loadCustomEmotions()
    }
    
    func loadCustomEmotions() {
        if let saved = UserDefaults.standard.array(forKey: "customEmotions") as? [String] {
            customEmotions = saved
        }
    }
    
    func addCustomEmotion() {
        let trimmed = newEmotionText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        // Check if emotion already exists in default or custom list
        let allEmotions = Emotion.allCases.map { $0.rawValue } + customEmotions
        guard !allEmotions.contains(trimmed) else { return }
        
        customEmotions.append(trimmed)
        selectedEmotions.insert(trimmed)
        UserDefaults.standard.set(customEmotions, forKey: "customEmotions")
        newEmotionText = ""
        showAddEmotion = false
    }
    
    func saveDream(modelContext: ModelContext) {
        guard let isRemembered = isRemembered else { return }
        
        let dream = Dream(
            title: isRemembered ? title : "Rêve oublié",
            date: date,
            content: isRemembered ? content : "",
            isRemembered: isRemembered,
            isLucid: isRemembered ? isLucid : false,
            emotions: Array(selectedEmotions)
        )
        
        modelContext.insert(dream)
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save dream: \(error)")
        }
    }
}
