import Foundation
import SwiftData

enum DreamType: String, Codable {
    case normal = "Rêve"
    case lucid = "Lucide"
    case nightmare = "Cauchemar"
}

@Model
final class Dream {
    @Attribute(.unique) var id: UUID
    var title: String
    var date: Date
    var content: String
    var isRemembered: Bool
    var isLucid: Bool
    var dreamType: String = "Rêve" // Default value for migration
    var emotions: [String]
    var aiAnalysis: String?
    var aiModel: String?
    
    var type: DreamType {
        get { DreamType(rawValue: dreamType) ?? .normal }
        set { dreamType = newValue.rawValue }
    }
    
    init(
        id: UUID = UUID(),
        title: String,
        date: Date = Date(),
        content: String = "",
        isRemembered: Bool = true,
        isLucid: Bool = false,
        dreamType: DreamType = .normal,
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
        self.dreamType = dreamType.rawValue
        self.emotions = emotions
        self.aiAnalysis = aiAnalysis
        self.aiModel = aiModel
    }
}
