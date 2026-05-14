import Foundation
import SwiftData

@MainActor
class DreamRepository {
    static let shared = DreamRepository()
    
    private init() {}
    
    func createDream(
        title: String,
        date: Date,
        content: String,
        isRemembered: Bool,
        dreamType: DreamType,
        emotions: [String],
        modelContext: ModelContext
    ) -> Dream {
        let dream = Dream(
            title: title,
            date: date,
            content: content,
            isRemembered: isRemembered,
            isLucid: dreamType == .lucid,
            dreamType: dreamType,
            emotions: emotions
        )
        modelContext.insert(dream)
        return dream
    }
    
    func updateDream(
        _ dream: Dream,
        title: String,
        date: Date,
        content: String,
        isRemembered: Bool,
        dreamType: DreamType,
        emotions: [String],
        modelContext: ModelContext
    ) {
        dream.title = title
        dream.date = date
        dream.content = content
        dream.isRemembered = isRemembered
        dream.isLucid = dreamType == .lucid
        dream.type = dreamType
        dream.emotions = emotions
    }
    
    func deleteDream(_ dream: Dream, modelContext: ModelContext) {
        modelContext.delete(dream)
    }
    
    func saveDream(_ dream: Dream, modelContext: ModelContext) {
        do {
            try modelContext.save()
        } catch {
            print("Failed to save dream: \(error)")
        }
    }
}
