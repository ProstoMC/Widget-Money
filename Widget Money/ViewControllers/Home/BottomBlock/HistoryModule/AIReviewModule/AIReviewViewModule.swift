//
//  AIReviewModule.swift
//  Widget Money
//
//  Created by Алексей Никитин on 12.02.26.
//

import SwiftUI

final class AIReviewModule {
    
    enum LoadingState {
        case idle
        case notAccessed
        case loading
        case loaded
        case failed
    }
    
    @Published var baseCode: String
    @Published var valueCode: String
    
    @Published var review: String = ""
    @Published var takes: [String] = []
    
    @Published var state: LoadingState = .idle
    
    init(baseCode: String, valueCode: String) {
        self.baseCode = baseCode
        self.valueCode = valueCode
        
    }
    
    func load() async {
        state = .loading
            
            do {
                let lang = Locale.current.language.languageCode?.identifier ?? "en"
                
                guard let response = try await CoreWorker.shared.coinList.fetcher.fetchAIReview(
                    valueCode: valueCode,
                    baseCode: baseCode,
                    lang: lang)
                else {
                    state = .failed
                    return
                }
                
                review = response.review
                takes = response.key_points
                state = .loaded
            } catch {
                state = .failed
            }
        }
    
}
