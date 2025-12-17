

import SwiftUI
import KeyboardShortcuts

@main
struct ScreenshotAIApp: App {
    @StateObject private var appState = AppState()
    
    @Environment(\.openWindow) private var openWindow
    
    var body: some Scene {
        MenuBarExtra("Screenshot AI", systemImage: "photo.on.rectangle") {
            MenuBarView()
                .environmentObject(appState)
        }
        .menuBarExtraStyle(.menu) 
        
        Window("AI Query", id: "query") {
            QueryWindow()
                .environmentObject(appState)
                .frame(minWidth: 500, minHeight: 600)
                .onOpenURL { url in
                    // Handle URL opening logic

                    if url.scheme == "screenshotai" && url.host == "capture" {
                        appState.startScreenshotFlow()
                    }
                }
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: .newItem) { }
        }
        .handlesExternalEvents(matching: Set(arrayLiteral: "query", "capture"))
        // Observe appState to open window programmatically
        .onChange(of: appState.showQueryWindow) { _, newValue in
            if newValue {
                openWindow(id: "query")
                NSApp.activate(ignoringOtherApps: true)
                // Reset state so we can trigger it again
                appState.showQueryWindow = false
            }
        }
        
        Settings {
            SettingsView()
        }
    }

    
    init() {

        // Set the app to be an accessory so it doesn't show in the Dock
        NSApplication.shared.setActivationPolicy(.accessory)
    }
}

// Extension to handle window opening if needed from AppState
// In SwiftUI lifecycle, opening windows programmatically usually requires the \.openWindow environment value.
// Since AppState is an ObservableObject, we might need a bridge.
// For now, simpler approach: The user can click the menu bar item to see state.
// But for "Pop up after screenshot", we need to open the window.
// We can use a change observer in the implementation.
