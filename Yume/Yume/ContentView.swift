//
//  ContentView.swift
//  Yume
//
//  Created by Amandine Robillard on 14/05/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab: TabBarItem = .accueil
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Main content area
                Group {
                    switch selectedTab {
                    case .accueil:
                        AccueilView()
                    case .dreams:
                        DreamsListView()
                    case .statistics:
                        StatistiquesView()
                    case .profile:
                        ProfilView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.2), value: selectedTab)
                
                // Tab bar
                TabBar(selectedTab: $selectedTab)
            }
        }
        .background(AppTheme.background)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Dream.self, inMemory: true)
}
