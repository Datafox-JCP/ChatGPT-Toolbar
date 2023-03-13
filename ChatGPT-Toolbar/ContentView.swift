//
//  ContentView.swift
//  ChatGPT-Toolbar
//
//  Created by Juan Hernandez Pazos on 12/03/23.
//

import SwiftUI
import OpenAISwift

// Package: https://github.com/adamrushy/OpenAISwift

struct ContentView: View {
    // MARK: Properties
    @State private var search: String = ""
    @State private var responses: [String] = []
    
    // Get api key: https://platform.openai.com
    let openAI = OpenAISwift(authToken: "")
    
    private var isFormValid: Bool {
        !search.isEmpty
        // no permitir espacios
    }
    
    // MARK: Functions
    private func performSearch() {
        responses.append("You: \(search)")
        
        openAI.sendCompletion(with: search, maxTokens: 500) { result in
            switch result {
            case .success(let success):
                let response = "ChatGPT: \(success.choices.first?.text ?? "")"
                responses.append(response)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    // MARK: View
    var body: some View {
        VStack {
            HStack {
                TextField("Search...", text: $search)
                    .textFieldStyle(.roundedBorder)
                
                Button {
                    performSearch()
                } label: {
                    Image(systemName: "magnifyingglass.circle")
                        .font(.title)
                }
                .buttonStyle(.borderless)
                .disabled(!isFormValid)
            } // HStack
            
            List(responses, id: \.self) { response in
                Text(response)
            } // List
            .listStyle(.plain)
        } // VStack
        .padding()
    }
}

// MARK: Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
