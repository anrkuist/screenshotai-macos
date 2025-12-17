import Cocoa
import Vision

class OCRService {
    
    /// Extracts text from the provided image data using the Vision framework.
    /// - Parameter imageData: The raw data of the image (PNG/JPEG)
    /// - Returns: The recognized text joined by newlines.
    /// - Throws: An error if Vision fails or no text is recognized.
    func extractText(from imageData: Data) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            let request = VNRecognizeTextRequest { request, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(returning: "")
                    return
                }
                
                let extractedText = observations.compactMap { observation in
                    observation.topCandidates(1).first?.string
                }.joined(separator: "\n")
                
                print("DEBUG: OCR finished. Observations: \(observations.count), Text length: \(extractedText.count)")
                if extractedText.isEmpty {
                    print("DEBUG: OCR returned empty text. Image might be blank or text is illegible.")
                }
                
                continuation.resume(returning: extractedText)
            }
            
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            
            let handler = VNImageRequestHandler(data: imageData, options: [:])
            
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
