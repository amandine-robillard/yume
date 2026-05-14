import SwiftUI

struct GlassCard<Content: View>: View {
    @ViewBuilder let content: () -> Content
    var padding: CGFloat = AppTheme.spacing16
    
    var body: some View {
        content()
            .padding(padding)
            .glassmorphic()
    }
}

#Preview {
    GlassCard {
        Text("Hello")
            .foregroundColor(.white)
    }
    .padding()
    .background(AppTheme.background)
}
