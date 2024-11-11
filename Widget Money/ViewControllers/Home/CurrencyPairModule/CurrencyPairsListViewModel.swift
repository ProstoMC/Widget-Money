//
//  ViewModel.swift
//  Currency Widget
//
//  Created by macSlm on 31.10.2023.
//

import Foundation
import RxSwift

protocol CurrencyPairsListViewModelProtocol {
    var pairList: [CurrencyPairCellModel] { get }
    var rxPairsUpdated: BehaviorSubject<Bool> { get }
    
    var rxAppThemeUpdated: BehaviorSubject<Bool> { get }
    var colorSet: AppColors { get }
    
    func selectTail(pair: CurrencyPairCellModel)
    func selectTail(indexPath: IndexPath)
    func reorderPair(fromIndex: Int, toIndex: Int)
    func deletePair(index: Int)
    
}

class CurrencyPairsListViewModel: CurrencyPairsListViewModelProtocol {
    var pairList: [CurrencyPairCellModel] = []
    var rxPairsUpdated = BehaviorSubject(value: false)
    
    var rxAppThemeUpdated = BehaviorSubject(value: false)
    var colorSet = CoreWorker.shared.colorsWorker.returnColors()

    let bag = DisposeBag()
    
    init() {
        //Start with nulls
        subscribeToCoreWorker()
    }
    
    func subscribeToCoreWorker(){
        
        //Update view after pairsList was updated
        CoreWorker.shared.favouritePairList.rxPairListCount.subscribe{ _ in  //I dont need count
            self.pairList = self.createList()
            self.rxPairsUpdated.onNext(true)
        }.disposed(by: bag)
        
        //Update after updating of rates
        CoreWorker.shared.coinList.rxRateUpdated.subscribe { _ in
            self.pairList = self.createList()
            self.rxPairsUpdated.onNext(true)
        }
        .disposed(by: bag)
        
        //Update Colors
        CoreWorker.shared.colorsWorker.rxAppThemeUpdated.subscribe{ _ in
            self.changeColorSet()
            self.rxAppThemeUpdated.onNext(true)
            //Just reload table - it is hidden 
            self.pairList = self.createList()
            self.rxPairsUpdated.onNext(true)
        }.disposed(by: bag)
        
    }
    
    func createList() -> [CurrencyPairCellModel] {
        var list: [CurrencyPairCellModel] = []
        
        for pair in CoreWorker.shared.favouritePairList.pairList {
            guard let valueCurrency = CoreWorker.shared.coinList.returnCoin(code: pair.valueCode) else {
                CoreWorker.shared.favouritePairList.deletePair(valueCode: pair.valueCode, baseCode: pair.baseCode)
                continue
            }
            guard let baseCurrency = CoreWorker.shared.coinList.returnCoin(code: pair.baseCode) else {
                CoreWorker.shared.favouritePairList.deletePair(valueCode: pair.valueCode, baseCode: pair.baseCode)
                continue
            }
            
            list.append(CurrencyPairCellModel(
                valueCurrency: valueCurrency,
                baseCurrency: baseCurrency,
                colorIndex: pair.colorIndex)
            )
        }
        return list
        
    }
    
    private func changeColorSet() {
        colorSet = CoreWorker.shared.colorsWorker.returnColors()
    }
}


// MARK: - Protocol Funcions
extension CurrencyPairsListViewModel {

    func selectTail(pair: CurrencyPairCellModel) {
        CoreWorker.shared.exchangeWorker.setFromCoin(code: pair.valueCurrencyCode)
        CoreWorker.shared.exchangeWorker.setToCoin(code: pair.baseCurrencyCode)
    }
    func selectTail(indexPath: IndexPath){
        let pair = CoreWorker.shared.favouritePairList.pairList[indexPath.row]
        CoreWorker.shared.exchangeWorker.setFromCoin(code: pair.valueCode)
        CoreWorker.shared.exchangeWorker.setToCoin(code: pair.baseCode)
    }
    
    func reorderPair(fromIndex: Int, toIndex: Int) {
        CoreWorker.shared.favouritePairList.reorderPair(from: fromIndex, to: toIndex)
    }
    
    func deletePair(index: Int) {
        CoreWorker.shared.favouritePairList.deletePair(index: index)
    }
    
}
