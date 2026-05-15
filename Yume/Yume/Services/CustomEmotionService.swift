import Foundation

class CustomEmotionService {
    static let shared = CustomEmotionService()
    private let customEmotionsKey = "custom_emotions"
    
    private let defaultEmotions = Set([
        "Joie",
        "Peur",
        "Sérénité",
        "Tristesse",
        "Liberté",
        "Émerveillement"
    ])
    
    private init() {}
    
    // MARK: - Custom Emotions Management
    
    /// Obtient toutes les émotions personnalisées (celles ajoutées par l'utilisateur)
    func getCustomEmotions() -> Set<String> {
        if let stored = UserDefaults.standard.array(forKey: customEmotionsKey) as? [String] {
            return Set(stored)
        }
        return Set()
    }
    
    /// Ajoute une émotion personnalisée
    func addCustomEmotion(_ emotion: String) {
        var customs = getCustomEmotions()
        if !defaultEmotions.contains(emotion) {
            customs.insert(emotion)
            saveCustomEmotions(customs)
        }
    }
    
    /// Supprime une émotion personnalisée
    func removeCustomEmotion(_ emotion: String) {
        var customs = getCustomEmotions()
        customs.remove(emotion)
        saveCustomEmotions(customs)
    }
    
    /// Ajoute plusieurs émotions personnalisées
    func addCustomEmotions(_ emotions: [String]) {
        var customs = getCustomEmotions()
        for emotion in emotions {
            if !defaultEmotions.contains(emotion) {
                customs.insert(emotion)
            }
        }
        saveCustomEmotions(customs)
    }
    
    /// Remplace toutes les émotions personnalisées
    func setCustomEmotions(_ emotions: Set<String>) {
        let filtered = emotions.filter { !defaultEmotions.contains($0) }
        saveCustomEmotions(filtered)
    }
    
    /// Efface toutes les émotions personnalisées
    func clearCustomEmotions() {
        UserDefaults.standard.removeObject(forKey: customEmotionsKey)
        UserDefaults.standard.synchronize()
    }
    
    // MARK: - Private Methods
    
    private func saveCustomEmotions(_ emotions: Set<String>) {
        UserDefaults.standard.set(Array(emotions), forKey: customEmotionsKey)
        UserDefaults.standard.synchronize()
    }
}
