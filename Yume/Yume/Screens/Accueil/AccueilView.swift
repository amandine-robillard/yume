import SwiftUI
import SwiftData

struct AccueilView: View {
    @StateObject var viewModel = AccueilViewModel()
    @State private var selectedDate = Date()
    @State private var showDreamEntry = false
    @State private var selectedWeekStart = Calendar.current.startOfWeek(for: Date())
    @State private var preselectedDate: Date?
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
    
    private var thisWeekDreams: [Dream] {
        let calendar = Calendar.current
        let now = Date()
        let weekStart = calendar.startOfWeek(for: now)
        let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart) ?? now
        return allDreams.filter { $0.date >= weekStart && $0.date < weekEnd }
    }
    
    private var rememberedThisWeek: [Dream] {
        thisWeekDreams.filter { $0.isRemembered }
    }
    
    private var lucidThisWeek: [Dream] {
        thisWeekDreams.filter { $0.type == .lucid && $0.isRemembered }
    }
    
    private var lucidityRate: Int {
        guard !rememberedThisWeek.isEmpty else { return 0 }
        return Int(Double(lucidThisWeek.count) / Double(rememberedThisWeek.count) * 100)
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppTheme.spacing20) {
                        // Cover image
                        Image("cover")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .frame(height: 180)
                        
                        // Greeting + Quote (no card background)
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
                        .padding(.horizontal, AppTheme.spacing16)
                        
                        // Week calendar
                        WeekCalendarView(
                            selectedWeekStart: $selectedWeekStart,
                            dreamsForDate: dreamsForCalendar,
                            onDateTap: { date in
                                preselectedDate = date
                                showDreamEntry = true
                            }
                        )
                        
                        // Stats row
                        HStack(spacing: AppTheme.spacing12) {
                            StatCard(
                                label: "Rêves",
                                value: String(thisWeekDreams.count),
                                icon: "book"
                            )
                            
                            StatCard(
                                label: "Rêves lucides",
                                value: String(lucidThisWeek.count),
                                icon: "sparkles"
                            )
                            
                            StatCard(
                                label: "Taux de lucidité",
                                value: "\(lucidityRate)%",
                                icon: "percent"
                            )
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
                DreamEntryView(isPresented: $showDreamEntry, preselectedDate: preselectedDate)
                    .presentationDetents([.medium, .large])
            }
            .navigationDestination(for: Dream.self) { dream in
                DreamDetailView(dream: dream)
            }
        }
        .preferredColorScheme(.dark)
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
