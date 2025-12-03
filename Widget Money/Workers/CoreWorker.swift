//
//  CoreWorker.swift
//  Currency Widget
//
//  Created by macSlm on 12.12.2023.



//  Main worker, core of app

//  Launched from TabBar View Controller

import Foundation
import YandexMobileAds
import Combine

class CoreWorker {
    
    static let shared = CoreWorker()
    
    @Published var rxViewControllersNumber: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    let adsWorker = AdsWorker()
    
    //Colors
    let colorsWorker = ColorsWorker()
    
    //Currency List
    let coinList = UniversalCoinWorker()
    
    //Favourite pairs
    let favouritePairList = CoinPairWorker()
    
    //Exchange
    var exchangeWorker = ExchangeWorker()
    
    var purchaseWorker = PurchaseWorker()
    
    //Widget
    let widgetWorker: WidgetWorkerProtocol
    
    
    init() {
        
        widgetWorker = WidgetWorker(pairModule: favouritePairList, coinList: coinList) // doesn't work without modules
        updateExchangeFields()
        //Request of review
        AppReviewWorker.requestIf(launches: 3, days: 3)
        
        subscribeToWidget()
        
    }
    
    private func updateExchangeFields(){
        favouritePairList.rxPairListCount
            .sink { count in
                //We do not need update it if we have rows filled
                if self.exchangeWorker.fromCoin != "" && self.exchangeWorker.toCoin != "" {
                    return
                }
                //Make default if we do not have favourite pairs
                if count < 1 {
                    self.exchangeWorker.setFromCoin(code: "USD")
                    self.exchangeWorker.setToCoin(code: "RUB")
                    
                    self.exchangeWorker.rxExchangeFlag = false // Do not open details
                    return
                }
                
                self.exchangeWorker.setFromCoin(code: self.favouritePairList.pairList[0].valueCode)
                self.exchangeWorker.setToCoin(code: self.favouritePairList.pairList[0].baseCode)
                self.exchangeWorker.rxExchangeFlag = false // Do not open details
                
            }
            .store(in: &cancellables)
    }
    
    func subscribeToWidget() {
        NotificationCenter.default.addObserver(
            forName: .intentTriggered, object: nil, queue: .main) { notification in
                guard let main = notification.userInfo?["main"] as? String,
                      let base = notification.userInfo?["base"] as? String else { return }
                
                
                self.exchangeWorker.setFromCoin(code: main)
                self.exchangeWorker.setToCoin(code: base)
                self.exchangeWorker.rxExchangeFlag = true
            }
    }
    
    
    
}
