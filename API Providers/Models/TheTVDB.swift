//
//  TheTVDBSearchResult.swift
//  WeJourney
//
//  Created by Jean-Charles Mourey on 04/05/2024.
//

import Foundation

/// TheTVDB search
/// https://api4.thetvdb.com/v4/search?query=Dark Matter

struct TheTVDBSeriesSearchResult: Codable {
    let data: [TheTVDBSeries]
}

struct TheTVDBSeries: Codable {
    let tvdbId: String
    let country: String?
    let name: String
    let type: String
    let year: String?
    let network: String?
    let overview: String?
    let imageUrl: URL?
    let thumbnail: URL?
    let primaryLanguage: String?
    let status: String?
}

extension TheTVDBSeries: Identifiable {
    var id: String { tvdbId }
}

extension TheTVDBSeries: Hashable {}

/// TheTVDB Series details
/// https://api4.thetvdb.com/v4/series/292174
//
//"data": {
//        "id": 292174,
//        "name": "Dark Matter",
//        "slug": "dark-matter",
//        "image": "https://artworks.thetvdb.com/banners/posters/292174-1.jpg",
//        "nameTranslations": [
//            "deu",
//            "eng",
//            "fra",
//            "heb",
//            "por",
//            "rus",
//            "spa",
//            "zho",
//            "pt",
//            "nld"
//        ],
//        "overviewTranslations": [
//            "ces",
//            "dan",
//            "deu",
//            "eng",
//            "fin",
//            "fra",
//            "heb",
//            "por",
//            "rus",
//            "spa",
//            "tur",
//            "zho",
//            "pt",
//            "nld"
//        ],
//        "aliases": [],
//        "firstAired": "2015-06-12",
//        "lastAired": "2017-08-25",
//        "nextAired": "",
//        "score": 113162,
//        "status": {
//            "id": 2,
//            "name": "Ended",
//            "recordType": "series",
//            "keepUpdated": false
//        },
//        "originalCountry": "usa",
//        "originalLanguage": "eng",
//        "defaultSeasonType": 1,
//        "isOrderRandomized": false,
//        "lastUpdated": "2024-04-16 10:52:45",
//        "averageRuntime": 45,
//        "episodes": null,
//        "overview": "The six-person crew of a derelict spaceship awakens from stasis in the farthest reaches of space. Their memories wiped clean, they have no recollection of who they are or how they got on board. The only clue to their identities is a cargo bay full of weaponry and a destination: a remote mining colony that is about to become a war zone. With no idea whose side they are on, they face a deadly decision. Will these amnesiacs turn their backs on history, or will their pasts catch up with them?",
//        "year": "2015"
//    }

struct TheTVDBSeriesDetailResult: Codable {
    let data: TheTVDBSeriesDetail
}

struct TheTVDBSeriesDetail: Codable {
    let id: Int
    let name: String
    let image: URL
    let firstAired: Date
    let lastAired: Date
    let nextAired: Date
    let score: Int
    let status: TheTVDBStatus
    let originalCountry: String
    let originalLanguage: String
    let overview: String
    let year: String
    let averageRuntime: Int
}

struct TheTVDBStatus: Codable {
    let id: Int
    let name: String
    let recordType: String
}
