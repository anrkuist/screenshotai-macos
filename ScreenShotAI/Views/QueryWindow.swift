//
//  QueryWindow.swift
//  ScreenShotAI
//
//  Created by augusto on 16/12/2025.
//

import SwiftUI

struct QueryWindow: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = QueryViewModel()
    @State private var isContextExpanded: Bool = true
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text("Screenshot AI")
                    .font(.headline)
                Spacer()
                if appState.isProcessing {
                   ProgressView()
                       .scaleEffect(0.8)
                }
            }
            .padding(.top)
            
            // Error overlay
            if let error = appState.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(5)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(5)
            }
            
            Divider()
            
            // Extracted Text Section
            DisclosureGroup("Extracted Text", isExpanded: $isContextExpanded) {
                ScrollView {
                    Text(appState.currentOCRText)
                        .font(.custom("Menlo", size: 12))
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(5)
                }
                .frame(height: 120)
                .background(Color(nsColor: .textBackgroundColor))
                .cornerRadius(5)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray.opacity(0.3), lineWidth: 1))
            }
            
            // AI Interaction Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Ask about this screenshot:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    TextField("Enter your question...", text: $viewModel.userQuestion)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            Task { await viewModel.submitQuery() }
                        }
                    
                    Button("Ask") {
                        Task { await viewModel.submitQuery() }
                    }
                    .disabled(viewModel.userQuestion.isEmpty || viewModel.isLoading)
                }
            }
            
            // Response Section
            if viewModel.isLoading {
                Spacer()
                ProgressView("Analyzing connection...")
                Spacer()
            } else if !viewModel.aiResponse.isEmpty {
                VStack(alignment: .leading) {
                    Divider()
                    HStack {
                        Text("AI Response")
                            .font(.headline)
                        Spacer()
                        Button(action: {
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString(viewModel.aiResponse, forType: .string)
                        }) {
                            Image(systemName: "doc.on.doc")
                                .help("Copy Response")
                        }
                        .buttonStyle(.borderless)
                    }
                    
                    ScrollView {
                        Text(viewModel.aiResponse)
                            .textSelection(.enabled)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 5)
                            .lineSpacing(4)
                    }
                }
            } else if let error = viewModel.error {
                 Spacer()
                 Text("Error: \(error)")
                    .foregroundColor(.red)
                 Spacer()
            }
            
            Spacer()
        }
        .padding()
        .frame(minWidth: 400, minHeight: 500)
        .onReceive(appState.$currentOCRText) { text in
            // When appState updates OCR text, pass it to viewModel
            viewModel.contextText = text
        }
        .background(WindowAccessor { window in
            window?.level = .floating
        })
    }
}

#Preview {
    QueryWindow()
}
