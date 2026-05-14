import SwiftUI
import SwiftData

struct DreamEditView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var isPresented: Bool
    
    let dream: Dream
    
    @State private var title: String = ""
    @State private var date: Date = Date()
    @State private var content: String = ""
    @State private var isLucid: Bool = false
    @State private var selectedEmotions: Set<String> = []
    @State private var customEmotions: [String] = []
    @State private var newEmotionText: String = ""
    @State private var showAddEmotion: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppTheme.spacing16) {
                        // Title
                        VStack(alignment: .leading, spacing: AppTheme.spacing8) {
                            Text("Titre du rêve")
                                .font(AppTheme.sfProRounded(size: 13, weight: .semibold))
                                .foregroundColor(AppTheme.textSecondary)
                            
                            TextField("Ex: Vol au-dessus des montagnes", text: $title)
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
                            
                            DatePicker("", selection: $date, displayedComponents: [.date])
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
                            
                            TextEditor(text: $content)
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
                            
                            Toggle("", isOn: $isLucid)
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
                                    showAddEmotion = true
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
                                ForEach(Emotion.allCases, id: \.self) { emotion in
                                    EmotionChip(
                                        emotion: emotion.rawValue,
                                        isSelected: selectedEmotions.contains(emotion.rawValue),
                                        action: {
                                            withAnimation(.spring()) {
                                                if selectedEmotions.contains(emotion.rawValue) {
                                                    selectedEmotions.remove(emotion.rawValue)
                                                } else {
                                                    selectedEmotions.insert(emotion.rawValue)
                                                }
                                            }
                                        }
                                    )
                                }
                                
                                ForEach(customEmotions, id: \.self) { emotion in
                                    EmotionChip(
                                        emotion: emotion,
                                        isSelected: selectedEmotions.contains(emotion),
                                        action: {
                                            withAnimation(.spring()) {
                                                if selectedEmotions.contains(emotion) {
                                                    selectedEmotions.remove(emotion)
                                                } else {
                                                    selectedEmotions.insert(emotion)
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
                        if showAddEmotion {
                            VStack(alignment: .leading, spacing: AppTheme.spacing8) {
                                Text("Nouvelle émotion")
                                    .font(AppTheme.sfProRounded(size: 13, weight: .semibold))
                                    .foregroundColor(AppTheme.textSecondary)
                                
                                HStack(spacing: AppTheme.spacing8) {
                                    TextField("Ex: Nostalgie", text: $newEmotionText)
                                        .font(AppTheme.sfProRounded(size: 14))
                                        .foregroundColor(AppTheme.textPrimary)
                                        .padding(AppTheme.spacing12)
                                        .background(AppTheme.cardBackground)
                                        .cornerRadius(8)
                                    
                                    Button(action: {
                                        let trimmed = newEmotionText.trimmingCharacters(in: .whitespacesAndNewlines)
                                        guard !trimmed.isEmpty else { return }
                                        
                                        let allEmotions = Emotion.allCases.map { $0.rawValue } + customEmotions
                                        guard !allEmotions.contains(trimmed) else { return }
                                        
                                        customEmotions.append(trimmed)
                                        selectedEmotions.insert(trimmed)
                                        var saved = UserDefaults.standard.array(forKey: "customEmotions") as? [String] ?? []
                                        if !saved.contains(trimmed) {
                                            saved.append(trimmed)
                                            UserDefaults.standard.set(saved, forKey: "customEmotions")
                                        }
                                        newEmotionText = ""
                                        showAddEmotion = false
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
                                        showAddEmotion = false
                                        newEmotionText = ""
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
                    .padding(AppTheme.spacing16)
                    .padding(.bottom, AppTheme.spacing100)
                }
                
                // Save button
                VStack {
                    Spacer()
                    
                    Button(action: {
                        dream.title = title
                        dream.date = date
                        dream.content = content
                        dream.isLucid = isLucid
                        dream.emotions = Array(selectedEmotions)
                        
                        try? modelContext.save()
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
            .navigationTitle("Modifier")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                }
            }
        }
        .onAppear {
            title = dream.title
            date = dream.date
            content = dream.content
            isLucid = dream.isLucid
            selectedEmotions = Set(dream.emotions)
            
            // Load custom emotions
            if let saved = UserDefaults.standard.array(forKey: "customEmotions") as? [String] {
                customEmotions = saved
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
