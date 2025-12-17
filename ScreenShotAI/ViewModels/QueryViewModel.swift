//
//  QueryViewModel.swift
//  ScreenShotAI
//
//  Created by augusto on 16/12/2025.
//

import Foundation
import Combine

@MainActor
class QueryViewModel: ObservableObject {
    @Published var contextText: String = ""
    @Published var userQuestion: String = ""
    @Published var aiResponse: String = ""
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    private let aiService = AIService()
    
    func submitQuery() async {
        guard !userQuestion.isEmpty else { return }
        
        isLoading = true
        error = nil
        
        do {
            let response = try await aiService.query(context: contextText, question: userQuestion)
            self.aiResponse = response
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
}

