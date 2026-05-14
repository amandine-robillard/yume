import Foundation
import SwiftData

@Model
final class Dream {
    @Attribute(.unique) var id: UUID
    var title: String
    var date: Date
    var content: String
    var isRemembered: Bool
    var isLucid: Bool
    var emotions: [String]
    var aiAnalysis: String?
    var aiModel: String?
    
    init(
        id: UUID = UUID(),
        title: String,
        date: Date = Date(),
        content: String = "",
        isRemembered: Bool = true,
        isLucid: Bool = false,
        emotions: [String] = [],
        aiAnalysis: String? = nil,
        aiModel: String? = nil
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.content = content
        self.isRemembered = isRemembered
        self.isLucid = isLucid
        self.emotions = emotions
        self.aiAnalysis = aiAnalysis
        self.aiModel = aiModel
    }
}
