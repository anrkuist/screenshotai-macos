import OSLog
import SwiftUI
import Combine
import KeyboardShortcuts

@MainActor
class AppState: ObservableObject {
    @Published var currentOCRText: String = ""
    @Published var isProcessing: Bool = false
    @Published var errorMessage: String?
    
    // Using this to signal the App to open the window
    @Published var showQueryWindow: Bool = false
    
    private let screenshotManager = ScreenshotManager()
    private let ocrService = OCRService()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "ScreenShotAI", category: "AppState")
    
    init() {
        logger.debug("AppState initializing...")
        
        // Register global shortcut listener
        KeyboardShortcuts.onKeyUp(for: .toggleScreenshot) { [weak self] in
            guard let self = self else { return }
            self.logger.debug("Global shortcut triggered")
            
            // We need to jump back to MainActor to update published properties and manage UI flow
            Task { @MainActor in
                self.startScreenshotFlow()
            }
        }
    }
    
    /// Initiates the screenshot flow: Capture -> OCR -> Display.
    /// - Note: This runs asynchronously and updates the published state.
    func startScreenshotFlow() {
        // Run in a detached task to avoid blocking the main thread during capture initiation
        Task {
            do {
                // Hide the app to ensure clean screenshot if window was just opened by shortcut
                NSApp.hide(nil)
                
                self.isProcessing = true
                self.errorMessage = nil
                
                // 1. Capture Screenshot
                // Runs on background
                let imageData = try await screenshotManager.captureInteractive()
                
                // 2. OCR
                let text = try await ocrService.extractText(from: imageData)
                
                if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    throw ScreenshotError.noTextFound
                }
                
                // 3. Update State
                self.currentOCRText = text
                self.isProcessing = false
                
                // 4. Signal to open Window
                self.showQueryWindow = true
                
            } catch {
                self.isProcessing = false
                if let screenshotError = error as? ScreenshotError, case .userCancelled = screenshotError {
                    // Ignore user cancellation, don't show error window
                    logger.info("User cancelled screenshot operation")
                } else {
                    self.errorMessage = error.localizedDescription
                    // Show window to display error
                    self.showQueryWindow = true
                    logger.error("Error in screenshot flow: \(error.localizedDescription)")
                }
            }
        }
    }
}
