import Foundation
import SwiftData
import Combine

enum DreamFilter: String, CaseIterable {
    case all = "Tous"
    case lucid = "Lucides"
    case nightmare = "Cauchemar"
    case forgotten = "Oubliés"
}

enum DreamSort: String, CaseIterable {
    case date = "Date"
    case emotions = "Émotions"
}

@MainActor
class DreamsListViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var selectedFilter: DreamFilter = .all
    @Published var selectedSort: DreamSort = .date
    
    func filteredAndSortedDreams(_ dreams: [Dream]) -> [Dream] {
        var filtered = dreams
        
        // Apply filter
        switch selectedFilter {
        case .all:
            break
        case .lucid:
            filtered = filtered.filter { $0.type == .lucid && $0.isRemembered }
        case .nightmare:
            filtered = filtered.filter { $0.type == .nightmare && $0.isRemembered }
        case .forgotten:
            filtered = filtered.filter { !$0.isRemembered }
        }
        
        // Apply search
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.content.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Apply sort
        switch selectedSort {
        case .date:
            filtered.sort { $0.date > $1.date }
        case .emotions:
            filtered.sort { $0.emotions.count > $1.emotions.count }
        }
        
        return filtered
    }
}
