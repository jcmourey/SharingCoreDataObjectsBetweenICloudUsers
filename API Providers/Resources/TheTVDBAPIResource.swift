//
//  TheTVDBAPIResource.swift
//  WeJourney
//
//  Created by Jean-Charles Mourey on 04/05/2024.
//

import Foundation

protocol TheTVDBAPIResource: APIResource {
    var token: String { get }
}

extension TheTVDBAPIResource {
    var basePath: String { "https://api4.thetvdb.com/v4/" }
    
    // token must be renewed every month
    var token: String { "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZ2UiOiIiLCJhcGlrZXkiOiJjZTlhYjA5My0wNzEwLTRiNDUtODBhZS0xMTk1NDJiYjE4ZWIiLCJjb21tdW5pdHlfc3VwcG9ydGVkIjpmYWxzZSwiZXhwIjoxNzE3NDQ5ODE5LCJnZW5kZXIiOiIiLCJoaXRzX3Blcl9kYXkiOjEwMDAwMDAwMCwiaGl0c19wZXJfbW9udGgiOjEwMDAwMDAwMCwiaWQiOiIyNDExODM3IiwiaXNfbW9kIjpmYWxzZSwiaXNfc3lzdGVtX2tleSI6ZmFsc2UsImlzX3RydXN0ZWQiOmZhbHNlLCJwaW4iOm51bGwsInJvbGVzIjpbXSwidGVuYW50IjoidHZkYiIsInV1aWQiOiIifQ.hmElEzF90h8Vy5AhrfapkSn9gMf-vOInWUb8LANhajiNocOYrgzML4UdC6PIcAP0GKVommtXS9qLpYNsO7MJB7JUbMkZ6VEvJ_uggV-bCkWrD1wlsbqKqMSc1SLsL7-hwPslzYHZIqmCW08_DIsUV8rHjx9NvwkPWnebyE7z64dK2iX8f-Kr82mMb1Jw_ydn3mAeNGvxTny44buAc9bSoziENqQvmHO5W4VEhSLqWoS0nW4z0Kb2vYNYElxR7nUb3K1Mmqr1svHTSwp93KVj3CB5kAU5Lsag--NI8Q0hgVbJlPCH4pvsee0DtY9g7aH41kw3dXazziVuKXlSpufs65ICOZ4NAHix_zjPwSCTp964gDzwsr84S7EuIJGs9sFndDlOyzpVKD040nT5kA0_wvbuSIODHUyVKZinBGGikZBBrsp4bnX7ZRz8d16xvSDFCCVCIsxhkN3YjxB4zwnd7Zmxelo8GuXq0fTXdw7_ZNtrvypNo9iR2oVBZunnfmmGrJmexc8C4qiW0ec9hlrtXJCLqE9mV5VCi5WB0pqwnm2t3QUlLAdd4uoL6wpFITvrZW96MwXPASenCWDoug3S7-zwQYl7pwkaw5ZTnr-FWjAvfEwOCYlCHqjfkZx1CkjcITU5b0QsVkZQj5I_yhhE6YWuIRXo9oioYouixLlj_2U"
    }
    
    var headers: [String: String] {
        ["Authorization": "Bearer \(token)"]
    }
}

struct TheTVDBSeriesSearchResource: TheTVDBAPIResource {
    typealias ModelType = TheTVDBSeriesSearchResult
    
    let searchQuery: String
    
    var method: String { "search" }
    
    var queryItems: [URLQueryItem] {
        [
            URLQueryItem(name: "query", value: searchQuery),
            URLQueryItem(name: "type", value: "series")
        ]
    }
}

struct TheTVDBSeriesDetailResource: TheTVDBAPIResource {
    typealias ModelType = TheTVDBSeriesDetailResult
    let tvdbId: Int
    var method: String { "series/\(tvdbId)" }
}
