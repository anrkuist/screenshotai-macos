//
//  MenuBarView.swift
//  ScreenShotAI
//
//  Created by augusto on 16/12/2025.
//

import SwiftUI

struct MenuBarView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.openWindow) var openWindow
    
    var body: some View {
        Group {
            Button(action: {
                appState.startScreenshotFlow()
            }) {
                Label("Capture Screenshot", systemImage: "viewfinder")
            }
            .keyboardShortcut("x", modifiers: [.command, .shift])
            
            if !appState.currentOCRText.isEmpty {
                Button("Show Query Window") {
                    appState.showQueryWindow = true
                }
            }
            
            Divider()
            
            if #available(macOS 14.0, *) {
                SettingsLink {
                     Text("Settings...")
                }
            } else {
                 Button("Settings...") {
                     NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                 }
            }
            
            Divider()
            
            Button("Quit Screenshot AI") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        }
    }
}


#Preview {
    MenuBarView()
}
