import SwiftUI
import SwiftData
import Charts

struct StatistiquesView: View {
    @StateObject var viewModel = StatistiquesViewModel()
    @Query(sort: \Dream.date, order: .reverse) var allDreams: [Dream]
    
    private var dreamsInRange: [Dream] {
        viewModel.getDreamsInRange(allDreams)
    }
    
    private var dreamsForCalendar: [Date: Dream] {
        var dict: [Date: Dream] = [:]
        let calendar = Calendar.current
        for dream in dreamsInRange {
            let key = calendar.startOfDay(for: dream.date)
            dict[key] = dream
        }
        return dict
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppTheme.spacing16) {
                        // Time range picker
                        HStack(spacing: AppTheme.spacing8) {
                            ForEach(TimeRange.allCases, id: \.self) { range in
                                Button(action: {
                                    withAnimation(.spring()) {
                                        viewModel.selectedTimeRange = range
                                    }
                                }) {
                                    Text(range.rawValue)
                                        .font(AppTheme.sfProRounded(size: 12, weight: .semibold))
                                        .foregroundColor(viewModel.selectedTimeRange == range ? .white : AppTheme.textSecondary)
                                        .padding(.horizontal, AppTheme.spacing12)
                                        .padding(.vertical, 6)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(viewModel.selectedTimeRange == range ? AppTheme.accentPurple : AppTheme.cardBackground)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, AppTheme.spacing16)
                        
                        // Calendar
                        CalendarView(selectedDate: $viewModel.selectedDate, dreamsForDate: dreamsForCalendar)
                        
                        // Lucid dreams stats
                        VStack(alignment: .leading, spacing: AppTheme.spacing12) {
                            Text("Rêves lucides")
                                .font(AppTheme.sfProRounded(size: 16, weight: .semibold))
                                .foregroundColor(AppTheme.textPrimary)
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(viewModel.getLucidCount(dreamsInRange))")
                                        .font(AppTheme.sfProRounded(size: 32, weight: .bold))
                                        .foregroundColor(AppTheme.brightPurple)
                                    
                                    Text("sur \(viewModel.getRememberedCount(dreamsInRange)) rêves")
                                        .font(AppTheme.sfProRounded(size: 12))
                                        .foregroundColor(AppTheme.textSecondary)
                                }
                                
                                Spacer()
                                
                                // Donut chart
                                ZStack {
                                    Circle()
                                        .stroke(AppTheme.cardBackground, lineWidth: 12)
                                        .frame(width: 80, height: 80)
                                    
                                    Circle()
                                        .trim(from: 0, to: CGFloat(viewModel.getLucidityRate(dreamsInRange)) / 100)
                                        .stroke(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    AppTheme.accentPurple,
                                                    AppTheme.brightPurple
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            style: StrokeStyle(lineWidth: 12, lineCap: .round)
                                        )
                                        .frame(width: 80, height: 80)
                                        .rotationEffect(.degrees(-90))
                                    
                                    Text("\(viewModel.getLucidityRate(dreamsInRange))%")
                                        .font(AppTheme.sfProRounded(size: 14, weight: .bold))
                                        .foregroundColor(AppTheme.textPrimary)
                                }
                            }
                        }
                        .padding(AppTheme.spacing16)
                        .glassmorphic()
                        .padding(.horizontal, AppTheme.spacing16)
                        
                        // Dreams over time chart
                        VStack(alignment: .leading, spacing: AppTheme.spacing12) {
                            Text("Évolution")
                                .font(AppTheme.sfProRounded(size: 16, weight: .semibold))
                                .foregroundColor(AppTheme.textPrimary)
                            
                            if !dreamsInRange.isEmpty {
                                DreamsTimelineChart(dreams: dreamsInRange, timeRange: viewModel.selectedTimeRange)
                                    .frame(height: 200)
                            } else {
                                Text("Pas assez de données")
                                    .font(AppTheme.sfProRounded(size: 12))
                                    .foregroundColor(AppTheme.textSecondary)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, 40)
                            }
                        }
                        .padding(AppTheme.spacing16)
                        .glassmorphic()
                        .padding(.horizontal, AppTheme.spacing16)
                        
                        // Emotions breakdown
                        let emotionBreakdown = viewModel.getEmotionBreakdown(dreamsInRange)
                        if !emotionBreakdown.isEmpty {
                            VStack(alignment: .leading, spacing: AppTheme.spacing12) {
                                Text("Rêves par émotions")
                                    .font(AppTheme.sfProRounded(size: 16, weight: .semibold))
                                    .foregroundColor(AppTheme.textPrimary)
                                
                                EmotionsChart(emotionBreakdown: emotionBreakdown)
                                    .frame(height: 200)
                            }
                            .padding(AppTheme.spacing16)
                            .glassmorphic()
                            .padding(.horizontal, AppTheme.spacing16)
                        }
                        
                        // Other stats
                        HStack(spacing: AppTheme.spacing12) {
                            StatCard(
                                label: "Oubliés",
                                value: String(viewModel.getForgottenCount(dreamsInRange)),
                                icon: "moon.zzz.fill"
                            )
                            
                            StatCard(
                                label: "Décodés IA",
                                value: String(viewModel.getAIDecodedCount(dreamsInRange)),
                                icon: "sparkles"
                            )
                        }
                        .padding(.horizontal, AppTheme.spacing16)
                    }
                    .padding(.vertical, AppTheme.spacing16)
                    .padding(.bottom, AppTheme.spacing100)
                }
            }
            .navigationTitle("Statistiques")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
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

// MARK: - Charts

private struct DreamsTimelineChart: View {
    let dreams: [Dream]
    let timeRange: TimeRange
    
    private var chartData: [(Date, String, Int)] {
        let calendar = Calendar.current
        let now = Date()
        let startDate = calendar.date(byAdding: .day, value: -timeRange.days, to: now) ?? now
        
        var data: [(Date, String, Int)] = []
        var currentDate = startDate
        
        while currentDate <= now {
            let dayDreams = dreams.filter {
                calendar.isDate($0.date, inSameDayAs: currentDate)
            }
            
            let forgotten = dayDreams.filter { !$0.isRemembered }.count
            let remembered = dayDreams.filter { $0.isRemembered && !$0.isLucid }.count
            let lucid = dayDreams.filter { $0.isLucid && $0.isRemembered }.count
            
            if forgotten > 0 { data.append((currentDate, "Oubliés", forgotten)) }
            if remembered > 0 { data.append((currentDate, "Rêves", remembered)) }
            if lucid > 0 { data.append((currentDate, "Lucides", lucid)) }
            
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? now
        }
        
        return data
    }
    
    var body: some View {
        Chart {
            ForEach(chartData, id: \.0) { item in
                BarMark(
                    x: .value("Date", item.0, unit: .day),
                    y: .value("Nombre", item.2)
                )
                .foregroundStyle(by: .value("Type", item.1))
            }
        }
        .chartForegroundStyleScale([
            "Oubliés": AppTheme.forgottenDream,
            "Rêves": AppTheme.rememberedDream,
            "Lucides": AppTheme.lucidDream
        ])
        .chartXAxis {
            AxisMarks(values: .automatic) { _ in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                    .foregroundStyle(AppTheme.textSecondary.opacity(0.2))
                AxisTick(stroke: StrokeStyle(lineWidth: 0.5))
                    .foregroundStyle(AppTheme.textSecondary.opacity(0.2))
                AxisValueLabel()
                    .font(AppTheme.sfProRounded(size: 10))
                    .foregroundStyle(AppTheme.textSecondary)
            }
        }
        .chartYAxis {
            AxisMarks { _ in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                    .foregroundStyle(AppTheme.textSecondary.opacity(0.2))
                AxisValueLabel()
                    .font(AppTheme.sfProRounded(size: 10))
                    .foregroundStyle(AppTheme.textSecondary)
            }
        }
    }
}

private struct EmotionsChart: View {
    let emotionBreakdown: [String: Int]
    
    private var sortedEmotions: [(String, Int)] {
        emotionBreakdown.sorted { $0.value > $1.value }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.spacing8) {
            ForEach(sortedEmotions, id: \.0) { emotion, count in
                HStack {
                    Text(emotion)
                        .font(AppTheme.sfProRounded(size: 12))
                        .foregroundColor(AppTheme.textPrimary)
                        .frame(width: 100, alignment: .leading)
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(AppTheme.cardBackground)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            AppTheme.accentPurple,
                                            AppTheme.brightPurple
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geometry.size.width * CGFloat(count) / CGFloat(sortedEmotions.first?.1 ?? 1))
                        }
                    }
                    .frame(height: 20)
                    
                    Text("\(count)")
                        .font(AppTheme.sfProRounded(size: 12, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)
                        .frame(width: 30, alignment: .trailing)
                }
            }
        }
    }
}

#Preview {
    StatistiquesView()
        .modelContainer(for: Dream.self, inMemory: true)
}
