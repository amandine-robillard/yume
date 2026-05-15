import SwiftUI

struct WeekCalendarView: View {
    @Binding var selectedWeekStart: Date
    let dreamsForDate: [Date: Dream]
    let onDateTap: (Date) -> Void
    
    init(selectedWeekStart: Binding<Date>, dreamsForDate: [Date: Dream], onDateTap: @escaping (Date) -> Void) {
        self._selectedWeekStart = selectedWeekStart
        self.dreamsForDate = dreamsForDate
        self.onDateTap = onDateTap
    }
    
    private var calendar = Calendar.current
    private var today = Date()
    
    private var weekDates: [Date] {
        var dates: [Date] = []
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: selectedWeekStart) {
                dates.append(date)
            }
        }
        return dates
    }
    
    private func getDreamForDate(_ date: Date) -> Dream? {
        let key = calendar.startOfDay(for: date)
        return dreamsForDate[key]
    }
    
    private func getDotColor(for dream: Dream?) -> Color {
        guard let dream = dream else { return .clear }
        if !dream.isRemembered {
            return AppTheme.forgottenDream
        } else {
            switch dream.type {
            case .lucid:
                return AppTheme.lucidDream
            case .nightmare:
                return AppTheme.nightmareDream
            case .normal:
                return AppTheme.rememberedDream
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "EEE"
        return formatter.string(from: date).prefix(1).uppercased()
    }
    
    var body: some View {
        VStack(spacing: AppTheme.spacing12) {
            // Week navigation
            HStack {
                Button(action: {
                    withAnimation(.spring()) {
                        selectedWeekStart = calendar.date(byAdding: .day, value: -7, to: selectedWeekStart) ?? selectedWeekStart
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppTheme.accentPurple)
                }
                
                Spacer()
                
                Text("Cette semaine")
                    .font(AppTheme.sfProRounded(size: 14, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring()) {
                        selectedWeekStart = calendar.date(byAdding: .day, value: 7, to: selectedWeekStart) ?? selectedWeekStart
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppTheme.accentPurple)
                }
            }
            .padding(.horizontal, AppTheme.spacing16)
            
            // Week days
            HStack(spacing: AppTheme.spacing8) {
                ForEach(weekDates, id: \.self) { date in
                    VStack(spacing: 8) {
                        Text(formatDate(date))
                            .font(AppTheme.sfProRounded(size: 11, weight: .semibold))
                            .foregroundColor(AppTheme.textSecondary)
                        
                        VStack(spacing: 4) {
                            Text("\(calendar.component(.day, from: date))")
                                .font(AppTheme.sfProRounded(size: 16, weight: .bold))
                                .foregroundColor(
                                    calendar.isDateInToday(date) ? AppTheme.brightPurple : AppTheme.textPrimary
                                )
                                .frame(width: 40, height: 40)
                                .background(
                                    Circle().fill(
                                        calendar.isDateInToday(date) ?
                                        AppTheme.accentPurple.opacity(0.3) :
                                        Color.clear
                                    )
                                )
                            
                            if let dream = getDreamForDate(date) {
                                Circle()
                                    .fill(getDotColor(for: dream))
                                    .frame(width: 6, height: 6)
                            } else {
                                Circle()
                                    .fill(Color.clear)
                                    .frame(width: 6, height: 6)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        // Only allow selecting current or past dates
                        let isCurrentOrPast = !calendar.isDateInFuture(date)
                        if isCurrentOrPast {
                            onDateTap(date)
                        }
                    }
                    .opacity(calendar.isDateInFuture(date) ? 0.4 : 1.0)
                }
            }
            .padding(.horizontal, AppTheme.spacing12)
        }
        .padding(.vertical, AppTheme.spacing12)
        .glassmorphic()
        .padding(.horizontal, AppTheme.spacing16)
    }
}
