import SwiftUI
import SwiftData

struct DreamsListView: View {
    @StateObject var viewModel = DreamsListViewModel()
    @Query(sort: \Dream.date, order: .reverse) var allDreams: [Dream]
    
    var filteredDreams: [Dream] {
        viewModel.filteredAndSortedDreams(allDreams)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.textSecondary)
                        
                        TextField("Rechercher...", text: $viewModel.searchText)
                            .font(AppTheme.sfProRounded(size: 14))
                            .foregroundColor(AppTheme.textPrimary)
                    }
                    .padding(AppTheme.spacing12)
                    .glassmorphic()
                    .padding(.horizontal, AppTheme.spacing16)
                    .padding(.top, AppTheme.spacing16)
                    
                    // Filter tabs
                    HStack(spacing: AppTheme.spacing8) {
                        ForEach(DreamFilter.allCases, id: \.self) { filter in
                            FilterTab(
                                title: filter.rawValue,
                                isSelected: viewModel.selectedFilter == filter,
                                action: {
                                    withAnimation(.spring()) {
                                        viewModel.selectedFilter = filter
                                    }
                                }
                            )
                        }
                        
                        Spacer()
                        
                        // Sort menu
                        Menu {
                            ForEach(DreamSort.allCases, id: \.self) { sort in
                                Button(action: {
                                    viewModel.selectedSort = sort
                                }) {
                                    HStack {
                                        Text(sort.rawValue)
                                        if viewModel.selectedSort == sort {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            Image(systemName: "arrow.up.arrow.down")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(AppTheme.accentPurple)
                                .padding(AppTheme.spacing8)
                                .glassmorphic()
                        }
                    }
                    .padding(.horizontal, AppTheme.spacing16)
                    .padding(.top, AppTheme.spacing12)
                    
                    // Dreams list
                    ScrollView {
                        LazyVStack(spacing: AppTheme.spacing8) {
                            if filteredDreams.isEmpty {
                                VStack(spacing: AppTheme.spacing12) {
                                    Image(systemName: "moon.zzz.fill")
                                        .font(.system(size: 48))
                                        .foregroundColor(AppTheme.textSecondary)
                                    
                                    Text("Aucun rêve trouvé")
                                        .font(AppTheme.sfProRounded(size: 14))
                                        .foregroundColor(AppTheme.textSecondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.top, 60)
                            } else {
                                ForEach(filteredDreams) { dream in
                                    NavigationLink(destination: DreamDetailView(dream: dream)) {
                                        DreamCard(dream: dream)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, AppTheme.spacing16)
                        .padding(.top, AppTheme.spacing16)
                        .padding(.bottom, AppTheme.spacing100)
                    }
                }
            }
            .navigationTitle("Rêves")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .preferredColorScheme(.dark)
    }
}

private struct FilterTab: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.sfProRounded(size: 12, weight: .semibold))
                .foregroundColor(isSelected ? .white : AppTheme.textSecondary)
                .padding(.horizontal, AppTheme.spacing12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? AppTheme.accentPurple : AppTheme.cardBackground)
                )
        }
    }
}

#Preview {
    DreamsListView()
        .modelContainer(for: Dream.self, inMemory: true)
}
