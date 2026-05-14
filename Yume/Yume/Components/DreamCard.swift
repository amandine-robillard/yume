import SwiftUI

struct DreamCard: View {
    let dream: Dream
    
    private var displayTitle: String {
        if !dream.title.isEmpty && dream.title != "Sans titre" {
            return dream.title
        } else if !dream.content.isEmpty {
            // Return first line of content or first 50 characters
            let content = dream.content.trimmingCharacters(in: .whitespacesAndNewlines)
            if content.count > 50 {
                return String(content.prefix(50)) + "..."
            }
            return content
        } else {
            return "Sans titre"
        }
    }
    
    private var statusBadge: String {
        if !dream.isRemembered {
            return "Oublié"
        } else {
            return dream.type.rawValue
        }
    }
    
    private var badgeColor: Color {
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
    
    private var dateFormatted: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "d MMM yyyy"
        return formatter.string(from: dream.date)
    }
    
    var body: some View {
        HStack(spacing: AppTheme.spacing12) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(displayTitle)
                        .font(AppTheme.sfProRounded(size: 14, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)
                        .lineLimit(1)
                    
                    if dream.aiAnalysis != nil {
                        Image(systemName: "sparkles")
                            .font(.system(size: 12))
                            .foregroundColor(AppTheme.brightPurple)
                    }
                    
                    Spacer()
                }
                
                Text(dateFormatted)
                    .font(AppTheme.sfProRounded(size: 12))
                    .foregroundColor(AppTheme.textSecondary)
            }
            
            Spacer()
            
            // Status badge
            Text(statusBadge)
                .font(AppTheme.sfProRounded(size: 11, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, AppTheme.spacing8)
                .padding(.vertical, 4)
                .background(badgeColor)
                .cornerRadius(6)
        }
        .padding(AppTheme.spacing12)
        .glassmorphic()
    }
}

#Preview {
    DreamCard(dream: Dream(title: "Vol au-dessus des montagnes", content: "", isRemembered: true, dreamType: .lucid))
        .padding()
        .background(AppTheme.background)
}
