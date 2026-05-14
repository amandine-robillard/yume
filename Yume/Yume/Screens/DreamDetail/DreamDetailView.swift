import SwiftUI
import SwiftData

struct DreamDetailView: View {
    @StateObject var viewModel = DreamDetailViewModel()
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    let dream: Dream
    
    init(dream: Dream) {
        self.dream = dream
        _viewModel = StateObject(wrappedValue: DreamDetailViewModel())
    }
    
    @State private var isEditing = false
    @State private var showDeleteConfirm = false
    
    private var dateFormatted: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter.string(from: dream.date)
    }
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.spacing16) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(dream.title)
                                .font(AppTheme.sfProRounded(size: 24, weight: .bold))
                                .foregroundColor(AppTheme.textPrimary)
                            
                            Text(dateFormatted)
                                .font(AppTheme.sfProRounded(size: 13))
                                .foregroundColor(AppTheme.textSecondary)
                        }
                        
                        Spacer()
                        
                        if dream.isRemembered {
                            VStack(spacing: 8) {
                                Text(dream.type.rawValue)
                                    .font(AppTheme.sfProRounded(size: 11, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, AppTheme.spacing8)
                                    .padding(.vertical, 6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill({
                                                switch dream.type {
                                                case .lucid:
                                                    return AppTheme.lucidDream
                                                case .nightmare:
                                                    return AppTheme.nightmareDream
                                                case .normal:
                                                    return AppTheme.rememberedDream
                                                }
                                            }())
                                    )
                            }
                        }
                    }
                    .padding(AppTheme.spacing16)
                    .glassmorphic()
                    
                    if !dream.isRemembered {
                        // Forgotten dream view
                        VStack(spacing: AppTheme.spacing12) {
                            HStack {
                                Image(systemName: "moon.zzz.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(AppTheme.forgottenDream)
                                
                                Text("Rêve oublié")
                                    .font(AppTheme.sfProRounded(size: 16, weight: .semibold))
                                    .foregroundColor(AppTheme.forgottenDream)
                                
                                Spacer()
                            }
                        }
                        .padding(AppTheme.spacing16)
                        .glassmorphic()
                    } else {
                        // Remembered dream view
                        
                        // Dream content
                        if !dream.content.isEmpty {
                            VStack(alignment: .leading, spacing: AppTheme.spacing8) {
                                Text("Le rêve")
                                    .font(AppTheme.sfProRounded(size: 14, weight: .semibold))
                                    .foregroundColor(AppTheme.textSecondary)
                                
                                Text(dream.content)
                                    .font(AppTheme.sfProRounded(size: 14))
                                    .foregroundColor(AppTheme.textPrimary)
                                    .lineSpacing(4)
                            }
                            .padding(AppTheme.spacing16)
                            .glassmorphic()
                        }
                        
                        // Emotions
                        if !dream.emotions.isEmpty {
                            VStack(alignment: .leading, spacing: AppTheme.spacing12) {
                                Text("Émotions ressenties")
                                    .font(AppTheme.sfProRounded(size: 14, weight: .semibold))
                                    .foregroundColor(AppTheme.textSecondary)
                                
                                FlowLayout(spacing: AppTheme.spacing8) {
                                    ForEach(dream.emotions, id: \.self) { emotion in
                                        Text(emotion)
                                            .font(AppTheme.sfProRounded(size: 12, weight: .semibold))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, AppTheme.spacing12)
                                            .padding(.vertical, 6)
                                            .background(AppTheme.accentPurple)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                            .padding(AppTheme.spacing16)
                            .glassmorphic()
                        }
                        
                        // AI Decode Section
                        VStack(alignment: .leading, spacing: AppTheme.spacing12) {
                            Button(action: {
                                viewModel.showAIModelPicker = true
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 14, weight: .semibold))
                                    Text("Décoder avec l'IA")
                                        .font(AppTheme.sfProRounded(size: 14, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(AppTheme.spacing12)
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
                                .cornerRadius(10)
                            }
                            
                            // AI Analysis display
                            if viewModel.isLoadingAI {
                                HStack(spacing: AppTheme.spacing8) {
                                    ProgressView()
                                        .tint(AppTheme.brightPurple)
                                    Text("Décodage en cours...")
                                        .font(AppTheme.sfProRounded(size: 13))
                                        .foregroundColor(AppTheme.textSecondary)
                                }
                                .padding(AppTheme.spacing16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .glassmorphic()
                            }
                            
                            if let error = viewModel.aiError {
                                VStack(alignment: .leading, spacing: AppTheme.spacing8) {
                                    Text("Erreur")
                                        .font(AppTheme.sfProRounded(size: 12, weight: .semibold))
                                        .foregroundColor(.red)
                                    
                                    Text(error)
                                        .font(AppTheme.sfProRounded(size: 12))
                                        .foregroundColor(AppTheme.textSecondary)
                                }
                                .padding(AppTheme.spacing12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .glassmorphic()
                            }
                            
                            if let analysis = dream.aiAnalysis {
                                VStack(alignment: .leading, spacing: AppTheme.spacing12) {
                                    HStack {
                                        Text("Décodage ✦")
                                            .font(AppTheme.sfProRounded(size: 13, weight: .semibold))
                                            .foregroundColor(AppTheme.brightPurple)
                                        
                                        if let model = dream.aiModel {
                                            Text(model)
                                                .font(AppTheme.sfProRounded(size: 11))
                                                .foregroundColor(AppTheme.textSecondary)
                                        }
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            Task {
                                                await viewModel.requestNewAnalysis()
                                            }
                                        }) {
                                            Text("Régénérer")
                                                .font(AppTheme.sfProRounded(size: 11, weight: .semibold))
                                                .foregroundColor(AppTheme.brightPurple)
                                        }
                                    }
                                    
                                    Text(analysis)
                                        .font(AppTheme.sfProRounded(size: 13))
                                        .foregroundColor(AppTheme.textPrimary)
                                        .lineSpacing(4)
                                }
                                .padding(AppTheme.spacing16)
                                .glassmorphic()
                            }
                        }
                        .padding(.horizontal, 0)
                    }
                    
                    // Actions
                    HStack(spacing: AppTheme.spacing12) {
                        Button(action: { showDeleteConfirm = true }) {
                            Image(systemName: "trash.fill")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding(AppTheme.spacing12)
                                .glassmorphic()
                        }
                        
                        Button(action: { isEditing = true }) {
                            HStack(spacing: 6) {
                                Image(systemName: "pencil")
                                    .font(.system(size: 14, weight: .semibold))
                                Text("Modifier")
                                    .font(AppTheme.sfProRounded(size: 13, weight: .semibold))
                            }
                            .foregroundColor(AppTheme.brightPurple)
                            .frame(maxWidth: .infinity)
                            .padding(AppTheme.spacing12)
                            .glassmorphic()
                        }
                    }
                    .padding(.horizontal, 0)
                }
                .padding(AppTheme.spacing16)
                .padding(.bottom, AppTheme.spacing100)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear {
            viewModel.dream = dream
            viewModel.modelContext = modelContext
        }
        .sheet(isPresented: $viewModel.showAIModelPicker) {
            AIModelPickerSheet(viewModel: viewModel)
        }
        .sheet(isPresented: $isEditing) {
            DreamEditView(isPresented: $isEditing, dream: dream)
                .presentationDetents([.medium, .large])
        }
        .alert("Supprimer le rêve ?", isPresented: $showDeleteConfirm) {
            Button("Supprimer", role: .destructive) {
                modelContext.delete(dream)
                try? modelContext.save()
                dismiss()
            }
        }
    }
}

// Simple flow layout for emotions
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        var totalHeight: CGFloat = 0
        var currentLineWidth: CGFloat = 0
        var lineHeight: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            if currentLineWidth + size.width + spacing > (proposal.width ?? 0) {
                totalHeight += lineHeight + spacing
                currentLineWidth = size.width + spacing
                lineHeight = size.height
            } else {
                currentLineWidth += size.width + spacing
                lineHeight = max(lineHeight, size.height)
            }
        }
        
        totalHeight += lineHeight
        return CGSize(width: proposal.width ?? 0, height: totalHeight)
    }
    
    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        var x: CGFloat = bounds.minX
        var y: CGFloat = bounds.minY
        var lineHeight: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            if x + size.width > bounds.maxX {
                y += lineHeight + spacing
                x = bounds.minX
                lineHeight = 0
            }
            
            subview.place(
                at: CGPoint(x: x, y: y),
                proposal: .init(size)
            )
            
            x += size.width + spacing
            lineHeight = max(lineHeight, size.height)
        }
    }
}

#Preview {
    let dream = Dream(
        title: "Vol au-dessus des montagnes",
        date: Date(),
        content: "Je me suis retrouvé sur une montagne, le ciel était dégagé et je pouvais voir toute la vallée.",
        isRemembered: true,
        dreamType: .lucid,
        emotions: ["Liberté", "Joie", "Émerveillement"]
    )
    
    NavigationStack {
        DreamDetailView(dream: dream)
            .modelContainer(for: Dream.self, inMemory: true)
    }
}
