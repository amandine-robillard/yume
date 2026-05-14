import SwiftUI
import SwiftData

struct AccueilView: View {
    @StateObject var viewModel = AccueilViewModel()
    @State private var selectedDate = Date()
    @State private var showDreamEntry = false
    @State private var navigationPath: NavigationPath = NavigationPath()
    
    @Query(sort: \Dream.date, order: .reverse) var allDreams: [Dream]
    @Environment(\.modelContext) var modelContext
    
    private var dreamsForCalendar: [Date: Dream] {
        var dict: [Date: Dream] = [:]
        let calendar = Calendar.current
        for dream in allDreams {
            let key = calendar.startOfDay(for: dream.date)
            dict[key] = dream
        }
        return dict
    }
    
    private var thisMonthDreams: [Dream] {
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
        return allDreams.filter { $0.date >= startOfMonth && $0.date <= endOfMonth }
    }
    
    private var rememberedThisMonth: [Dream] {
        thisMonthDreams.filter { $0.isRemembered }
    }
    
    private var lucidThisMonth: [Dream] {
        thisMonthDreams.filter { $0.isLucid && $0.isRemembered }
    }
    
    private var lucidityRate: Int {
        guard !rememberedThisMonth.isEmpty else { return 0 }
        return Int(Double(lucidThisMonth.count) / Double(rememberedThisMonth.count) * 100)
    }
    
    private var recentDreams: [Dream] {
        Array(allDreams.prefix(5))
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppTheme.spacing20) {
                        // Moon and clouds illustration
                        ZStack {
                            // Cloud 1
                            Circle()
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 60, height: 60)
                                .offset(x: -40, y: 10)
                            
                            // Cloud 2
                            Circle()
                                .fill(Color.white.opacity(0.08))
                                .frame(width: 50, height: 50)
                                .offset(x: 40, y: 15)
                            
                            // Moon
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            AppTheme.brightPurple,
                                            AppTheme.accentPurple
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Circle()
                                        .fill(Color.white.opacity(0.2))
                                        .frame(width: 20, height: 20)
                                        .offset(x: 15, y: -10)
                                )
                        }
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        
                        // Greeting + Quote
                        VStack(alignment: .leading, spacing: AppTheme.spacing8) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(viewModel.getGreeting()), \(viewModel.firstName)")
                                        .font(AppTheme.sfProRounded(size: 20, weight: .bold))
                                        .foregroundColor(AppTheme.textPrimary)
                                    
                                    Text("\"" + viewModel.dailyQuote + "\"")
                                        .font(AppTheme.sfProRounded(size: 12))
                                        .foregroundColor(AppTheme.textSecondary)
                                        .lineLimit(2)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "moon.stars.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(AppTheme.brightPurple)
                            }
                        }
                        .padding(AppTheme.spacing16)
                        .glassmorphic()
                        
                        // Stats row
                        HStack(spacing: AppTheme.spacing12) {
                            StatCard(
                                label: "Rêves ce mois-ci",
                                value: String(thisMonthDreams.count),
                                icon: "book"
                            )
                            
                            StatCard(
                                label: "Rêves lucides",
                                value: String(lucidThisMonth.count),
                                icon: "sparkles"
                            )
                            
                            StatCard(
                                label: "Taux de lucidité",
                                value: "\(lucidityRate)%",
                                icon: "percent"
                            )
                        }
                        
                        // Recent dreams
                        VStack(alignment: .leading, spacing: AppTheme.spacing12) {
                            Text("Récents")
                                .font(AppTheme.sfProRounded(size: 16, weight: .semibold))
                                .foregroundColor(AppTheme.textPrimary)
                            
                            if recentDreams.isEmpty {
                                Text("Aucun rêve enregistré pour le moment")
                                    .font(AppTheme.sfProRounded(size: 13))
                                    .foregroundColor(AppTheme.textSecondary)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(AppTheme.spacing16)
                            } else {
                                VStack(spacing: AppTheme.spacing8) {
                                    ForEach(recentDreams) { dream in
                                        NavigationLink(destination: DreamDetailView(dream: dream)) {
                                            DreamCard(dream: dream)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, AppTheme.spacing16)
                    }
                    .padding(.bottom, AppTheme.spacing100)
                }
                
                // FAB
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button(action: { showDreamEntry = true }) {
                            HStack(spacing: 8) {
                                Image(systemName: "plus")
                                    .font(.system(size: 14, weight: .semibold))
                                Text("Noter un rêve")
                                    .font(AppTheme.sfProRounded(size: 14, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(height: 50)
                            .frame(maxWidth: 180)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        AppTheme.accentPurple,
                                        AppTheme.brightPurple
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(25)
                            .shadow(color: AppTheme.brightPurple.opacity(0.5), radius: 12, x: 0, y: 4)
                        }
                        
                        Spacer()
                    }
                    .padding(.bottom, AppTheme.spacing20 + 70)
                }
            }
            .sheet(isPresented: $showDreamEntry) {
                DreamEntryView(isPresented: $showDreamEntry)
                    .presentationDetents([.medium, .large])
            }
            .navigationDestination(for: Dream.self) { dream in
                DreamDetailView(dream: dream)
            }
        }
    }
}

private struct StatCard: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppTheme.brightPurple)
            
            Text(value)
                .font(AppTheme.sfProRounded(size: 18, weight: .bold))
                .foregroundColor(AppTheme.textPrimary)
            
            Text(label)
                .font(AppTheme.sfProRounded(size: 10))
                .foregroundColor(AppTheme.textSecondary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(AppTheme.spacing12)
        .glassmorphic()
    }
}

#Preview {
    AccueilView()
        .modelContainer(for: Dream.self, inMemory: true)
}
