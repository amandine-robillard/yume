import Foundation

enum Emotion: String, CaseIterable {
    case joy = "Joie"
    case fear = "Peur"
    case serenity = "Sérénité"
    case sadness = "Tristesse"
    case freedom = "Liberté"
    case wonder = "Émerveillement"
    
    var id: String { self.rawValue }
}
