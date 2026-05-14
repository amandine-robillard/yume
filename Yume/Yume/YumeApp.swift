import SwiftUI
import SwiftData

@main
struct YumeApp: App {
    let modelContainer: ModelContainer
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
    
    init() {
        do {
            // Enable lightweight migration for model changes
            let modelConfiguration = ModelConfiguration(
                isStoredInMemoryOnly: false,
                allowsSave: true
            )
            
            modelContainer = try ModelContainer(
                for: Dream.self,
                configurations: modelConfiguration
            )
            
            // Perform migration for existing dreams without dreamType
            let container = modelContainer
            Task { @MainActor in
                await Self.migrateDreamsIfNeeded(container: container)
            }
        } catch {
            // If initialization fails, try to delete and recreate
            print("⚠️ SwiftData initialization error: \(error)")
            print("Attempting to reset database...")
            
            do {
                // Delete the old database and create a new one
                let url = URL.documentsDirectory.appending(path: "default.store")
                if FileManager.default.fileExists(atPath: url.path()) {
                    try FileManager.default.removeItem(at: url)
                    print("✅ Old database removed")
                }
                
                let modelConfiguration = ModelConfiguration(isStoredInMemoryOnly: false)
                modelContainer = try ModelContainer(
                    for: Dream.self,
                    configurations: modelConfiguration
                )
                print("✅ New database created")
            } catch {
                fatalError("Could not initialize SwiftData after reset: \(error)")
            }
        }
        
        // Configure navigation bar appearance for white text
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(red: 0.04, green: 0.055, blue: 0.1, alpha: 1.0)
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    @MainActor
    private static func migrateDreamsIfNeeded(container: ModelContainer) async {
        let context = container.mainContext
        let descriptor = FetchDescriptor<Dream>()
        
        do {
            let dreams = try context.fetch(descriptor)
            var needsMigration = false
            
            for dream in dreams {
                // Check if dreamType is empty (old data)
                if dream.dreamType.isEmpty {
                    // Migrate based on isLucid flag
                    if dream.isLucid {
                        dream.type = .lucid
                    } else {
                        dream.type = .normal
                    }
                    needsMigration = true
                }
            }
            
            if needsMigration {
                try context.save()
                print("✅ Migrated \(dreams.count) dreams to new dreamType schema")
            }
        } catch {
            print("⚠️ Migration error: \(error)")
        }
    }
}
