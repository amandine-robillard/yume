import Foundation

extension Calendar {
    func startOfWeek(for date: Date) -> Date {
        let components = dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return self.date(from: components) ?? date
    }
    
    func isDateInFuture(_ date: Date) -> Bool {
        let today = startOfDay(for: Date())
        let checkDate = startOfDay(for: date)
        return checkDate > today
    }
}
