//
//  ExchangeWorker.swift
//  Currency Widget
//
//  Created by  slm on 20.01.2024.
//

import Foundation
import Combine

protocol ExchangeWorkerProtocol {
    var fromCoin: String { get }
    var toCoin: String { get }
    
    var rxExchangeFlag: Bool { get set }
    
    func setFromCoin(code: String)
    func setToCoin(code: String)
    func switchRows()
    
}


class ExchangeWorker: ExchangeWorkerProtocol {

    
    var fromCoin = ""
    var toCoin = ""
    @Published var rxExchangeFlag: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    init() {

    }
    
    func setFromCoin(code: String) {
        fromCoin = code
        rxExchangeFlag = true
    }
    
    func setToCoin(code: String) {
        toCoin = code
        rxExchangeFlag = true
    }
    
    func switchRows() {
        let coin = fromCoin
        fromCoin = toCoin
        toCoin = coin
        rxExchangeFlag = true
    }
    
}
