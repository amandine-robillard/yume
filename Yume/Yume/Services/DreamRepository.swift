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
        isLucid: Bool,
        emotions: [String],
        modelContext: ModelContext
    ) -> Dream {
        let dream = Dream(
            title: title,
            date: date,
            content: content,
            isRemembered: isRemembered,
            isLucid: isLucid,
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
        isLucid: Bool,
        emotions: [String],
        modelContext: ModelContext
    ) {
        dream.title = title
        dream.date = date
        dream.content = content
        dream.isRemembered = isRemembered
        dream.isLucid = isLucid
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
