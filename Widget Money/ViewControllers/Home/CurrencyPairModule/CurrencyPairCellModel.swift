//
//  CurrencyPair.swift
//  Currency Widget
//
//  Created by macSlm on 31.10.2023.
//

import Foundation
import RxSwift

struct CurrencyPairCellModel {
    var valueCurrencyCode: String
    var valueCurrencyLogo: String
    var valueCurrencyName: String
    var baseCurrencyCode: String
    var baseLogo: String
    var baseCurrencyName: String
    var colorIndex: Int
    var typeOfLogo: TypeOfCoin
    var imageUrl: String?
    var baseImageUrl: String?
    
    var value: Double
    var flow: Double
    
    let bag = DisposeBag()
    

    init(valueCurrency: CoinUniversal, baseCurrency: CoinUniversal, colorIndex: Int?) {
        
        self.valueCurrencyCode = valueCurrency.code
        self.valueCurrencyLogo = valueCurrency.logo
        self.valueCurrencyName = valueCurrency.name
        self.baseCurrencyCode = baseCurrency.code
        self.baseLogo = baseCurrency.logo
        self.baseCurrencyName = baseCurrency.name
        self.typeOfLogo = valueCurrency.type
        self.imageUrl = valueCurrency.imageUrl
        self.baseImageUrl = baseCurrency.imageUrl
        
        self.value = valueCurrency.rate/baseCurrency.rate
        
        let previosValue = valueCurrency.rate-valueCurrency.flow24Hours
        let previosBase = baseCurrency.rate-baseCurrency.flow24Hours
        
        self.flow = (valueCurrency.rate/baseCurrency.rate)-(previosValue/previosBase)
        
        if colorIndex == nil {
            self.colorIndex = valueCurrency.colorIndex
        } else {
            self.colorIndex = colorIndex!
        }
        
    }
}




