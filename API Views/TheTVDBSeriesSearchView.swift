//
//  TheTVDBSeriesSearchView.swift
//  WeJourney
//
//  Created by Jean-Charles Mourey on 04/05/2024.
//

import SwiftUI

struct TheTVDBSeriesSearchView: View {
    @State private var model = Model()
    @FocusState private var searchFieldIsFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            LazyVStack(alignment: .leading) {
                AutoCompleteSearchField(
                    lookupValues: model.tvShows.map(\.name),
                    textFieldInput: $model.tvShowName,
                    updatePredicted: $model.isUpdated,
                    maxPredictedValues: 4
                )
                .focused($searchFieldIsFocused)
                .onSubmit {
                    Task { await model.fetchTVShows() }
                }

                if model.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                if let error = model.errorString {
                    Text(error)
                        .font(.caption)
                }
            }
            .padding(.horizontal, 20.0)
            
            TheTVDBSeriesListView(tvShows: model.tvShows)

        }
        .task(id: model.tvShowName) { await model.fetchTVShows() }
        .refreshable { await model.fetchTVShows() }
        .navigationTitle("TV Shows")
    }
}

#Preview {
    NavigationStack {
        TheTVDBSeriesSearchView()
            .environment(\.locale, .init(identifier: "fr_FR"))
    }
}
