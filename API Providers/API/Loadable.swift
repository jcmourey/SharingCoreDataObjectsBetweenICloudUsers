//
//  Model.swift
//  TopQuestions
//
//  Created by Jean-Charles Mourey on 03/05/2024.
//

import Foundation

protocol Loadable: AnyObject {
    var isLoading: Bool { get set }
    var errorString: String? { get set }
}

extension Loadable {    
    @MainActor func whileLoading(_ code: () async throws -> Void) async {
        guard !isLoading else { return }
        isLoading = true
        do {
            errorString = nil
            try await code()
        } catch URLError.cancelled {
            errorString = nil
        } catch {
            errorString = "\(error): \(error.localizedDescription)"
        }
        isLoading = false
    }
}
