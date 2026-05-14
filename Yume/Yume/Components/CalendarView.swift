import SwiftUI

struct CalendarView: View {
    @Binding var selectedDate: Date
    let dreamsForDate: [Date: Dream]
    
    init(selectedDate: Binding<Date>, dreamsForDate: [Date: Dream]) {
        self._selectedDate = selectedDate
        self.dreamsForDate = dreamsForDate
    }
    
    private var calendar = Calendar.current
    private var today = Date()
    
    private var monthYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.string(from: selectedDate)
    }
    
    private var daysInMonth: [Date?] {
        let components = calendar.dateComponents([.year, .month], from: selectedDate)
        let firstDay = calendar.date(from: components)!
        let range = calendar.range(of: .day, in: .month, for: firstDay)!
        let numDays = range.count
        
        var firstWeekday = calendar.component(.weekday, from: firstDay) - 2 // Monday = 0
        if firstWeekday < 0 { firstWeekday += 7 }
        
        var days: [Date?] = Array(repeating: nil, count: firstWeekday)
        for day in 1...numDays {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDay) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func getDreamForDate(_ date: Date) -> Dream? {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        for (dreamDate, dream) in dreamsForDate {
            let dreamComponents = calendar.dateComponents([.year, .month, .day], from: dreamDate)
            if components == dreamComponents {
                return dream
            }
        }
        return nil
    }
    
    private func getDotColor(for dream: Dream?) -> Color {
        guard let dream = dream else { return .clear }
        if !dream.isRemembered {
            return AppTheme.forgottenDream
        } else if dream.isLucid {
            return AppTheme.lucidDream
        } else {
            return AppTheme.rememberedDream
        }
    }
    
    var body: some View {
        VStack(spacing: AppTheme.spacing12) {
            // Month/Year Header
            HStack {
                Button(action: {
                    withAnimation(.spring()) {
                        selectedDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppTheme.accentPurple)
                }
                
                Spacer()
                
                Text(monthYear)
                    .font(AppTheme.sfProRounded(size: 16, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring()) {
                        selectedDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppTheme.accentPurple)
                }
            }
            .padding(.horizontal, AppTheme.spacing16)
            
            // Weekday headers
            HStack {
                ForEach(["L", "M", "M", "J", "V", "S", "D"], id: \.self) { day in
                    Text(day)
                        .font(AppTheme.sfProRounded(size: 12, weight: .semibold))
                        .foregroundColor(AppTheme.textSecondary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, AppTheme.spacing16)
            
            // Calendar grid
            VStack(spacing: AppTheme.spacing8) {
                ForEach(0..<ceil(Double(daysInMonth.count) / 7).toInt, id: \.self) { week in
                    HStack {
                        ForEach(0..<7, id: \.self) { day in
                            let index = week * 7 + day
                            
                            if index < daysInMonth.count, let date = daysInMonth[index] {
                                VStack(spacing: 4) {
                                    Text("\(calendar.component(.day, from: date))")
                                        .font(AppTheme.sfProRounded(size: 14, weight: .semibold))
                                        .foregroundColor(
                                            calendar.isDateInToday(date) ? AppTheme.brightPurple : AppTheme.textPrimary
                                        )
                                        .frame(width: 32, height: 32)
                                        .background(
                                            calendar.isDateInToday(date) ?
                                            Circle().fill(AppTheme.accentPurple) :
                                            Circle().fill(Color.clear)
                                        )
                                    
                                    if let dream = getDreamForDate(date) {
                                        Circle()
                                            .fill(getDotColor(for: dream))
                                            .frame(width: 6, height: 6)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        selectedDate = date
                                    }
                                }
                            } else {
                                Color.clear
                                    .frame(height: 40)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, AppTheme.spacing16)
        }
        .glassmorphic()
        .padding(AppTheme.spacing16)
    }
}

extension Double {
    var toInt: Int {
        return Int(self)
    }
}
