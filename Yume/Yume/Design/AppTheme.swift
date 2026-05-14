import SwiftUI

struct AppTheme {
    // MARK: - Colors
    static let background = Color(red: 0.04, green: 0.055, blue: 0.1) // #0A0E1A
    static let cardBackground = Color(red: 0.071, green: 0.09, blue: 0.169) // #12172B
    static let accentPurple = Color(red: 0.482, green: 0.369, blue: 0.655) // #7B5EA7
    static let brightPurple = Color(red: 0.655, green: 0.549, blue: 0.98) // #A78BFA
    
    static let textPrimary = Color.white
    static let textSecondary = Color(red: 0.533, green: 0.573, blue: 0.643) // #8892A4
    
    // Dream state colors
    static let forgottenDream = Color(red: 0.29, green: 0.333, blue: 0.408) // #4A5568
    static let rememberedDream = Color(red: 0.482, green: 0.369, blue: 0.655) // #7B5EA7
    static let lucidDream = Color(red: 0.263, green: 1.0, blue: 0.863) // #43ffdc
    static let nightmareDream = Color(red: 0.765, green: 0.212, blue: 0.325) // #c33653
    
    // MARK: - Spacing
    static let spacing8: CGFloat = 8
    static let spacing12: CGFloat = 12
    static let spacing16: CGFloat = 16
    static let spacing20: CGFloat = 20
    static let spacing24: CGFloat = 24
    static let spacing100: CGFloat = 100
    
    // MARK: - Fonts
    static func sfProRounded(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return .system(size: size, weight: weight, design: .rounded)
    }
}
