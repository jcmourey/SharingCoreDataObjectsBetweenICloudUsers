//
//  TVShowDetailsView.swift
//  WeJourney
//
//  Created by Jean-Charles Mourey on 04/05/2024.
//

import SwiftUI

struct TVShowDetailsView: View {
    let show: TheTVDBSeries
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            Text(show.name)
                .font(.headline)
            Text(show.network.orEmpty)
                .font(.footnote)
                .bold()
                .foregroundColor(.accentColor)
            Text("Year: \(show.year.orUnknown)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    TVShowDetailsView(show: .preview)
}
