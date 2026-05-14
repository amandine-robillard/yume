import SwiftUI

enum TabBarItem {
    case accueil
    case dreams
    case statistics
    case profile
    
    var label: String {
        switch self {
        case .accueil: return "Accueil"
        case .dreams: return "Rêves"
        case .statistics: return "Statistiques"
        case .profile: return "Profil"
        }
    }
    
    var icon: String {
        switch self {
        case .accueil: return "house.fill"
        case .dreams: return "book.fill"
        case .statistics: return "chart.bar.fill"
        case .profile: return "person.fill"
        }
    }
}

struct TabBar: View {
    @Binding var selectedTab: TabBarItem
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach([TabBarItem.accueil, .dreams, .statistics, .profile], id: \.self) { tab in
                VStack(spacing: 4) {
                    Image(systemName: tab.icon)
                        .font(.system(size: 20, weight: .semibold))
                    Text(tab.label)
                        .font(AppTheme.sfProRounded(size: 10, weight: .semibold))
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(selectedTab == tab ? AppTheme.brightPurple : AppTheme.textSecondary)
                .padding(.vertical, AppTheme.spacing12)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.spring()) {
                        selectedTab = tab
                    }
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.1),
                                    Color.white.opacity(0.05)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: -4)
        )
        .padding(.horizontal, AppTheme.spacing16)
        .padding(.bottom, AppTheme.spacing16)
    }
}

// For SwiftUI Hashable conformance
extension TabBarItem: Hashable {}

#Preview {
    @State var selected = TabBarItem.accueil
    return TabBar(selectedTab: $selected)
        .background(AppTheme.background.ignoresSafeArea())
}
