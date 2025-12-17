//
//  ScreenshotError.swift
//  ScreenShotAI
//
//  Created by augusto on 16/12/2025.
//


import Foundation

enum ScreenshotError: Error, LocalizedError {
    case invalidData
    case commandFailed(Int32)
    case ocrFailed
    case apiError(String)
    case noTextFound
    
    case userCancelled
    
    var errorDescription: String? {
        switch self {
        case .invalidData:
            return "Could not load image data."
        case .commandFailed(let code):
            return "Screen capture failed with exit code \(code)."
        case .ocrFailed:
            return "Failed to extract text from the image."
        case .apiError(let message):
            return "AI API Error: \(message)"
        case .noTextFound:
            return "No text was found in the screenshot."
        case .userCancelled:
            return "Screenshot capture cancelled."
        }
    }
}
