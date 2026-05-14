import Foundation
import SwiftData
import Combine

enum TimeRange: String, CaseIterable {
    case week = "7j"
    case month = "30j"
    case threeMonths = "3 mois"
    case year = "1 an"
    
    var days: Int {
        switch self {
        case .week: return 7
        case .month: return 30
        case .threeMonths: return 90
        case .year: return 365
        }
    }
}

@MainActor
class StatistiquesViewModel: ObservableObject {
    @Published var selectedTimeRange: TimeRange = .month
    @Published var selectedDate = Date()
    
    func getDreamsInRange(_ dreams: [Dream]) -> [Dream] {
        let now = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -selectedTimeRange.days, to: now) ?? now
        return dreams.filter { $0.date >= startDate && $0.date <= now }
    }
    
    func getLucidCount(_ dreams: [Dream]) -> Int {
        dreams.filter { $0.type == .lucid && $0.isRemembered }.count
    }
    
    func getRememberedCount(_ dreams: [Dream]) -> Int {
        dreams.filter { $0.isRemembered }.count
    }
    
    func getForgottenCount(_ dreams: [Dream]) -> Int {
        dreams.filter { !$0.isRemembered }.count
    }
    
    func getLucidityRate(_ dreams: [Dream]) -> Int {
        let remembered = getRememberedCount(dreams)
        guard remembered > 0 else { return 0 }
        let lucid = getLucidCount(dreams)
        return Int(Double(lucid) / Double(remembered) * 100)
    }
    
    func getAIDecodedCount(_ dreams: [Dream]) -> Int {
        dreams.filter { $0.aiAnalysis != nil }.count
    }
    
    func getEmotionBreakdown(_ dreams: [Dream]) -> [String: Int] {
        var breakdown: [String: Int] = [:]
        let rememberedDreams = dreams.filter { $0.isRemembered }
        
        for dream in rememberedDreams {
            for emotion in dream.emotions {
                breakdown[emotion, default: 0] += 1
            }
        }
        
        return breakdown
    }
}
