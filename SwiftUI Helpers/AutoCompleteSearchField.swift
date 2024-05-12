//
//  AutoCompleteSearchField.swift
//  WeJourney
//
//  Created by Jean-Charles Mourey on 05/05/2024.
//

import SwiftUI

struct AutoCompleteSearchField: View {
    var lookupValues: [String]
    @Binding var textFieldInput: String
    @Binding var updatePredicted: Bool
    var maxPredictedValues: Int = 4

    @State private var predictableValues: [String] = []
    @State private var predictedValues: [String] = []

    func updatePredictableValues() {
        defer { updatePredicted = false }
        guard maxPredictedValues > 0 else { return }
        
        let wordCount = textFieldInput.split(separator: " ").count
        
        predictableValues = Array(
            lookupValues
                .map {
                    $0.split(separator: " ").prefix(wordCount + 1).joined(separator: " ")
                }
                .filter { $0.lowercased().starts(with: textFieldInput.lowercased()) }
                .prefix(maxPredictedValues)
        )
    }
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            AutoCompleteTextField(
                predictableValues: $predictableValues,
                predictedValues: $predictedValues,
                textFieldInput: $textFieldInput,
                textFieldTitle: "Search",
                showPredictedValues: maxPredictedValues > 0
            )
        }
        .padding(10)
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(.gray, lineWidth: 0.2)
        )
        .task(id: updatePredicted)  { updatePredictableValues() }
        .onAppear { updatePredictableValues() }
    }
}

#Preview {
    struct AutoCompleteSearchFieldPreviewContainers: View {
        var lookupValues = ["Dexter", "Star Trek", "Dark Matter", "Dark Crystal", "Dark Angels", "Dark Matter (2024)"]
        
        var body: some View {
            Form {
                Text("lookup values".uppercased())
                    .foregroundStyle(.gray)
                
                VStack(alignment: .leading) {
                    ForEach(lookupValues, id: \.self) { Text($0).font(.caption) }
                }

                Section("Show clickable predicted values") {
                    AutoCompleteSearchFieldPreviewContainer(lookupValues: lookupValues, maxPredictedValues: 4)
                }
                Section("Don't show clickable predicted values") {
                    AutoCompleteSearchFieldPreviewContainer(lookupValues: lookupValues, maxPredictedValues: 0)
                }
            }
        }
    }
    
    struct AutoCompleteSearchFieldPreviewContainer: View {
        let lookupValues: [String]
        let maxPredictedValues: Int

        @State private var textFieldInput = ""
        @State private var updatePredicted = false
        
        var body: some View {
            AutoCompleteSearchField(lookupValues: lookupValues, textFieldInput: $textFieldInput, updatePredicted: $updatePredicted, maxPredictedValues: maxPredictedValues)
        }
    }

    return AutoCompleteSearchFieldPreviewContainers()
}
