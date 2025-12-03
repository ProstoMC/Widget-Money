//
//  ExchangeViewModel.swift
//  Currency Widget
//
//  Created by macSlm on 28.11.2023.
//

import Foundation
import Combine



protocol ExchangeViewModelProtocol {
    var fromText: String {get set}
    var toText: String {get set}
    var fromCurrency: String {get set}
    var toCurrency: String {get set}
    
    var rxAppThemeUpdated: Bool { get }
    var colorSet: AppColors { get }
    
    func makeExchangeNormal()
    func makeExchangeReverse()
    func switchFields()
    func setCurrency(shortName: String, type: String)
    
}

class ExchangeViewModel: ExchangeViewModelProtocol  {
    
    @Published var rxAppThemeUpdated: Bool = false
    var colorSet = CoreWorker.shared.colorsWorker.returnColors()
    
    @Published var fromText: String = "1"
    @Published var toText: String = "1"
    @Published var fromCurrency: String = "RUB"
    @Published var toCurrency: String = "USD"
    
    private var cancellables = Set<AnyCancellable>()
    //let formatter = NumberFormatter().numberStyle = .decimal
    
    init() {
        subscrubeToCoreWorker()
    }
    
    private func subscrubeToCoreWorker() {
        // Update after fetching currency rates
        CoreWorker.shared.coinList.rxRateUpdated.sink {_ in
            self.makeExchangeNormal()
        }.store(in: &cancellables)
        
        //Update exchanging and fields after new currency on the fields
        CoreWorker.shared.exchangeWorker.$rxExchangeFlag.sink { _ in
            self.fromCurrency = CoreWorker.shared.exchangeWorker.fromCoin
            self.toCurrency = CoreWorker.shared.exchangeWorker.toCoin
            self.makeExchangeNormal()
        }.store(in: &cancellables)
        
        //Update colors
        CoreWorker.shared.colorsWorker.$rxAppThemeUpdated.sink { _ in
            self.colorSet = CoreWorker.shared.colorsWorker.returnColors()
            self.rxAppThemeUpdated = true
        }.store(in: &cancellables)
    }
    
    func makeExchangeNormal() {
        
        let fromValue = convertStringToDouble(text: fromText)
        let fromRate = CoreWorker.shared.coinList.returnCoin(code: fromCurrency)?.rate ?? 1
        let toRate = CoreWorker.shared.coinList.returnCoin(code: toCurrency)?.rate ?? 1
        
        let rate = toRate/fromRate
        let value = fromValue/rate
        let valueText = String(Double(round(100*value)/100))
        toText = valueText
        
        
    }
    
    func makeExchangeReverse() {
        
        let fromValue = convertStringToDouble(text: toText)
        let fromRate = CoreWorker.shared.coinList.returnCoin(code:  fromCurrency)?.rate ?? 1
        let toRate = CoreWorker.shared.coinList.returnCoin(code: toCurrency)?.rate ?? 1
        
        let rate = fromRate/toRate
        let value = fromValue/rate
        let valueText = String(Double(round(100*value)/100))
        fromText = valueText
        
    }
    
    func switchFields() {
        CoreWorker.shared.exchangeWorker.switchRows()
    }
    
    func setCurrency(shortName: String, type: String) {
        print("--Setted currency = \(shortName) -- type = \(type)")
        if type == "From" {
            CoreWorker.shared.exchangeWorker.setFromCoin(code: shortName)
        }
        if type == "To" {
            CoreWorker.shared.exchangeWorker.setToCoin(code: shortName)
        }
        
    }
    
}

extension ExchangeViewModel {
    
    private func convertStringToDouble(text: String) -> Double {
        let formatter = NumberFormatter()
        if let value = Double(text) {
            return value
        }
        formatter.decimalSeparator = ","
        if let value = NumberFormatter().number(from: text)?.doubleValue {
            return value
        }
        return 0
    }
}
