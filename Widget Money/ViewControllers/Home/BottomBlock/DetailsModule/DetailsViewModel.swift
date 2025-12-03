//
//  DetailsViewModule.swift
//  Currency Widget
//
//  Created by macSlm on 21.12.2023.
//

import Foundation
import Combine

protocol DetailsViewModelProtocol {
    var rxIsAppearFlag: Bool { get }
    var rxFavoriteStatus: Bool { get set }
    
    var rxAppThemeUpdated: Bool { get }
    var colorSet: AppColors { get }
    var pair: CurrencyPairCellModel { get }
    
    func changeFavoriteStatus()
}

class DetailsViewModel: DetailsViewModelProtocol {
    
    private var cancellables = Set<AnyCancellable>()
    var pair = CurrencyPairCellModel(
        valueCurrency: CoreWorker.shared.coinList.baseCoin,
        baseCurrency: CoreWorker.shared.coinList.baseCoin,
        colorIndex: nil
    )
    
    @Published var rxIsAppearFlag: Bool = false //hidden as default
    @Published var rxFavoriteStatus: Bool = false
    
    @Published var rxAppThemeUpdated: Bool = false
    var colorSet = CoreWorker.shared.colorsWorker.returnColors()
    
    init() {
        subscribeToCoreWorker()
        getFavouriteStatus()
    }
    
    func changeFavoriteStatus() {
        
        
            let status = rxFavoriteStatus
            let from = CoreWorker.shared.exchangeWorker.fromCoin
            let to = CoreWorker.shared.exchangeWorker.toCoin

            if status {
                CoreWorker.shared.favouritePairList.deletePair(valueCode: from, baseCode: to)
            }
            else {
                CoreWorker.shared.favouritePairList.addNewPair(valueCode: from, baseCode: to, colorIndex: nil)
            }
            CoreWorker.shared.exchangeWorker.rxExchangeFlag = true

        
    }
    
}

extension DetailsViewModel {
    
    private func subscribeToCoreWorker() {
        CoreWorker.shared.exchangeWorker.$rxExchangeFlag.sink { flag in
            self.updatePair()
            self.getFavouriteStatus()
            self.rxIsAppearFlag = flag
        }.store(in: &cancellables)
        
        //Update colors
        CoreWorker.shared.colorsWorker.$rxAppThemeUpdated.sink { _ in
            self.colorSet = CoreWorker.shared.colorsWorker.returnColors()
            self.rxAppThemeUpdated = true
        }.store(in: &cancellables)
    }
    
    private func updatePair() {
        let coinPair = CoinPair(
            valueCode: CoreWorker.shared.exchangeWorker.fromCoin,
            baseCode: CoreWorker.shared.exchangeWorker.toCoin
        )
        
        pair = CurrencyPairCellModel(
            valueCurrency: CoreWorker.shared.coinList.returnCoin(code: coinPair.valueCode) ?? CoreWorker.shared.coinList.baseCoin,
            baseCurrency: CoreWorker.shared.coinList.returnCoin(code: coinPair.baseCode) ?? CoreWorker.shared.coinList.baseCoin,
            colorIndex: nil)
    }
    
    private func getFavouriteStatus() {
        
        rxFavoriteStatus = CoreWorker.shared.favouritePairList.checkIsExist(
                valueCode: pair.valueCurrencyCode,
                baseCode: pair.baseCurrencyCode
        )
        
    }
}
