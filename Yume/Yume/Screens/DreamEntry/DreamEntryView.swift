import SwiftUI
import SwiftData

struct DreamEntryView: View {
    @StateObject var viewModel = DreamEntryViewModel()
    @Environment(\.modelContext) var modelContext
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppTheme.spacing20) {
                        if viewModel.isRemembered == nil {
                            // Step 1: Memory check
                            MemoryCheckView(viewModel: viewModel)
                        } else if viewModel.isRemembered == false {
                            // Forgotten dream - just save it
                            ForgottenDreamView(viewModel: viewModel, isPresented: $isPresented)
                        } else {
                            // Step 2: Dream details
                            DreamDetailsView(viewModel: viewModel)
                        }
                    }
                    .padding(AppTheme.spacing16)
                    .padding(.bottom, 100)
                }
                
                // Save button for step 2
                if viewModel.isRemembered == true {
                    VStack {
                        Spacer()
                        
                        Button(action: {
                            viewModel.saveDream(modelContext: modelContext)
                            isPresented = false
                        }) {
                            Text("Enregistrer")
                                .font(AppTheme.sfProRounded(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(AppTheme.spacing16)
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
                                .cornerRadius(12)
                                .padding(AppTheme.spacing16)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(viewModel.isRemembered != nil)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if viewModel.isRemembered != nil {
                        Button(action: {
                            withAnimation(.spring()) {
                                viewModel.isRemembered = nil
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(AppTheme.accentPurple)
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                }
            }
        }
    }
}

// MARK: - Step 1: Memory Check

private struct MemoryCheckView: View {
    @ObservedObject var viewModel: DreamEntryViewModel
    
    var body: some View {
        VStack(spacing: AppTheme.spacing24) {
            VStack(spacing: AppTheme.spacing12) {
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 48))
                    .foregroundColor(AppTheme.brightPurple)
                
                Text("Tu te souviens de ton rêve ?")
                    .font(AppTheme.sfProRounded(size: 22, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
            }
            
            Spacer()
            
            VStack(spacing: AppTheme.spacing12) {
                Button(action: {
                    withAnimation(.spring()) {
                        viewModel.isRemembered = true
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "star.fill")
                        Text("Oui ✦")
                            .font(AppTheme.sfProRounded(size: 16, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(AppTheme.spacing16)
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
                    .cornerRadius(12)
                }
                
                Button(action: {
                    withAnimation(.spring()) {
                        viewModel.isRemembered = false
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "moon.zzz.fill")
                        Text("Non")
                            .font(AppTheme.sfProRounded(size: 16, weight: .bold))
                    }
                    .foregroundColor(AppTheme.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(AppTheme.spacing16)
                    .background(AppTheme.forgottenDream)
                    .cornerRadius(12)
                }
            }
        }
        .frame(minHeight: 300)
    }
}

// MARK: - Forgotten Dream

private struct ForgottenDreamView: View {
    @ObservedObject var viewModel: DreamEntryViewModel
    @Binding var isPresented: Bool
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        VStack(spacing: AppTheme.spacing24) {
            VStack(spacing: AppTheme.spacing12) {
                Image(systemName: "moon.zzz.fill")
                    .font(.system(size: 48))
                    .foregroundColor(AppTheme.forgottenDream)
                
                Text("Rêve oublié")
                    .font(AppTheme.sfProRounded(size: 22, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
                
                Text("Ce rêve a été enregistré")
                    .font(AppTheme.sfProRounded(size: 14))
                    .foregroundColor(AppTheme.textSecondary)
            }
            
            Spacer()
            
            Button(action: {
                viewModel.saveDream(modelContext: modelContext)
                isPresented = false
            }) {
                Text("OK")
                    .font(AppTheme.sfProRounded(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(AppTheme.spacing16)
                    .background(AppTheme.forgottenDream)
                    .cornerRadius(12)
            }
        }
        .frame(minHeight: 300)
        .onAppear {
            // Auto-save forgotten dream after 1 second
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                viewModel.saveDream(modelContext: modelContext)
                isPresented = false
            }
        }
    }
}

// MARK: - Step 2: Dream Details

private struct DreamDetailsView: View {
    @ObservedObject var viewModel: DreamEntryViewModel
    
    var body: some View {
        VStack(spacing: AppTheme.spacing16) {
            // Title
            VStack(alignment: .leading, spacing: AppTheme.spacing8) {
                Text("Titre du rêve")
                    .font(AppTheme.sfProRounded(size: 13, weight: .semibold))
                    .foregroundColor(AppTheme.textSecondary)
                
                TextField("Ex: Vol au-dessus des montagnes", text: $viewModel.title)
                    .font(AppTheme.sfProRounded(size: 14))
                    .foregroundColor(AppTheme.textPrimary)
                    .padding(AppTheme.spacing12)
                    .glassmorphic()
            }
            
            // Date
            VStack(alignment: .leading, spacing: AppTheme.spacing8) {
                Text("Date du rêve")
                    .font(AppTheme.sfProRounded(size: 13, weight: .semibold))
                    .foregroundColor(AppTheme.textSecondary)
                
                DatePicker("", selection: $viewModel.date, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .tint(AppTheme.brightPurple)
                    .environment(\.colorScheme, .dark)
                    .padding(AppTheme.spacing12)
                    .glassmorphic()
            }
            
            // Content
            VStack(alignment: .leading, spacing: AppTheme.spacing8) {
                Text("Récit du rêve")
                    .font(AppTheme.sfProRounded(size: 13, weight: .semibold))
                    .foregroundColor(AppTheme.textSecondary)
                
                TextEditor(text: $viewModel.content)
                    .font(AppTheme.sfProRounded(size: 14))
                    .foregroundColor(AppTheme.textPrimary)
                    .scrollContentBackground(.hidden)
                    .background(AppTheme.cardBackground)
                    .cornerRadius(8)
                    .frame(minHeight: 120)
                    .padding(AppTheme.spacing12)
                    .glassmorphic()
            }
            
            // Lucid toggle
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Rêve lucide ?")
                        .font(AppTheme.sfProRounded(size: 13, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)
                }
                
                Spacer()
                
                Toggle("", isOn: $viewModel.isLucid)
                    .tint(AppTheme.brightPurple)
            }
            .padding(AppTheme.spacing12)
            .glassmorphic()
            
            // Emotions
            VStack(alignment: .leading, spacing: AppTheme.spacing12) {
                HStack {
                    Text("Émotions ressenties")
                        .font(AppTheme.sfProRounded(size: 13, weight: .semibold))
                        .foregroundColor(AppTheme.textSecondary)
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.showAddEmotion = true
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 12))
                            Text("Ajouter")
                                .font(AppTheme.sfProRounded(size: 11, weight: .semibold))
                        }
                        .foregroundColor(AppTheme.brightPurple)
                    }
                }
                
                FlowLayout(spacing: AppTheme.spacing8) {
                    // Default emotions
                    ForEach(Emotion.allCases, id: \.self) { emotion in
                        EmotionChip(
                            emotion: emotion.rawValue,
                            isSelected: viewModel.selectedEmotions.contains(emotion.rawValue),
                            action: {
                                withAnimation(.spring()) {
                                    if viewModel.selectedEmotions.contains(emotion.rawValue) {
                                        viewModel.selectedEmotions.remove(emotion.rawValue)
                                    } else {
                                        viewModel.selectedEmotions.insert(emotion.rawValue)
                                    }
                                }
                            }
                        )
                    }
                    
                    // Custom emotions
                    ForEach(viewModel.customEmotions, id: \.self) { emotion in
                        EmotionChip(
                            emotion: emotion,
                            isSelected: viewModel.selectedEmotions.contains(emotion),
                            action: {
                                withAnimation(.spring()) {
                                    if viewModel.selectedEmotions.contains(emotion) {
                                        viewModel.selectedEmotions.remove(emotion)
                                    } else {
                                        viewModel.selectedEmotions.insert(emotion)
                                    }
                                }
                            }
                        )
                    }
                }
                .padding(AppTheme.spacing12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .glassmorphic()
            }
            
            // Add emotion dialog
            if viewModel.showAddEmotion {
                VStack(alignment: .leading, spacing: AppTheme.spacing8) {
                    Text("Nouvelle émotion")
                        .font(AppTheme.sfProRounded(size: 13, weight: .semibold))
                        .foregroundColor(AppTheme.textSecondary)
                    
                    HStack(spacing: AppTheme.spacing8) {
                        TextField("Ex: Nostalgie", text: $viewModel.newEmotionText)
                            .font(AppTheme.sfProRounded(size: 14))
                            .foregroundColor(AppTheme.textPrimary)
                            .padding(AppTheme.spacing12)
                            .background(AppTheme.cardBackground)
                            .cornerRadius(8)
                        
                        Button(action: {
                            viewModel.addCustomEmotion()
                        }) {
                            Text("Ajouter")
                                .font(AppTheme.sfProRounded(size: 13, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, AppTheme.spacing12)
                                .padding(.vertical, AppTheme.spacing8)
                                .background(AppTheme.brightPurple)
                                .cornerRadius(8)
                        }
                        
                        Button(action: {
                            viewModel.showAddEmotion = false
                            viewModel.newEmotionText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(AppTheme.textSecondary)
                        }
                    }
                }
                .padding(AppTheme.spacing12)
                .glassmorphic()
            }
        }
    }
}

private struct EmotionChip: View {
    let emotion: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(emotion)
                .font(AppTheme.sfProRounded(size: 12, weight: .semibold))
                .foregroundColor(isSelected ? .white : AppTheme.textSecondary)
                .padding(.horizontal, AppTheme.spacing12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? AppTheme.accentPurple : AppTheme.cardBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            isSelected ? AppTheme.accentPurple : AppTheme.textSecondary,
                            lineWidth: isSelected ? 0 : 1
                        )
                )
        }
    }
}

#Preview {
    DreamEntryView(isPresented: .constant(true))
        .modelContainer(for: Dream.self, inMemory: true)
}
