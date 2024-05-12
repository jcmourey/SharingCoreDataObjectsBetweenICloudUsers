//
//  PreviewData.swift
//  WeJourney
//
//  Created by Jean-Charles Mourey on 04/05/2024.
//

import Foundation

extension [TheTVDBSeries] {
    static var preview: [TheTVDBSeries] {
        let url = Bundle.main.url(forResource: "TheTVDBSearchResult", withExtension: ".json")!
        let data = try! Data(contentsOf: url)
        let wrapper = try! JSONDecoder.apiDecoder.decode(TheTVDBSeriesSearchResult.self, from: data)
        return wrapper.data
    }
}

extension TheTVDBSeries {
    static var preview: TheTVDBSeries {
        [TheTVDBSeries].preview[0]
    }
}
