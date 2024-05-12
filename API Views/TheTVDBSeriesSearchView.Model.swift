//
//  TheTVDBSeriesSearchView.Model.swift
//  WeJourney
//
//  Created by Jean-Charles Mourey on 04/05/2024.
//

import Foundation

extension TheTVDBSeriesSearchView {
    @Observable class Model: Loadable {
        var tvShowName = ""
        private(set) var tvShows: [TheTVDBSeries] = []

        var predictableValues: Array<String> = []
        var myPredictedValues: Array<String> = []
                    
        var isLoading: Bool = false
        var errorString: String?
        
        var isUpdated: Bool = false
        
        func fetchTVShows() async {
            await whileLoading {
                guard !self.tvShowName.isEmpty else { return }
                let resource = TheTVDBSeriesSearchResource(searchQuery: self.tvShowName)
                let request = APIRequest(resource: resource)
                self.tvShows = try await request.execute().data
                isUpdated = true
            }
        }
    }
}
