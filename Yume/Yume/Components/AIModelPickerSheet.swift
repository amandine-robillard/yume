import SwiftUI

struct AIModelPickerSheet: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: DreamDetailViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.spacing16) {
                    Text("Choisir le modèle")
                        .font(AppTheme.sfProRounded(size: 20, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)
                        .padding(.top, AppTheme.spacing20)
                    
                    ForEach(AIModel.allCases, id: \.self) { model in
                        ModelCard(model: model, viewModel: viewModel, onSelect: {
                            dismiss()
                        })
                    }
                }
                .padding(AppTheme.spacing16)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .background(AppTheme.background.ignoresSafeArea())
    }
}

private struct ModelCard: View {
    let model: AIModel
    @ObservedObject var viewModel: DreamDetailViewModel
    let onSelect: () -> Void
    
    private var isConfigured: Bool {
        let keyName = keyNameForModel(model)
        return KeychainManager.shared.exists(for: keyName)
    }
    
    private func keyNameForModel(_ model: AIModel) -> String {
        switch model {
        case .claude: return "anthropic_api_key"
        case .gpt: return "openai_api_key"
        case .gemini: return "gemini_api_key"
        }
    }
    
    var body: some View {
        Button(action: {
            if isConfigured {
                Task {
                    await viewModel.requestAIAnalysis(model: model)
                    onSelect()
                }
            }
        }) {
            HStack(spacing: AppTheme.spacing16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(model.rawValue)
                        .font(AppTheme.sfProRounded(size: 16, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)
                    
                    Text(model.version)
                        .font(AppTheme.sfProRounded(size: 12))
                        .foregroundColor(AppTheme.textSecondary)
                    
                    Text(model.provider)
                        .font(AppTheme.sfProRounded(size: 11))
                        .foregroundColor(AppTheme.textSecondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    if isConfigured {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 12))
                            Text("Configurée ✓")
                                .font(AppTheme.sfProRounded(size: 11, weight: .semibold))
                        }
                        .foregroundColor(.green)
                    } else {
                        HStack(spacing: 4) {
                            Image(systemName: "exclamationmark.circle.fill")
                                .font(.system(size: 12))
                            Text("Non configurée")
                                .font(AppTheme.sfProRounded(size: 11, weight: .semibold))
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .padding(AppTheme.spacing16)
            .glassmorphic()
            .opacity(isConfigured ? 1.0 : 0.6)
        }
        .disabled(!isConfigured)
    }
}
