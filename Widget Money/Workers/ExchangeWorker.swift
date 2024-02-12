//
//  ExchangeWorker.swift
//  Currency Widget
//
//  Created by  slm on 20.01.2024.
//

import Foundation
import RxSwift

protocol ExchangeWorkerProtocol {
    var fromCoin: String { get }
    var toCoin: String { get }
    
    var rxExchangeFlag: BehaviorSubject<Bool> { get set }
    
    func setFromCoin(code: String)
    func setToCoin(code: String)
    func switchRows()
    
}


class ExchangeWorker: ExchangeWorkerProtocol {

    
    var fromCoin = ""
    var toCoin = ""
    var rxExchangeFlag = BehaviorSubject(value: false)
    var bag = DisposeBag()
    
    init() {

    }
    
    func setFromCoin(code: String) {
        fromCoin = code
        rxExchangeFlag.onNext(true)
    }
    
    func setToCoin(code: String) {
        toCoin = code
        rxExchangeFlag.onNext(true)
    }
    
    func switchRows() {
        let coin = fromCoin
        fromCoin = toCoin
        toCoin = coin
        rxExchangeFlag.onNext(true)
    }
    
}
