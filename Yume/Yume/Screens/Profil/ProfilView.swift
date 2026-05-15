import SwiftUI
import SwiftData
import UIKit
import UniformTypeIdentifiers

struct ProfilView: View {
    @StateObject var viewModel = ProfilViewModel()
    @Environment(\.modelContext) var modelContext
    
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
                        
                        // Export/Import section
                        VStack(alignment: .leading, spacing: AppTheme.spacing12) {
                            Text("Données")
                                .font(AppTheme.sfProRounded(size: 16, weight: .bold))
                                .foregroundColor(AppTheme.textPrimary)
                            
                            Text("Exportez et importez vos rêves en cas de changement de téléphone")
                                .font(AppTheme.sfProRounded(size: 12))
                                .foregroundColor(AppTheme.textSecondary)
                            
                            VStack(spacing: AppTheme.spacing8) {
                                Button(action: {
                                    viewModel.loadDreams(from: modelContext)
                                    viewModel.exportDreams()
                                }) {
                                    HStack {
                                        Image(systemName: "arrow.up.doc")
                                            .font(.system(size: 16, weight: .semibold))
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Exporter les rêves")
                                                .font(AppTheme.sfProRounded(size: 14, weight: .semibold))
                                            
                                            Text("Partager vos rêves sauvegardés")
                                                .font(AppTheme.sfProRounded(size: 11))
                                        }
                                        
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(AppTheme.spacing12)
                                    .foregroundColor(.white)
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
                                
                                Button(action: {
                                    viewModel.showFileImporter = true
                                }) {
                                    HStack {
                                        Image(systemName: "arrow.down.doc")
                                            .font(.system(size: 16, weight: .semibold))
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Importer les rêves")
                                                .font(AppTheme.sfProRounded(size: 14, weight: .semibold))
                                            
                                            Text("Charger un fichier d'export")
                                                .font(AppTheme.sfProRounded(size: 11))
                                        }
                                        
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(AppTheme.spacing12)
                                    .foregroundColor(.white)
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(red: 0.2, green: 0.4, blue: 0.8),
                                                Color(red: 0.3, green: 0.6, blue: 1.0)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .cornerRadius(10)
                                }
                                
                                Divider()
                                    .padding(.vertical, AppTheme.spacing8)
                                
                                Button(action: {
                                    viewModel.showDeleteConfirmation = true
                                }) {
                                    HStack {
                                        Image(systemName: "trash")
                                            .font(.system(size: 16, weight: .semibold))
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Supprimer les données")
                                                .font(AppTheme.sfProRounded(size: 14, weight: .semibold))
                                            
                                            Text("Effacer tous les rêves et émotions")
                                                .font(AppTheme.sfProRounded(size: 11))
                                        }
                                        
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(AppTheme.spacing12)
                                    .foregroundColor(.white)
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(red: 0.8, green: 0.2, blue: 0.2),
                                                Color(red: 1.0, green: 0.3, blue: 0.3)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .cornerRadius(10)
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
            .alert("Export", isPresented: $viewModel.showExportAlert) {
                Button("OK") { }
            } message: {
                Text(viewModel.exportMessage)
            }
            .alert("Import", isPresented: $viewModel.showImportAlert) {
                Button("OK") { }
            } message: {
                Text(viewModel.importMessage)
            }
            .confirmationDialog(
                "Options d'import",
                isPresented: $viewModel.showImportOptions,
                presenting: ()
            ) { _ in
                Button("Mixer avec les données existantes", action: {
                    viewModel.performImport(replaceExisting: false)
                })
                
                Button("Remplacer toutes les données", role: .destructive, action: {
                    viewModel.performImport(replaceExisting: true)
                })
                
                Button("Annuler", role: .cancel, action: {
                    viewModel.importFileURL = nil
                })
            } message: { _ in
                Text("Que souhaitez-vous faire avec les données existantes?")
            }
            .sheet(isPresented: $viewModel.showShareSheet) {
                ShareSheet(items: viewModel.shareItems)
            }
            .fileImporter(
                isPresented: $viewModel.showFileImporter,
                allowedContentTypes: [.json],
                onCompletion: { result in
                    switch result {
                    case .success(let url):
                        viewModel.loadDreams(from: modelContext)
                        viewModel.importFromFile(url: url)
                    case .failure(let error):
                        viewModel.importMessage = "Erreur lors de la sélection du fichier: \(error.localizedDescription)"
                        viewModel.showImportAlert = true
                    }
                }
            )
            .confirmationDialog(
                "Supprimer toutes les données?",
                isPresented: $viewModel.showDeleteConfirmation,
                presenting: ()
            ) { _ in
                Button("Supprimer", role: .destructive, action: {
                    viewModel.modelContext = modelContext
                    viewModel.deleteAllData()
                })
                
                Button("Annuler", role: .cancel, action: {})
            } message: { _ in
                Text("Cette action supprimera tous vos rêves et vos émotions personnalisées. Cette action ne peut pas être annulée.")
            }
            .alert("Suppression", isPresented: $viewModel.showDeleteAlert) {
                Button("OK") { }
            } message: {
                Text(viewModel.deleteMessage)
            }
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

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    }
}

#Preview {
    ProfilView()
}
