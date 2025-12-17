import Cocoa
import Foundation

class ScreenshotManager {
    
    /// Captures a selected portion of the screen interactively.
    /// returns captured image Data (PNG).
    func captureInteractive() async throws -> Data {
        let task = Task.detached(priority: .userInitiated) {
            let temporaryDirectoryURL = FileManager.default.temporaryDirectory
            let temporaryFileURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("png")
            
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/sbin/screencapture")
            // -i: interactive mode
            // -r: doesn't capture shadow
            process.arguments = ["-i", "-r", temporaryFileURL.path]
            
            try process.run()
            process.waitUntilExit()
            
            if process.terminationStatus != 0 {
                // Check if file exists, if not, it's cancellation
                 if !FileManager.default.fileExists(atPath: temporaryFileURL.path) {
                     // Clean up
                     try? FileManager.default.removeItem(at: temporaryFileURL)
                     throw ScreenshotError.userCancelled
                 }
                throw ScreenshotError.commandFailed(process.terminationStatus)
            }
            
            guard FileManager.default.fileExists(atPath: temporaryFileURL.path) else {
                // User cancelled
                throw ScreenshotError.userCancelled
            }
            
            let data: Data
            do {
                data = try Data(contentsOf: temporaryFileURL)
                print("DEBUG: Interactive capture successful. Image size: \(data.count) bytes")
            } catch {
                print("ERROR: Failed to read captured data: \(error)")
                throw ScreenshotError.invalidData
            }
            
            // Cleanup
            try? FileManager.default.removeItem(at: temporaryFileURL)
            
            return data
        }
        
        return try await task.value
    }
}
