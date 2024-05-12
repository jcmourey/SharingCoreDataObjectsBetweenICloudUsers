//
//  SwiftHelper.swift
//  WeJourney
//
//  Created by Jean-Charles Mourey on 04/05/2024.
//

import Foundation

extension Optional {
    public func orIfNil(_ replacement: String) -> String {
        switch self {
        case .none:
            replacement
        case let .some(value):
            "\(value)"
        }
    }
    
    public var orEmpty: String { orIfNil("") }
    public var orUnknown: String { orIfNil("unknown") }

}
