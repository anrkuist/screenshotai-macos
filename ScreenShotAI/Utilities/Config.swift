//
//  Config.swift
//  ScreenShotAI
//
//  Created by augusto on 16/12/2025.
//

import Foundation

enum Config {
    // TODO: Ideally, load this from the Keychain or a secure location
    // For this project, we'll keep it here but remind the user to replace it.
    static let openAIKey = "INSERT_YOUR_OPENAI_API_KEY_HERE"
    
    // Gemini Configuration
    static let useGemini = true
    static let geminiKey = "INSERT_YOUR_GEMINI_API_KEY_HERE"
}
