//
//  AutoCompleteTextField.swift
//  WeJourney
//
//  Created by Jean-Charles Mourey on 05/05/2024.
//

import SwiftUI

struct AutoCompleteTextField: View {
    @Binding var predictableValues: [String]
    @Binding var predictedValues: [String]
    @Binding var textFieldInput: String
    var textFieldTitle: String = ""
    var showPredictedValues: Bool = true
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .leading) {
                
                let firstPrediction = predictedValues.first
                
                PredictingTextField(
                    predictableValues: $predictableValues,
                    predictedValues: $predictedValues,
                    textFieldInput: $textFieldInput,
                    textFieldTitle: textFieldTitle
                )
                .onTapGesture {
                    if let firstPrediction {
                        textFieldInput = firstPrediction
                    }
                }
                
                if let firstPrediction  {
                    HStack(spacing: 0) {
                        Text(textFieldInput)
                        Text(firstPrediction.dropFirst(textFieldInput.count))
                            .foregroundStyle(.gray)
                    }
                }
            }
            
            if showPredictedValues {
                HStack {
                    ForEach(predictedValues, id: \.self) { value in
                        Text(value)
                            .foregroundColor(.accentColor)
                            .font(.caption)
                            .padding(5)
                            .cornerRadius(5)
                            .background (
                                RoundedRectangle(cornerRadius: 5, style: .circular)
                                    .foregroundStyle(.blue)
                                    .opacity(0.1)
                            )
                            .onTapGesture {
                                textFieldInput = value
                            }
                    }
                }
            }
        }
    }
}

#Preview {
    struct AutoCompleteTextFieldPreviewContainers: View {
        @State private var predictableValues = ["Dexter", "Star Trek", "Dark Matter", "Dark Crystal", "Dark Angels", "Dark Matter (2024)"]
        
        var body: some View {
            Form {
                Text("predictable values".uppercased())
                    .foregroundStyle(.gray)
                
                VStack(alignment: .leading) {
                    ForEach(predictableValues, id: \.self) { Text($0).font(.caption) }
                }

                Section("Show clickable predicted values") {
                    AutoCompleteTextFieldPreviewContainer(predictableValues: $predictableValues, showPredictedValues: true)
                }
                Section("Don't show clickable predicted values") {
                    AutoCompleteTextFieldPreviewContainer(predictableValues: $predictableValues, showPredictedValues: false)
                }
            }
        }
    }
    
    struct AutoCompleteTextFieldPreviewContainer: View {
        @Binding var predictableValues: [String]
        let showPredictedValues: Bool

        @State private var predictedValues: [String] = []
        @State private var textFieldInput = ""
        
        var body: some View {
            AutoCompleteTextField(predictableValues: $predictableValues, predictedValues: $predictedValues, textFieldInput: $textFieldInput, textFieldTitle: "Search", showPredictedValues: showPredictedValues)
        }
    }

    return AutoCompleteTextFieldPreviewContainers()
}
