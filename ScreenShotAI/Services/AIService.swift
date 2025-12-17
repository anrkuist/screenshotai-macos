import Foundation
import OpenAI

class AIService {
    
    private let openAI: OpenAI
    
    init() {
        print("DEBUG: AIService initializing...")
        if Config.useGemini {
            print("DEBUG: Configuring for Gemini...")
            let configuration = OpenAI.Configuration(
                token: Config.geminiKey,
                host: "generativelanguage.googleapis.com", // Google's OpenAI endpoint
                scheme: "https",
                basePath: "/v1beta/openai/"
            )
            self.openAI = OpenAI(configuration: configuration)
            print("DEBUG: OpenAI instance created with Gemini config.")
        } else {
            print("DEBUG: Configuring for OpenAI...")
            self.openAI = OpenAI(apiToken: Config.openAIKey)
            print("DEBUG: OpenAI instance created with standard config.")
        }
    }
    
    func query(context: String, question: String) async throws -> String {
        let prompt = "Context from screenshot:\n\(context)\n\nUser question:\n\(question)"
        
        // Use Gemini Flash if configured, else default to GPT 3.5 Turbo
        let model: Model = Config.useGemini ? "gemini-2.5-flash" : .gpt3_5Turbo
        
        guard let message = ChatQuery.ChatCompletionMessageParam(role: .user, content: prompt) else {
            throw ScreenshotError.apiError("Failed to create chat message.")
        }
        
        let query = ChatQuery(
            messages: [message],
            model: model
        )
        
        do {
            let result = try await openAI.chats(query: query)
            guard let choice = result.choices.first else {
                 throw ScreenshotError.apiError("No response from OpenAI.")
            }
            
            // Handle different message content types if necessary, but essentially extract string
            return choice.message.content ?? "No text in response."
            
        } catch {
            throw ScreenshotError.apiError("OpenAI Error: \(error.localizedDescription)")
        }
    }
}

