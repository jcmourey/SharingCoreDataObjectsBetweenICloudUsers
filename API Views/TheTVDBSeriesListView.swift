//
//  TheTVDBSeriesListView.swift
//  WeJourney
//
//  Created by Jean-Charles Mourey on 04/05/2024.
//

import SwiftUI

struct TheTVDBSeriesListView: View {
    let tvShows: [TheTVDBSeries]
    
    var body: some View {
        List(tvShows) { show in
            NavigationLink(value: show) {
                TVShowDetailsView(show: show)
                #if !os(watchOS)
                    .alignmentGuide(.listRowSeparatorLeading) { d in d[.leading] }
                #endif
            }
        }
        .listStyle(.plain)
        .listRowInsets(.none)
        #if !os(watchOS)
        .listRowSpacing(8.0)
        #endif
        .navigationDestination(for: TheTVDBSeries.self) { show in
            // TVShowView(show: show)
        }
    }
}

#Preview {
    NavigationStack {
        TheTVDBSeriesListView(tvShows: .preview)
    }
}
