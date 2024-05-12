//
//  ContentView.swift
//  WeJourney
//
//  Created by Jean-Charles Mourey on 04/05/2024.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationStack {
            TheTVDBSeriesSearchView()
        }
    }
}

#Preview {
    ContentView()
}
