import SwiftUI

struct ProfilView: View {
    @StateObject var viewModel = ProfilViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppTheme.spacing16) {
                        // Name
                        VStack(alignment: .leading, spacing: AppTheme.spacing8) {
                            Text("Prénom")
                                .font(AppTheme.sfProRounded(size: 13, weight: .semibold))
                                .foregroundColor(AppTheme.textSecondary)
                            
                            TextField("Ton prénom", text: $viewModel.firstName)
                                .font(AppTheme.sfProRounded(size: 14))
                                .foregroundColor(AppTheme.textPrimary)
                                .padding(AppTheme.spacing12)
                                .glassmorphic()
                                .onChange(of: viewModel.firstName) { _, _ in
                                    viewModel.saveUserData()
                                }
                        }
                        .padding(.horizontal, AppTheme.spacing16)
                        
                        // API Keys section
                        VStack(alignment: .leading, spacing: AppTheme.spacing12) {
                            Text("Clés API")
                                .font(AppTheme.sfProRounded(size: 16, weight: .bold))
                                .foregroundColor(AppTheme.textPrimary)
                            
                            // Anthropic
                            APIKeyField(
                                title: "Anthropic API Key",
                                placeholder: "sk-ant-...",
                                text: $viewModel.anthropicKey,
                                isSecure: !viewModel.showAnthropicKey,
                                isConfigured: viewModel.isKeyConfigured(.claude),
                                toggleVisibility: {
                                    viewModel.showAnthropicKey.toggle()
                                }
                            )
                            
                            // OpenAI
                            APIKeyField(
                                title: "OpenAI API Key",
                                placeholder: "sk-...",
                                text: $viewModel.openaiKey,
                                isSecure: !viewModel.showOpenAIKey,
                                isConfigured: viewModel.isKeyConfigured(.gpt),
                                toggleVisibility: {
                                    viewModel.showOpenAIKey.toggle()
                                }
                            )
                            
                            // Gemini
                            APIKeyField(
                                title: "Google Gemini API Key",
                                placeholder: "AI...",
                                text: $viewModel.geminiKey,
                                isSecure: !viewModel.showGeminiKey,
                                isConfigured: viewModel.isKeyConfigured(.gemini),
                                toggleVisibility: {
                                    viewModel.showGeminiKey.toggle()
                                }
                            )
                            
                            Button(action: {
                                viewModel.saveAPIKeys()
                            }) {
                                Text("Enregistrer les clés")
                                    .font(AppTheme.sfProRounded(size: 14, weight: .semibold))
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
                        }
                        .padding(AppTheme.spacing16)
                        .glassmorphic()
                        .padding(.horizontal, AppTheme.spacing16)
                        
                        // Preferred model
                        VStack(alignment: .leading, spacing: AppTheme.spacing12) {
                            Text("Modèle préféré")
                                .font(AppTheme.sfProRounded(size: 16, weight: .bold))
                                .foregroundColor(AppTheme.textPrimary)
                            
                            VStack(spacing: AppTheme.spacing8) {
                                ForEach(AIModel.allCases, id: \.self) { model in
                                    Button(action: {
                                        viewModel.preferredModel = model
                                        viewModel.saveUserData()
                                    }) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(model.rawValue)
                                                    .font(AppTheme.sfProRounded(size: 14, weight: .semibold))
                                                    .foregroundColor(AppTheme.textPrimary)
                                                
                                                Text(model.provider)
                                                    .font(AppTheme.sfProRounded(size: 11))
                                                    .foregroundColor(AppTheme.textSecondary)
                                            }
                                            
                                            Spacer()
                                            
                                            if viewModel.preferredModel == model {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .font(.system(size: 18))
                                                    .foregroundColor(AppTheme.brightPurple)
                                            } else {
                                                Image(systemName: "circle")
                                                    .font(.system(size: 18))
                                                    .foregroundColor(AppTheme.textSecondary)
                                            }
                                        }
                                        .padding(AppTheme.spacing12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(viewModel.preferredModel == model ? AppTheme.accentPurple.opacity(0.2) : Color.clear)
                                        )
                                    }
                                }
                            }
                        }
                        .padding(AppTheme.spacing16)
                        .glassmorphic()
                        .padding(.horizontal, AppTheme.spacing16)
                        
                        // Notifications
                        VStack(alignment: .leading, spacing: AppTheme.spacing12) {
                            Text("Notifications")
                                .font(AppTheme.sfProRounded(size: 16, weight: .bold))
                                .foregroundColor(AppTheme.textPrimary)
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Rappel quotidien")
                                        .font(AppTheme.sfProRounded(size: 14, weight: .semibold))
                                        .foregroundColor(AppTheme.textPrimary)
                                    
                                    Text("Recevoir une notification quotidienne")
                                        .font(AppTheme.sfProRounded(size: 11))
                                        .foregroundColor(AppTheme.textSecondary)
                                }
                                
                                Spacer()
                                
                                Toggle("", isOn: $viewModel.notificationsEnabled)
                                    .tint(AppTheme.brightPurple)
                                    .onChange(of: viewModel.notificationsEnabled) { _, _ in
                                        viewModel.saveUserData()
                                    }
                            }
                            
                            if viewModel.notificationsEnabled {
                                VStack(alignment: .leading, spacing: AppTheme.spacing8) {
                                    Text("Heure du rappel")
                                        .font(AppTheme.sfProRounded(size: 13, weight: .semibold))
                                        .foregroundColor(AppTheme.textSecondary)
                                    
                                    DatePicker("", selection: $viewModel.reminderTime, displayedComponents: [.hourAndMinute])
                                        .datePickerStyle(.wheel)
                                        .labelsHidden()
                                        .tint(AppTheme.brightPurple)
                                        .environment(\.colorScheme, .dark)
                                        .padding(AppTheme.spacing8)
                                        .background(AppTheme.cardBackground)
                                        .cornerRadius(8)
                                        .onChange(of: viewModel.reminderTime) { _, _ in
                                            viewModel.saveUserData()
                                        }
                                }
                            }
                        }
                        .padding(AppTheme.spacing16)
                        .glassmorphic()
                        .padding(.horizontal, AppTheme.spacing16)
                    }
                    .padding(.vertical, AppTheme.spacing16)
                    .padding(.bottom, AppTheme.spacing100)
                }
            }
            .navigationTitle("Profil")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .preferredColorScheme(.dark)
    }
}

private struct APIKeyField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let isSecure: Bool
    let isConfigured: Bool
    let toggleVisibility: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.spacing8) {
            HStack {
                Text(title)
                    .font(AppTheme.sfProRounded(size: 13, weight: .semibold))
                    .foregroundColor(AppTheme.textSecondary)
                
                Spacer()
                
                if isConfigured {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 10))
                        Text("✓ Configurée")
                            .font(AppTheme.sfProRounded(size: 10, weight: .semibold))
                    }
                    .foregroundColor(.green)
                } else {
                    Text("Non configurée")
                        .font(AppTheme.sfProRounded(size: 10, weight: .semibold))
                        .foregroundColor(.red)
                }
            }
            
            HStack {
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .font(AppTheme.sfProRounded(size: 13))
                        .foregroundColor(AppTheme.textPrimary)
                } else {
                    TextField(placeholder, text: $text)
                        .font(AppTheme.sfProRounded(size: 13))
                        .foregroundColor(AppTheme.textPrimary)
                }
                
                Button(action: toggleVisibility) {
                    Image(systemName: isSecure ? "eye.slash.fill" : "eye.fill")
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.textSecondary)
                }
            }
            .padding(AppTheme.spacing12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppTheme.cardBackground)
            )
        }
    }
}

#Preview {
    ProfilView()
}
