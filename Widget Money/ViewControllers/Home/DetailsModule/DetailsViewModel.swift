//
//  DetailsViewModule.swift
//  Currency Widget
//
//  Created by macSlm on 21.12.2023.
//

import Foundation
import RxSwift

protocol DetailsViewModelProtocol {
    var rxIsAppearFlag: BehaviorSubject<Bool> { get }
    var rxFavoriteStatus: BehaviorSubject<Bool> { get set }
    
    var rxAppThemeUpdated: BehaviorSubject<Bool> { get }
    var colorSet: AppColors { get }
    var pair: CurrencyPairCellModel { get }
    
    func changeFavoriteStatus()
}

class DetailsViewModel: DetailsViewModelProtocol {
    
    let bag = DisposeBag()
    var pair = CurrencyPairCellModel(
        valueCurrency: CoreWorker.shared.coinList.baseCoin,
        baseCurrency: CoreWorker.shared.coinList.baseCoin,
        colorIndex: nil
    )
    
    var rxIsAppearFlag = RxSwift.BehaviorSubject(value: false) //hidden as default
    var rxFavoriteStatus = RxSwift.BehaviorSubject(value: false)
    
    var rxAppThemeUpdated = BehaviorSubject(value: false)
    var colorSet = CoreWorker.shared.colorsWorker.returnColors()
    
    init() {
        subscribeToCoreWorker()
        getFavouriteStatus()
    }
    
    func changeFavoriteStatus() {
        
        do {
            let status = try rxFavoriteStatus.value()
            let from = CoreWorker.shared.exchangeWorker.fromCoin
            let to = CoreWorker.shared.exchangeWorker.toCoin

            if status {
                CoreWorker.shared.favouritePairList.deletePair(valueCode: from, baseCode: to)
            }
            else {
                CoreWorker.shared.favouritePairList.addNewPair(valueCode: from, baseCode: to, colorIndex: nil)
            }
            CoreWorker.shared.exchangeWorker.rxExchangeFlag.onNext(true)

        } catch {
            return
        }
    }
    
}

extension DetailsViewModel {
    
    private func subscribeToCoreWorker() {
        CoreWorker.shared.exchangeWorker.rxExchangeFlag.subscribe { flag in
            self.updatePair()
            self.getFavouriteStatus()
            self.rxIsAppearFlag.onNext(flag)
        }.disposed(by: bag)
        
        //Update colors
        CoreWorker.shared.colorsWorker.rxAppThemeUpdated.subscribe{ _ in
            self.colorSet = CoreWorker.shared.colorsWorker.returnColors()
            self.rxAppThemeUpdated.onNext(true)
        }.disposed(by: bag)
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
        
        rxFavoriteStatus.onNext(
            CoreWorker.shared.favouritePairList.checkIsExist(
                valueCode: pair.valueCurrencyCode,
                baseCode: pair.baseCurrencyCode)
        )
    }
}
