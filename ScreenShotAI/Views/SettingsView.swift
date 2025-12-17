//
//  SettingsView.swift
//  ScreenShotAI
//
//  Created by augusto on 16/12/2025.
//

import SwiftUI
import KeyboardShortcuts

public struct SettingsView: View {
    public var body: some View {
        Form {
            Section(header: Text("Shortcut")) {
                KeyboardShortcuts.Recorder("Capture Screenshot:", name: .toggleScreenshot)
            }
        }
        .padding()
        .frame(width: 300, height: 150)
        .background(WindowAccessor { window in
            window?.level = .floating
        })
    }
}


#Preview {
    SettingsView()
}
