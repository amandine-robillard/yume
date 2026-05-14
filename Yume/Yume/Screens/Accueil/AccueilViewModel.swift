import Foundation
import SwiftData
import Combine

@MainActor
class AccueilViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var dailyQuote: String = ""
    @Published var selectedDate: Date = Date()
    
    private let quotes = [
        "Chaque rêve est une porte vers ton monde intérieur.",
        "Les rêves sont le langage secret de l'âme.",
        "Dans tes rêves réside la sagesse que tu cherches.",
        "Les rêves lucides sont des clés du pouvoir intérieur.",
        "Tes rêves te parlent dans le langage de l'invisible.",
        "La nuit révèle ce que le jour cache.",
        "Chaque rêve oublié laisse une trace en toi.",
        "Les symboles de tes rêves sont tes guides."
    ]
    
    init() {
        loadUserName()
        setDailyQuote()
    }
    
    func loadUserName() {
        if let name = UserDefaults.standard.string(forKey: "userName") {
            firstName = name
        } else {
            firstName = "Rêveur"
        }
    }
    
    func setDailyQuote() {
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 0
        dailyQuote = quotes[dayOfYear % quotes.count]
    }
    
    func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour >= 6 && hour < 12 {
            return "Bonjour"
        } else if hour >= 12 && hour < 18 {
            return "Bon après-midi"
        } else {
            return "Bonsoir"
        }
    }
}
